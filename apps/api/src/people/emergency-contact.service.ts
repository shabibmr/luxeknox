import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { runInTransaction } from '../platform/db/transaction-context';
import { users } from '../platform/db/schema/users';
import { members } from '../platform/db/schema/members';
import type { EmergencyContact } from '../platform/db/schema/members';
import { NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import {
  type EmergencyContactUpdateDto,
  type EmergencyContactWriteDto,
} from './emergency-contact.dto';
import { EmergencyContactRepository } from './emergency-contact.repository';
import { assertPeopleRowScope } from './row-scope';

/**
 * Primary uniqueness: transactional unset-others pattern (MariaDB-safe; no generated column).
 * When creating/updating with is_primary=true, clear other primaries for that user_id in the same TX.
 */
@Injectable()
export class EmergencyContactService {
  constructor(
    private readonly repository: EmergencyContactRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  /**
   * Ensure target user exists, then apply PEOPLE row-scope (404).
   * Contacts hang off user_id; trainers may only see assigned members' contacts.
   */
  private async assertTargetInScope(actor: AuthenticatedUser, targetUserId: number): Promise<void> {
    const userRows = await (this.db as any)
      .select({ id: users.id })
      .from(users)
      .where(eq(users.id, targetUserId))
      .limit(1);
    if (!userRows[0]) {
      throw new NotFoundError('Resource not found');
    }

    const memberRows = await (this.db as any)
      .select({
        id: members.id,
        assigned_trainer_id: members.assigned_trainer_id,
      })
      .from(members)
      .where(eq(members.user_id, targetUserId))
      .limit(1);
    const member = memberRows[0] as
      | { id: number; assigned_trainer_id: number | null }
      | undefined;

    assertPeopleRowScope(actor, {
      kind: 'emergency_contact',
      userId: targetUserId,
      profileId: member?.id ?? null,
      assignedTrainerId: member?.assigned_trainer_id ?? null,
    });
  }

  async list(
    userId: number,
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<EmergencyContact>> {
    await this.assertTargetInScope(actor, userId);

    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;
    const { rows, total } = await this.repository.findByUserId(
      userId,
      pagination.limit,
      offset,
    );

    return createPaginatedResponse({
      items: rows,
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async create(
    userId: number,
    dto: EmergencyContactWriteDto,
    actor: AuthenticatedUser,
  ): Promise<EmergencyContact> {
    await this.assertTargetInScope(actor, userId);

    const now = new Date();
    const id = await runInTransaction(this.db, async () => {
      if (dto.is_primary) {
        await this.repository.clearPrimaryForUser(userId);
      }
      return this.repository.insertContact({
        user_id: userId,
        contact_name: dto.contact_name,
        relationship: dto.relationship ?? null,
        phone_primary: dto.phone_primary,
        phone_secondary: dto.phone_secondary ?? null,
        is_primary: dto.is_primary ?? false,
        created_at: now,
        updated_at: null,
      });
    });

    const created = await this.repository.findByIdForUser(id, userId);
    if (!created) {
      throw new NotFoundError('Emergency contact not found after create');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'emergency_contact.created',
      entityName: 'emergency_contacts',
      entityId: id,
      afterState: created,
    });

    return created;
  }

  async update(
    userId: number,
    contactId: number,
    dto: EmergencyContactUpdateDto,
    actor: AuthenticatedUser,
  ): Promise<EmergencyContact> {
    await this.assertTargetInScope(actor, userId);

    const before = await this.repository.findByIdForUser(contactId, userId);
    if (!before) {
      throw new NotFoundError('Emergency contact not found');
    }

    const now = new Date();
    await runInTransaction(this.db, async () => {
      if (dto.is_primary === true) {
        await this.repository.clearPrimaryForUser(userId);
      }
      const patch: Partial<EmergencyContact> = { updated_at: now };
      if (dto.contact_name !== undefined) patch.contact_name = dto.contact_name;
      if (dto.relationship !== undefined) patch.relationship = dto.relationship;
      if (dto.phone_primary !== undefined) patch.phone_primary = dto.phone_primary;
      if (dto.phone_secondary !== undefined) patch.phone_secondary = dto.phone_secondary;
      if (dto.is_primary !== undefined) patch.is_primary = dto.is_primary;
      await this.repository.updateContact(contactId, patch);
    });

    const after = await this.repository.findByIdForUser(contactId, userId);
    if (!after) {
      throw new NotFoundError('Emergency contact not found after update');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'emergency_contact.updated',
      entityName: 'emergency_contacts',
      entityId: contactId,
      beforeState: before,
      afterState: after,
    });

    return after;
  }

  async remove(
    userId: number,
    contactId: number,
    actor: AuthenticatedUser,
  ): Promise<void> {
    await this.assertTargetInScope(actor, userId);

    const before = await this.repository.findByIdForUser(contactId, userId);
    if (!before) {
      throw new NotFoundError('Emergency contact not found');
    }

    await this.repository.deleteContact(contactId);

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'emergency_contact.deleted',
      entityName: 'emergency_contacts',
      entityId: contactId,
      beforeState: before,
    });
  }
}
