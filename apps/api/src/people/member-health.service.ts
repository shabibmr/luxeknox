import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import type { MemberHealth } from '../platform/db/schema/member-health';
import { NotFoundError } from '../platform/errors/app-error';
import { MemberRepository } from './member.repository';
import { MemberHealthRepository } from './member-health.repository';
import type { MemberHealthWriteDto } from './member-health.dto';
import { requireScopedMember } from './require-scoped-member';

@Injectable()
export class MemberHealthService {
  constructor(
    private readonly healthRepository: MemberHealthRepository,
    private readonly memberRepository: MemberRepository,
    private readonly auditService: AuditService,
  ) {}

  async get(memberId: number, actor: AuthenticatedUser): Promise<MemberHealth> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const row = await this.healthRepository.findByMemberId(memberId);
    if (!row) {
      throw new NotFoundError('Member health not found');
    }
    return row;
  }

  async put(
    memberId: number,
    dto: MemberHealthWriteDto,
    actor: AuthenticatedUser,
  ): Promise<MemberHealth> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const before = await this.healthRepository.findByMemberId(memberId);
    const now = new Date();
    const id = await this.healthRepository.upsertForMember(memberId, {
      blood_group: dto.blood_group ?? null,
      height_cm: dto.height_cm ?? null,
      baseline_weight_kg: dto.baseline_weight_kg ?? null,
      allergies: dto.allergies ?? null,
      dietary_preferences: dto.dietary_preferences ?? null,
      physician_name: dto.physician_name ?? null,
      physician_phone: dto.physician_phone ?? null,
      created_at: before?.created_at ?? now,
      updated_at: now,
    });

    const after = await this.healthRepository.findById(id);
    if (!after) {
      throw new NotFoundError('Member health not found after upsert');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: before ? 'member_health.updated' : 'member_health.created',
      entityName: 'member_health',
      entityId: id,
      beforeState: before,
      afterState: after,
    });

    return after;
  }
}
