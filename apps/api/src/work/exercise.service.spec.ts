import { describe, it, expect, vi, beforeEach } from 'vitest';
import { ExerciseService } from './exercise.service';
import { ExerciseRepository } from './exercise.repository';
import { PaginationHelper } from '../platform/http/pagination';
import { AuditService } from '../platform/audit/audit.service';
import { PermissionCache } from '../rbac/permission-cache';
import { NotFoundError } from '../platform/errors/app-error';
import type { Exercise } from '../platform/db/schema/exercises';
import type { AuthenticatedUser } from '../auth/auth.guard';

const MEMBER_USER: AuthenticatedUser = {
  id: 10,
  email: 'member@luxeknox.test',
  phoneNumber: null,
  userType: 'member',
  roleId: 5,
  profileId: null,
  sessionId: 1,
};

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 2,
};

function makeExercise(overrides: Partial<Exercise> = {}): Exercise {
  return {
    id: 1,
    name: 'Barbell Squat',
    primary_muscle_group: 'legs',
    secondary_muscles: ['glutes'],
    equipment_needed: 'barbell',
    instructions: 'Squat down, stand up.',
    video_url: null,
    gif_url: null,
    difficulty_level: 'intermediate',
    is_active: true,
    created_at: new Date('2026-09-01T00:00:00.000Z'),
    updated_at: null,
    ...overrides,
  };
}

describe('ExerciseService', () => {
  let repository: Partial<ExerciseRepository>;
  let paginationHelper: PaginationHelper;
  let auditService: Partial<AuditService>;
  let permissionCache: Partial<PermissionCache>;
  let service: ExerciseService;

  beforeEach(() => {
    repository = {
      findManyFiltered: vi.fn(),
      findById: vi.fn(),
      insertExercise: vi.fn(),
      updateExercise: vi.fn(),
    };
    paginationHelper = new PaginationHelper({
      getDefaultPageSize: vi.fn().mockResolvedValue(20),
    } as any);
    auditService = { recordAudit: vi.fn().mockResolvedValue(undefined) };
    permissionCache = { hasPermission: vi.fn().mockResolvedValue(false) };

    service = new ExerciseService(
      repository as ExerciseRepository,
      paginationHelper,
      auditService as AuditService,
      permissionCache as PermissionCache,
    );
  });

  describe('list', () => {
    it('passes filters and offset-mode pagination through to the repository', async () => {
      vi.mocked(repository.findManyFiltered!).mockResolvedValue({
        rows: [makeExercise()],
        total: 1,
      });

      const result = await service.list(
        { q: 'squat', primary_muscle_group: 'legs', limit: '10', offset: '0' },
        MEMBER_USER,
      );

      expect(repository.findManyFiltered).toHaveBeenCalledWith(
        expect.objectContaining({
          q: 'squat',
          primaryMuscleGroup: 'legs',
          activeOnly: true,
          limit: 10,
          offset: 0,
        }),
      );
      expect(result.data).toHaveLength(1);
      expect(result.meta).toEqual({
        limit: 10,
        offset: 0,
        cursor: null,
        next_cursor: null,
        has_more: false,
        total: 1,
      });
    });

    it('sets activeOnly=false when the caller holds exercises.update', async () => {
      vi.mocked(permissionCache.hasPermission!).mockResolvedValue(true);
      vi.mocked(repository.findManyFiltered!).mockResolvedValue({ rows: [], total: 0 });

      await service.list({}, ADMIN_USER);

      expect(permissionCache.hasPermission).toHaveBeenCalledWith(ADMIN_USER.roleId, 'exercises.update');
      expect(repository.findManyFiltered).toHaveBeenCalledWith(
        expect.objectContaining({ activeOnly: false }),
      );
    });
  });

  describe('getById', () => {
    it('throws NotFoundError when the repository returns null', async () => {
      vi.mocked(repository.findById!).mockResolvedValue(null);

      await expect(service.getById(999, MEMBER_USER)).rejects.toThrow(NotFoundError);
    });

    it('passes activeOnly=true for a caller without exercises.update', async () => {
      vi.mocked(repository.findById!).mockResolvedValue(makeExercise());

      await service.getById(1, MEMBER_USER);

      expect(repository.findById).toHaveBeenCalledWith(1, true);
    });

    it('passes activeOnly=false for a caller with exercises.update', async () => {
      vi.mocked(permissionCache.hasPermission!).mockResolvedValue(true);
      vi.mocked(repository.findById!).mockResolvedValue(makeExercise({ is_active: false }));

      const result = await service.getById(1, ADMIN_USER);

      expect(repository.findById).toHaveBeenCalledWith(1, false);
      expect(result.is_active).toBe(false);
    });
  });

  describe('create', () => {
    it('inserts, then records exactly one audit row', async () => {
      vi.mocked(repository.insertExercise!).mockResolvedValue(42);
      vi.mocked(repository.findById!).mockResolvedValue(makeExercise({ id: 42 }));

      const result = await service.create({ name: 'Deadlift' }, ADMIN_USER);

      expect(result.id).toBe(42);
      expect(auditService.recordAudit).toHaveBeenCalledTimes(1);
      expect(auditService.recordAudit).toHaveBeenCalledWith(
        expect.objectContaining({
          actorUserId: ADMIN_USER.id,
          action: 'exercise.created',
          entityName: 'exercises',
          entityId: 42,
        }),
      );
    });
  });

  describe('update', () => {
    it('throws NotFoundError when the exercise does not exist', async () => {
      vi.mocked(repository.findById!).mockResolvedValue(null);

      await expect(service.update(1, { name: 'X' }, ADMIN_USER)).rejects.toThrow(NotFoundError);
      expect(repository.updateExercise).not.toHaveBeenCalled();
    });

    it('only writes fields present in the DTO, leaving the rest untouched', async () => {
      vi.mocked(repository.findById!)
        .mockResolvedValueOnce(makeExercise())
        .mockResolvedValueOnce(makeExercise({ is_active: false }));

      await service.update(1, { is_active: false }, ADMIN_USER);

      expect(repository.updateExercise).toHaveBeenCalledWith(
        1,
        expect.objectContaining({ is_active: false, updated_at: expect.any(Date) }),
      );
      const values = vi.mocked(repository.updateExercise!).mock.calls[0][1];
      expect(values).not.toHaveProperty('name');
      expect(values).not.toHaveProperty('instructions');
    });

    it('writes exactly one audit row with before/after state', async () => {
      const before = makeExercise();
      const after = makeExercise({ is_active: false });
      vi.mocked(repository.findById!).mockResolvedValueOnce(before).mockResolvedValueOnce(after);

      await service.update(1, { is_active: false }, ADMIN_USER);

      expect(auditService.recordAudit).toHaveBeenCalledTimes(1);
      expect(auditService.recordAudit).toHaveBeenCalledWith(
        expect.objectContaining({
          action: 'exercise.updated',
          entityName: 'exercises',
          entityId: 1,
          beforeState: before,
          afterState: after,
        }),
      );
    });
  });
});
