import { describe, expect, it, vi } from 'vitest';
import { ForbiddenError } from '../platform/errors/app-error';
import { PtAccessService } from './pt-access.service';

const trainer = {
  id: 9,
  email: 't@x.com',
  phoneNumber: null,
  userType: 'trainer' as const,
  roleId: 3,
  profileId: 7,
  sessionId: 1,
};

describe('PtAccessService', () => {
  it('gives full access while the trainer holds an active PT with the member', async () => {
    const repo = { hasActiveForMemberAndTrainer: vi.fn().mockResolvedValue(true) };
    const service = new PtAccessService(repo as any);
    await expect(service.assertTrainerCanWrite(trainer, 42)).resolves.toBeUndefined();
    expect(repo.hasActiveForMemberAndTrainer).toHaveBeenCalledWith(42, 7);
  });

  it('is read-only once PT has ended', async () => {
    const repo = { hasActiveForMemberAndTrainer: vi.fn().mockResolvedValue(false) };
    const service = new PtAccessService(repo as any);
    expect(await service.trainerAccess(7, 42)).toBe('read_only');
    await expect(service.assertTrainerCanWrite(trainer, 42)).rejects.toBeInstanceOf(ForbiddenError);
  });

  it('never restricts staff', async () => {
    const repo = { hasActiveForMemberAndTrainer: vi.fn() };
    const service = new PtAccessService(repo as any);
    await service.assertTrainerCanWrite({ ...trainer, userType: 'admin' }, 42);
    expect(repo.hasActiveForMemberAndTrainer).not.toHaveBeenCalled();
  });
});
