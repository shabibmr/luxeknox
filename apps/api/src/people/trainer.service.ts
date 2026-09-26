import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { runInTransaction } from '../platform/db/transaction-context';
import type { Trainer } from '../platform/db/schema/trainers';
import { NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { roundMoney } from '../platform/money/money';
import { PersonFactory } from './person.factory';
import { assertPeopleRowScope } from './row-scope';
import { normalizeSpecializations } from './normalize-specializations';
import {
  trainerFilterQuerySchema,
  type TrainerCreateDto,
  type TrainerUpdateDto,
} from './trainer.dto';
import { TrainerRepository } from './trainer.repository';
import { MemberRepository } from './member.repository';
import type { Member } from '../platform/db/schema/members';

export interface TrainerResponse extends Omit<Trainer, 'specializations' | 'hourly_rate'> {
  specializations: string[] | null;
  hourly_rate: string | null;
  assigned_active_count: number;
}

@Injectable()
export class TrainerService {
  constructor(
    private readonly repository: TrainerRepository,
    private readonly memberRepository: MemberRepository,
    private readonly personFactory: PersonFactory,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  private formatHourlyRate(raw: unknown): string | null {
    if (raw == null || raw === '') return null;
    return roundMoney(typeof raw === 'number' ? raw : String(raw));
  }

  private toResponse(
    row: Trainer,
    assignedCount: number,
    actor: AuthenticatedUser,
  ): TrainerResponse {
    const hideRate = actor.userType === 'member';
    return {
      id: row.id,
      user_id: row.user_id,
      first_name: row.first_name,
      last_name: row.last_name,
      bio: row.bio,
      specializations: normalizeSpecializations(row.specializations),
      hourly_rate: hideRate ? null : this.formatHourlyRate(row.hourly_rate),
      rating: row.rating,
      max_clients_capacity: row.max_clients_capacity,
      is_active: row.is_active,
      created_at: row.created_at,
      updated_at: row.updated_at,
      assigned_active_count: assignedCount,
    };
  }

  async list(
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<TrainerResponse>> {
    const filters = trainerFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findManyFiltered({
      q: filters.q,
      status: filters.status,
      is_active: filters.is_active,
      limit: pagination.limit,
      offset,
    });

    const counts = await this.repository.countAssignedMembersForIds(rows.map((r) => r.id));
    const items = rows.map((row) => this.toResponse(row, counts.get(row.id) ?? 0, actor));

    return createPaginatedResponse({
      items,
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async create(dto: TrainerCreateDto, actor: AuthenticatedUser): Promise<TrainerResponse> {
    const created = await this.personFactory.createPerson({
      userType: 'trainer',
      credentials: {
        email: dto.email,
        phone_number: dto.phone_number,
        password: dto.password,
      },
      profile: {
        first_name: dto.first_name,
        last_name: dto.last_name,
        bio: dto.bio,
        specializations: dto.specializations,
        hourly_rate: dto.hourly_rate != null ? roundMoney(dto.hourly_rate) : null,
        max_clients_capacity: dto.max_clients_capacity,
        is_active: true,
      },
    });

    if (created.userType !== 'trainer') {
      throw new NotFoundError('Trainer not found after create');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'trainer.created',
      entityName: 'trainers',
      entityId: created.profile.id,
      afterState: created.profile,
    });

    return this.toResponse(created.profile, 0, actor);
  }

  async getById(id: number, actor: AuthenticatedUser): Promise<TrainerResponse> {
    const trainer = await this.repository.findById(id);
    if (!trainer) {
      throw new NotFoundError('Trainer not found');
    }

    // Trainers may read self; staff unrestricted; members with trainers.read may
    // browse the directory (hourly_rate stripped in toResponse — FR-PEOPLE-010).
    if (actor.userType === 'trainer') {
      assertPeopleRowScope(actor, {
        kind: 'trainer',
        profileId: trainer.id,
        userId: trainer.user_id,
      });
    }

    const assigned = await this.repository.countAssignedMembers(id);
    return this.toResponse(trainer, assigned, actor);
  }

  async update(
    id: number,
    dto: TrainerUpdateDto,
    actor: AuthenticatedUser,
  ): Promise<TrainerResponse> {
    const before = await this.repository.findById(id);
    if (!before) {
      throw new NotFoundError('Trainer not found');
    }

    if (actor.userType === 'trainer') {
      assertPeopleRowScope(actor, {
        kind: 'trainer',
        profileId: before.id,
        userId: before.user_id,
      });
    }

    const now = new Date();
    await runInTransaction(this.db, async () => {
      const patch: Partial<Trainer> = { updated_at: now };
      if (dto.first_name !== undefined) patch.first_name = dto.first_name;
      if (dto.last_name !== undefined) patch.last_name = dto.last_name;
      if (dto.bio !== undefined) patch.bio = dto.bio;
      if (dto.specializations !== undefined) patch.specializations = dto.specializations;
      if (dto.hourly_rate !== undefined) {
        patch.hourly_rate = dto.hourly_rate == null ? null : roundMoney(dto.hourly_rate);
      }
      if (dto.max_clients_capacity !== undefined && actor.userType !== 'trainer') {
        patch.max_clients_capacity = dto.max_clients_capacity;
      }
      if (dto.is_active !== undefined && actor.userType !== 'trainer') {
        patch.is_active = dto.is_active;
      }

      await this.repository.updateTrainer(id, patch);

      if (dto.phone_number !== undefined) {
        await this.personFactory.patchUserCredentials(
          before.user_id,
          { phone_number: dto.phone_number },
          this.repository.getDb() as any,
        );
      }
    });

    const after = await this.repository.findById(id);
    if (!after) {
      throw new NotFoundError('Trainer not found after update');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'trainer.updated',
      entityName: 'trainers',
      entityId: id,
      beforeState: before,
      afterState: after,
    });

    const assigned = await this.repository.countAssignedMembers(id);
    return this.toResponse(after, assigned, actor);
  }

  async listMembers(
    trainerId: number,
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<Member>> {
    const trainer = await this.repository.findById(trainerId);
    if (!trainer) {
      throw new NotFoundError('Trainer not found');
    }

    if (actor.userType === 'trainer') {
      assertPeopleRowScope(actor, {
        kind: 'trainer',
        profileId: trainer.id,
        userId: trainer.user_id,
      });
    } else if (actor.userType === 'member') {
      throw new NotFoundError('Trainer not found');
    }

    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.memberRepository.findManyFiltered({
      scope: { type: 'trainer', trainerProfileId: trainerId },
      limit: pagination.limit,
      offset,
    });

    return createPaginatedResponse({
      items: rows,
      limit: pagination.limit,
      offset,
      total,
    });
  }
}
