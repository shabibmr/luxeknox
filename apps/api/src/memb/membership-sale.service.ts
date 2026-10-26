import type { AuthenticatedUser } from '../auth/auth.guard';
import type { PaymentService } from '../pay/payment.service';
import type { AuditService } from '../platform/audit/audit.service';
import type { DrizzleDb } from '../platform/db/client';
import type { Membership } from '../platform/db/schema/memberships';
import { runInTransaction } from '../platform/db/transaction-context';
import {
  BusinessRuleError,
  ConflictError,
  NotFoundError,
} from '../platform/errors/app-error';
import type { DomainEvent, DomainEventBus } from '../platform/events/domain-events';
import { cmpMoney, fromCents, roundMoney, toCents } from '../platform/money/money';
import type { MemberRepository } from '../people/member.repository';
import { assertPartnerForPackage } from './membership-partner';
import type { MembershipProductRepository } from './membership-product.repository';
import { addDays, cancelRow, loadPartner, renewRow } from './membership-rows';
import type { MembershipCreateDto, MembershipReplacementPreview } from './membership.dto';
import type { MembershipRepository, MembershipWithProduct } from './membership.repository';

/** Catalog-hidden product that PT-bundled memberships point at (ADR-0012). */
export const PT_BUNDLE_PRODUCT_CODE = 'PT-BUNDLE';

/** Plain day difference; negative if `endIso` precedes `startIso`. */
function daysBetween(startIso: string, endIso: string): number {
  const [sy, sm, sd] = startIso.split('-').map(Number);
  const [ey, em, ed] = endIso.split('-').map(Number);
  const start = Date.UTC(sy, sm - 1, sd);
  const end = Date.UTC(ey, em - 1, ed);
  return Math.round((end - start) / 86_400_000);
}

type PtBundleInput = {
  memberIds: number[];
  startDate: string;
  endDate: string;
  durationDays: number;
  today: string;
  actor: AuthenticatedUser;
  now: Date;
};

/** One member's bundle decision. Writes happen only while applying the whole plan. */
type PtBundleAction =
  | { kind: 'extend'; memberId: number; rows: Membership[]; newEndDate: string }
  | { kind: 'create'; memberId: number };

/** CM-06: round-half-up pro-rated credit, capped at `basePrice`. */
function proRatedCredit(basePrice: string, remainingDays: number, durationDays: number): string {
  if (durationDays <= 0) {
    return roundMoney('0');
  }
  const baseCents = toCents(basePrice);
  const numerator = baseCents * BigInt(remainingDays);
  const denom = BigInt(durationDays);
  const half = denom / 2n;
  const creditCents = (numerator + half) / denom;
  const credit = fromCents(creditCents);
  return cmpMoney(credit, basePrice) > 0 ? roundMoney(basePrice) : credit;
}

/**
 * Assign, replacement preview, and the PT membership bundle.
 * Constructed inside MembershipService from deps that service already has.
 */
export class MembershipSaleService {
  constructor(
    private readonly repository: MembershipRepository,
    private readonly productRepository: MembershipProductRepository,
    private readonly memberRepository: MemberRepository,
    private readonly auditService: AuditService,
    private readonly domainEventBus: DomainEventBus,
    private readonly paymentService: PaymentService,
    private readonly db: DrizzleDb<any>,
  ) {}

  /** CM-06: pro-rated credit preview for replacing a member's current membership with a couple purchase. */
  async getReplacementPreview(memberId: number): Promise<MembershipReplacementPreview> {
    const existing = await this.repository.findActiveOrFrozenForMember(memberId);
    if (!existing) {
      throw new NotFoundError('Member has no active or frozen membership to replace');
    }

    const product = await this.productRepository.findById(existing.product_id);
    if (!product) {
      throw new NotFoundError('Membership product not found');
    }

    const today = new Date().toISOString().slice(0, 10);
    const effectiveStart = today > existing.start_date ? today : existing.start_date;
    const remainingDays = Math.max(0, daysBetween(effectiveStart, existing.end_date));

    return {
      membership_id: existing.id,
      product_name: product.name,
      status: existing.status,
      end_date: existing.end_date,
      remaining_days: remainingDays,
      is_couple: product.package_type === 'couple',
      suggested_credit: proRatedCredit(product.base_price, remainingDays, product.duration_days),
    };
  }

  /**
   * FR-MEMB-005/006/CM-07: assign a new contract; at most one active/frozen membership per member.
   * Open-membership, locker, and partner-replacement checks run before the transaction and again
   * inside it after locking the buyer, partner, and locker. Returns the row before actor-scoped
   * presentation. Domain events are published only after commit.
   */
  async create(dto: MembershipCreateDto, actor: AuthenticatedUser): Promise<MembershipWithProduct> {
    const member = await this.memberRepository.findById(dto.member_id);
    if (!member) {
      throw new NotFoundError('Member not found');
    }

    const product = await this.productRepository.findById(dto.product_id);
    if (!product || !product.is_active) {
      throw new NotFoundError('Membership product not found');
    }

    assertPartnerForPackage(product.package_type, dto.member_id, dto.partner_member_id);

    let partner: { id: number } | null = null;
    if (dto.partner_member_id != null) {
      partner = await this.memberRepository.findById(dto.partner_member_id);
      if (!partner) {
        throw new NotFoundError('Partner member not found');
      }
    }

    const existing = await this.repository.findActiveOrFrozenForMember(dto.member_id);
    if (existing) {
      throw new BusinessRuleError(
        'Member already has an active or frozen membership; use renew/upgrade instead',
      );
    }

    if (partner) {
      const partnerExisting = await this.repository.findActiveOrFrozenForMember(partner.id);
      if (partnerExisting) {
        if (!dto.replace_partner_membership) {
          throw new BusinessRuleError(
            'Partner has an active or frozen membership; confirm replacement',
          );
        }
        const partnerProduct = await this.productRepository.findById(partnerExisting.product_id);
        if (partnerProduct?.package_type === 'couple') {
          throw new BusinessRuleError(
            'Partner is already in a couple membership; replace it from that membership instead',
          );
        }
      }
    }

    if (dto.locker_number) {
      const lockerConflict = await this.repository.findByLockerNumberActiveOrFrozen(
        dto.locker_number,
      );
      if (lockerConflict) {
        throw new ConflictError(`Locker "${dto.locker_number}" is already assigned`);
      }
    }

    const endDate = addDays(dto.start_date, product.duration_days);
    const now = new Date();
    const memberIds = partner ? [dto.member_id, partner.id] : [dto.member_id];

    const { primaryId, partnerId, cancelledPartnerId } = await runInTransaction(this.db, async () => {
      await this.repository.lockMembers(memberIds);
      if (dto.locker_number) {
        await this.repository.lockLocker(dto.locker_number);
      }

      const existingNow = await this.repository.findActiveOrFrozenForMember(dto.member_id);
      if (existingNow) {
        throw new BusinessRuleError(
          'Member already has an active or frozen membership; use renew/upgrade instead',
        );
      }

      let partnerExistingNow: Membership | null = null;
      if (partner) {
        partnerExistingNow = await this.repository.findActiveOrFrozenForMember(partner.id);
        if (partnerExistingNow) {
          if (!dto.replace_partner_membership) {
            throw new BusinessRuleError(
              'Partner has an active or frozen membership; confirm replacement',
            );
          }
          const partnerProduct = await this.productRepository.findById(partnerExistingNow.product_id);
          if (partnerProduct?.package_type === 'couple') {
            throw new BusinessRuleError(
              'Partner is already in a couple membership; replace it from that membership instead',
            );
          }
        }
      }

      if (dto.locker_number) {
        const lockerConflictNow = await this.repository.findByLockerNumberActiveOrFrozen(
          dto.locker_number,
        );
        if (lockerConflictNow) {
          throw new ConflictError(`Locker "${dto.locker_number}" is already assigned`);
        }
      }

      if (partnerExistingNow) {
        await cancelRow(
          this.repository,
          this.auditService,
          partnerExistingNow,
          'replaced_by_couple',
          actor,
          now,
        );
      }

      const primaryMembershipId = await this.repository.insertMembership({
        member_id: dto.member_id,
        product_id: dto.product_id,
        start_date: dto.start_date,
        end_date: endDate,
        status: 'active',
        locker_number: dto.locker_number ?? null,
        auto_renew: dto.auto_renew ?? false,
        row_version: 1,
        created_at: now,
      });

      await this.repository.insertHistory({
        membership_id: primaryMembershipId,
        action: 'created',
        old_end_date: null,
        new_end_date: endDate,
        performed_by_user_id: actor.id,
        timestamp: now,
      });

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'membership.created',
        entityName: 'memberships',
        entityId: primaryMembershipId,
        afterState: { member_id: dto.member_id, product_id: dto.product_id, end_date: endDate },
      });

      let partnerMembershipId: number | null = null;
      if (partner) {
        partnerMembershipId = await this.repository.insertMembership({
          member_id: partner.id,
          product_id: dto.product_id,
          start_date: dto.start_date,
          end_date: endDate,
          status: 'active',
          locker_number: null,
          auto_renew: dto.auto_renew ?? false,
          partner_membership_id: primaryMembershipId,
          row_version: 1,
          created_at: now,
        });

        await this.repository.setPartner(primaryMembershipId, partnerMembershipId);

        await this.repository.insertHistory({
          membership_id: partnerMembershipId,
          action: 'created',
          old_end_date: null,
          new_end_date: endDate,
          performed_by_user_id: actor.id,
          timestamp: now,
        });

        await this.auditService.recordAudit({
          actorUserId: actor.id,
          action: 'membership.created',
          entityName: 'memberships',
          entityId: partnerMembershipId,
          afterState: { member_id: partner.id, product_id: dto.product_id, end_date: endDate },
        });
      }

      await this.paymentService.create(
        {
          member_id: dto.member_id,
          membership_id: primaryMembershipId,
          payment_method_id: dto.payment_method_id,
          subtotal: product.base_price,
          discount_amount: dto.discount_amount,
        },
        actor,
      );

      return {
        primaryId: primaryMembershipId,
        partnerId: partnerMembershipId,
        cancelledPartnerId: partnerExistingNow?.id ?? null,
      };
    });

    await this.domainEventBus.emit({
      eventName: 'membership.created',
      occurredAt: now,
      payload: { membershipId: primaryId, memberId: dto.member_id },
    });
    if (partnerId != null && partner) {
      await this.domainEventBus.emit({
        eventName: 'membership.created',
        occurredAt: now,
        payload: { membershipId: partnerId, memberId: partner.id },
      });
    }
    if (cancelledPartnerId != null) {
      await this.domainEventBus.emit({
        eventName: 'membership.cancelled',
        occurredAt: now,
        payload: { membershipId: cancelledPartnerId },
      });
    }

    const created = await this.repository.findByIdWithProduct(primaryId);
    if (!created) {
      throw new NotFoundError('Membership not found after creation');
    }
    return created;
  }

  /**
   * ADR-0012: a PT package includes a gym membership of the same duration, at no extra charge.
   * Runs inside the caller's (PT sale) transaction. Decides every member first, then applies:
   * - no active membership → one `PT-BUNDLE` membership covering the PT period, no second payment;
   * - active membership → one extend of that row and its partner row (kept product, history `renewed`,
   *   audit `via: pt_bundle`), from the day after end, or from today if it has lapsed;
   * - frozen membership → one rejection, and nothing is written.
   * A couple pair is a single extend even when both members are in the sale. Couple PT does not
   * link the bundled memberships. Returns domain events for the caller to publish after commit.
   */
  async bundleForPt(
    p: PtBundleInput,
  ): Promise<{ membershipIds: Map<number, number>; events: DomainEvent[] }> {
    const actions = await this.decidePtBundleActions(p);
    return this.applyPtBundleActions(actions, p);
  }

  /** Reads only. One action per input member. A frozen membership rejects before any write. */
  private async decidePtBundleActions(p: PtBundleInput): Promise<PtBundleAction[]> {
    const actions: PtBundleAction[] = [];
    for (const memberId of p.memberIds) {
      const existing = await this.repository.findActiveOrFrozenForMember(memberId);
      if (existing?.status === 'frozen') {
        const member = await this.memberRepository.findById(memberId);
        const who = member ? `${member.first_name} ${member.last_name}`.trim() : 'Member';
        throw new BusinessRuleError(
          `${who}'s membership is frozen; unfreeze it before adding Personal Training`,
        );
      }
      if (!existing) {
        actions.push({ kind: 'create', memberId });
        continue;
      }
      const partner = await loadPartner(this.repository, existing);
      const continuation = existing.end_date >= p.today ? addDays(existing.end_date, 1) : p.today;
      actions.push({
        kind: 'extend',
        memberId,
        rows: partner ? [existing, partner] : [existing],
        newEndDate: addDays(continuation, p.durationDays),
      });
    }
    return actions;
  }

  /** Applies an already-decided plan. A row already extended for this sale is not extended again. */
  private async applyPtBundleActions(
    actions: PtBundleAction[],
    p: PtBundleInput,
  ): Promise<{ membershipIds: Map<number, number>; events: DomainEvent[] }> {
    const membershipIds = new Map<number, number>();
    const events: DomainEvent[] = [];
    const extended = new Set<number>();

    for (const action of actions) {
      if (action.kind === 'extend') {
        membershipIds.set(action.memberId, action.rows[0].id);
        if (extended.has(action.rows[0].id)) {
          continue;
        }
        for (const row of action.rows) {
          await renewRow(
            this.repository,
            this.auditService,
            row,
            row.product_id,
            action.newEndDate,
            p.actor,
            p.now,
            'pt_bundle',
          );
          extended.add(row.id);
          events.push({
            eventName: 'membership.renewed',
            occurredAt: p.now,
            payload: { membershipId: row.id },
          });
        }
        continue;
      }

      const product = await this.productRepository.findByCode(PT_BUNDLE_PRODUCT_CODE);
      if (!product) {
        throw new NotFoundError(
          `Membership product "${PT_BUNDLE_PRODUCT_CODE}" is missing; run migrations`,
        );
      }
      const membershipId = await this.repository.insertMembership({
        member_id: action.memberId,
        product_id: product.id,
        start_date: p.startDate,
        end_date: p.endDate,
        status: 'active',
        locker_number: null,
        auto_renew: false,
        row_version: 1,
        created_at: p.now,
      });
      await this.repository.insertHistory({
        membership_id: membershipId,
        action: 'created',
        old_end_date: null,
        new_end_date: p.endDate,
        performed_by_user_id: p.actor.id,
        timestamp: p.now,
      });
      await this.auditService.recordAudit({
        actorUserId: p.actor.id,
        action: 'membership.created',
        entityName: 'memberships',
        entityId: membershipId,
        afterState: {
          member_id: action.memberId,
          product_id: product.id,
          end_date: p.endDate,
          via: 'pt_bundle',
        },
      });
      membershipIds.set(action.memberId, membershipId);
      events.push({
        eventName: 'membership.created',
        occurredAt: p.now,
        payload: { membershipId, memberId: action.memberId },
      });
    }

    for (const memberId of p.memberIds) {
      if (!membershipIds.has(memberId)) {
        throw new BusinessRuleError(
          `PT bundle did not produce a membership for member ${memberId}`,
        );
      }
    }

    return { membershipIds, events };
  }
}
