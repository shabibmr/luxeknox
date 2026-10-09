import { describe, it, expect, vi, beforeEach } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { NotFoundError } from '../platform/errors/app-error';
import { MemberHealthService } from './member-health.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const MEMBER_USER: AuthenticatedUser = {
  id: 10,
  email: 'member@luxeknox.test',
  phoneNumber: null,
  userType: 'member',
  roleId: 5,
  profileId: 100,
  sessionId: 2,
};

describe('MemberHealthService', () => {
  let service: MemberHealthService;
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let memberRepository: Record<string, ReturnType<typeof vi.fn>>;
  let auditService: { recordAudit: ReturnType<typeof vi.fn> };
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };

  beforeEach(() => {
    repository = {
      findManyByMemberId: vi.fn().mockResolvedValue({
        rows: [
          {
            id: 1,
            member_id: 100,
            blood_group: 'O+',
            height_cm: 180,
            baseline_weight_kg: 75,
            allergies: null,
            dietary_preferences: null,
            physician_name: null,
            physician_phone: null,
            recorded_at: new Date('2026-01-01T00:00:00.000Z'),
            created_at: new Date('2026-01-01T00:00:00.000Z'),
          },
        ],
        total: 1,
      }),
      findByIdAndMemberId: vi.fn().mockImplementation(async (id: number, memberId: number) => ({
        id,
        member_id: memberId,
        blood_group: 'O+',
        height_cm: 180,
        baseline_weight_kg: 75,
        allergies: null,
        dietary_preferences: null,
        physician_name: null,
        physician_phone: null,
        recorded_at: new Date('2026-02-01T00:00:00.000Z'),
        created_at: new Date('2026-02-01T00:00:00.000Z'),
      })),
      insertRecord: vi.fn().mockResolvedValue(1),
    };

    memberRepository = {
      findById: vi.fn().mockImplementation(async (id: number) => ({
        id,
        user_id: 10,
        assigned_trainer_id: null,
      })),
    };

    auditService = { recordAudit: vi.fn().mockResolvedValue(undefined) };
    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ mode: 'offset', limit: 20, offset: 0 }),
    };

    service = new MemberHealthService(
      repository as any,
      memberRepository as any,
      auditService as any,
      paginationHelper as any,
    );
  });

  describe('list', () => {
    it('returns paginated health history for member', async () => {
      const result = await service.list(100, {}, MEMBER_USER);
      expect(result.data).toHaveLength(1);
      expect(result.data[0].recorded_at).toBe('2026-01-01T00:00:00.000Z');
      expect(result.meta.total).toBe(1);
    });

    it('rejects access for an unscoped member', async () => {
      const otherMember: AuthenticatedUser = { ...MEMBER_USER, id: 999, profileId: 999 };
      await expect(service.list(100, {}, otherMember)).rejects.toThrow(NotFoundError);
    });
  });

  describe('create', () => {
    it('always inserts a new record with current recorded_at and records audit', async () => {
      const result = await service.create(
        100,
        {
          blood_group: 'O+',
          height_cm: 180,
          baseline_weight_kg: 75,
          allergies: null,
          dietary_preferences: null,
          physician_name: null,
          physician_phone: null,
        },
        ADMIN_USER,
      );

      expect(repository.insertRecord).toHaveBeenCalledWith(
        expect.objectContaining({
          member_id: 100,
          blood_group: 'O+',
          recorded_at: expect.any(Date),
        }),
      );
      expect(repository.findByIdAndMemberId).toHaveBeenCalledWith(1, 100);
      expect(auditService.recordAudit).toHaveBeenCalledWith(
        expect.objectContaining({
          action: 'member_health.recorded',
          entityName: 'member_health',
        }),
      );
      expect(result.id).toBe(1);
    });
  });
});
