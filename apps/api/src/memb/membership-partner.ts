import { BadRequestError } from '../platform/errors/app-error';

/**
 * Couple packages require a different member as partner. Single packages reject one.
 * Shared by membership assign and PT purchase.
 */
export function assertPartnerForPackage(
  packageType: 'single' | 'couple',
  memberId: number,
  partnerMemberId: number | null | undefined,
): void {
  if (packageType === 'couple' && partnerMemberId == null) {
    throw new BadRequestError('partner_member_id is required for a couple package');
  }
  if (packageType !== 'couple' && partnerMemberId != null) {
    throw new BadRequestError('partner_member_id is only valid for a couple package');
  }
  if (partnerMemberId != null && partnerMemberId === memberId) {
    throw new BadRequestError('partner_member_id must differ from member_id');
  }
}
