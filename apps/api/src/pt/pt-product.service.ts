import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import {
  canBrowseUnrestricted,
  requireVisibleCatalogueRow,
} from '../platform/catalogue/browse-policy';
import type { NewPtProduct, PtProduct } from '../platform/db/schema/personal-training';
import { ConflictError, NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { roundMoney } from '../platform/money/money';
import { PermissionCache } from '../rbac/permission-cache';
import {
  ptProductFilterQuerySchema,
  type PtProductUpdateDto,
  type PtProductWriteDto,
} from './pt.dto';
import { PtProductRepository } from './pt-product.repository';

/** Only catalog editors see archived (inactive) PT packages. */
const SEE_INACTIVE_PERMISSION = 'pt_products.write';

@Injectable()
export class PtProductService {
  constructor(
    private readonly repository: PtProductRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
    private readonly permissionCache: PermissionCache,
  ) {}

  async list(
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<PtProduct>> {
    const filters = ptProductFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;
    const unrestricted = await canBrowseUnrestricted(
      this.permissionCache,
      actor.roleId,
      SEE_INACTIVE_PERMISSION,
    );
    const { rows, total } = await this.repository.findManyFiltered({
      q: filters.q,
      activeOnly: !unrestricted,
      limit: pagination.limit,
      offset,
    });
    return createPaginatedResponse({ items: rows, limit: pagination.limit, offset, total });
  }

  async getById(id: number, actor: AuthenticatedUser): Promise<PtProduct> {
    const unrestricted = await canBrowseUnrestricted(
      this.permissionCache,
      actor.roleId,
      SEE_INACTIVE_PERMISSION,
    );
    return requireVisibleCatalogueRow(await this.repository.findById(id), {
      unrestricted,
      isVisible: (row) => row.is_active === true,
      notFoundMessage: 'PT package not found',
      NotFoundError,
    });
  }

  async create(dto: PtProductWriteDto, actor: AuthenticatedUser): Promise<PtProduct> {
    if (await this.repository.findByCode(dto.code)) {
      throw new ConflictError(`PT package code "${dto.code}" already exists`);
    }
    const id = await this.repository.insertProduct({
      name: dto.name,
      code: dto.code,
      description: dto.description ?? null,
      duration_days: dto.duration_days,
      sessions_per_week: dto.sessions_per_week,
      base_price: roundMoney(dto.base_price),
      tax_percentage: dto.tax_percentage ? roundMoney(dto.tax_percentage) : '0.00',
      is_active: dto.is_active ?? true,
      created_at: new Date(),
    });
    const created = await this.repository.findById(id);
    if (!created) throw new NotFoundError('PT package not found after creation');

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'pt_product.created',
      entityName: 'pt_products',
      entityId: id,
      afterState: created,
    });
    return created;
  }

  /**
   * Archiving is `is_active=false`. Existing subscriptions keep their dates/slot — they
   * copied everything they need at purchase time — so no cascade is required.
   */
  async update(id: number, dto: PtProductUpdateDto, actor: AuthenticatedUser): Promise<PtProduct> {
    const before = await this.repository.findById(id);
    if (!before) throw new NotFoundError('PT package not found');
    if (dto.code !== undefined && dto.code !== before.code && (await this.repository.findByCode(dto.code))) {
      throw new ConflictError(`PT package code "${dto.code}" already exists`);
    }

    const values: Partial<NewPtProduct> = { updated_at: new Date() };
    if (dto.name !== undefined) values.name = dto.name;
    if (dto.code !== undefined) values.code = dto.code;
    if (dto.description !== undefined) values.description = dto.description;
    if (dto.duration_days !== undefined) values.duration_days = dto.duration_days;
    if (dto.sessions_per_week !== undefined) values.sessions_per_week = dto.sessions_per_week;
    if (dto.base_price !== undefined) values.base_price = roundMoney(dto.base_price);
    if (dto.tax_percentage !== undefined) values.tax_percentage = roundMoney(dto.tax_percentage);
    if (dto.is_active !== undefined) values.is_active = dto.is_active;
    await this.repository.updateProduct(id, values);

    const after = await this.repository.findById(id);
    if (!after) throw new NotFoundError('PT package not found after update');
    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'pt_product.updated',
      entityName: 'pt_products',
      entityId: id,
      beforeState: before,
      afterState: after,
    });
    return after;
  }
}
