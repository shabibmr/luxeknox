import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import type { Exercise, NewExercise } from '../platform/db/schema/exercises';
import { NotFoundError } from '../platform/errors/app-error';
import { PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { PermissionCache } from '../rbac/permission-cache';
import { exerciseFilterQuerySchema, type ExerciseUpdateDto, type ExerciseWriteDto } from './exercise.dto';
import { ExerciseRepository } from './exercise.repository';

const SEE_INACTIVE_PERMISSION = 'exercises.update';

@Injectable()
export class ExerciseService {
  constructor(
    private readonly repository: ExerciseRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
    private readonly permissionCache: PermissionCache,
  ) {}

  /**
   * Admins/managers (holders of `exercises.update`) see inactive exercises too;
   * everyone else only sees the active catalog. Deactivated exercises are treated
   * as gone for non-privileged callers, matching the soft-deactivate convention.
   */
  private async canSeeInactive(actor: AuthenticatedUser): Promise<boolean> {
    return this.permissionCache.hasPermission(actor.roleId, SEE_INACTIVE_PERMISSION);
  }

  async list(
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<Exercise>> {
    const filters = exerciseFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;
    const showInactive = await this.canSeeInactive(actor);

    const { rows, total } = await this.repository.findManyFiltered({
      q: filters.q,
      primaryMuscleGroup: filters.primary_muscle_group,
      equipmentNeeded: filters.equipment_needed,
      difficultyLevel: filters.difficulty_level,
      activeOnly: !showInactive,
      limit: pagination.limit,
      offset,
    });

    return this.paginationHelper.createResponse({
      items: rows,
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async getById(id: number, actor: AuthenticatedUser): Promise<Exercise> {
    const showInactive = await this.canSeeInactive(actor);
    const exercise = await this.repository.findById(id, !showInactive);
    if (!exercise) {
      throw new NotFoundError('Exercise not found');
    }
    return exercise;
  }

  async create(dto: ExerciseWriteDto, actor: AuthenticatedUser): Promise<Exercise> {
    const id = await this.repository.insertExercise({
      name: dto.name,
      primary_muscle_group: dto.primary_muscle_group ?? null,
      secondary_muscles: dto.secondary_muscles ?? null,
      equipment_needed: dto.equipment_needed ?? null,
      instructions: dto.instructions ?? null,
      video_url: dto.video_url ?? null,
      gif_url: dto.gif_url ?? null,
      difficulty_level: dto.difficulty_level ?? null,
      is_active: dto.is_active ?? true,
      created_at: new Date(),
    });

    const created = await this.repository.findById(id);
    if (!created) {
      throw new NotFoundError('Exercise not found after creation');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'exercise.created',
      entityName: 'exercises',
      entityId: id,
      afterState: created,
    });

    return created;
  }

  /**
   * Partial update: only fields present in `dto` are written. `docs/openapi/v1.yaml` reuses the
   * `ExerciseWrite` schema (only `name` required) for both `POST` and `PATCH`, but PATCH keeps its
   * HTTP-verb semantics here — omitted fields are left untouched, not nulled. This is also how
   * deactivation works: `PATCH { is_active: false }` alone, no need to resend the whole record.
   */
  async update(id: number, dto: ExerciseUpdateDto, actor: AuthenticatedUser): Promise<Exercise> {
    const before = await this.repository.findById(id);
    if (!before) {
      throw new NotFoundError('Exercise not found');
    }

    const values: Partial<NewExercise> = { updated_at: new Date() };
    if (dto.name !== undefined) values.name = dto.name;
    if (dto.primary_muscle_group !== undefined) values.primary_muscle_group = dto.primary_muscle_group;
    if (dto.secondary_muscles !== undefined) values.secondary_muscles = dto.secondary_muscles;
    if (dto.equipment_needed !== undefined) values.equipment_needed = dto.equipment_needed;
    if (dto.instructions !== undefined) values.instructions = dto.instructions;
    if (dto.video_url !== undefined) values.video_url = dto.video_url;
    if (dto.gif_url !== undefined) values.gif_url = dto.gif_url;
    if (dto.difficulty_level !== undefined) values.difficulty_level = dto.difficulty_level;
    if (dto.is_active !== undefined) values.is_active = dto.is_active;

    await this.repository.updateExercise(id, values);

    const after = await this.repository.findById(id);
    if (!after) {
      throw new NotFoundError('Exercise not found after update');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'exercise.updated',
      entityName: 'exercises',
      entityId: id,
      beforeState: before,
      afterState: after,
    });

    return after;
  }
}
