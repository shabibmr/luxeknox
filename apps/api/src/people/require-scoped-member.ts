import type { AuthenticatedUser } from '../auth/auth.guard';
import type { Member } from '../platform/db/schema/members';
import { NotFoundError } from '../platform/errors/app-error';
import type { MemberRepository } from './member.repository';
import { assertPeopleRowScope } from './row-scope';

/** Load member by profile id and enforce PEOPLE row-scope (404). */
export async function requireScopedMember(
  memberRepository: MemberRepository,
  memberId: number,
  actor: AuthenticatedUser,
): Promise<Member> {
  const member = await memberRepository.findById(memberId);
  if (!member) {
    throw new NotFoundError('Member not found');
  }
  assertPeopleRowScope(actor, {
    kind: 'member',
    profileId: member.id,
    userId: member.user_id,
    assignedTrainerId: member.assigned_trainer_id,
  });
  return member;
}
