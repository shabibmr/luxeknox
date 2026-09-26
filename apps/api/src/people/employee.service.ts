import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { SessionCache } from '../auth/session.cache';
import { SessionRepository } from '../auth/session.repository';
import { AuditService } from '../platform/audit/audit.service';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { runInTransaction } from '../platform/db/transaction-context';
import { users } from '../platform/db/schema/users';
import { roles } from '../platform/db/schema/roles';
import { NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { PersonFactory } from './person.factory';
import {
  employeeFilterQuerySchema,
  type AssignRoleDto,
  type EmployeeCreateDto,
  type EmployeeStatusDto,
  type EmployeeUpdateDto,
} from './employee.dto';
import { EmployeeRepository, type EmployeeWithRole } from './employee.repository';

@Injectable()
export class EmployeeService {
  constructor(
    private readonly repository: EmployeeRepository,
    private readonly personFactory: PersonFactory,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
    private readonly sessionRepository: SessionRepository,
    private readonly sessionCache: SessionCache,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  async list(
    rawQuery: Record<string, unknown>,
    _actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<EmployeeWithRole>> {
    const filters = employeeFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findManyFiltered({
      q: filters.q,
      status: filters.status,
      department: filters.department,
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

  async create(dto: EmployeeCreateDto, actor: AuthenticatedUser): Promise<EmployeeWithRole> {
    const created = await this.personFactory.createPerson({
      userType: 'employee',
      credentials: {
        email: dto.email,
        phone_number: dto.phone_number,
        password: dto.password,
      },
      roleId: dto.role_id,
      profile: {
        first_name: dto.first_name,
        last_name: dto.last_name,
        job_title: dto.job_title,
        department: dto.department,
        hire_date: dto.hire_date,
        status: 'active',
      },
    });

    if (created.userType !== 'employee') {
      throw new NotFoundError('Employee not found after create');
    }

    const withRole = await this.repository.findByIdWithRole(created.profile.id);
    if (!withRole) {
      throw new NotFoundError('Employee not found after create');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'employee.created',
      entityName: 'employees',
      entityId: withRole.id,
      afterState: withRole,
    });

    return withRole;
  }

  async getById(id: number, _actor: AuthenticatedUser): Promise<EmployeeWithRole> {
    const employee = await this.repository.findByIdWithRole(id);
    if (!employee) {
      throw new NotFoundError('Employee not found');
    }
    return employee;
  }

  async update(
    id: number,
    dto: EmployeeUpdateDto,
    actor: AuthenticatedUser,
  ): Promise<EmployeeWithRole> {
    const before = await this.repository.findByIdWithRole(id);
    if (!before) {
      throw new NotFoundError('Employee not found');
    }

    const now = new Date();
    const patch: Record<string, unknown> = { updated_at: now };
    if (dto.job_title !== undefined) patch.job_title = dto.job_title;
    if (dto.department !== undefined) patch.department = dto.department;
    if (dto.hire_date !== undefined) patch.hire_date = dto.hire_date;
    if (dto.first_name !== undefined) patch.first_name = dto.first_name;
    if (dto.last_name !== undefined) patch.last_name = dto.last_name;

    await this.repository.updateEmployee(id, patch);

    const after = await this.repository.findByIdWithRole(id);
    if (!after) {
      throw new NotFoundError('Employee not found after update');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'employee.updated',
      entityName: 'employees',
      entityId: id,
      beforeState: before,
      afterState: after,
    });

    return after;
  }

  async assignRole(
    id: number,
    dto: AssignRoleDto,
    actor: AuthenticatedUser,
  ): Promise<EmployeeWithRole> {
    const before = await this.repository.findByIdWithRole(id);
    if (!before) {
      throw new NotFoundError('Employee not found');
    }

    const roleRows = await (this.db as any)
      .select({ id: roles.id })
      .from(roles)
      .where(eq(roles.id, dto.role_id))
      .limit(1);
    if (!roleRows[0]) {
      throw new NotFoundError('Role not found');
    }

    const now = new Date();
    await (this.db as any)
      .update(users)
      .set({ role_id: dto.role_id, updated_at: now })
      .where(eq(users.id, before.user_id));

    const after = await this.repository.findByIdWithRole(id);
    if (!after) {
      throw new NotFoundError('Employee not found after role assign');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'employee.role_assigned',
      entityName: 'employees',
      entityId: id,
      beforeState: { role_id: before.role_id },
      afterState: { role_id: after.role_id },
    });

    return after;
  }

  /**
   * Sets employment status. Suspended/terminated → users.status non-authable + revoke sessions.
   */
  async setStatus(
    id: number,
    dto: EmployeeStatusDto,
    actor: AuthenticatedUser,
  ): Promise<EmployeeWithRole> {
    const before = await this.repository.findByIdWithRole(id);
    if (!before) {
      throw new NotFoundError('Employee not found');
    }

    const now = new Date();
    const blockAuth = dto.status === 'suspended' || dto.status === 'terminated';

    await runInTransaction(this.db, async () => {
      await this.repository.updateStatus(id, dto.status);

      if (blockAuth) {
        await (this.repository.getDb() as any)
          .update(users)
          .set({
            status: dto.status === 'terminated' ? 'inactive' : 'suspended',
            updated_at: now,
          })
          .where(eq(users.id, before.user_id));
      } else if (dto.status === 'active' || dto.status === 'on_probation') {
        await (this.repository.getDb() as any)
          .update(users)
          .set({ status: 'active', updated_at: now })
          .where(eq(users.id, before.user_id));
      }
    });

    if (blockAuth) {
      await this.sessionRepository.revokeAllForUser(before.user_id, now);
      this.sessionCache.dropByUser(before.user_id);
    }

    const after = await this.repository.findByIdWithRole(id);
    if (!after) {
      throw new NotFoundError('Employee not found after status change');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'employee.status_changed',
      entityName: 'employees',
      entityId: id,
      beforeState: { status: before.status },
      afterState: { status: after.status, auth_blocked: blockAuth },
    });

    return after;
  }
}
