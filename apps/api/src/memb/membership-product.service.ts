import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import {
  canBrowseUnrestricted,
  requireVisibleCatalogueRow,
} from '../platform/catalogue/browse-policy';
import type { MembershipProduct, NewMembershipProduct } from '../platform/db/schema/memberships';
import { roundMoney } from '../platform/money/money';
import { ConflictError, NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { PermissionCache } from '../rbac/permission-cache';
import {
  membershipProductFilterQuerySchema,
  type MembershipProductUpdateDto,
  type MembershipProductWriteDto,
} from './membership-product.dto';
import { MembershipProductRepository } from './membership-product.repository';

/** Mirrors exercises.update/diet.update — only mutate-capable roles browse inactive products. */
const SEE_INACTIVE_PERMISSION = 'memberships.update';

@Injectable()
export class MembershipProductService {
  constructor(
    private readonly repository: MembershipProductRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
    private readonly permissionCache: PermissionCache,
  ) {}

  async list(
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<MembershipProduct>> {
    const filters = membershipProductFilterQuerySchema.parse(rawQuery);
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

  async getById(id: number, actor: AuthenticatedUser): Promise<MembershipProduct> {
    const unrestricted = await canBrowseUnrestricted(
      this.permissionCache,
      actor.roleId,
      SEE_INACTIVE_PERMISSION,
    );
    const product = await this.repository.findById(id);
    return requireVisibleCatalogueRow(product, {
      unrestricted,
      isVisible: (row) => row.is_active === true,
      notFoundMessage: 'Membership product not found',
      NotFoundError,
    });
  }

  async create(
    dto: MembershipProductWriteDto,
    actor: AuthenticatedUser,
  ): Promise<MembershipProduct> {
    const existing = await this.repository.findByCode(dto.code);
    if (existing) {
      throw new ConflictError(`Membership product code "${dto.code}" already exists`);
    }

    const id = await this.repository.insertProduct({
      name: dto.name,
      code: dto.code,
      description: dto.description ?? null,
      duration_days: dto.duration_days,
      base_price: roundMoney(dto.base_price),
      tax_percentage: dto.tax_percentage ? roundMoney(dto.tax_percentage) : '0.00',
      max_freeze_days: dto.max_freeze_days ?? 0,
      pt_sessions_included: dto.pt_sessions_included ?? 0,
      access_facilities: dto.access_facilities ?? null,
      is_active: dto.is_active ?? true,
      created_at: new Date(),
    });

    const created = await this.repository.findById(id);
    if (!created) {
      throw new NotFoundError('Membership product not found after creation');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'membership_product.created',
      entityName: 'membership_products',
      entityId: id,
      afterState: created,
    });

    return created;
  }

  /**
   * FR-MEMB-003: archiving is `is_active=false`, not a mutation of existing contracts — this
   * only ever touches the catalog row. Existing `memberships` keep their terms via the row they
   * already copied at assignment time (duration/PT sessions), so no cascading update is needed.
   */
  async update(
    id: number,
    dto: MembershipProductUpdateDto,
    actor: AuthenticatedUser,
  ): Promise<MembershipProduct> {
    const before = await this.repository.findById(id);
    if (!before) {
      throw new NotFoundError('Membership product not found');
    }

    if (dto.code !== undefined && dto.code !== before.code) {
      const existing = await this.repository.findByCode(dto.code);
      if (existing) {
        throw new ConflictError(`Membership product code "${dto.code}" already exists`);
      }
    }

    const values: Partial<NewMembershipProduct> = { updated_at: new Date() };
    if (dto.name !== undefined) values.name = dto.name;
    if (dto.code !== undefined) values.code = dto.code;
    if (dto.description !== undefined) values.description = dto.description;
    if (dto.duration_days !== undefined) values.duration_days = dto.duration_days;
    if (dto.base_price !== undefined) values.base_price = roundMoney(dto.base_price);
    if (dto.tax_percentage !== undefined) values.tax_percentage = roundMoney(dto.tax_percentage);
    if (dto.max_freeze_days !== undefined) values.max_freeze_days = dto.max_freeze_days;
    if (dto.pt_sessions_included !== undefined) {
      values.pt_sessions_included = dto.pt_sessions_included;
    }
    if (dto.access_facilities !== undefined) values.access_facilities = dto.access_facilities;
    if (dto.is_active !== undefined) values.is_active = dto.is_active;

    await this.repository.updateProduct(id, values);

    const after = await this.repository.findById(id);
    if (!after) {
      throw new NotFoundError('Membership product not found after update');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'membership_product.updated',
      entityName: 'membership_products',
      entityId: id,
      beforeState: before,
      afterState: after,
    });

    return after;
  }
}
