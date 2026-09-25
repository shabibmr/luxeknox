import { Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import type { Permission } from '../platform/db/schema/permissions';
import { roles, type Role } from '../platform/db/schema/roles';
import { BusinessRuleError, ConflictError, NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { PermissionCache } from './permission-cache';
import { PermissionRepository } from './permission.repository';
import { RoleRepository } from './role.repository';
import type { RolePermissionsWriteDto, RoleWriteDto } from './role.dto';

export interface RoleWithPermissions extends Role {
  permissions: Permission[];
}

function slugifyRoleName(name: string): string {
  const base = name
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '_')
    .replace(/^_+|_+$/g, '');
  return base || `role_${Date.now()}`;
}

@Injectable()
export class RoleService {
  constructor(
    private readonly roleRepository: RoleRepository,
    private readonly permissionRepository: PermissionRepository,
    private readonly permissionCache: PermissionCache,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
  ) {}

  private async withPermissions(role: Role): Promise<RoleWithPermissions> {
    const permissions = await this.permissionRepository.findManyByRoleId(role.id);
    return { ...role, permissions };
  }

  async list(rawQuery: Record<string, unknown>): Promise<PaginatedResponse<RoleWithPermissions>> {
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.roleRepository.findManyPaged(pagination.limit, offset);
    const withPerms = await Promise.all(rows.map((role) => this.withPermissions(role)));

    return createPaginatedResponse({
      items: withPerms,
      total,
      limit: pagination.limit,
      offset,
    });
  }

  async getById(id: number): Promise<RoleWithPermissions> {
    const role = await this.roleRepository.findById(id);
    if (!role) {
      throw new NotFoundError(`Role with id ${id} not found`);
    }
    return this.withPermissions(role);
  }

  async create(dto: RoleWriteDto, actor: AuthenticatedUser): Promise<RoleWithPermissions> {
    const slug = slugifyRoleName(dto.name);
    const conflict = await this.roleRepository.findBySlug(slug);
    if (conflict) {
      throw new ConflictError(`A role named '${dto.name}' already exists`);
    }

    const now = new Date();
    await this.roleRepository.create({
      name: dto.name,
      slug,
      description: dto.description ?? null,
      is_system: false,
      created_at: now,
      updated_at: now,
    });

    const created = await this.roleRepository.findBySlug(slug);
    if (!created) {
      throw new NotFoundError('Role was created but could not be reloaded');
    }
    const result = await this.withPermissions(created);

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'create',
      entityName: 'roles',
      entityId: created.id,
      afterState: result,
    });

    return result;
  }

  async update(id: number, dto: RoleWriteDto, actor: AuthenticatedUser): Promise<RoleWithPermissions> {
    const existing = await this.roleRepository.findById(id);
    if (!existing) {
      throw new NotFoundError(`Role with id ${id} not found`);
    }
    if (existing.is_system) {
      throw new BusinessRuleError('System roles cannot be modified');
    }

    await this.roleRepository.update(eq(roles.id, id), {
      name: dto.name,
      description: dto.description ?? null,
      updated_at: new Date(),
    });

    this.permissionCache.invalidateRole(id);
    const updated = await this.getById(id);

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'update',
      entityName: 'roles',
      entityId: id,
      beforeState: existing,
      afterState: updated,
    });

    return updated;
  }

  async replacePermissions(
    id: number,
    dto: RolePermissionsWriteDto,
    actor: AuthenticatedUser,
  ): Promise<RoleWithPermissions> {
    const existing = await this.roleRepository.findById(id);
    if (!existing) {
      throw new NotFoundError(`Role with id ${id} not found`);
    }
    if (existing.is_system) {
      throw new BusinessRuleError('System role permissions cannot be modified');
    }

    const uniqueIds = Array.from(new Set(dto.permission_ids));
    const validPermissions = await this.permissionRepository.findManyByIds(uniqueIds);
    if (validPermissions.length !== uniqueIds.length) {
      throw new BusinessRuleError('One or more permission_ids are invalid');
    }

    const before = await this.withPermissions(existing);
    await this.roleRepository.replacePermissions(id, uniqueIds);
    this.permissionCache.invalidateRole(id);

    const updated = await this.getById(id);

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'update',
      entityName: 'role_permissions',
      entityId: id,
      beforeState: before,
      afterState: updated,
    });

    return updated;
  }
}
