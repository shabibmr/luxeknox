import type { AuthenticatedUser } from '../auth/auth.guard';
import { NotFoundError } from '../platform/errors/app-error';

/**
 * Target identity for PEOPLE row-scope checks (BR-PEOPLE-002/003).
 * Pass whatever identifiers the caller already has; missing fields are treated
 * as unknown and fail closed for scoped roles.
 */
export interface RowScopeTarget {
  /** Profile table primary key (members.id / trainers.id / …). */
  profileId?: number | null;
  /** Owning users.id for the target row. */
  userId?: number | null;
  /** members.assigned_trainer_id when the target is a member row. */
  assignedTrainerId?: number | null;
  /** Resource kind — defaults to member (most common dossier path). */
  kind?: 'member' | 'trainer' | 'employee' | 'emergency_contact';
}

export interface AssertPeopleRowScopeOptions {
  /**
   * When true, staff (admin / employee) bypass row filters. PermissionGuard
   * must already have gated the route; this helper only enforces row visibility.
   * Default true.
   */
  staffBypass?: boolean;
}

/**
 * Throws {@link NotFoundError} when the principal must not learn that the
 * target exists (404, not 403). Free of HTTP — services call before returning.
 *
 * Rules:
 * - Admin / employee: no row filter (staffBypass).
 * - Member: only own user_id / own profile id.
 * - Trainer: members where assigned_trainer_id = trainer profileId; own trainer profile ok.
 */
export function assertPeopleRowScope(
  principal: AuthenticatedUser,
  target: RowScopeTarget,
  options: AssertPeopleRowScopeOptions = {},
): void {
  const staffBypass = options.staffBypass !== false;
  const kind = target.kind ?? 'member';

  if (staffBypass && (principal.userType === 'admin' || principal.userType === 'employee')) {
    return;
  }

  if (principal.userType === 'member') {
    const ownsByUser =
      target.userId != null && principal.id === target.userId;
    const ownsByProfile =
      target.profileId != null &&
      principal.profileId != null &&
      principal.profileId === target.profileId;
    if (ownsByUser || ownsByProfile) {
      return;
    }
    throw new NotFoundError('Resource not found');
  }

  if (principal.userType === 'trainer') {
    if (kind === 'trainer') {
      const ownsByUser =
        target.userId != null && principal.id === target.userId;
      const ownsByProfile =
        target.profileId != null &&
        principal.profileId != null &&
        principal.profileId === target.profileId;
      if (ownsByUser || ownsByProfile) {
        return;
      }
      throw new NotFoundError('Resource not found');
    }

    // Member (or member-owned EC): must be assigned to this trainer.
    if (
      principal.profileId != null &&
      target.assignedTrainerId != null &&
      principal.profileId === target.assignedTrainerId
    ) {
      return;
    }
    throw new NotFoundError('Resource not found');
  }

  // Unrecognized / unexpected principal types fail closed.
  throw new NotFoundError('Resource not found');
}
