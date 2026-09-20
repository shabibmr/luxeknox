import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { runInTransaction } from '../platform/db/transaction-context';
import type { Member } from '../platform/db/schema/members';
import {
  BadRequestError,
  BusinessRuleError,
  NotFoundError,
} from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { PersonFactory } from './person.factory';
import { assertPeopleRowScope } from './row-scope';
import {
  memberFilterQuerySchema,
  type AssignTrainerDto,
  type MemberCreateDto,
  type MemberUpdateDto,
} from './member.dto';
import { MemberRepository, type MemberListScope } from './member.repository';

export interface MemberDossier extends Member {
  membership: null;
  outstanding_balance: null;
  last_check_in: null;
  next_schedule: null;
}

@Injectable()
export class MemberService {
  constructor(
    private readonly repository: MemberRepository,
    private readonly personFactory: PersonFactory,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  private listScope(actor: AuthenticatedUser): MemberListScope {
    if (actor.userType === 'admin' || actor.userType === 'employee') {
      return { type: 'all' };
    }
    if (actor.userType === 'trainer') {
      if (actor.profileId == null) {
        // No trainer profile yet — empty scope via impossible trainer id.
        return { type: 'trainer', trainerProfileId: -1 };
      }
      return { type: 'trainer', trainerProfileId: actor.profileId };
    }
    return { type: 'self', userId: actor.id };
  }

  private toDossier(member: Member): MemberDossier {
    return {
      ...member,
      membership: null,
      outstanding_balance: null,
      last_check_in: null,
      next_schedule: null,
    };
  }

  async list(
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<Member>> {
    const filters = memberFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findManyFiltered({
      q: filters.q,
      status: filters.status,
      assignedTrainerId: filters.assigned_trainer_id,
      scope: this.listScope(actor),
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

  async create(dto: MemberCreateDto, actor: AuthenticatedUser): Promise<Member> {
    const created = await this.personFactory.createPerson({
      userType: 'member',
      credentials: {
        email: dto.email,
        phone_number: dto.phone_number,
        password: dto.password,
      },
      profile: {
        first_name: dto.first_name,
        last_name: dto.last_name,
        gender: dto.gender,
        date_of_birth: dto.date_of_birth,
        address: dto.address,
        assigned_trainer_id: dto.assigned_trainer_id,
        notes: dto.notes,
      },
    });

    if (created.userType !== 'member') {
      throw new BadRequestError('Person factory returned non-member profile');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'member.created',
      entityName: 'members',
      entityId: created.profile.id,
      afterState: created.profile,
    });

    return created.profile;
  }

  async getById(id: number, actor: AuthenticatedUser): Promise<MemberDossier> {
    const member = await this.repository.findById(id);
    if (!member) {
      throw new NotFoundError('Member not found');
    }

    assertPeopleRowScope(actor, {
      kind: 'member',
      profileId: member.id,
      userId: member.user_id,
      assignedTrainerId: member.assigned_trainer_id,
    });

    return this.toDossier(member);
  }

  async update(id: number, dto: MemberUpdateDto, actor: AuthenticatedUser): Promise<Member> {
    if ('membership_number' in (dto as Record<string, unknown>)) {
      throw new BadRequestError('membership_number is immutable');
    }

    const before = await this.repository.findById(id);
    if (!before) {
      throw new NotFoundError('Member not found');
    }

    assertPeopleRowScope(actor, {
      kind: 'member',
      profileId: before.id,
      userId: before.user_id,
      assignedTrainerId: before.assigned_trainer_id,
    });

    const now = new Date();
    await runInTransaction(this.db, async () => {
      const profilePatch: Partial<Member> = { updated_at: now };
      if (dto.first_name !== undefined) profilePatch.first_name = dto.first_name;
      if (dto.last_name !== undefined) profilePatch.last_name = dto.last_name;
      if (dto.gender !== undefined) profilePatch.gender = dto.gender;
      if (dto.date_of_birth !== undefined) profilePatch.date_of_birth = dto.date_of_birth;
      if (dto.address !== undefined) profilePatch.address = dto.address;
      if (dto.assigned_trainer_id !== undefined) {
        profilePatch.assigned_trainer_id = dto.assigned_trainer_id;
      }
      if (dto.notes !== undefined) profilePatch.notes = dto.notes;

      await this.repository.updateMember(id, profilePatch);

      if (dto.email !== undefined || dto.phone_number !== undefined) {
        await this.personFactory.patchUserCredentials(
          before.user_id,
          {
            email: dto.email,
            phone_number: dto.phone_number,
          },
          this.repository.getDb() as any,
        );
      }
    });

    const after = await this.repository.findById(id);
    if (!after) {
      throw new NotFoundError('Member not found after update');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'member.updated',
      entityName: 'members',
      entityId: id,
      beforeState: before,
      afterState: after,
    });

    return after;
  }

  /**
   * FR-PEOPLE-013 / FR-PEOPLE-008: assign or reassign trainer.
   * Inactive trainers rejected; capacity 422 unless admin override.
   * Notifications deferred — audit only (FR-PEOPLE-007 carve-out).
   */
  async assignTrainer(
    id: number,
    dto: AssignTrainerDto,
    actor: AuthenticatedUser,
  ): Promise<Member> {
    const before = await this.repository.findById(id);
    if (!before) {
      throw new NotFoundError('Member not found');
    }

    assertPeopleRowScope(actor, {
      kind: 'member',
      profileId: before.id,
      userId: before.user_id,
      assignedTrainerId: before.assigned_trainer_id,
    });

    const trainer = await this.repository.findTrainerAssignmentMeta(dto.trainer_id);
    if (!trainer) {
      throw new NotFoundError('Trainer not found');
    }
    if (!trainer.is_active) {
      throw new BusinessRuleError('Inactive trainers cannot take new assignments');
    }

    const assignedCount = await this.repository.countAssignedToTrainer(dto.trainer_id);
    const isNewAssignment = before.assigned_trainer_id !== dto.trainer_id;
    const atCapacity =
      isNewAssignment &&
      trainer.max_clients_capacity != null &&
      assignedCount >= trainer.max_clients_capacity;

    if (atCapacity) {
      const canOverride =
        dto.override_capacity === true &&
        (actor.userType === 'admin' || actor.userType === 'employee');
      if (!canOverride) {
        throw new BusinessRuleError(
          'Trainer is at max_clients_capacity; admin override_capacity required',
        );
      }
      if (!dto.reason || String(dto.reason).trim().length === 0) {
        throw new BadRequestError('reason is required when override_capacity is true');
      }
    }

    const now = new Date();
    await this.repository.updateMember(id, {
      assigned_trainer_id: dto.trainer_id,
      updated_at: now,
    });

    const after = await this.repository.findById(id);
    if (!after) {
      throw new NotFoundError('Member not found after assign-trainer');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'member.trainer_assigned',
      entityName: 'members',
      entityId: id,
      beforeState: {
        assigned_trainer_id: before.assigned_trainer_id,
      },
      afterState: {
        assigned_trainer_id: after.assigned_trainer_id,
        override_capacity: dto.override_capacity === true,
        reason: dto.reason ?? null,
      },
    });

    return after;
  }
}
