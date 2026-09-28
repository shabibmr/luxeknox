import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { UserRepository } from '../auth/user.repository';
import { MembershipRepository } from '../memb/membership.repository';
import { AuditService } from '../platform/audit/audit.service';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { Attendance, AttendanceHistory } from '../platform/db/schema/attendance';
import { members } from '../platform/db/schema/members';
import { runInTransaction } from '../platform/db/transaction-context';
import {
  BadRequestError,
  BusinessRuleError,
  ConflictError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { DomainEventBus } from '../platform/events/domain-events';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import { SettingsService } from '../sys/settings.service';
import type {
  AttendanceHistoryDto,
  AttendanceResponseDto,
  AttendanceSummaryDto,
  AttendanceSummaryQueryDto,
  CheckInRequestDto,
  ListAttendanceHistoriesQueryDto,
  ListAttendancesQueryDto,
  ManualOverrideRequestDto,
  OccupancyDto,
} from './attendance.dto';
import {
  AttendanceRepository,
  type AttendanceListScope,
} from './attendance.repository';
import { HardwareIngestAdapter } from './hardware-ingest.adapter';

const STAFF_TYPES = new Set(['admin', 'employee', 'trainer']);

export interface CheckInContext {
  actor?: AuthenticatedUser | null;
  device?: { id: number; device_name: string } | null;
}

@Injectable()
export class AttendanceService {
  constructor(
    private readonly repository: AttendanceRepository,
    private readonly ingestAdapter: HardwareIngestAdapter,
    private readonly userRepository: UserRepository,
    private readonly membershipRepository: MembershipRepository,
    private readonly settingsService: SettingsService,
    private readonly auditService: AuditService,
    private readonly domainEventBus: DomainEventBus,
    private readonly paginationHelper: PaginationHelper,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  toDto(row: Attendance): AttendanceResponseDto {
    return {
      id: row.id,
      user_id: row.user_id,
      check_in_time: row.check_in_time.toISOString(),
      check_out_time: row.check_out_time ? row.check_out_time.toISOString() : null,
      method: row.method,
      gate_identifier: row.gate_identifier,
      verified_by_user_id: row.verified_by_user_id,
    };
  }

  toHistoryDto(row: AttendanceHistory): AttendanceHistoryDto {
    return {
      id: row.id,
      date: String(row.date).slice(0, 10),
      total_member_checkins: row.total_member_checkins,
      total_trainer_checkins: row.total_trainer_checkins,
      peak_hour: row.peak_hour,
      peak_count: row.peak_count,
    };
  }

  async checkIn(dto: CheckInRequestDto, ctx: CheckInContext): Promise<AttendanceResponseDto> {
    const resolved = this.ingestAdapter.resolve({
      user_id: dto.user_id,
      method: dto.method,
      gate_identifier: dto.gate_identifier,
      payload: dto.payload,
      deviceAuthenticated: Boolean(ctx.device),
      actorUserId: ctx.actor?.id ?? null,
    });

    const user = await this.userRepository.findById(resolved.userId);
    if (!user || user.status !== 'active') {
      throw new NotFoundError('User not found or inactive');
    }

    await this.assertEligibility(user.id, user.user_type);

    return this.insertCheckInWithGuards({
      userId: resolved.userId,
      method: resolved.method,
      gateIdentifier: resolved.gateIdentifier,
      verifiedByUserId: resolved.method === 'manual_override' ? (ctx.actor?.id ?? null) : null,
      actorUserId: ctx.actor?.id ?? null,
      deviceId: ctx.device?.id ?? null,
      bypassCap: false,
      auditAction: 'attendance.checked_in',
      auditExtra: {},
    });
  }

  /**
   * ATT-010: staff manual override — bypasses membership eligibility and daily caps.
   * Requires `attendance.override` at the controller. Always method `manual_override`.
   */
  async manualOverride(
    dto: ManualOverrideRequestDto,
    actor: AuthenticatedUser,
  ): Promise<AttendanceResponseDto> {
    const user = await this.userRepository.findById(dto.user_id);
    if (!user || user.status !== 'active') {
      throw new NotFoundError('User not found or inactive');
    }

    return this.insertCheckInWithGuards({
      userId: dto.user_id,
      method: 'manual_override',
      gateIdentifier: dto.gate_identifier ?? null,
      verifiedByUserId: actor.id,
      actorUserId: actor.id,
      deviceId: null,
      bypassCap: true,
      auditAction: 'attendance.manual_override',
      auditExtra: { reason: dto.reason },
    });
  }

  async checkOut(id: number, actor: AuthenticatedUser): Promise<AttendanceResponseDto> {
    const row = await this.repository.findById(id);
    if (!row) {
      throw new NotFoundError('Attendance not found');
    }
    if (row.check_out_time) {
      throw new ConflictError('Attendance is already checked out');
    }

    if (actor.userType === 'member' && actor.id !== row.user_id) {
      throw new ForbiddenError('Members may only check out their own attendance');
    }

    const now = new Date();
    const updated = await this.repository.setCheckOut(id, now);
    if (!updated) {
      throw new NotFoundError('Attendance not found');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'attendance.checked_out',
      entityName: 'attendances',
      entityId: id,
      beforeState: { check_out_time: null },
      afterState: { check_out_time: now.toISOString() },
    });

    await this.domainEventBus.emit({
      eventName: 'attendance.checked_out',
      occurredAt: now,
      payload: { attendance_id: id, user_id: row.user_id },
    });

    return this.toDto(updated);
  }

  async list(
    query: ListAttendancesQueryDto,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<AttendanceResponseDto>> {
    const scope = this.resolveListScope(actor);
    this.assertListFilterAllowed(query.user_id, scope, actor);

    const pagination = await this.paginationHelper.normalizeParams(query);
    let cursor: { checkInTime: Date; id: number } | undefined;
    if (pagination.mode === 'cursor' && pagination.cursor) {
      cursor = {
        checkInTime: new Date(pagination.cursor.createdAt),
        id: pagination.cursor.id,
      };
    }

    const rows = await this.repository.findManyFiltered({
      scope,
      userId: query.user_id,
      from: query.from ? new Date(query.from) : undefined,
      to: query.to ? new Date(query.to) : undefined,
      limit: pagination.limit,
      cursor,
    });

    const page = createPaginatedResponse({
      items: rows,
      limit: pagination.limit,
      requestCursor: query.cursor ?? null,
      cursorExtractor: (row) => ({
        createdAt: row.check_in_time.toISOString(),
        id: row.id,
      }),
    });

    return {
      data: page.data.map((r) => this.toDto(r)),
      meta: page.meta,
    };
  }

  async summary(
    query: AttendanceSummaryQueryDto,
    actor: AuthenticatedUser,
  ): Promise<AttendanceSummaryDto> {
    const userId = await this.resolveSummaryUserId(query.member_id, actor);
    const dates = await this.repository.listCheckInDatesDesc(userId);
    const latest = await this.repository.findLatestCheckIn(userId);

    const now = new Date();
    const monthStart = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 1));
    const monthEnd = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() + 1, 1));
    const visits_this_month = await this.repository.countCheckInsForUserBetween(
      userId,
      monthStart,
      monthEnd,
    );

    return {
      streak_days: this.computeStreak(dates, now),
      last_check_in: latest ? latest.check_in_time.toISOString() : null,
      visits_this_month,
    };
  }

  /** ATT-017: live gate occupancy for dashboard/ops. */
  async getOccupancy(): Promise<OccupancyDto> {
    const snapshot = await this.repository.getOccupancySnapshot();
    return {
      checked_in_now: snapshot.checked_in_now,
      as_of: new Date().toISOString(),
      by_gate: snapshot.by_gate,
    };
  }

  async listHistories(
    query: ListAttendanceHistoriesQueryDto,
  ): Promise<PaginatedResponse<AttendanceHistoryDto>> {
    const pagination = await this.paginationHelper.normalizeParams(query);
    let cursorId: number | undefined;
    if (pagination.mode === 'cursor' && pagination.cursor) {
      cursorId = pagination.cursor.id;
    }

    const rows = await this.repository.listHistories({
      from: query.from,
      to: query.to,
      limit: pagination.limit,
      cursorId,
    });

    const page = createPaginatedResponse({
      items: rows,
      limit: pagination.limit,
      requestCursor: query.cursor ?? null,
      cursorExtractor: (row) => ({
        createdAt: `${String(row.date).slice(0, 10)}T00:00:00.000Z`,
        id: row.id,
      }),
    });

    return {
      data: page.data.map((r) => this.toHistoryDto(r)),
      meta: page.meta,
    };
  }

  /** ATT-013: roll up a UTC calendar day into attendance_histories. */
  async rollupDay(day: Date = this.yesterdayUtc()): Promise<AttendanceHistoryDto> {
    const dayStart = new Date(
      Date.UTC(day.getUTCFullYear(), day.getUTCMonth(), day.getUTCDate(), 0, 0, 0, 0),
    );
    const dayEnd = new Date(dayStart.getTime() + 24 * 60 * 60 * 1000);
    const dateStr = dayStart.toISOString().slice(0, 10);
    const agg = await this.repository.aggregateDay(dayStart, dayEnd);
    const now = new Date();
    const row = await this.repository.upsertHistory({
      date: dateStr,
      total_member_checkins: agg.total_member_checkins,
      total_trainer_checkins: agg.total_trainer_checkins,
      peak_hour: agg.peak_hour,
      peak_count: agg.peak_count,
      created_at: now,
      updated_at: now,
    });
    return this.toHistoryDto(row);
  }

  /** ATT-014: close open visits older than the configured auto-checkout window. */
  async autoCheckoutStale(now = new Date()): Promise<number> {
    const hours = await this.settingsService.getAttendanceAutoCheckoutHours();
    const cutoff = new Date(now.getTime() - hours * 60 * 60 * 1000);
    const stale = await this.repository.findOpenOlderThan(cutoff);
    let closed = 0;
    for (const row of stale) {
      await this.repository.setCheckOut(row.id, now);
      await this.auditService.recordAudit({
        actorUserId: null,
        action: 'attendance.auto_checked_out',
        entityName: 'attendances',
        entityId: row.id,
        afterState: { check_out_time: now.toISOString(), cutoff: cutoff.toISOString() },
      });
      closed += 1;
    }
    return closed;
  }

  private async insertCheckInWithGuards(args: {
    userId: number;
    method: string;
    gateIdentifier: string | null;
    verifiedByUserId: number | null;
    actorUserId: number | null;
    deviceId: number | null;
    bypassCap: boolean;
    auditAction: string;
    auditExtra: Record<string, unknown>;
  }): Promise<AttendanceResponseDto> {
    return runInTransaction(this.db, async () => {
      const now = new Date();
      const open = await this.repository.findOpenByUserIdForUpdate(args.userId);

      if (open) {
        const debounceSeconds = await this.settingsService.getAttendanceDebounceSeconds();
        const ageMs = now.getTime() - open.check_in_time.getTime();
        if (ageMs <= debounceSeconds * 1000) {
          return this.toDto(open);
        }
        throw new ConflictError('User already has an open attendance; check out first');
      }

      if (!args.bypassCap) {
        await this.assertDailyCap(args.userId, now);
      }

      const created = await this.repository.insertCheckIn({
        user_id: args.userId,
        check_in_time: now,
        check_out_time: null,
        method: args.method,
        gate_identifier: args.gateIdentifier,
        verified_by_user_id: args.verifiedByUserId,
        created_at: now,
        updated_at: now,
      });

      await this.auditService.recordAudit({
        actorUserId: args.actorUserId,
        action: args.auditAction,
        entityName: 'attendances',
        entityId: created.id,
        afterState: {
          user_id: created.user_id,
          method: created.method,
          gate_identifier: created.gate_identifier,
          device_id: args.deviceId,
          ...args.auditExtra,
        },
      });

      await this.domainEventBus.emit({
        eventName: args.auditAction,
        occurredAt: now,
        payload: { attendance_id: created.id, user_id: created.user_id, method: created.method },
      });

      return this.toDto(created);
    });
  }

  private resolveListScope(actor: AuthenticatedUser): AttendanceListScope {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return { type: 'all' };
    }
    if (actor.userType === 'trainer') {
      if (actor.profileId == null) {
        throw new ForbiddenError('Trainer profile is required for attendance queries');
      }
      return { type: 'trainer', trainerProfileId: actor.profileId };
    }
    return { type: 'self', userId: actor.id };
  }

  private assertListFilterAllowed(
    filterUserId: number | undefined,
    scope: AttendanceListScope,
    actor: AuthenticatedUser,
  ): void {
    if (filterUserId == null) return;
    if (scope.type === 'all') return;
    if (scope.type === 'self' && filterUserId !== actor.id) {
      throw new NotFoundError('Resource not found');
    }
    // Trainer: repository join enforces assigned members; optional user_id still applied.
  }

  private async resolveSummaryUserId(
    memberId: number | undefined,
    actor: AuthenticatedUser,
  ): Promise<number> {
    if (actor.userType === 'member') {
      if (memberId != null) {
        const own = await this.findMemberById(memberId);
        if (!own || own.user_id !== actor.id) {
          throw new NotFoundError('Resource not found');
        }
        return actor.id;
      }
      return actor.id;
    }

    if (memberId == null) {
      throw new BadRequestError('member_id is required');
    }
    const member = await this.findMemberById(memberId);
    if (!member) {
      throw new NotFoundError('Member not found');
    }
    if (actor.userType === 'trainer') {
      if (actor.profileId == null || member.assigned_trainer_id !== actor.profileId) {
        throw new NotFoundError('Resource not found');
      }
    }
    return member.user_id;
  }

  private async findMemberById(
    memberId: number,
  ): Promise<{ id: number; user_id: number; assigned_trainer_id: number | null } | null> {
    const db = this.db as any;
    const rows = await db
      .select({
        id: members.id,
        user_id: members.user_id,
        assigned_trainer_id: members.assigned_trainer_id,
      })
      .from(members)
      .where(eq(members.id, memberId))
      .limit(1);
    return rows[0] ?? null;
  }

  /** Consecutive UTC days with activity ending at today or yesterday. */
  computeStreak(datesDesc: string[], now: Date): number {
    if (datesDesc.length === 0) return 0;
    const today = now.toISOString().slice(0, 10);
    const yesterdayDate = new Date(now.getTime() - 24 * 60 * 60 * 1000);
    const yesterday = yesterdayDate.toISOString().slice(0, 10);

    let cursor: string | null =
      datesDesc[0] === today || datesDesc[0] === yesterday ? datesDesc[0] : null;
    if (!cursor) return 0;

    let streak = 0;
    const set = new Set(datesDesc);
    while (cursor !== null && set.has(cursor)) {
      streak += 1;
      const d: Date = new Date(`${cursor}T00:00:00.000Z`);
      d.setUTCDate(d.getUTCDate() - 1);
      cursor = d.toISOString().slice(0, 10);
    }
    return streak;
  }

  private yesterdayUtc(now = new Date()): Date {
    return new Date(now.getTime() - 24 * 60 * 60 * 1000);
  }

  private async assertEligibility(userId: number, userType: string): Promise<void> {
    if (STAFF_TYPES.has(userType) || userType === 'admin') {
      return;
    }
    if (userType !== 'member') {
      throw new BusinessRuleError('Only members and staff may check in at the gate');
    }

    const db = this.db as any;
    const memberRows = await db
      .select({ id: members.id })
      .from(members)
      .where(eq(members.user_id, userId))
      .limit(1);
    const member = memberRows[0];
    if (!member) {
      throw new NotFoundError('Member profile not found for user');
    }

    const membership = await this.membershipRepository.findActiveOrFrozenForMember(member.id);
    if (!membership) {
      throw new BusinessRuleError('No active membership for check-in');
    }
    if (membership.status === 'frozen') {
      throw new BusinessRuleError('Membership is frozen; check-in is not allowed');
    }
    if (membership.status !== 'active') {
      throw new BusinessRuleError('Membership is not active');
    }
  }

  private async assertDailyCap(userId: number, now: Date): Promise<void> {
    const cap = await this.settingsService.getAttendanceDailyCheckInCap();
    const dayStart = new Date(
      Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), 0, 0, 0, 0),
    );
    const dayEnd = new Date(dayStart.getTime() + 24 * 60 * 60 * 1000);
    const checkInCount = await this.repository.countCheckInsForUserBetween(
      userId,
      dayStart,
      dayEnd,
    );
    if (checkInCount >= cap) {
      throw new BusinessRuleError(`Daily check-in cap of ${cap} reached`);
    }
  }
}
