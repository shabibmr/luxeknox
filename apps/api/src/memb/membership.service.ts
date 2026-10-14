import { Inject, Injectable, Optional, forwardRef } from '@nestjs/common';
import { RevenueRecognitionPortService } from '../acct/revenue-recognition-port.service';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { PaymentService } from '../pay/payment.service';
import { AuditService } from '../platform/audit/audit.service';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { runInTransaction } from '../platform/db/transaction-context';
import type {
  Membership,
  MembershipFreeze,
  MembershipProduct,
} from '../platform/db/schema/memberships';
import { verifyRowVersion } from '../platform/concurrency/row-version';
import { DomainEventBus, type DomainEvent } from '../platform/events/domain-events';
import {
  BadRequestError,
  BusinessRuleError,
  ConflictError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { cmpMoney, fromCents, roundMoney, toCents } from '../platform/money/money';
import { MemberRepository } from '../people/member.repository';
import { MembershipProductRepository } from './membership-product.repository';
import {
  type MembershipCreateDto,
  type MembershipActionRequestDto,
  type MembershipExtensionWriteDto,
  type MembershipFreezeWriteDto,
  type MembershipReplacementPreview,
  type MembershipUpgradeRequestDto,
  type RejectRequestDto,
  membershipFilterQuerySchema,
} from './membership.dto';
import {
  MembershipRepository,
  type MembershipListScope,
  type MembershipWithProduct,
} from './membership.repository';

/** Catalog-hidden product that PT-bundled memberships point at (ADR-0012). */
export const PT_BUNDLE_PRODUCT_CODE = 'PT-BUNDLE';

/** Adds one calendar day to an ISO date string. */
function addDays(isoDate: string, days: number): string {
  const [y, m, d] = isoDate.split('-').map(Number);
  const date = new Date(Date.UTC(y, m - 1, d));
  date.setUTCDate(date.getUTCDate() + days);
  return date.toISOString().slice(0, 10);
}

function daysBetweenInclusive(startIso: string, endIso: string): number {
  const [sy, sm, sd] = startIso.split('-').map(Number);
  const [ey, em, ed] = endIso.split('-').map(Number);
  const start = Date.UTC(sy, sm - 1, sd);
  const end = Date.UTC(ey, em - 1, ed);
  return Math.round((end - start) / 86_400_000) + 1;
}

/** Plain (non-inclusive) day difference between two ISO dates; negative if `endIso` precedes `startIso`. */
function daysBetween(startIso: string, endIso: string): number {
  const [sy, sm, sd] = startIso.split('-').map(Number);
  const [ey, em, ed] = endIso.split('-').map(Number);
  const start = Date.UTC(sy, sm - 1, sd);
  const end = Date.UTC(ey, em - 1, ed);
  return Math.round((end - start) / 86_400_000);
}

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

@Injectable()
export class MembershipService {
  constructor(
    private readonly repository: MembershipRepository,
    private readonly productRepository: MembershipProductRepository,
    private readonly memberRepository: MemberRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
    private readonly domainEventBus: DomainEventBus,
    @Inject(forwardRef(() => PaymentService))
    private readonly paymentService: PaymentService,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
    @Optional()
    private readonly recognitionPort?: RevenueRecognitionPortService,
  ) {}

  private listScope(actor: AuthenticatedUser): MembershipListScope {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return { type: 'all' };
    }
    if (actor.userType === 'trainer') {
      if (actor.profileId == null) {
        return { type: 'trainer', trainerProfileId: -1 };
      }
      return { type: 'trainer', trainerProfileId: actor.profileId };
    }
    if (actor.profileId == null) {
      return { type: 'self', memberProfileId: -1 };
    }
    return { type: 'self', memberProfileId: actor.profileId };
  }

  /** FR-MEMB-007: member reads own contract; assigned trainer reads it (no pricing); admin/employee read all. */
  private async assertReadScope(actor: AuthenticatedUser, membership: Membership): Promise<void> {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return;
    }
    if (actor.userType === 'member') {
      if (actor.profileId === membership.member_id) {
        return;
      }
      throw new NotFoundError('Membership not found');
    }
    if (actor.userType === 'trainer') {
      const member = await this.memberRepository.findById(membership.member_id);
      if (member && member.assigned_trainer_id === actor.profileId) {
        return;
      }
      throw new NotFoundError('Membership not found');
    }
    throw new ForbiddenError();
  }

  /**
   * FR-MEMB-007/BR: trainer never sees pricing or locker; hides the nested product for them entirely.
   * CM-05: a member-scoped read shows only the partner's name, never the partner's membership/member id.
   */
  private present(membership: MembershipWithProduct, actor: AuthenticatedUser): MembershipWithProduct {
    if (actor.userType === 'trainer') {
      return { ...membership, product: null, locker_number: null };
    }
    if (actor.userType === 'member') {
      return { ...membership, partner_membership_id: null, partner_member_id: null };
    }
    return membership;
  }

  async list(
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<MembershipWithProduct>> {
    const filters = membershipFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findManyFiltered({
      memberId: filters.member_id,
      status: filters.status,
      scope: this.listScope(actor),
      limit: pagination.limit,
      offset,
    });

    return createPaginatedResponse({
      items: rows.map((row) => this.present(row, actor)),
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async getById(id: number, actor: AuthenticatedUser): Promise<MembershipWithProduct> {
    const membership = await this.repository.findByIdWithProduct(id);
    if (!membership) {
      throw new NotFoundError('Membership not found');
    }
    await this.assertReadScope(actor, membership);
    return this.present(membership, actor);
  }

  /** CM-07: cancels `before` inside the current transaction; caller emits the domain event after commit. */
  private async cancelRow(
    before: Membership,
    reason: string | null,
    actor: AuthenticatedUser,
    now: Date,
  ): Promise<void> {
    await this.repository.updateMembership(before.id, {
      status: 'cancelled',
      row_version: before.row_version + 1,
      updated_at: now,
    });

    await this.repository.insertHistory({
      membership_id: before.id,
      action: 'cancelled',
      old_end_date: before.end_date,
      new_end_date: before.end_date,
      performed_by_user_id: actor.id,
      timestamp: now,
    });

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'membership.cancelled',
      entityName: 'memberships',
      entityId: before.id,
      beforeState: { status: before.status },
      afterState: { status: 'cancelled', reason },
    });
  }

  /** CM-08: the linked partner row of a couple membership, or null for a single membership. */
  private async loadPartner(membership: Membership): Promise<Membership | null> {
    if (membership.partner_membership_id == null) {
      return null;
    }
    const partner = await this.repository.findPartner(membership);
    if (!partner) {
      throw new NotFoundError('Partner membership not found');
    }
    return partner;
  }

  /** CM-08: renew/upgrade must stay within the same package type (single <-> couple is rejected). */
  private async assertSamePackageType(
    current: Membership,
    target: MembershipProduct,
  ): Promise<void> {
    if (target.id === current.product_id) {
      return;
    }
    const currentProduct = await this.productRepository.findById(current.product_id);
    if (currentProduct && currentProduct.package_type !== target.package_type) {
      throw new BusinessRuleError(
        `Cannot switch between ${currentProduct.package_type} and ${target.package_type} packages`,
      );
    }
  }

  /** CM-08: renew a row and its history/audit inside the current transaction. */
  private async renewRow(
    row: Membership,
    productId: number,
    newEndDate: string,
    actor: AuthenticatedUser,
    now: Date,
    via?: string,
    checkVersion = true,
  ): Promise<void> {
    await this.repository.updateMembership(
      row.id,
      {
        product_id: productId,
        end_date: newEndDate,
        status: 'active',
        row_version: row.row_version + 1,
        updated_at: now,
      },
      checkVersion ? row.row_version : undefined,
    );
    await this.repository.insertHistory({
      membership_id: row.id,
      action: 'renewed',
      old_end_date: row.end_date,
      new_end_date: newEndDate,
      performed_by_user_id: actor.id,
      timestamp: now,
    });
    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'membership.renewed',
      entityName: 'memberships',
      entityId: row.id,
      beforeState: { end_date: row.end_date },
      afterState: via ? { end_date: newEndDate, via } : { end_date: newEndDate },
    });
  }

  /** CM-10: the twin of a paired freeze, or null for a single membership. It must still be pending. */
  private async loadPairedFreeze(freeze: MembershipFreeze): Promise<MembershipFreeze | null> {
    if (freeze.paired_freeze_id == null) {
      return null;
    }
    const paired = await this.repository.findFreezeById(freeze.paired_freeze_id);
    if (!paired) {
      throw new NotFoundError('Paired freeze not found');
    }
    if (paired.status !== 'pending') {
      throw new BusinessRuleError('Paired freeze is no longer pending');
    }
    return paired;
  }

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

  /** FR-MEMB-005/006/CM-07: assign a new contract; at most one active/frozen membership per member. */
  async create(dto: MembershipCreateDto, actor: AuthenticatedUser): Promise<MembershipWithProduct> {
    const member = await this.memberRepository.findById(dto.member_id);
    if (!member) {
      throw new NotFoundError('Member not found');
    }

    const product = await this.productRepository.findById(dto.product_id);
    if (!product || !product.is_active) {
      throw new NotFoundError('Membership product not found');
    }

    const isCouple = product.package_type === 'couple';
    if (isCouple && dto.partner_member_id == null) {
      throw new BadRequestError('partner_member_id is required for a couple package');
    }
    if (!isCouple && dto.partner_member_id != null) {
      throw new BadRequestError('partner_member_id is only valid for a couple package');
    }
    if (dto.partner_member_id != null && dto.partner_member_id === dto.member_id) {
      throw new BadRequestError('partner_member_id must differ from member_id');
    }

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

    let partnerExisting: Membership | null = null;
    if (partner) {
      partnerExisting = await this.repository.findActiveOrFrozenForMember(partner.id);
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

    if (
      dto.discount_amount !== undefined &&
      (cmpMoney(dto.discount_amount, '0') < 0 || cmpMoney(dto.discount_amount, product.base_price) > 0)
    ) {
      throw new BadRequestError('discount_amount must be between 0 and base_price');
    }

    const endDate = addDays(dto.start_date, product.duration_days);
    const now = new Date();

    const { primaryId, partnerId } = await runInTransaction(this.db, async () => {
      if (partnerExisting) {
        await this.cancelRow(partnerExisting, 'replaced_by_couple', actor, now);
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

      return { primaryId: primaryMembershipId, partnerId: partnerMembershipId };
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
    if (partnerExisting) {
      await this.domainEventBus.emit({
        eventName: 'membership.cancelled',
        occurredAt: now,
        payload: { membershipId: partnerExisting.id },
      });
    }

    const created = await this.repository.findByIdWithProduct(primaryId);
    if (!created) {
      throw new NotFoundError('Membership not found after creation');
    }
    return this.present(created, actor);
  }

  /** FR-MEMB-009: renew — continuation start is day after current end when still active. */
  async renew(
    id: number,
    dto: MembershipActionRequestDto,
    actor: AuthenticatedUser,
  ): Promise<MembershipWithProduct> {
    const before = await this.repository.findById(id);
    if (!before) {
      throw new NotFoundError('Membership not found');
    }
    verifyRowVersion(dto.row_version, before.row_version);

    const targetProductId = dto.product_id ?? before.product_id;
    const product = await this.productRepository.findById(targetProductId);
    if (!product || !product.is_active) {
      throw new NotFoundError('Membership product not found');
    }
    await this.assertSamePackageType(before, product);
    const partner = await this.loadPartner(before);

    const today = new Date().toISOString().slice(0, 10);
    const continuationStart =
      (before.status === 'active' || before.status === 'frozen') && before.end_date >= today
        ? addDays(before.end_date, 1)
        : today;
    const newEndDate = addDays(continuationStart, product.duration_days);
    const now = new Date();

    await runInTransaction(this.db, async () => {
      await this.renewRow(before, targetProductId, newEndDate, actor, now);
      if (partner) {
        await this.renewRow(partner, targetProductId, newEndDate, actor, now);
      }
    });

    await this.domainEventBus.emit({
      eventName: 'membership.renewed',
      occurredAt: now,
      payload: { membershipId: id },
    });
    if (partner) {
      await this.domainEventBus.emit({
        eventName: 'membership.renewed',
        occurredAt: now,
        payload: { membershipId: partner.id },
      });
    }

    const after = await this.repository.findByIdWithProduct(id);
    if (!after) {
      throw new NotFoundError('Membership not found after renew');
    }
    return this.present(after, actor);
  }

  /**
   * ADR-0012: a PT package includes a gym membership of the same duration, at no extra charge.
   * Runs inside the caller's (PT sale) transaction:
   * - no active membership → a new `PT-BUNDLE` membership covering the PT period;
   * - active membership → extended by the PT duration, the way a renewal continues it
   *   (a linked couple pair is extended together, once);
   * - frozen membership → rejected.
   * Returns domain events for the caller to publish via {@link emitEvents} after commit.
   */
  async bundleForPt(p: {
    memberIds: number[];
    startDate: string;
    endDate: string;
    durationDays: number;
    today: string;
    actor: AuthenticatedUser;
    now: Date;
  }): Promise<{ membershipIds: Map<number, number>; events: DomainEvent[] }> {
    const membershipIds = new Map<number, number>();
    const events: DomainEvent[] = [];
    const extended = new Set<number>();

    for (const memberId of p.memberIds) {
      const existing = await this.repository.findActiveOrFrozenForMember(memberId);

      if (existing?.status === 'frozen') {
        const member = await this.memberRepository.findById(memberId);
        const who = member ? `${member.first_name} ${member.last_name}`.trim() : 'Member';
        throw new BusinessRuleError(
          `${who}'s membership is frozen; unfreeze it before adding Personal Training`,
        );
      }

      if (existing) {
        membershipIds.set(memberId, existing.id);
        if (extended.has(existing.id)) {
          continue;
        }
        const partner = await this.loadPartner(existing);
        const continuation =
          existing.end_date >= p.today ? addDays(existing.end_date, 1) : p.today;
        const newEndDate = addDays(continuation, p.durationDays);
        for (const row of partner ? [existing, partner] : [existing]) {
          await this.renewRow(row, row.product_id, newEndDate, p.actor, p.now, 'pt_bundle');
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
        member_id: memberId,
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
          member_id: memberId,
          product_id: product.id,
          end_date: p.endDate,
          via: 'pt_bundle',
        },
      });
      membershipIds.set(memberId, membershipId);
      extended.add(membershipId);
      events.push({
        eventName: 'membership.created',
        occurredAt: p.now,
        payload: { membershipId, memberId },
      });
    }

    return { membershipIds, events };
  }

  /** Publishes events returned by {@link bundleForPt}; call after the transaction commits. */
  async emitEvents(events: DomainEvent[]): Promise<void> {
    for (const event of events) {
      await this.domainEventBus.emit(event);
    }
  }

  /** FR-MEMB-010: upgrade — switches product and recomputes the end date from the original start. */
  async upgrade(
    id: number,
    dto: MembershipUpgradeRequestDto,
    actor: AuthenticatedUser,
  ): Promise<MembershipWithProduct> {
    const before = await this.repository.findById(id);
    if (!before) {
      throw new NotFoundError('Membership not found');
    }
    verifyRowVersion(dto.row_version, before.row_version);

    const newProduct = await this.productRepository.findById(dto.product_id);
    if (!newProduct || !newProduct.is_active) {
      throw new NotFoundError('Membership product not found');
    }

    await this.assertSamePackageType(before, newProduct);
    const partner = await this.loadPartner(before);

    const newEndDate = addDays(before.start_date, newProduct.duration_days);
    const now = new Date();

    const upgradeRow = async (row: Membership) => {
      await this.repository.updateMembership(row.id, {
        product_id: dto.product_id,
        end_date: newEndDate,
        row_version: row.row_version + 1,
        updated_at: now,
      });

      await this.repository.insertHistory({
        membership_id: row.id,
        action: 'upgraded',
        old_end_date: row.end_date,
        new_end_date: newEndDate,
        performed_by_user_id: actor.id,
        timestamp: now,
      });

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'membership.upgraded',
        entityName: 'memberships',
        entityId: row.id,
        beforeState: { product_id: row.product_id, end_date: row.end_date },
        afterState: { product_id: dto.product_id, end_date: newEndDate },
      });
    };

    await runInTransaction(this.db, async () => {
      await upgradeRow(before);
      if (partner) {
        await upgradeRow(partner);
      }
    });

    for (const row of partner ? [before, partner] : [before]) {
      await this.domainEventBus.emit({
        eventName: 'membership.upgraded',
        occurredAt: now,
        payload: { membershipId: row.id },
      });
    }

    const after = await this.repository.findByIdWithProduct(id);
    if (!after) {
      throw new NotFoundError('Membership not found after upgrade');
    }
    return this.present(after, actor);
  }

  /** FR-MEMB-011: cancel — admin only (enforced by `memberships.approve` permission); no auto-refund. */
  async cancel(
    id: number,
    dto: MembershipActionRequestDto,
    actor: AuthenticatedUser,
  ): Promise<MembershipWithProduct> {
    const before = await this.repository.findById(id);
    if (!before) {
      throw new NotFoundError('Membership not found');
    }
    verifyRowVersion(dto.row_version, before.row_version);

    const partner = await this.loadPartner(before);
    const now = new Date();
    await runInTransaction(this.db, async () => {
      await this.cancelRow(before, dto.reason ?? null, actor, now);
      if (partner) {
        await this.cancelRow(partner, dto.reason ?? null, actor, now);
      }
      if (this.recognitionPort) {
        for (const row of partner ? [before, partner] : [before]) {
          await this.recognitionPort.onMembershipCancelled({
            membershipId: row.id,
            cancelledByUserId: actor.id,
          });
        }
      }
    });

    for (const row of partner ? [before, partner] : [before]) {
      await this.domainEventBus.emit({
        eventName: 'membership.cancelled',
        occurredAt: now,
        payload: { membershipId: row.id },
      });
    }

    const after = await this.repository.findByIdWithProduct(id);
    if (!after) {
      throw new NotFoundError('Membership not found after cancel');
    }
    return this.present(after, actor);
  }

  /** FR-MEMB-013: chronological, append-only, read-only to clients. */
  async listHistory(id: number, rawQuery: Record<string, unknown>, actor: AuthenticatedUser) {
    const membership = await this.repository.findById(id);
    if (!membership) {
      throw new NotFoundError('Membership not found');
    }
    await this.assertReadScope(actor, membership);

    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const rows = await this.repository.listHistory(id, pagination.limit);
    return createPaginatedResponse({ items: rows, limit: pagination.limit, offset: 0 });
  }

  async listFreezes(id: number, actor: AuthenticatedUser): Promise<MembershipFreeze[]> {
    const membership = await this.repository.findById(id);
    if (!membership) {
      throw new NotFoundError('Membership not found');
    }
    await this.assertReadScope(actor, membership);
    return this.repository.listFreezesForMembership(id);
  }

  /**
   * FR-MEMB-014/016: member submits a `pending` freeze; admin/employee create an already-`approved`
   * one and it takes effect immediately. FR-MEMB-018 overlap check applies to both.
   */
  async requestFreeze(
    id: number,
    dto: MembershipFreezeWriteDto,
    actor: AuthenticatedUser,
  ): Promise<MembershipFreeze> {
    const membership = await this.repository.findById(id);
    if (!membership) {
      throw new NotFoundError('Membership not found');
    }
    if (actor.userType === 'member' && actor.profileId !== membership.member_id) {
      throw new NotFoundError('Membership not found');
    }
    if (dto.end_date < dto.start_date) {
      throw new BadRequestError('end_date must not be before start_date');
    }

    const partner = await this.loadPartner(membership);

    // A cancelled/expired/already-frozen row must not be (re)frozen: a direct approval would
    // resurrect it as `frozen`.
    for (const row of partner ? [membership, partner] : [membership]) {
      if (row.status !== 'active') {
        throw new BusinessRuleError('Only active memberships can be frozen');
      }
    }

    const overlap = await this.repository.findOverlappingFreeze(id, dto.start_date, dto.end_date);
    if (overlap) {
      throw new BusinessRuleError('Freeze dates overlap an existing pending/approved freeze');
    }
    if (partner) {
      const partnerOverlap = await this.repository.findOverlappingFreeze(
        partner.id,
        dto.start_date,
        dto.end_date,
      );
      if (partnerOverlap) {
        throw new BusinessRuleError('Freeze dates overlap an existing pending/approved freeze');
      }
    }

    const isDirectApproval = actor.userType === 'admin' || actor.userType === 'employee';
    const totalDays = daysBetweenInclusive(dto.start_date, dto.end_date);
    const now = new Date();

    if (isDirectApproval) {
      for (const row of partner ? [membership, partner] : [membership]) {
        const product = await this.productRepository.findById(row.product_id);
        const approvedSoFar = await this.repository.sumApprovedFreezeDays(row.id);
        if (product && approvedSoFar + totalDays > product.max_freeze_days) {
          throw new BusinessRuleError(
            `Freeze exceeds product.max_freeze_days (${product.max_freeze_days})`,
          );
        }
      }
    }

    const createFreezeRow = async (row: Membership): Promise<number> => {
      const newFreezeId = await this.repository.insertFreeze({
        membership_id: row.id,
        start_date: dto.start_date,
        end_date: dto.end_date,
        total_freeze_days: totalDays,
        reason: dto.reason ?? null,
        status: isDirectApproval ? 'approved' : 'pending',
        reviewed_by_user_id: isDirectApproval ? actor.id : null,
        reviewed_at: isDirectApproval ? now : null,
        created_at: now,
      });

      if (isDirectApproval) {
        const newEndDate = addDays(row.end_date, totalDays);
        await this.repository.updateMembership(row.id, {
          status: 'frozen',
          end_date: newEndDate,
          row_version: row.row_version + 1,
          updated_at: now,
        });
        await this.repository.insertHistory({
          membership_id: row.id,
          action: 'frozen',
          old_end_date: row.end_date,
          new_end_date: newEndDate,
          performed_by_user_id: actor.id,
          timestamp: now,
        });

        if (this.recognitionPort) {
          await this.recognitionPort.onFreezeApproved({
            membershipId: id,
            freezeStartDate: dto.start_date,
          });
        }
      }

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: isDirectApproval ? 'membership.freeze_created_approved' : 'membership.freeze_requested',
        entityName: 'membership_freezes',
        entityId: newFreezeId,
        afterState: { membership_id: row.id, start_date: dto.start_date, end_date: dto.end_date },
      });

      return newFreezeId;
    };

    const { freezeId, partnerFreezeId } = await runInTransaction(this.db, async () => {
      const ownFreezeId = await createFreezeRow(membership);
      let twinFreezeId: number | null = null;
      if (partner) {
        twinFreezeId = await createFreezeRow(partner);
        await this.repository.setPairedFreeze(ownFreezeId, twinFreezeId);
        await this.repository.setPairedFreeze(twinFreezeId, ownFreezeId);
      }
      return { freezeId: ownFreezeId, partnerFreezeId: twinFreezeId };
    });

    const eventName = isDirectApproval ? 'membership.frozen' : 'membership.freeze_pending';
    await this.domainEventBus.emit({
      eventName,
      occurredAt: now,
      payload: { membershipId: id, freezeId },
    });
    if (partner && partnerFreezeId != null) {
      await this.domainEventBus.emit({
        eventName,
        occurredAt: now,
        payload: { membershipId: partner.id, freezeId: partnerFreezeId },
      });
    }

    const created = await this.repository.findFreezeById(freezeId);
    if (!created) {
      throw new NotFoundError('Freeze not found after creation');
    }
    return created;
  }

  /** FR-MEMB-015: approve — quota-checked at approval time since only approved days count. */
  async approveFreeze(freezeId: number, actor: AuthenticatedUser): Promise<MembershipFreeze> {
    const freeze = await this.repository.findFreezeById(freezeId);
    if (!freeze) {
      throw new NotFoundError('Freeze not found');
    }
    if (freeze.status !== 'pending') {
      throw new BusinessRuleError('Only pending freezes can be approved');
    }

    const pairedFreeze = await this.loadPairedFreeze(freeze);
    const targets = [freeze, ...(pairedFreeze ? [pairedFreeze] : [])];

    const rows: Array<{ freeze: MembershipFreeze; membership: Membership }> = [];
    for (const f of targets) {
      const membership = await this.repository.findById(f.membership_id);
      if (!membership) {
        throw new NotFoundError('Membership not found');
      }
      if (membership.status !== 'active') {
        throw new BusinessRuleError('Membership is no longer active; reject this freeze instead');
      }
      const product = await this.productRepository.findById(membership.product_id);
      const approvedSoFar = await this.repository.sumApprovedFreezeDays(f.membership_id);
      if (product && approvedSoFar + f.total_freeze_days > product.max_freeze_days) {
        throw new BusinessRuleError(
          `Freeze exceeds product.max_freeze_days (${product.max_freeze_days})`,
        );
      }
      rows.push({ freeze: f, membership });
    }

    const now = new Date();

    await runInTransaction(this.db, async () => {
      for (const { freeze: f, membership } of rows) {
        const newEndDate = addDays(membership.end_date, f.total_freeze_days);

        await this.repository.updateFreeze(f.id, {
          status: 'approved',
          reviewed_by_user_id: actor.id,
          reviewed_at: now,
        });

        await this.repository.updateMembership(f.membership_id, {
          status: 'frozen',
          end_date: newEndDate,
          row_version: membership.row_version + 1,
          updated_at: now,
        });

        await this.repository.insertHistory({
          membership_id: f.membership_id,
          action: 'frozen',
          old_end_date: membership.end_date,
          new_end_date: newEndDate,
          performed_by_user_id: actor.id,
          timestamp: now,
        });

        await this.auditService.recordAudit({
          actorUserId: actor.id,
          action: 'membership.freeze_approved',
          entityName: 'membership_freezes',
          entityId: f.id,
          beforeState: { status: 'pending' },
          afterState: { status: 'approved' },
        });

        if (this.recognitionPort) {
          await this.recognitionPort.onFreezeApproved({
            membershipId: f.membership_id,
            freezeStartDate: f.start_date,
          });
        }
      }
    });

    for (const { freeze: f } of rows) {
      await this.domainEventBus.emit({
        eventName: 'membership.frozen',
        occurredAt: now,
        payload: { membershipId: f.membership_id, freezeId: f.id },
      });
    }

    const after = await this.repository.findFreezeById(freezeId);
    if (!after) {
      throw new NotFoundError('Freeze not found after approval');
    }
    return after;
  }

  /** FR-MEMB-015: reject — membership is left unchanged. */
  async rejectFreeze(
    freezeId: number,
    dto: RejectRequestDto,
    actor: AuthenticatedUser,
  ): Promise<MembershipFreeze> {
    const freeze = await this.repository.findFreezeById(freezeId);
    if (!freeze) {
      throw new NotFoundError('Freeze not found');
    }
    if (freeze.status !== 'pending') {
      throw new BusinessRuleError('Only pending freezes can be rejected');
    }

    const pairedFreeze = await this.loadPairedFreeze(freeze);
    const now = new Date();
    await runInTransaction(this.db, async () => {
      for (const f of [freeze, ...(pairedFreeze ? [pairedFreeze] : [])]) {
        await this.repository.updateFreeze(f.id, {
          status: 'rejected',
          reviewed_by_user_id: actor.id,
          reviewed_at: now,
        });

        await this.auditService.recordAudit({
          actorUserId: actor.id,
          action: 'membership.freeze_rejected',
          entityName: 'membership_freezes',
          entityId: f.id,
          beforeState: { status: 'pending' },
          afterState: { status: 'rejected', reason: dto.reason ?? null },
        });
      }
    });

    const after = await this.repository.findFreezeById(freezeId);
    if (!after) {
      throw new NotFoundError('Freeze not found after rejection');
    }
    return after;
  }

  /** FR-MEMB-020: admin-granted compensatory extension; member cannot self-extend. */
  async extend(
    id: number,
    dto: MembershipExtensionWriteDto,
    actor: AuthenticatedUser,
  ): Promise<{ id: number; membership_id: number; days_extended: number; reason: string | null; granted_by_user_id: number; created_at: Date }> {
    const membership = await this.repository.findById(id);
    if (!membership) {
      throw new NotFoundError('Membership not found');
    }

    const partner = await this.loadPartner(membership);
    const now = new Date();

    const extendRow = async (row: Membership): Promise<number> => {
      const newEndDate = addDays(row.end_date, dto.days_extended);
      const newExtensionId = await this.repository.insertExtension({
        membership_id: row.id,
        days_extended: dto.days_extended,
        reason: dto.reason ?? null,
        granted_by_user_id: actor.id,
        created_at: now,
      });

      await this.repository.updateMembership(row.id, {
        end_date: newEndDate,
        row_version: row.row_version + 1,
        updated_at: now,
      });

      await this.repository.insertHistory({
        membership_id: row.id,
        action: 'extended',
        old_end_date: row.end_date,
        new_end_date: newEndDate,
        performed_by_user_id: actor.id,
        timestamp: now,
      });

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'membership.extended',
        entityName: 'membership_extensions',
        entityId: newExtensionId,
        afterState: { membership_id: row.id, days_extended: dto.days_extended },
      });

      if (this.recognitionPort) {
        await this.recognitionPort.onMembershipExtended({
          membershipId: id,
          newEndDate,
        });
      }

      return newExtensionId;
    };

    const { extensionId, partnerExtensionId } = await runInTransaction(this.db, async () => {
      const own = await extendRow(membership);
      const twin = partner ? await extendRow(partner) : null;
      return { extensionId: own, partnerExtensionId: twin };
    });

    await this.domainEventBus.emit({
      eventName: 'membership.extended',
      occurredAt: now,
      payload: { membershipId: id, extensionId },
    });
    if (partner && partnerExtensionId != null) {
      await this.domainEventBus.emit({
        eventName: 'membership.extended',
        occurredAt: now,
        payload: { membershipId: partner.id, extensionId: partnerExtensionId },
      });
    }

    return {
      id: extensionId,
      membership_id: id,
      days_extended: dto.days_extended,
      reason: dto.reason ?? null,
      granted_by_user_id: actor.id,
      created_at: now,
    };
  }

  /**
   * PAY-008 / MEMB consolidation: creates or renews membership when paying via desk/online.
   * Participates in ambient transactions, emits domain events, updates audit log,
   * and enforces row versioning.
   */
  async createOrRenewForPayment(params: {
    memberId: number;
    productId: number;
    membershipId?: number | null;
    startDate?: string;
    expectedRowVersion?: number;
    actor: AuthenticatedUser;
    now?: Date;
  }): Promise<number> {
    const product = await this.productRepository.findById(params.productId);
    if (!product || !product.is_active) {
      throw new NotFoundError('Membership product not found or inactive');
    }

    const member = await this.memberRepository.findById(params.memberId);
    if (!member) {
      throw new NotFoundError('Member not found');
    }

    let existing: Membership | null = null;
    if (params.membershipId != null) {
      existing = await this.repository.findById(params.membershipId);
      if (!existing) {
        throw new NotFoundError('Membership not found');
      }
    } else {
      existing = await this.repository.findActiveOrFrozenForMember(params.memberId);
    }

    const now = params.now ?? new Date();
    const today = now.toISOString().slice(0, 10);

    if (!existing) {
      if (product.package_type === 'couple') {
        throw new BusinessRuleError('Couple packages must be sold via POST /memberships');
      }
      const startDate = params.startDate ?? today;
      const endDate = addDays(startDate, product.duration_days);

      const membershipId = await runInTransaction(this.db, async () => {
        const id = await this.repository.insertMembership({
          member_id: params.memberId,
          product_id: params.productId,
          start_date: startDate,
          end_date: endDate,
          status: 'active',
          locker_number: null,
          auto_renew: false,
          row_version: 1,
          created_at: now,
        });

        await this.repository.insertHistory({
          membership_id: id,
          action: 'created',
          old_end_date: null,
          new_end_date: endDate,
          performed_by_user_id: params.actor.id,
          timestamp: now,
        });

        await this.auditService.recordAudit({
          actorUserId: params.actor.id,
          action: 'membership.created',
          entityName: 'memberships',
          entityId: id,
          afterState: { member_id: params.memberId, product_id: params.productId, via: 'payment' },
        });

        return id;
      });

      await this.domainEventBus.emit({
        eventName: 'membership.created',
        occurredAt: now,
        payload: { membershipId, memberId: params.memberId },
      });

      return membershipId;
    }

    if (params.expectedRowVersion != null) {
      verifyRowVersion(params.expectedRowVersion, existing.row_version);
    }

    const continuationStart =
      params.startDate ??
      ((existing.status === 'active' || existing.status === 'frozen') && existing.end_date >= today
        ? addDays(existing.end_date, 1)
        : today);
    const newEndDate = addDays(continuationStart, product.duration_days);

    await this.assertSamePackageType(existing, product);
    const partner = await this.loadPartner(existing);

    await runInTransaction(this.db, async () => {
      await this.renewRow(existing, params.productId, newEndDate, params.actor, now, 'payment');
      if (partner) {
        await this.renewRow(partner, params.productId, newEndDate, params.actor, now, 'payment');
      }
      if (this.recognitionPort) {
        for (const row of partner ? [existing, partner] : [existing]) {
          await this.recognitionPort.onMembershipUpgraded({
            membershipId: row.id,
            newEndDate,
          });
        }
      }
    });

    await this.domainEventBus.emit({
      eventName: 'membership.renewed',
      occurredAt: now,
      payload: { membershipId: existing.id },
    });
    if (partner) {
      await this.domainEventBus.emit({
        eventName: 'membership.renewed',
        occurredAt: now,
        payload: { membershipId: partner.id },
      });
    }

    return existing.id;
  }

  /** Unfreezes a frozen membership, restoring status to 'active' and unpausing recognition schedules. */
  async unfreeze(id: number, actor: AuthenticatedUser): Promise<Membership> {
    const membership = await this.repository.findById(id);
    if (!membership) {
      throw new NotFoundError('Membership not found');
    }
    if (membership.status !== 'frozen') {
      throw new BusinessRuleError('Membership is not frozen');
    }

    const now = new Date();
    await runInTransaction(this.db, async () => {
      await this.repository.updateMembership(id, {
        status: 'active',
        row_version: membership.row_version + 1,
        updated_at: now,
      });

      await this.repository.insertHistory({
        membership_id: id,
        action: 'status_changed',
        old_end_date: membership.end_date,
        new_end_date: membership.end_date,
        performed_by_user_id: actor.id,
        timestamp: now,
      });

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'membership.unfrozen',
        entityName: 'memberships',
        entityId: id,
        beforeState: { status: 'frozen' },
        afterState: { status: 'active' },
      });

      if (this.recognitionPort) {
        await this.recognitionPort.onFreezeEnded({
          membershipId: id,
          newEndDate: membership.end_date,
        });
      }
    });

    const updated = await this.repository.findById(id);
    return updated!;
  }
}
