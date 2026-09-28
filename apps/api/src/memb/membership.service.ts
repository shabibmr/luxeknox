import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { runInTransaction } from '../platform/db/transaction-context';
import type { Membership, MembershipFreeze } from '../platform/db/schema/memberships';
import { verifyRowVersion } from '../platform/concurrency/row-version';
import { DomainEventBus } from '../platform/events/domain-events';
import {
  BadRequestError,
  BusinessRuleError,
  ConflictError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { MemberRepository } from '../people/member.repository';
import { Inject } from '@nestjs/common';
import { MembershipProductRepository } from './membership-product.repository';
import {
  type MembershipCreateDto,
  type MembershipActionRequestDto,
  type MembershipExtensionWriteDto,
  type MembershipFreezeWriteDto,
  type MembershipUpgradeRequestDto,
  type RejectRequestDto,
  membershipFilterQuerySchema,
} from './membership.dto';
import {
  MembershipRepository,
  type MembershipListScope,
  type MembershipWithProduct,
} from './membership.repository';

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

@Injectable()
export class MembershipService {
  constructor(
    private readonly repository: MembershipRepository,
    private readonly productRepository: MembershipProductRepository,
    private readonly memberRepository: MemberRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
    private readonly domainEventBus: DomainEventBus,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
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

  /** FR-MEMB-007/BR: trainer never sees pricing or locker; hides the nested product for them entirely. */
  private present(membership: MembershipWithProduct, actor: AuthenticatedUser): MembershipWithProduct {
    if (actor.userType !== 'trainer') {
      return membership;
    }
    return { ...membership, product: null, locker_number: null };
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

  /** FR-MEMB-005/006: assign a new contract; at most one active/frozen membership per member. */
  async create(dto: MembershipCreateDto, actor: AuthenticatedUser): Promise<MembershipWithProduct> {
    const member = await this.memberRepository.findById(dto.member_id);
    if (!member) {
      throw new NotFoundError('Member not found');
    }

    const product = await this.productRepository.findById(dto.product_id);
    if (!product || !product.is_active) {
      throw new NotFoundError('Membership product not found');
    }

    const existing = await this.repository.findActiveOrFrozenForMember(dto.member_id);
    if (existing) {
      throw new BusinessRuleError(
        'Member already has an active or frozen membership; use renew/upgrade instead',
      );
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

    const id = await runInTransaction(this.db, async () => {
      const membershipId = await this.repository.insertMembership({
        member_id: dto.member_id,
        product_id: dto.product_id,
        start_date: dto.start_date,
        end_date: endDate,
        remaining_pt_sessions: product.pt_sessions_included,
        status: 'active',
        locker_number: dto.locker_number ?? null,
        auto_renew: dto.auto_renew ?? false,
        row_version: 1,
        created_at: now,
      });

      await this.repository.insertHistory({
        membership_id: membershipId,
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
        entityId: membershipId,
        afterState: { member_id: dto.member_id, product_id: dto.product_id, end_date: endDate },
      });

      return membershipId;
    });

    await this.domainEventBus.emit({
      eventName: 'membership.created',
      occurredAt: now,
      payload: { membershipId: id, memberId: dto.member_id },
    });

    const created = await this.repository.findByIdWithProduct(id);
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

    const today = new Date().toISOString().slice(0, 10);
    const continuationStart =
      (before.status === 'active' || before.status === 'frozen') && before.end_date >= today
        ? addDays(before.end_date, 1)
        : today;
    const newEndDate = addDays(continuationStart, product.duration_days);
    const now = new Date();

    await runInTransaction(this.db, async () => {
      await this.repository.updateMembership(
        id,
        {
          product_id: targetProductId,
          end_date: newEndDate,
          status: 'active',
          remaining_pt_sessions: before.remaining_pt_sessions + product.pt_sessions_included,
          row_version: before.row_version + 1,
          updated_at: now,
        },
        before.row_version,
      );

      await this.repository.insertHistory({
        membership_id: id,
        action: 'renewed',
        old_end_date: before.end_date,
        new_end_date: newEndDate,
        performed_by_user_id: actor.id,
        timestamp: now,
      });

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'membership.renewed',
        entityName: 'memberships',
        entityId: id,
        beforeState: { end_date: before.end_date },
        afterState: { end_date: newEndDate },
      });
    });

    await this.domainEventBus.emit({
      eventName: 'membership.renewed',
      occurredAt: now,
      payload: { membershipId: id },
    });

    const after = await this.repository.findByIdWithProduct(id);
    if (!after) {
      throw new NotFoundError('Membership not found after renew');
    }
    return this.present(after, actor);
  }

  /** FR-MEMB-010: upgrade — switches product, resets PT sessions to the new plan's included amount. */
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

    const newEndDate = addDays(before.start_date, newProduct.duration_days);
    const now = new Date();

    await runInTransaction(this.db, async () => {
      await this.repository.updateMembership(id, {
        product_id: dto.product_id,
        end_date: newEndDate,
        remaining_pt_sessions: newProduct.pt_sessions_included,
        row_version: before.row_version + 1,
        updated_at: now,
      });

      await this.repository.insertHistory({
        membership_id: id,
        action: 'upgraded',
        old_end_date: before.end_date,
        new_end_date: newEndDate,
        performed_by_user_id: actor.id,
        timestamp: now,
      });

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'membership.upgraded',
        entityName: 'memberships',
        entityId: id,
        beforeState: { product_id: before.product_id, end_date: before.end_date },
        afterState: { product_id: dto.product_id, end_date: newEndDate },
      });
    });

    await this.domainEventBus.emit({
      eventName: 'membership.upgraded',
      occurredAt: now,
      payload: { membershipId: id },
    });

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

    const now = new Date();
    await runInTransaction(this.db, async () => {
      await this.repository.updateMembership(id, {
        status: 'cancelled',
        row_version: before.row_version + 1,
        updated_at: now,
      });

      await this.repository.insertHistory({
        membership_id: id,
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
        entityId: id,
        beforeState: { status: before.status },
        afterState: { status: 'cancelled', reason: dto.reason ?? null },
      });
    });

    await this.domainEventBus.emit({
      eventName: 'membership.cancelled',
      occurredAt: now,
      payload: { membershipId: id },
    });

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

    const overlap = await this.repository.findOverlappingFreeze(id, dto.start_date, dto.end_date);
    if (overlap) {
      throw new BusinessRuleError('Freeze dates overlap an existing pending/approved freeze');
    }

    const isDirectApproval = actor.userType === 'admin' || actor.userType === 'employee';
    const totalDays = daysBetweenInclusive(dto.start_date, dto.end_date);
    const now = new Date();

    if (isDirectApproval) {
      const product = await this.productRepository.findById(membership.product_id);
      const approvedSoFar = await this.repository.sumApprovedFreezeDays(id);
      if (product && approvedSoFar + totalDays > product.max_freeze_days) {
        throw new BusinessRuleError(
          `Freeze exceeds product.max_freeze_days (${product.max_freeze_days})`,
        );
      }
    }

    const freezeId = await runInTransaction(this.db, async () => {
      const newFreezeId = await this.repository.insertFreeze({
        membership_id: id,
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
        const newEndDate = addDays(membership.end_date, totalDays);
        await this.repository.updateMembership(id, {
          status: 'frozen',
          end_date: newEndDate,
          row_version: membership.row_version + 1,
          updated_at: now,
        });
        await this.repository.insertHistory({
          membership_id: id,
          action: 'frozen',
          old_end_date: membership.end_date,
          new_end_date: newEndDate,
          performed_by_user_id: actor.id,
          timestamp: now,
        });
      }

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: isDirectApproval ? 'membership.freeze_created_approved' : 'membership.freeze_requested',
        entityName: 'membership_freezes',
        entityId: newFreezeId,
        afterState: { membership_id: id, start_date: dto.start_date, end_date: dto.end_date },
      });

      return newFreezeId;
    });

    await this.domainEventBus.emit({
      eventName: isDirectApproval ? 'membership.frozen' : 'membership.freeze_pending',
      occurredAt: now,
      payload: { membershipId: id, freezeId },
    });

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

    const membership = await this.repository.findById(freeze.membership_id);
    if (!membership) {
      throw new NotFoundError('Membership not found');
    }
    const product = await this.productRepository.findById(membership.product_id);
    const approvedSoFar = await this.repository.sumApprovedFreezeDays(freeze.membership_id);
    if (product && approvedSoFar + freeze.total_freeze_days > product.max_freeze_days) {
      throw new BusinessRuleError(
        `Freeze exceeds product.max_freeze_days (${product.max_freeze_days})`,
      );
    }

    const now = new Date();
    const newEndDate = addDays(membership.end_date, freeze.total_freeze_days);

    await runInTransaction(this.db, async () => {
      await this.repository.updateFreeze(freezeId, {
        status: 'approved',
        reviewed_by_user_id: actor.id,
        reviewed_at: now,
      });

      await this.repository.updateMembership(freeze.membership_id, {
        status: 'frozen',
        end_date: newEndDate,
        row_version: membership.row_version + 1,
        updated_at: now,
      });

      await this.repository.insertHistory({
        membership_id: freeze.membership_id,
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
        entityId: freezeId,
        beforeState: { status: 'pending' },
        afterState: { status: 'approved' },
      });
    });

    await this.domainEventBus.emit({
      eventName: 'membership.frozen',
      occurredAt: now,
      payload: { membershipId: freeze.membership_id, freezeId },
    });

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

    const now = new Date();
    await this.repository.updateFreeze(freezeId, {
      status: 'rejected',
      reviewed_by_user_id: actor.id,
      reviewed_at: now,
    });

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'membership.freeze_rejected',
      entityName: 'membership_freezes',
      entityId: freezeId,
      beforeState: { status: 'pending' },
      afterState: { status: 'rejected', reason: dto.reason ?? null },
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

    const now = new Date();
    const newEndDate = addDays(membership.end_date, dto.days_extended);

    const extensionId = await runInTransaction(this.db, async () => {
      const newExtensionId = await this.repository.insertExtension({
        membership_id: id,
        days_extended: dto.days_extended,
        reason: dto.reason ?? null,
        granted_by_user_id: actor.id,
        created_at: now,
      });

      await this.repository.updateMembership(id, {
        end_date: newEndDate,
        row_version: membership.row_version + 1,
        updated_at: now,
      });

      await this.repository.insertHistory({
        membership_id: id,
        action: 'extended',
        old_end_date: membership.end_date,
        new_end_date: newEndDate,
        performed_by_user_id: actor.id,
        timestamp: now,
      });

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: 'membership.extended',
        entityName: 'membership_extensions',
        entityId: newExtensionId,
        afterState: { membership_id: id, days_extended: dto.days_extended },
      });

      return newExtensionId;
    });

    await this.domainEventBus.emit({
      eventName: 'membership.extended',
      occurredAt: now,
      payload: { membershipId: id, extensionId },
    });

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
      const startDate = params.startDate ?? today;
      const endDate = addDays(startDate, product.duration_days);

      const membershipId = await runInTransaction(this.db, async () => {
        const id = await this.repository.insertMembership({
          member_id: params.memberId,
          product_id: params.productId,
          start_date: startDate,
          end_date: endDate,
          remaining_pt_sessions: product.pt_sessions_included,
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

    await runInTransaction(this.db, async () => {
      await this.repository.updateMembership(
        existing.id,
        {
          product_id: params.productId,
          end_date: newEndDate,
          status: 'active',
          remaining_pt_sessions: existing.remaining_pt_sessions + product.pt_sessions_included,
          row_version: existing.row_version + 1,
          updated_at: now,
        },
        existing.row_version,
      );

      await this.repository.insertHistory({
        membership_id: existing.id,
        action: 'renewed',
        old_end_date: existing.end_date,
        new_end_date: newEndDate,
        performed_by_user_id: params.actor.id,
        timestamp: now,
      });

      await this.auditService.recordAudit({
        actorUserId: params.actor.id,
        action: 'membership.renewed',
        entityName: 'memberships',
        entityId: existing.id,
        beforeState: { end_date: existing.end_date },
        afterState: { end_date: newEndDate, via: 'payment' },
      });
    });

    await this.domainEventBus.emit({
      eventName: 'membership.renewed',
      occurredAt: now,
      payload: { membershipId: existing.id },
    });

    return existing.id;
  }
}
