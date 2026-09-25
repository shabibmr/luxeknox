import { describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import {
  BadRequestError,
  BusinessRuleError,
  ConflictError,
  NotFoundError,
} from '../platform/errors/app-error';
import { WorkoutSessionService } from './workout-session.service';

const memberActor: AuthenticatedUser = {
  id: 3,
  email: 'member@example.com',
  phoneNumber: null,
  roleId: 3,
  userType: 'member',
  profileId: 30,
  sessionId: 3,
};

const otherMemberActor: AuthenticatedUser = {
  id: 4,
  email: 'other@example.com',
  phoneNumber: null,
  roleId: 3,
  userType: 'member',
  profileId: 40,
  sessionId: 4,
};

const trainerActor: AuthenticatedUser = {
  id: 2,
  email: 'trainer@example.com',
  phoneNumber: null,
  roleId: 2,
  userType: 'trainer',
  profileId: 20,
  sessionId: 2,
};

function buildService(overrides: {
  sessionRepo?: Partial<Record<string, unknown>>;
  planRepo?: Partial<Record<string, unknown>>;
  memberRepo?: Partial<Record<string, unknown>>;
  eventBus?: Partial<Record<string, unknown>>;
} = {}) {
  const sessionRepo = {
    findSessions: vi.fn().mockResolvedValue({ rows: [], total: 0 }),
    findSessionById: vi.fn(),
    findActiveSessionForMember: vi.fn().mockResolvedValue(null),
    insertSession: vi.fn(),
    insertSessionExercise: vi.fn(),
    findSetsBySessionId: vi.fn().mockResolvedValue([]),
    completeSession: vi.fn(),
    findPersonalRecords: vi.fn().mockResolvedValue([]),
    ...overrides.sessionRepo,
  };

  const planRepo = {
    findPlanById: vi.fn(),
    findLatestVersionByPlanId: vi.fn(),
    ...overrides.planRepo,
  };

  const memberRepo = {
    findById: vi.fn().mockImplementation(async (id: number) => {
      if (id === 30) return { id: 30, user_id: 3, assigned_trainer_id: 20 };
      if (id === 40) return { id: 40, user_id: 4, assigned_trainer_id: 99 };
      return null;
    }),
    ...overrides.memberRepo,
  };

  const eventBus = {
    emitSync: vi.fn(),
    emit: vi.fn().mockResolvedValue([]),
    ...overrides.eventBus,
  };

  const paginationHelper = {
    normalizeParams: vi.fn().mockResolvedValue({ limit: 20, offset: 0 }),
  };

  const service = new WorkoutSessionService(
    sessionRepo as any,
    planRepo as any,
    memberRepo as any,
    eventBus as any,
    paginationHelper as any,
  );

  return { service, sessionRepo, planRepo, memberRepo, eventBus };
}

describe('WorkoutSessionService', () => {
  describe('start and in-progress constraint (WRK-012, WRK-013)', () => {
    it('starts a new workout session for a member', async () => {
      const { service, sessionRepo, eventBus } = buildService();

      sessionRepo.insertSession.mockResolvedValue({
        id: 50,
        member_id: 30,
        workout_plan_id: null,
        workout_plan_version_id: null,
        trainer_id: null,
        started_at: new Date(),
        completed_at: null,
        total_volume_kg: '0.00',
      });

      const session = await service.start({}, memberActor);

      expect(sessionRepo.findActiveSessionForMember).toHaveBeenCalledWith(30);
      expect(sessionRepo.insertSession).toHaveBeenCalledWith(
        expect.objectContaining({
          member_id: 30,
        }),
      );
      expect(session.id).toBe(50);
      expect(eventBus.emitSync).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'workout_session.started',
          payload: expect.objectContaining({ session_id: 50, member_id: 30 }),
        }),
      );
    });

    it('enforces one in-progress workout session per member (WRK-013)', async () => {
      const { service, sessionRepo } = buildService();

      sessionRepo.findActiveSessionForMember.mockResolvedValue({
        id: 49,
        member_id: 30,
        started_at: new Date(),
        completed_at: null,
      });

      await expect(service.start({}, memberActor)).rejects.toThrow(ConflictError);
    });
  });

  describe('set logging (WRK-014)', () => {
    it('logs an exercise set to an active workout session', async () => {
      const { service, sessionRepo } = buildService();

      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: null,
      });

      sessionRepo.insertSessionExercise.mockResolvedValue({
        id: 501,
        workout_session_id: 50,
        exercise_id: 1,
        set_number: 1,
        reps_completed: 10,
        weight_lifted_kg: '60.00',
        rpe_score: '8.0',
        is_completed: true,
      });

      const set = await service.logSet(
        50,
        {
          exercise_id: 1,
          set_number: 1,
          reps_completed: 10,
          weight_lifted_kg: 60,
          rpe_score: 8,
          is_completed: true,
        },
        memberActor,
      );

      expect(sessionRepo.insertSessionExercise).toHaveBeenCalledWith(
        expect.objectContaining({
          workout_session_id: 50,
          exercise_id: 1,
          set_number: 1,
          reps_completed: 10,
          weight_lifted_kg: '60',
          rpe_score: '8',
          is_completed: true,
        }),
      );
      expect(set.id).toBe(501);
    });

    it('rejects logging sets to a completed session', async () => {
      const { service, sessionRepo } = buildService();

      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: new Date(),
      });

      await expect(
        service.logSet(
          50,
          {
            exercise_id: 1,
            set_number: 1,
            reps_completed: 10,
            weight_lifted_kg: 50,
            is_completed: true,
          },
          memberActor,
        ),
      ).rejects.toThrow(BusinessRuleError);
    });
  });

  describe('session completion and volume calculation (WRK-015)', () => {
    it('calculates total volume and duration upon completion', async () => {
      const { service, sessionRepo, eventBus } = buildService();

      const startTime = new Date(Date.now() - 45 * 60 * 1000); // 45 minutes ago
      sessionRepo.findSessionById
        .mockResolvedValueOnce({
          id: 50,
          member_id: 30,
          started_at: startTime,
          completed_at: null,
        })
        .mockResolvedValueOnce({
          id: 50,
          member_id: 30,
          started_at: startTime,
          completed_at: new Date(),
          total_volume_kg: '1800.00',
          duration_minutes: 45,
          client_feedback_rating: 5,
          notes: 'Great workout',
          sets: [],
        });

      // 3 sets:
      // Set 1: 10 reps * 60kg = 600
      // Set 2: 10 reps * 60kg = 600
      // Set 3: 10 reps * 60kg = 600
      // Total volume: 1800kg
      sessionRepo.findSetsBySessionId.mockResolvedValue([
        { reps_completed: 10, weight_lifted_kg: '60.00', is_completed: true },
        { reps_completed: 10, weight_lifted_kg: '60.00', is_completed: true },
        { reps_completed: 10, weight_lifted_kg: '60.00', is_completed: true },
      ]);

      const completed = await service.complete(
        50,
        {
          client_feedback_rating: 5,
          notes: 'Great workout',
        },
        memberActor,
      );

      expect(sessionRepo.completeSession).toHaveBeenCalledWith(
        50,
        expect.any(Date),
        '1800.00',
        expect.any(Number),
        5,
        'Great workout',
      );

      expect(completed.total_volume_kg).toBe('1800.00');
      expect(eventBus.emitSync).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'workout_session.completed',
          payload: expect.objectContaining({
            session_id: 50,
            total_volume_kg: 1800,
          }),
        }),
      );
    });
  });

  describe('personal records query (WRK-016)', () => {
    it('returns member personal records across exercises', async () => {
      const { service, sessionRepo } = buildService();

      sessionRepo.findPersonalRecords.mockResolvedValue([
        {
          exercise_id: 1,
          exercise_name: 'Barbell Bench Press',
          max_weight_kg: 100,
          max_reps: 12,
          best_set_volume_kg: 1200,
          achieved_at: new Date(),
        },
      ]);

      const prs = await service.getPersonalRecords(30, 1, memberActor);

      expect(sessionRepo.findPersonalRecords).toHaveBeenCalledWith(30, 1);
      expect(prs).toHaveLength(1);
      expect(prs[0].max_weight_kg).toBe(100);
    });

    it('rejects access when a member requests another member PRs', async () => {
      const { service } = buildService();

      await expect(service.getPersonalRecords(40, 1, memberActor)).rejects.toThrow(
        NotFoundError,
      );
    });
  });
});
