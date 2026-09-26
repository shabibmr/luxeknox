import { describe, it, expect, vi, beforeEach } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { NotFoundError } from '../platform/errors/app-error';
import { MedicalHistoryService } from './medical-history.service';

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

describe('MedicalHistoryService', () => {
  let service: MedicalHistoryService;
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
            condition_id: null,
            title: 'Asthma',
            description: 'Mild exercise-induced asthma',
            diagnosed_date: '2020-05-10',
            clearance_status: 'cleared',
            document_key: null,
            created_at: new Date('2026-01-01T00:00:00.000Z'),
            updated_at: null,
          },
        ],
        total: 1,
      }),
      findByIdAndMemberId: vi.fn().mockImplementation(async (id: number, memberId: number) => ({
        id,
        member_id: memberId,
        condition_id: null,
        title: 'Asthma',
        description: 'Mild exercise-induced asthma',
        diagnosed_date: '2020-05-10',
        clearance_status: 'cleared',
        document_key: null,
        created_at: new Date('2026-01-01T00:00:00.000Z'),
        updated_at: null,
      })),
      insertHistory: vi.fn().mockResolvedValue(1),
      updateHistory: vi.fn().mockResolvedValue(undefined),
      deleteHistory: vi.fn().mockResolvedValue(undefined),
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

    service = new MedicalHistoryService(
      repository as any,
      memberRepository as any,
      auditService as any,
      paginationHelper as any,
    );
  });

  describe('list', () => {
    it('returns paginated medical history list for member', async () => {
      const result = await service.list(100, {}, MEMBER_USER);
      expect(result.data).toHaveLength(1);
      expect(result.data[0].title).toBe('Asthma');
      expect(result.meta.total).toBe(1);
    });

    it('rejects unassigned trainer or another member via row-scope', async () => {
      const otherMember: AuthenticatedUser = { ...MEMBER_USER, id: 999, profileId: 999 };
      await expect(service.list(100, {}, otherMember)).rejects.toThrow(NotFoundError);
    });
  });

  describe('create', () => {
    it('creates medical history record and records audit', async () => {
      const result = await service.create(
        100,
        {
          title: 'Hypertension',
          description: 'Stage 1',
          diagnosed_date: '2022-01-15',
          clearance_status: 'pending',
        },
        ADMIN_USER,
      );

      expect(repository.insertHistory).toHaveBeenCalledWith(
        expect.objectContaining({
          member_id: 100,
          title: 'Hypertension',
          description: 'Stage 1',
          diagnosed_date: '2022-01-15',
          clearance_status: 'pending',
        }),
      );
      expect(auditService.recordAudit).toHaveBeenCalledWith(
        expect.objectContaining({
          action: 'medical_history.created',
          entityName: 'medical_histories',
        }),
      );
      expect(result.id).toBe(1);
    });
  });

  describe('update', () => {
    it('updates medical history record and records audit', async () => {
      const result = await service.update(
        100,
        1,
        {
          title: 'Asthma Updated',
          clearance_status: 'cleared',
        },
        ADMIN_USER,
      );

      expect(repository.updateHistory).toHaveBeenCalledWith(
        1,
        100,
        expect.objectContaining({
          title: 'Asthma Updated',
          clearance_status: 'cleared',
        }),
      );
      expect(auditService.recordAudit).toHaveBeenCalledWith(
        expect.objectContaining({
          action: 'medical_history.updated',
          entityName: 'medical_histories',
        }),
      );
      expect(result.id).toBe(1);
    });

    it('throws NotFoundError if record does not exist', async () => {
      repository.findByIdAndMemberId.mockResolvedValue(null);

      await expect(
        service.update(100, 999, { title: 'Nonexistent' }, ADMIN_USER),
      ).rejects.toThrow(NotFoundError);
    });
  });

  describe('delete', () => {
    it('deletes medical history record and records audit', async () => {
      await service.delete(100, 1, ADMIN_USER);

      expect(repository.deleteHistory).toHaveBeenCalledWith(1, 100);
      expect(auditService.recordAudit).toHaveBeenCalledWith(
        expect.objectContaining({
          action: 'medical_history.deleted',
          entityName: 'medical_histories',
        }),
      );
    });

    it('throws NotFoundError if record does not exist', async () => {
      repository.findByIdAndMemberId.mockResolvedValue(null);

      await expect(service.delete(100, 999, ADMIN_USER)).rejects.toThrow(NotFoundError);
    });
  });
});
