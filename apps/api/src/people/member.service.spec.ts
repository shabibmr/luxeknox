import { describe, it, expect, vi, beforeEach } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { BadRequestError, BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import { MemberService } from './member.service';
import type { MemberRepository } from './member.repository';
import type { PersonFactory } from './person.factory';
import type { AuditService } from '../platform/audit/audit.service';
import type { PaginationHelper } from '../platform/http/pagination';
import type { DrizzleDb } from '../platform/db/client';

function actor(partial: Partial<AuthenticatedUser> & Pick<AuthenticatedUser, 'userType'>): AuthenticatedUser {
  return {
    id: partial.id ?? 1,
    email: 'admin@example.com',
    phoneNumber: null,
    userType: partial.userType,
    roleId: partial.roleId ?? 1,
    profileId: partial.profileId ?? null,
    sessionId: 1,
  };
}

describe('MemberService.assignTrainer', () => {
  let service: MemberService;
  let repository: {
    findById: ReturnType<typeof vi.fn>;
    findTrainerAssignmentMeta: ReturnType<typeof vi.fn>;
    countAssignedToTrainer: ReturnType<typeof vi.fn>;
    updateMember: ReturnType<typeof vi.fn>;
  };
  let auditService: { recordAudit: ReturnType<typeof vi.fn> };

  const member = {
    id: 10,
    user_id: 100,
    membership_number: 'M00000001',
    first_name: 'Ada',
    last_name: 'Lovelace',
    gender: null,
    date_of_birth: null,
    address: null,
    assigned_trainer_id: null as number | null,
    joined_date: '2026-01-01',
    notes: null,
    created_at: new Date(),
    updated_at: null,
  };

  beforeEach(() => {
    repository = {
      findById: vi.fn(),
      findTrainerAssignmentMeta: vi.fn(),
      countAssignedToTrainer: vi.fn(),
      updateMember: vi.fn().mockResolvedValue(undefined),
    };
    auditService = { recordAudit: vi.fn().mockResolvedValue(undefined) };

    service = new MemberService(
      repository as unknown as MemberRepository,
      {} as PersonFactory,
      {} as PaginationHelper,
      auditService as unknown as AuditService,
      { transaction: vi.fn() } as unknown as DrizzleDb<any>,
    );
  });

  it('rejects inactive trainers with 422', async () => {
    repository.findById.mockResolvedValue(member);
    repository.findTrainerAssignmentMeta.mockResolvedValue({
      id: 5,
      is_active: false,
      max_clients_capacity: 10,
    });

    await expect(
      service.assignTrainer(10, { trainer_id: 5, override_capacity: false }, actor({ userType: 'admin' })),
    ).rejects.toThrow(BusinessRuleError);
  });

  it('rejects at-capacity without override', async () => {
    repository.findById.mockResolvedValue(member);
    repository.findTrainerAssignmentMeta.mockResolvedValue({
      id: 5,
      is_active: true,
      max_clients_capacity: 2,
    });
    repository.countAssignedToTrainer.mockResolvedValue(2);

    await expect(
      service.assignTrainer(10, { trainer_id: 5, override_capacity: false }, actor({ userType: 'admin' })),
    ).rejects.toThrow(BusinessRuleError);
  });

  it('allows admin override_capacity with reason and writes audit', async () => {
    repository.findById
      .mockResolvedValueOnce(member)
      .mockResolvedValueOnce({ ...member, assigned_trainer_id: 5 });
    repository.findTrainerAssignmentMeta.mockResolvedValue({
      id: 5,
      is_active: true,
      max_clients_capacity: 2,
    });
    repository.countAssignedToTrainer.mockResolvedValue(2);

    const result = await service.assignTrainer(
      10,
      { trainer_id: 5, override_capacity: true, reason: 'VIP intake' },
      actor({ userType: 'admin' }),
    );

    expect(result.assigned_trainer_id).toBe(5);
    expect(auditService.recordAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: 'member.trainer_assigned',
        entityId: 10,
      }),
    );
  });

  it('requires reason when override_capacity is true', async () => {
    repository.findById.mockResolvedValue(member);
    repository.findTrainerAssignmentMeta.mockResolvedValue({
      id: 5,
      is_active: true,
      max_clients_capacity: 1,
    });
    repository.countAssignedToTrainer.mockResolvedValue(1);

    await expect(
      service.assignTrainer(
        10,
        { trainer_id: 5, override_capacity: true, reason: null },
        actor({ userType: 'admin' }),
      ),
    ).rejects.toThrow(BadRequestError);
  });

  it('404 when member missing', async () => {
    repository.findById.mockResolvedValue(null);
    await expect(
      service.assignTrainer(99, { trainer_id: 5, override_capacity: false }, actor({ userType: 'admin' })),
    ).rejects.toThrow(NotFoundError);
  });
});

describe('MemberService.update', () => {
  let service: MemberService;
  let repository: {
    findById: ReturnType<typeof vi.fn>;
    findTrainerAssignmentMeta: ReturnType<typeof vi.fn>;
    countAssignedToTrainer: ReturnType<typeof vi.fn>;
    updateMember: ReturnType<typeof vi.fn>;
  };

  const member = {
    id: 10,
    user_id: 100,
    membership_number: 'M00000001',
    first_name: 'Ada',
    last_name: 'Lovelace',
    gender: null,
    date_of_birth: null,
    address: null,
    assigned_trainer_id: null as number | null,
    joined_date: '2026-01-01',
    notes: null,
    created_at: new Date(),
    updated_at: null,
  };

  beforeEach(() => {
    repository = {
      findById: vi.fn().mockResolvedValue(member),
      findTrainerAssignmentMeta: vi.fn(),
      countAssignedToTrainer: vi.fn(),
      updateMember: vi.fn(),
    };

    service = new MemberService(
      repository as unknown as MemberRepository,
      {} as PersonFactory,
      {} as PaginationHelper,
      { recordAudit: vi.fn() } as unknown as AuditService,
      { transaction: vi.fn() } as unknown as DrizzleDb<any>,
    );
  });

  it('rejects patch of membership_number as immutable', async () => {
    await expect(
      service.update(
        10,
        { membership_number: 'M99999999' } as any,
        actor({ userType: 'admin' }),
      ),
    ).rejects.toThrow(BadRequestError);
    expect(repository.updateMember).not.toHaveBeenCalled();
  });
});
