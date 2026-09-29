import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { BusinessRuleError, ForbiddenError } from '../platform/errors/app-error';
import { PtSubscriptionRepository } from './pt-subscription.repository';

export type TrainerAccess = 'full' | 'read_only';

/**
 * Trainer write access to a member's hub (goals, workout plans, diet plans).
 *
 * Read access still follows `members.assigned_trainer_id` (people/row-scope.ts). Write
 * access additionally requires the trainer to hold an *active* PT subscription with the
 * member — once PT ends the trainer stays assigned but drops to read-only until renewal.
 */
@Injectable()
export class PtAccessService {
  constructor(private readonly subscriptions: PtSubscriptionRepository) {}

  async trainerAccess(trainerId: number, memberId: number): Promise<TrainerAccess> {
    return (await this.subscriptions.hasActiveForMemberAndTrainer(memberId, trainerId))
      ? 'full'
      : 'read_only';
  }

  /** No-op for non-trainer actors; staff/member rules are enforced by the caller. */
  async assertTrainerCanWrite(actor: AuthenticatedUser, memberId: number): Promise<void> {
    if (actor.userType !== 'trainer') return;
    if (actor.profileId == null) {
      throw new ForbiddenError('Trainer profile required');
    }
    if ((await this.trainerAccess(actor.profileId, memberId)) !== 'full') {
      // BusinessRuleError (not ForbiddenError): this is a recoverable, PT-renewal-dependent
      // state rather than a hard authorization denial, and its message must reach the client
      // verbatim (ADR-0006 §3) so trainers see *why* they're read-only instead of a generic
      // "no permission" error.
      throw new BusinessRuleError(
        'Read-only: an active Personal Training subscription is required to modify this member',
      );
    }
  }
}
