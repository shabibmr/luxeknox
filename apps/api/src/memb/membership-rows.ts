import type { AuthenticatedUser } from '../auth/auth.guard';
import type { AuditService } from '../platform/audit/audit.service';
import type { Membership } from '../platform/db/schema/memberships';
import { NotFoundError } from '../platform/errors/app-error';
import type { MembershipRepository } from './membership.repository';

/** Adds one calendar day to an ISO date string. */
export function addDays(isoDate: string, days: number): string {
  const [y, m, d] = isoDate.split('-').map(Number);
  const date = new Date(Date.UTC(y, m - 1, d));
  date.setUTCDate(date.getUTCDate() + days);
  return date.toISOString().slice(0, 10);
}

/** CM-07: cancels `before` inside the current transaction; caller emits the domain event after commit. */
export async function cancelRow(
  repository: MembershipRepository,
  auditService: AuditService,
  before: Membership,
  reason: string | null,
  actor: AuthenticatedUser,
  now: Date,
): Promise<void> {
  await repository.updateMembership(before.id, {
    status: 'cancelled',
    row_version: before.row_version + 1,
    updated_at: now,
  });

  await repository.insertHistory({
    membership_id: before.id,
    action: 'cancelled',
    old_end_date: before.end_date,
    new_end_date: before.end_date,
    performed_by_user_id: actor.id,
    timestamp: now,
  });

  await auditService.recordAudit({
    actorUserId: actor.id,
    action: 'membership.cancelled',
    entityName: 'memberships',
    entityId: before.id,
    beforeState: { status: before.status },
    afterState: { status: 'cancelled', reason },
  });
}

/** CM-08: the linked partner row of a couple membership, or null for a single membership. */
export async function loadPartner(
  repository: MembershipRepository,
  membership: Membership,
): Promise<Membership | null> {
  if (membership.partner_membership_id == null) {
    return null;
  }
  const partner = await repository.findPartner(membership);
  if (!partner) {
    throw new NotFoundError('Partner membership not found');
  }
  return partner;
}

/** CM-08: renew a row and its history/audit inside the current transaction. */
export async function renewRow(
  repository: MembershipRepository,
  auditService: AuditService,
  row: Membership,
  productId: number,
  newEndDate: string,
  actor: AuthenticatedUser,
  now: Date,
  via?: string,
  checkVersion = true,
): Promise<void> {
  await repository.updateMembership(
    row.id,
    {
      product_id: productId,
      end_date: newEndDate,
      status: 'active',
      row_version: row.row_version + 1,
      updated_at: now,
    },
    checkVersion ? row.row_version : undefined,
  );
  await repository.insertHistory({
    membership_id: row.id,
    action: 'renewed',
    old_end_date: row.end_date,
    new_end_date: newEndDate,
    performed_by_user_id: actor.id,
    timestamp: now,
  });
  await auditService.recordAudit({
    actorUserId: actor.id,
    action: 'membership.renewed',
    entityName: 'memberships',
    entityId: row.id,
    beforeState: { end_date: row.end_date },
    afterState: via ? { end_date: newEndDate, via } : { end_date: newEndDate },
  });
}
