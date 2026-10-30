import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import { runInTransaction } from '../platform/db/transaction-context';
import { NotFoundError } from '../platform/errors/app-error';
import type {
  LifestylePriorityItem,
  MemberLifestyleIntake,
  NewMemberLifestyleIntake,
} from '../platform/db/schema/lifestyle-intake';
import { MemberRepository } from './member.repository';
import { LifestyleIntakeRepository } from './lifestyle-intake.repository';
import type { LifestyleIntakeDto, LifestyleIntakePutDto } from './lifestyle-intake.dto';
import { requireScopedMember } from './require-scoped-member';

const PRIORITY_ORDER = ['sleep', 'nutrition', 'activity', 'recovery'] as const;

function nullableTrimmed(value: string | null | undefined): string | null {
  if (value == null) return null;
  const trimmed = value.trim();
  return trimmed.length === 0 ? null : trimmed;
}

function sortPriorities(items: LifestylePriorityItem[]): LifestylePriorityItem[] {
  const byDomain = new Map(items.map((item) => [item.priority, item]));
  return PRIORITY_ORDER.map((domain) => {
    const item = byDomain.get(domain)!;
    return {
      priority: item.priority,
      current_status: item.current_status.trim(),
      first_action: item.first_action.trim(),
    };
  });
}

@Injectable()
export class LifestyleIntakeService {
  constructor(
    private readonly repository: LifestyleIntakeRepository,
    private readonly memberRepository: MemberRepository,
    private readonly auditService: AuditService,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  toDto(row: MemberLifestyleIntake): LifestyleIntakeDto {
    return {
      id: row.id,
      member_id: row.member_id,
      activity_level: row.activity_level ?? null,
      training_history: row.training_history ?? null,
      current_pain_discomfort: row.current_pain_discomfort ?? null,
      sleep_hours_typical: row.sleep_hours_typical ?? null,
      stress_level: row.stress_level ?? null,
      work_activity_demands: row.work_activity_demands ?? null,
      typical_daily_steps: row.typical_daily_steps ?? null,
      nutrition_approach: row.nutrition_approach ?? null,
      hydration_habits: row.hydration_habits ?? null,
      recovery_habits: row.recovery_habits ?? null,
      other_notes: row.other_notes ?? null,
      lifestyle_priorities: row.lifestyle_priorities ?? null,
      conducted_by_trainer_id: row.conducted_by_trainer_id ?? null,
      created_at: row.created_at.toISOString(),
      updated_at: row.updated_at ? row.updated_at.toISOString() : null,
    };
  }

  async get(memberId: number, actor: AuthenticatedUser): Promise<LifestyleIntakeDto> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const row = await this.repository.findByMemberId(memberId);
    if (!row) {
      throw new NotFoundError('Lifestyle intake not found');
    }
    return this.toDto(row);
  }

  async put(
    memberId: number,
    dto: LifestyleIntakePutDto,
    actor: AuthenticatedUser,
  ): Promise<LifestyleIntakeDto> {
    await requireScopedMember(this.memberRepository, memberId, actor);

    const now = new Date();
    const conductedBy =
      actor.userType === 'trainer'
        ? actor.profileId
        : (dto.conducted_by_trainer_id ?? null);

    const payload: Omit<NewMemberLifestyleIntake, 'id' | 'created_at'> & {
      updated_at: Date;
    } = {
      member_id: memberId,
      activity_level: dto.activity_level ?? null,
      training_history: nullableTrimmed(dto.training_history),
      current_pain_discomfort: nullableTrimmed(dto.current_pain_discomfort),
      sleep_hours_typical:
        dto.sleep_hours_typical == null ? null : dto.sleep_hours_typical.toFixed(1),
      stress_level: dto.stress_level,
      work_activity_demands: nullableTrimmed(dto.work_activity_demands),
      typical_daily_steps: dto.typical_daily_steps ?? null,
      nutrition_approach: nullableTrimmed(dto.nutrition_approach),
      hydration_habits: nullableTrimmed(dto.hydration_habits),
      recovery_habits: nullableTrimmed(dto.recovery_habits),
      other_notes: nullableTrimmed(dto.other_notes),
      lifestyle_priorities: sortPriorities(dto.lifestyle_priorities),
      conducted_by_trainer_id: conductedBy,
      updated_at: now,
    };

    return runInTransaction(this.db, async () => {
      const existing = await this.repository.findByMemberId(memberId);
      let entityId: number;

      if (!existing) {
        entityId = await this.repository.insert({
          ...payload,
          created_at: now,
        });
      } else {
        entityId = existing.id;
        await this.repository.updateByMemberId(memberId, payload);
      }

      const saved = await this.repository.findByMemberId(memberId);
      if (!saved) {
        throw new NotFoundError('Lifestyle intake not found');
      }

      await this.auditService.recordAudit({
        actorUserId: actor.id,
        action: existing ? 'lifestyle_intake.updated' : 'lifestyle_intake.created',
        entityName: 'member_lifestyle_intakes',
        entityId,
        beforeState: existing ?? undefined,
        afterState: saved,
      });

      return this.toDto(saved);
    });
  }
}
