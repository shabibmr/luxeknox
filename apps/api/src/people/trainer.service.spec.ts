import { describe, it, expect, vi, beforeEach } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { AuditService } from '../platform/audit/audit.service';
import type { DrizzleDb } from '../platform/db/client';
import type { PaginationHelper } from '../platform/http/pagination';
import { TrainerService } from './trainer.service';
import type { TrainerRepository } from './trainer.repository';
import type { MemberRepository } from './member.repository';
import type { PersonFactory } from './person.factory';

function actor(userType: AuthenticatedUser['userType']): AuthenticatedUser {
  return {
    id: 1,
    email: `${userType}@example.com`,
    phoneNumber: null,
    userType,
    roleId: 1,
    profileId: userType === 'member' ? 99 : 1,
    sessionId: 1,
  };
}

describe('TrainerService outbound shaping', () => {
  let service: TrainerService;
  let repository: {
    findById: ReturnType<typeof vi.fn>;
    countAssignedMembers: ReturnType<typeof vi.fn>;
  };
  let memberRepository: { findById: ReturnType<typeof vi.fn> };

  const trainerRow = {
    id: 5,
    user_id: 50,
    first_name: 'Pat',
    last_name: 'Coach',
    bio: null,
    specializations: '["strength","yoga"]',
    hourly_rate: '75.5',
    rating: null,
    max_clients_capacity: 10,
    is_active: true,
    created_at: new Date(),
    updated_at: null,
  };

  beforeEach(() => {
    repository = {
      findById: vi.fn().mockResolvedValue(trainerRow),
      countAssignedMembers: vi.fn().mockResolvedValue(2),
    };
    memberRepository = {
      findById: vi.fn().mockResolvedValue({
        id: 99,
        assigned_trainer_id: 5,
      }),
    };

    service = new TrainerService(
      repository as unknown as TrainerRepository,
      memberRepository as unknown as MemberRepository,
      {} as PersonFactory,
      {} as PaginationHelper,
      { recordAudit: vi.fn() } as unknown as AuditService,
      {} as DrizzleDb<any>,
    );
  });

  it('normalizes specializations and Money for staff', async () => {
    const result = await service.getById(5, actor('admin'));
    expect(result.specializations).toEqual(['strength', 'yoga']);
    expect(result.hourly_rate).toBe('75.50');
    expect(result.assigned_active_count).toBe(2);
  });

  it('hides hourly_rate from members', async () => {
    const result = await service.getById(5, actor('member'));
    expect(result.hourly_rate).toBeNull();
    expect(result.specializations).toEqual(['strength', 'yoga']);
  });
});
