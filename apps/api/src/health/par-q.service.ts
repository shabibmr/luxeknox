import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import type { ParQScreening } from '../platform/db/schema/par-q';
import {
  BusinessRuleError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { MemberRepository } from '../people/member.repository';
import { requireScopedMember } from '../people/require-scoped-member';
import type {
  ParQClearanceDto,
  ParQScreeningDto,
  ParQSubmitDto,
  ParQTrainerReviewDto,
} from './dto/par-q.dto';
import { ParQRepository } from './par-q.repository';

export const MEDICAL_CLEARANCE_REQUIRED = 'MEDICAL_CLEARANCE_REQUIRED';

/** Statuses that stop a member from booking or starting PT sessions. */
const BLOCKING_STATUSES = new Set<ParQScreening['clearance_status']>([
  'pending_clearance',
  'rejected',
]);

function nullableTrimmed(value: string | null | undefined): string | null {
  if (value == null) return null;
  const trimmed = value.trim();
  return trimmed.length === 0 ? null : trimmed;
}

/** Audit rows carry status only: the answers and notes are health free text. */
function auditView(row: ParQScreening) {
  return {
    id: row.id,
    member_id: row.member_id,
    has_positive_answer: row.has_positive_answer,
    referral_required: row.referral_required,
    clearance_status: row.clearance_status,
  };
}

@Injectable()
export class ParQService {
  constructor(
    private readonly repository: ParQRepository,
    private readonly memberRepository: MemberRepository,
    private readonly auditService: AuditService,
  ) {}

  toDto(row: ParQScreening): ParQScreeningDto {
    return {
      id: row.id,
      member_id: row.member_id,
      version: row.version,
      q1_heart_condition: row.q1_heart_condition,
      q1_details: row.q1_details ?? null,
      q2_chest_pain_activity: row.q2_chest_pain_activity,
      q2_details: row.q2_details ?? null,
      q3_chest_pain_rest: row.q3_chest_pain_rest,
      q3_details: row.q3_details ?? null,
      q4_dizziness_consciousness: row.q4_dizziness_consciousness,
      q4_details: row.q4_details ?? null,
      q5_bone_joint_problem: row.q5_bone_joint_problem,
      q5_details: row.q5_details ?? null,
      q6_medication_condition: row.q6_medication_condition,
      q6_details: row.q6_details ?? null,
      q7_other_reason: row.q7_other_reason,
      q7_details: row.q7_details ?? null,
      has_positive_answer: row.has_positive_answer,
      trainer_screening_notes: row.trainer_screening_notes ?? null,
      referral_required: row.referral_required,
      referral_reason: row.referral_reason ?? null,
      declaration_accepted: row.declaration_accepted,
      client_signed_at: row.client_signed_at?.toISOString() ?? null,
      trainer_signed_at: row.trainer_signed_at?.toISOString() ?? null,
      clearance_status: row.clearance_status,
      cleared_at: row.cleared_at?.toISOString() ?? null,
      cleared_by_user_id: row.cleared_by_user_id ?? null,
      created_at: row.created_at.toISOString(),
      updated_at: row.updated_at?.toISOString() ?? null,
    };
  }

  /** The member's newest screening; 404 when none is on file. */
  async getLatest(memberId: number, actor: AuthenticatedUser): Promise<ParQScreeningDto> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    return this.toDto(await this.requireLatest(memberId));
  }

  /**
   * Record a questionnaire. Any YES answer is positive and parks the member in
   * `pending_clearance` until a doctor referral is cleared; all-NO passes outright.
   */
  async submit(
    memberId: number,
    dto: ParQSubmitDto,
    actor: AuthenticatedUser,
  ): Promise<ParQScreeningDto> {
    await requireScopedMember(this.memberRepository, memberId, actor);

    const hasPositiveAnswer = [
      dto.q1_heart_condition,
      dto.q2_chest_pain_activity,
      dto.q3_chest_pain_rest,
      dto.q4_dizziness_consciousness,
      dto.q5_bone_joint_problem,
      dto.q6_medication_condition,
      dto.q7_other_reason,
    ].some(Boolean);

    const now = new Date();
    const id = await this.repository.insert({
      member_id: memberId,
      q1_heart_condition: dto.q1_heart_condition,
      q1_details: nullableTrimmed(dto.q1_details),
      q2_chest_pain_activity: dto.q2_chest_pain_activity,
      q2_details: nullableTrimmed(dto.q2_details),
      q3_chest_pain_rest: dto.q3_chest_pain_rest,
      q3_details: nullableTrimmed(dto.q3_details),
      q4_dizziness_consciousness: dto.q4_dizziness_consciousness,
      q4_details: nullableTrimmed(dto.q4_details),
      q5_bone_joint_problem: dto.q5_bone_joint_problem,
      q5_details: nullableTrimmed(dto.q5_details),
      q6_medication_condition: dto.q6_medication_condition,
      q6_details: nullableTrimmed(dto.q6_details),
      q7_other_reason: dto.q7_other_reason,
      q7_details: nullableTrimmed(dto.q7_details),
      has_positive_answer: hasPositiveAnswer,
      referral_required: hasPositiveAnswer,
      declaration_accepted: dto.declaration_accepted,
      client_signed_at: now,
      clearance_status: hasPositiveAnswer ? 'pending_clearance' : 'passed',
      created_at: now,
      updated_at: now,
    });

    const saved = await this.requireLatest(memberId);
    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'par_q.submitted',
      entityName: 'par_q_screenings',
      entityId: id,
      afterState: auditView(saved),
    });
    return this.toDto(saved);
  }

  /** Trainer screening notes and referral call on the member's latest questionnaire. */
  async trainerReview(
    memberId: number,
    dto: ParQTrainerReviewDto,
    actor: AuthenticatedUser,
  ): Promise<ParQScreeningDto> {
    if (actor.userType === 'member') {
      throw new ForbiddenError('Members cannot review their own PAR-Q+');
    }
    await requireScopedMember(this.memberRepository, memberId, actor);
    const before = await this.requireLatest(memberId);

    const now = new Date();
    await this.repository.updateById(before.id, {
      trainer_screening_notes: dto.trainer_screening_notes.trim(),
      referral_required: dto.referral_required,
      referral_reason: dto.referral_required ? nullableTrimmed(dto.referral_reason) : null,
      trainer_signed_at: now,
      trainer_user_id: actor.id,
      updated_at: now,
    });

    const saved = await this.requireLatest(memberId);
    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'par_q.trainer_reviewed',
      entityName: 'par_q_screenings',
      entityId: before.id,
      beforeState: auditView(before),
      afterState: auditView(saved),
    });
    return this.toDto(saved);
  }

  /** Admin decision on a pending screening, usually after the doctor's sign-off. */
  async clear(
    memberId: number,
    dto: ParQClearanceDto,
    actor: AuthenticatedUser,
  ): Promise<ParQScreeningDto> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const before = await this.requireLatest(memberId);
    if (before.clearance_status !== 'pending_clearance') {
      throw new BusinessRuleError(
        `Only a screening in 'pending_clearance' can be decided; this one is '${before.clearance_status}'`,
      );
    }

    const now = new Date();
    await this.repository.updateById(before.id, {
      clearance_status: dto.decision,
      cleared_at: now,
      cleared_by_user_id: actor.id,
      updated_at: now,
    });

    const saved = await this.requireLatest(memberId);
    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: dto.decision === 'cleared' ? 'par_q.cleared' : 'par_q.rejected',
      entityName: 'par_q_screenings',
      entityId: before.id,
      beforeState: auditView(before),
      afterState: auditView(saved),
    });
    return this.toDto(saved);
  }

  /**
   * Scheduling gate: PT sessions are blocked while the latest screening awaits
   * clearance or was rejected. A member with no screening on file is not blocked.
   */
  async assertMayTrain(memberId: number): Promise<void> {
    const latest = await this.repository.findLatestByMemberId(memberId);
    if (latest && BLOCKING_STATUSES.has(latest.clearance_status)) {
      throw new BusinessRuleError(MEDICAL_CLEARANCE_REQUIRED, [
        { member_id: memberId, clearance_status: latest.clearance_status },
      ]);
    }
  }

  private async requireLatest(memberId: number): Promise<ParQScreening> {
    const row = await this.repository.findLatestByMemberId(memberId);
    if (!row) {
      throw new NotFoundError('PAR-Q+ screening not found');
    }
    return row;
  }
}
