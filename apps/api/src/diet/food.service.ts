import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import {
  canBrowseUnrestricted,
  requireVisibleCatalogueRow,
} from '../platform/catalogue/browse-policy';
import type { Food, NewFood } from '../platform/db/schema/foods';
import { NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { PermissionCache } from '../rbac/permission-cache';
import { foodFilterQuerySchema, type FoodUpdateDto, type FoodWriteDto } from './food.dto';
import { FoodRepository } from './food.repository';

const SEE_UNRESTRICTED_PERMISSION = 'diet.update';

@Injectable()
export class FoodService {
  constructor(
    private readonly repository: FoodRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
    private readonly permissionCache: PermissionCache,
  ) {}

  /** Public catalogue row: verified and active (FR-DIET-001). */
  private isPublicCatalogueRow(food: Food): boolean {
    return food.is_active === true && food.is_verified === true;
  }

  async list(
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<Food>> {
    const filters = foodFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;
    const unrestricted = await canBrowseUnrestricted(
      this.permissionCache,
      actor.roleId,
      SEE_UNRESTRICTED_PERMISSION,
    );

    const { rows, total } = await this.repository.findManyFiltered({
      q: filters.q,
      isActive: unrestricted ? filters.is_active : true,
      isVerified: unrestricted ? filters.is_verified : true,
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

  async getById(id: number, actor: AuthenticatedUser): Promise<Food> {
    const unrestricted = await canBrowseUnrestricted(
      this.permissionCache,
      actor.roleId,
      SEE_UNRESTRICTED_PERMISSION,
    );
    const food = await this.repository.findById(id);
    return requireVisibleCatalogueRow(food, {
      unrestricted,
      isVisible: (row) => this.isPublicCatalogueRow(row),
      notFoundMessage: 'Food not found',
      NotFoundError,
    });
  }

  async create(dto: FoodWriteDto, actor: AuthenticatedUser): Promise<Food> {
    const id = await this.repository.insertFood({
      name: dto.name,
      serving_unit: dto.serving_unit,
      serving_size: dto.serving_size ?? null,
      calories: dto.calories ?? null,
      protein_grams: dto.protein_grams ?? null,
      carbs_grams: dto.carbs_grams ?? null,
      fat_grams: dto.fat_grams ?? null,
      fiber_grams: dto.fiber_grams ?? null,
      is_verified: dto.is_verified ?? false,
      is_active: dto.is_active ?? true,
      created_at: new Date(),
    });

    const created = await this.repository.findById(id);
    if (!created) {
      throw new NotFoundError('Food not found after creation');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'food.created',
      entityName: 'foods',
      entityId: id,
      afterState: created,
    });

    return created;
  }

  /**
   * Partial update: only fields present in `dto` are written. Deactivation is
   * `PATCH { is_active: false }` — no DELETE endpoint.
   */
  async update(id: number, dto: FoodUpdateDto, actor: AuthenticatedUser): Promise<Food> {
    const before = await this.repository.findById(id);
    if (!before) {
      throw new NotFoundError('Food not found');
    }

    const values: Partial<NewFood> = { updated_at: new Date() };
    if (dto.name !== undefined) values.name = dto.name;
    if (dto.serving_unit !== undefined) values.serving_unit = dto.serving_unit;
    if (dto.serving_size !== undefined) values.serving_size = dto.serving_size;
    if (dto.calories !== undefined) values.calories = dto.calories;
    if (dto.protein_grams !== undefined) values.protein_grams = dto.protein_grams;
    if (dto.carbs_grams !== undefined) values.carbs_grams = dto.carbs_grams;
    if (dto.fat_grams !== undefined) values.fat_grams = dto.fat_grams;
    if (dto.fiber_grams !== undefined) values.fiber_grams = dto.fiber_grams;
    if (dto.is_verified !== undefined) values.is_verified = dto.is_verified;
    if (dto.is_active !== undefined) values.is_active = dto.is_active;

    await this.repository.updateFood(id, values);

    const after = await this.repository.findById(id);
    if (!after) {
      throw new NotFoundError('Food not found after update');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'food.updated',
      entityName: 'foods',
      entityId: id,
      beforeState: before,
      afterState: after,
    });

    return after;
  }
}
