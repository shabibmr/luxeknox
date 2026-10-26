import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { assertPartnerForPackage } from '../memb/membership-partner';
import { MembershipService } from '../memb/membership.service';
import { PaymentService } from '../pay/payment.service';
import type { PaymentDto } from '../pay/payment.dto';
import { MemberRepository } from '../people/member.repository';
import { assertMemberAccess } from '../people/row-scope';
import { TrainerRepository } from '../people/trainer.repository';
import { AuditService } from '../platform/audit/audit.service';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type {
  PtProduct,
  PtSubscription,
  PtSubscriptionChange,
} from '../platform/db/schema/personal-training';
import { runInTransaction } from '../platform/db/transaction-context';
import {
  BadRequestError,
  BusinessRuleError,
  ConflictError,
  NotFoundError,
} from '../platform/errors/app-error';
import { addMoney, cmpMoney } from '../platform/money/money';
import { formatDateInTimezone } from '../reports/reports.timezone';
import { ScheduleRepository } from '../sched/schedule.repository';
import { ScheduleTypeRepository } from '../sched/schedule-type.repository';
import { SettingsService } from '../sys/settings.service';
import type {
  PtChangeSlotDto,
  PtPurchaseDto,
  PtReassignTrainerDto,
  PtRenewDto,
} from './pt.dto';
import type { TrainerAccess } from './pt-access.service';
import { PtAccessService } from './pt-access.service';
import { PtProductRepository } from './pt-product.repository';
import { addDays, normalizeSlotStart, slotLabel } from './pt-schedule';
import { PtScheduleService, type OccurrenceWindow, type SlotConflict } from './pt-schedule.service';
import { OPEN_PT_STATUSES, PtSubscriptionRepository } from './pt-subscription.repository';

export const PT_SCHEDULE_TYPE_NAME = 'Personal Training';

export type PtSubscriptionView = PtSubscription & {
  product_name: string;
  package_type: 'single' | 'couple';
  sessions_per_week: number;
  trainer_name: string;
  slot_label: string;
  partner_member_id: number | null;
  partner_member_name: string | null;
};

export type MemberPtSummary = {
  /** The member's scheduled/active PT, if any. */
  current: PtSubscriptionView | null;
  history: PtSubscriptionView[];
  /** Only meaningful for a trainer caller; null for everyone else. */
  trainer_access: TrainerAccess | null;
};

type PaymentFields = Pick<
  PtPurchaseDto,
  'discount_amount' | 'payment_method_id' | 'tenders' | 'transaction_reference'
>;

@Injectable()
export class PtSubscriptionService {
  constructor(
    private readonly repository: PtSubscriptionRepository,
    private readonly productRepository: PtProductRepository,
    private readonly scheduleService: PtScheduleService,
    private readonly accessService: PtAccessService,
    private readonly memberRepository: MemberRepository,
    private readonly trainerRepository: TrainerRepository,
    private readonly membershipService: MembershipService,
    private readonly scheduleRepository: ScheduleRepository,
    private readonly scheduleTypeRepository: ScheduleTypeRepository,
    private readonly paymentService: PaymentService,
    private readonly settingsService: SettingsService,
    private readonly auditService: AuditService,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  async today(): Promise<string> {
    return formatDateInTimezone(new Date(), await this.settingsService.getTimezone());
  }

  // ---------------------------------------------------------------- reads

  async getById(id: number, actor: AuthenticatedUser): Promise<PtSubscriptionView> {
    const sub = await this.repository.findById(id);
    if (!sub) throw new NotFoundError('PT subscription not found');
    await this.assertReadScope(actor, sub.member_id, 'PT subscription not found');
    return this.present(sub, actor);
  }

  async summaryForMember(memberId: number, actor: AuthenticatedUser): Promise<MemberPtSummary> {
    await this.assertReadScope(actor, memberId, 'Member not found');
    const rows = await this.repository.listForMember(memberId);
    const views = await Promise.all(rows.map((r) => this.present(r, actor)));
    const current =
      views
        .filter((v) => (OPEN_PT_STATUSES as readonly string[]).includes(v.status))
        .sort((a, b) => a.start_date.localeCompare(b.start_date))[0] ?? null;
    const trainerAccess =
      actor.userType === 'trainer' && actor.profileId != null
        ? await this.accessService.trainerAccess(actor.profileId, memberId)
        : null;
    return { current, history: views, trainer_access: trainerAccess };
  }

  // ---------------------------------------------------------------- purchase / renew

  async purchase(
    dto: PtPurchaseDto,
    actor: AuthenticatedUser,
  ): Promise<{ subscription: PtSubscriptionView; payment: PaymentDto }> {
    const product = await this.requireActiveProduct(dto.pt_product_id);
    await this.scheduleService.requireMember(dto.member_id);
    await this.scheduleService.requireEligibleTrainer(dto.trainer_id);

    assertPartnerForPackage(product.package_type, dto.member_id, dto.partner_member_id);

    let partnerMember: { id: number; first_name: string; last_name: string } | null = null;
    if (dto.partner_member_id != null) {
      const partner = await this.memberRepository.findById(dto.partner_member_id);
      if (!partner) throw new NotFoundError('Partner member not found');
      partnerMember = partner;
    }

    const today = await this.today();
    if (dto.start_date < today) {
      throw new BadRequestError('start_date cannot be in the past');
    }

    const primaryMember = await this.memberRepository.findById(dto.member_id);
    const primaryLabel = primaryMember
      ? `${primaryMember.first_name} ${primaryMember.last_name}`.trim()
      : 'Member';
    const partnerLabel = partnerMember
      ? `${partnerMember.first_name} ${partnerMember.last_name}`.trim()
      : null;

    const endDate = addDays(dto.start_date, product.duration_days);
    await this.assertNoOtherOpenPt(dto.member_id, dto.start_date, endDate, primaryLabel);
    if (partnerMember) {
      await this.assertNoOtherOpenPt(partnerMember.id, dto.start_date, endDate, partnerLabel!);
    }
    await this.assertPaymentActivates(product.base_price, dto);

    const slotStart = normalizeSlotStart(dto.slot_start);

    return this.createPaidSubscription({
      memberId: dto.member_id,
      partnerMemberId: partnerMember?.id ?? null,
      product,
      trainerId: dto.trainer_id,
      renewedFromId: null,
      partnerRenewedFromId: null,
      startDate: dto.start_date,
      endDate,
      weekdays: dto.weekdays,
      slotStart,
      today,
      payment: dto,
      actor,
      auditAction: 'pt_subscription.purchased',
    });
  }

  /**
   * Renew: same trainer, weekdays and hour, continuing the day after the current end date.
   * Couple (CP-08): from either row, creates two new linked rows billed on the primary.
   */
  async renew(
    id: number,
    dto: PtRenewDto,
    actor: AuthenticatedUser,
  ): Promise<{ subscription: PtSubscriptionView; payment: PaymentDto }> {
    const current = await this.repository.findById(id);
    if (!current) throw new NotFoundError('PT subscription not found');
    if (current.status === 'cancelled') {
      throw new BusinessRuleError('Cancelled PT subscriptions cannot be renewed');
    }

    const product = await this.requireActiveProduct(dto.pt_product_id ?? current.pt_product_id);
    await this.assertSamePackageType(current, product);
    await this.scheduleService.requireEligibleTrainer(current.trainer_id);

    const today = await this.today();
    const partner = await this.loadPartner(current);
    const continuation = addDays(current.end_date, 1);
    const startDate = continuation > today ? continuation : today;
    const endDate = addDays(startDate, product.duration_days);
    await this.assertPaymentActivates(product.base_price, dto);

    const primary = partner ? (current.is_primary ? current : partner) : current;
    const secondary = partner ? (current.is_primary ? partner : current) : null;

    const primaryMember = await this.memberRepository.findById(primary.member_id);
    const primaryLabel = primaryMember
      ? `${primaryMember.first_name} ${primaryMember.last_name}`.trim()
      : 'Member';
    await this.assertNoOtherOpenPt(primary.member_id, startDate, endDate, primaryLabel);

    if (secondary) {
      const partnerMember = await this.memberRepository.findById(secondary.member_id);
      const partnerLabel = partnerMember
        ? `${partnerMember.first_name} ${partnerMember.last_name}`.trim()
        : 'Partner';
      await this.assertNoOtherOpenPt(secondary.member_id, startDate, endDate, partnerLabel);
    }

    return this.createPaidSubscription({
      memberId: primary.member_id,
      partnerMemberId: secondary?.member_id ?? null,
      product,
      trainerId: current.trainer_id,
      renewedFromId: primary.id,
      partnerRenewedFromId: secondary?.id ?? null,
      startDate,
      endDate,
      weekdays: current.weekdays,
      slotStart: current.slot_start,
      today,
      payment: dto,
      actor,
      auditAction: 'pt_subscription.renewed',
    });
  }

  // ---------------------------------------------------------------- mid-PT changes

  async reassignTrainer(
    id: number,
    dto: PtReassignTrainerDto,
    actor: AuthenticatedUser,
  ): Promise<PtSubscriptionView> {
    const sub = await this.requireOpenSubscription(id);
    const effective = await this.resolveEffectiveDate(sub, dto.effective_date);
    const oldTrainerId = this.trainerOn(sub, await this.repository.listChanges(sub.id), effective);
    if (dto.trainer_id === oldTrainerId) {
      throw new BadRequestError('Member is already with this trainer');
    }
    await this.scheduleService.requireEligibleTrainer(dto.trainer_id);

    return this.replan({
      sub,
      effectiveDate: effective,
      oldTrainerId,
      trainerId: dto.trainer_id,
      weekdays: sub.weekdays,
      slotStart: sub.slot_start,
      changeType: 'trainer',
      reason: dto.reason,
      actor,
    });
  }

  async changeSlot(id: number, dto: PtChangeSlotDto, actor: AuthenticatedUser): Promise<PtSubscriptionView> {
    const sub = await this.requireOpenSubscription(id);
    const effective = await this.resolveEffectiveDate(sub, dto.effective_date);
    const oldTrainerId = this.trainerOn(sub, await this.repository.listChanges(sub.id), effective);
    const trainerId = dto.trainer_id ?? oldTrainerId;
    if (trainerId !== oldTrainerId) {
      await this.scheduleService.requireEligibleTrainer(trainerId);
    }

    return this.replan({
      sub,
      effectiveDate: effective,
      oldTrainerId,
      trainerId,
      weekdays: dto.weekdays,
      slotStart: normalizeSlotStart(dto.slot_start),
      changeType: trainerId !== oldTrainerId ? 'trainer_slot' : 'slot',
      reason: dto.reason,
      actor,
    });
  }

  // ---------------------------------------------------------------- scheduled job

  /**
   * Called by the hourly job: scheduled → active, active → completed, and trainer handovers
   * whose effective date has arrived. A newly active PT's trainer becomes the member's
   * assigned trainer.
   */
  async runStatusTransitions(): Promise<{ activated: number; completed: number }> {
    const today = await this.today();
    return runInTransaction(this.db, async () => {
      const now = new Date();
      const completed = await this.repository.completeDue(today);
      const activated = await this.repository.activateDue(today);
      await this.applyDueTrainerChanges(today, now);
      for (const id of activated) {
        const sub = await this.repository.findById(id);
        if (sub) {
          await this.memberRepository.updateMember(sub.member_id, {
            assigned_trainer_id: sub.trainer_id,
            updated_at: now,
          });
        }
      }
      return { activated: activated.length, completed: completed.length };
    });
  }

  // ---------------------------------------------------------------- internals

  private async createPaidSubscription(p: {
    memberId: number;
    partnerMemberId: number | null;
    product: PtProduct;
    trainerId: number;
    renewedFromId: number | null;
    partnerRenewedFromId: number | null;
    startDate: string;
    endDate: string;
    weekdays: number[];
    slotStart: string;
    today: string;
    payment: PaymentFields;
    actor: AuthenticatedUser;
    auditAction: string;
  }): Promise<{ subscription: PtSubscriptionView; payment: PaymentDto }> {
    const windows = await this.scheduleService.occurrenceWindows(
      p.startDate,
      p.endDate,
      p.weekdays,
      p.slotStart,
    );
    if (windows.length === 0) {
      throw new BusinessRuleError('The chosen weekdays produce no sessions in this period');
    }

    const memberIds = p.partnerMemberId != null ? [p.memberId, p.partnerMemberId] : [p.memberId];

    const result = await runInTransaction(this.db, async () => {
      await this.repository.lockMembers(memberIds);
      await this.repository.lockTrainer(p.trainerId);
      // Re-checked under the member locks: a concurrent sale may have committed since.
      await this.assertNoOtherOpenPt(p.memberId, p.startDate, p.endDate);
      if (p.partnerMemberId != null) {
        await this.assertNoOtherOpenPt(p.partnerMemberId, p.startDate, p.endDate);
      }
      await this.throwIfConflicts(
        await this.scheduleService.findConflicts({
          trainerId: p.trainerId,
          memberIds,
          windows,
        }),
      );

      const now = new Date();

      // ADR-0012: PT includes a membership of the same duration (created or extended).
      const bundle = await this.membershipService.bundleForPt({
        memberIds,
        startDate: p.startDate,
        endDate: p.endDate,
        durationDays: p.product.duration_days,
        today: p.today,
        actor: p.actor,
        now,
      });
      const membershipId = bundle.membershipIds.get(p.memberId)!;
      const partnerMembershipId =
        p.partnerMemberId != null ? bundle.membershipIds.get(p.partnerMemberId)! : null;

      const weekdays = [...p.weekdays].sort((a, b) => a - b);
      const status = p.startDate <= p.today ? 'active' : 'scheduled';
      const shared = {
        pt_product_id: p.product.id,
        trainer_id: p.trainerId,
        start_date: p.startDate,
        end_date: p.endDate,
        weekdays,
        slot_start: p.slotStart,
        status,
        row_version: 1,
        created_at: now,
        updated_at: null,
      } as const;

      const primaryId = await this.repository.insertSubscription({
        ...shared,
        member_id: p.memberId,
        membership_id: membershipId,
        renewed_from_id: p.renewedFromId,
        is_primary: true,
        partner_subscription_id: null,
      });

      let partnerId: number | null = null;
      if (p.partnerMemberId != null && partnerMembershipId != null) {
        partnerId = await this.repository.insertSubscription({
          ...shared,
          member_id: p.partnerMemberId,
          membership_id: partnerMembershipId,
          renewed_from_id: p.partnerRenewedFromId,
          is_primary: false,
          partner_subscription_id: primaryId,
        });
        await this.repository.setPartner(primaryId, partnerId);
      }

      const payment = await this.paymentService.create(
        {
          member_id: p.memberId,
          subtotal: p.product.base_price,
          discount_amount: p.payment.discount_amount,
          payment_method_id: p.payment.payment_method_id,
          tenders: p.payment.tenders,
          transaction_reference: p.payment.transaction_reference,
        },
        p.actor,
        { ptSubscriptionId: primaryId },
      );

      await this.generateOccurrences(primaryId, memberIds, p.trainerId, windows, p.actor, now);

      for (const memberId of memberIds) {
        // A future PT must not take the member away from a trainer who is still running
        // their current PT; the status job hands over on the start date instead.
        if (p.startDate <= p.today || !(await this.repository.hasActiveForMember(memberId))) {
          await this.memberRepository.updateMember(memberId, {
            assigned_trainer_id: p.trainerId,
            updated_at: now,
          });
        }
      }

      const created = (await this.repository.findById(primaryId))!;
      await this.auditService.recordAudit({
        actorUserId: p.actor.id,
        action: p.auditAction,
        entityName: 'pt_subscriptions',
        entityId: primaryId,
        afterState: { ...created, payment_id: payment.id, sessions: windows.length },
      });
      if (partnerId != null) {
        const partnerRow = (await this.repository.findById(partnerId))!;
        await this.auditService.recordAudit({
          actorUserId: p.actor.id,
          action: p.auditAction,
          entityName: 'pt_subscriptions',
          entityId: partnerId,
          afterState: { ...partnerRow, payment_id: payment.id, sessions: windows.length },
        });
      }
      return { created, payment, membershipEvents: bundle.events };
    });

    await this.membershipService.emitEvents(result.membershipEvents);

    return { subscription: await this.present(result.created, p.actor), payment: result.payment };
  }

  /** CP-08: linked partner row, or null for a single PT. */
  private async loadPartner(sub: PtSubscription): Promise<PtSubscription | null> {
    if (sub.partner_subscription_id == null) {
      return null;
    }
    const partner = await this.repository.findPartner(sub);
    if (!partner) {
      throw new NotFoundError('Partner PT subscription not found');
    }
    return partner;
  }

  /** CP-08: renew must stay within the same package type (single ↔ couple is rejected). */
  private async assertSamePackageType(current: PtSubscription, target: PtProduct): Promise<void> {
    if (target.id === current.pt_product_id) {
      return;
    }
    const currentProduct = await this.productRepository.findById(current.pt_product_id);
    if (currentProduct && currentProduct.package_type !== target.package_type) {
      throw new BusinessRuleError(
        `Cannot switch between ${currentProduct.package_type} and ${target.package_type} packages`,
      );
    }
  }

  private async replan(p: {
    sub: PtSubscription;
    effectiveDate: string;
    /** Trainer holding the PT on the effective date (may differ from sub.trainer_id). */
    oldTrainerId: number;
    trainerId: number;
    weekdays: number[];
    slotStart: string;
    changeType: 'trainer' | 'slot' | 'trainer_slot';
    reason?: string;
    actor: AuthenticatedUser;
  }): Promise<PtSubscriptionView> {
    const now = new Date();
    // A future-dated handover keeps the current trainer (and their write access) until the
    // effective date; runStatusTransitions applies it then.
    const takesEffectNow = p.effectiveDate <= (await this.today());
    const partner = await this.loadPartner(p.sub);
    const ownerId = this.repository.occurrenceOwnerId(p.sub);
    const memberIds = partner
      ? [p.sub.member_id, partner.member_id]
      : [p.sub.member_id];
    const rows = partner ? [p.sub, partner] : [p.sub];
    const windows = (
      await this.scheduleService.occurrenceWindows(
        p.effectiveDate,
        p.sub.end_date,
        p.weekdays,
        p.slotStart,
      )
    ).filter((w) => w.start > now);

    const updated = await runInTransaction(this.db, async () => {
      await this.repository.lockMembers(memberIds);
      await this.repository.lockTrainer(p.trainerId);
      await this.throwIfConflicts(
        await this.scheduleService.findConflicts({
          trainerId: p.trainerId,
          memberIds,
          windows,
          excludeSubscriptionId: ownerId,
        }),
      );

      // Occurrences from the effective date onward are replaced; earlier ones (history,
      // attendance) are untouched. Never touch anything that has already started.
      // Couple sessions hang off the primary (owner) row only.
      const effectiveStart = await this.scheduleService.startOfDayUtc(p.effectiveDate);
      await this.cancelFutureOccurrences(
        ownerId,
        effectiveStart > now ? effectiveStart : now,
        p.actor,
        now,
      );
      await this.generateOccurrences(ownerId, memberIds, p.trainerId, windows, p.actor, now);

      const auditAction =
        p.changeType === 'trainer'
          ? 'pt_subscription.trainer_reassigned'
          : 'pt_subscription.slot_changed';
      const weekdays = [...p.weekdays].sort((a, b) => a - b);

      for (const row of rows) {
        await this.repository.updateSubscription(row.id, {
          ...(takesEffectNow ? { trainer_id: p.trainerId } : {}),
          weekdays,
          slot_start: p.slotStart,
          row_version: row.row_version + 1,
          updated_at: now,
        });
        if (takesEffectNow && p.trainerId !== row.trainer_id) {
          await this.memberRepository.updateMember(row.member_id, {
            assigned_trainer_id: p.trainerId,
            updated_at: now,
          });
        }
        await this.repository.insertChange({
          pt_subscription_id: row.id,
          change_type: p.changeType,
          effective_date: p.effectiveDate,
          old_trainer_id: p.oldTrainerId,
          new_trainer_id: p.trainerId,
          old_weekdays: row.weekdays,
          new_weekdays: p.weekdays,
          old_slot_start: row.slot_start,
          new_slot_start: p.slotStart,
          reason: p.reason ?? null,
          changed_by_user_id: p.actor.id,
          created_at: now,
        });
        const after = (await this.repository.findById(row.id))!;
        await this.auditService.recordAudit({
          actorUserId: p.actor.id,
          action: auditAction,
          entityName: 'pt_subscriptions',
          entityId: row.id,
          beforeState: row,
          afterState: after,
        });
      }

      return (await this.repository.findById(p.sub.id))!;
    });

    return this.present(updated, p.actor);
  }

  /**
   * Trainer holding the PT on `date`. A re-plan replaces sessions from its effective date
   * onward, so the most recently recorded change already in effect wins; before any change
   * takes effect it is the original trainer. `changes` must be newest first.
   */
  private trainerOn(sub: PtSubscription, changes: PtSubscriptionChange[], date: string): number {
    const inEffect = changes.find((c) => c.effective_date <= date && c.new_trainer_id != null);
    if (inEffect) return inEffect.new_trainer_id!;
    return changes[changes.length - 1]?.old_trainer_id ?? sub.trainer_id;
  }

  /** Applies trainer handovers whose effective date has arrived. */
  private async applyDueTrainerChanges(today: string, now: Date): Promise<void> {
    for (const sub of await this.repository.listOpenWithEffectiveChanges(today)) {
      const trainerId = this.trainerOn(sub, await this.repository.listChanges(sub.id), today);
      if (trainerId === sub.trainer_id) continue;
      await this.repository.updateSubscription(sub.id, {
        trainer_id: trainerId,
        row_version: sub.row_version + 1,
        updated_at: now,
      });
      if (sub.status === 'active') {
        await this.memberRepository.updateMember(sub.member_id, {
          assigned_trainer_id: trainerId,
          updated_at: now,
        });
      }
    }
  }

  private async generateOccurrences(
    subscriptionId: number,
    memberIds: number[],
    trainerId: number,
    windows: OccurrenceWindow[],
    actor: AuthenticatedUser,
    now: Date,
  ): Promise<void> {
    const type = await this.scheduleTypeRepository.findByName(PT_SCHEDULE_TYPE_NAME);
    if (!type) {
      throw new NotFoundError(`Schedule type "${PT_SCHEDULE_TYPE_NAME}" is missing; run migrations`);
    }
    const names: string[] = [];
    for (const memberId of memberIds) {
      const member = await this.memberRepository.findById(memberId);
      names.push(member ? `${member.first_name} ${member.last_name}`.trim() : `Member #${memberId}`);
    }
    const title = `PT · ${names.join(' & ')}`;
    const capacity = memberIds.length;

    for (const w of windows) {
      const scheduleId = await this.scheduleRepository.insertSchedule({
        series_id: null,
        pt_subscription_id: subscriptionId,
        schedule_type_id: type.id,
        facility_id: null,
        trainer_id: trainerId,
        title,
        start_time: w.start,
        end_time: w.end,
        max_capacity: capacity,
        status: 'scheduled',
        notes: null,
        row_version: 1,
        created_at: now,
        updated_at: null,
      });
      for (const memberId of memberIds) {
        await this.scheduleRepository.insertParticipant({
          schedule_id: scheduleId,
          member_id: memberId,
          booking_status: 'booked',
          attended: null,
          booked_at: now,
          marked_at: null,
        });
      }
      await this.scheduleRepository.insertHistory({
        schedule_id: scheduleId,
        action: 'created',
        changed_by_user_id: actor.id,
        notes: `PT subscription #${subscriptionId}`,
        timestamp: now,
      });
    }
  }

  private async cancelFutureOccurrences(
    subscriptionId: number,
    from: Date,
    actor: AuthenticatedUser,
    now: Date,
  ): Promise<void> {
    const ids = await this.repository.findFutureOccurrenceIds(subscriptionId, from);
    for (const scheduleId of ids) {
      await this.scheduleRepository.updateSchedule(scheduleId, { status: 'cancelled', updated_at: now });
      await this.scheduleRepository.cancelParticipants(scheduleId);
      await this.scheduleRepository.insertHistory({
        schedule_id: scheduleId,
        action: 'cancelled',
        changed_by_user_id: actor.id,
        notes: `PT subscription #${subscriptionId} re-planned`,
        timestamp: now,
      });
    }
  }

  private async throwIfConflicts(conflicts: SlotConflict[]): Promise<void> {
    if (conflicts.length === 0) return;
    const first = conflicts[0]!;
    const what =
      first.reason === 'unavailable'
        ? 'trainer is not available'
        : first.reason === 'member_busy'
          ? 'member already has a session'
          : `slot is occupied${first.occupied_by ? ` by ${first.occupied_by}` : ''}`;
    throw new ConflictError(
      `Slot not free for the whole period: ${what} on ${first.date}` +
        (conflicts.length > 1 ? ` (+${conflicts.length - 1} more date(s))` : ''),
      conflicts,
    );
  }

  private async requireActiveProduct(id: number): Promise<PtProduct> {
    const product = await this.productRepository.findById(id);
    if (!product || !product.is_active) throw new NotFoundError('PT package not found or inactive');
    return product;
  }

  private async assertNoOtherOpenPt(
    memberId: number,
    from: string,
    to: string,
    who = 'Member',
  ): Promise<void> {
    const open = await this.repository.findOpenOverlappingForMember(memberId, from, to);
    if (open.length > 0) {
      throw new ConflictError(
        `${who} already has Personal Training until ${open[0]!.end_date}; renew it or start after that date`,
      );
    }
  }

  /** Mirrors PaymentService.create's activation rule: paid, or partial when the gym setting allows. */
  private async assertPaymentActivates(subtotal: string, dto: PaymentFields): Promise<void> {
    const totals = await this.paymentService.computeTotals(subtotal, dto.discount_amount);
    if (cmpMoney(totals.total, '0') <= 0) return;
    const paid = dto.tenders?.length
      ? dto.tenders.reduce((sum, t) => addMoney(sum, t.amount), '0.00')
      : dto.payment_method_id != null
        ? totals.total
        : '0.00';
    const status = this.paymentService.resolveStatus(totals.total, paid);
    const allowPartial = await this.settingsService.getPaymentsActivateMembershipOnPartial();
    if (!(status === 'paid' || (status === 'partial' && allowPartial))) {
      throw new BusinessRuleError(
        allowPartial
          ? 'Record at least a partial payment to activate Personal Training'
          : 'Personal Training must be paid in full to activate',
      );
    }
  }

  private async requireOpenSubscription(id: number): Promise<PtSubscription> {
    const sub = await this.repository.findById(id);
    if (!sub) throw new NotFoundError('PT subscription not found');
    if (!(OPEN_PT_STATUSES as readonly string[]).includes(sub.status)) {
      throw new BusinessRuleError('Only scheduled or active PT subscriptions can be changed');
    }
    return sub;
  }

  private async resolveEffectiveDate(sub: PtSubscription, requested: string): Promise<string> {
    const today = await this.today();
    const floor = sub.start_date > today ? sub.start_date : today;
    if (requested < floor) {
      throw new BadRequestError(`effective_date must be on or after ${floor}`);
    }
    if (requested > sub.end_date) {
      throw new BadRequestError(`effective_date must be on or before ${sub.end_date}`);
    }
    return requested;
  }

  private async assertReadScope(actor: AuthenticatedUser, memberId: number, notFound: string): Promise<void> {
    try {
      await assertMemberAccess(this.memberRepository, actor, memberId);
    } catch (err) {
      if (err instanceof NotFoundError) throw new NotFoundError(notFound);
      throw err;
    }
  }

  /**
   * CP-06: enrich with package_type and partner fields. A member-scoped read keeps only the
   * partner's name — never the partner subscription/member ids.
   */
  private async present(sub: PtSubscription, actor?: AuthenticatedUser): Promise<PtSubscriptionView> {
    const [product, trainer] = await Promise.all([
      this.productRepository.findById(sub.pt_product_id),
      this.trainerRepository.findById(sub.trainer_id),
    ]);

    let partnerMemberId: number | null = null;
    let partnerMemberName: string | null = null;
    if (sub.partner_subscription_id != null) {
      const partner = await this.repository.findPartner(sub);
      if (partner) {
        partnerMemberId = partner.member_id;
        const partnerMember = await this.memberRepository.findById(partner.member_id);
        partnerMemberName = partnerMember
          ? `${partnerMember.first_name} ${partnerMember.last_name}`.trim()
          : null;
      }
    }

    const view: PtSubscriptionView = {
      ...sub,
      product_name: product?.name ?? '',
      package_type: product?.package_type ?? 'single',
      sessions_per_week: sub.weekdays.length,
      trainer_name: trainer ? `${trainer.first_name} ${trainer.last_name}`.trim() : '',
      slot_label: slotLabel(sub.slot_start),
      partner_member_id: partnerMemberId,
      partner_member_name: partnerMemberName,
    };

    if (actor?.userType === 'member') {
      return {
        ...view,
        partner_subscription_id: null,
        partner_member_id: null,
      };
    }
    return view;
  }
}
