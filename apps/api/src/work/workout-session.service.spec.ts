import { describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import {
  BadRequestError,
  BusinessRuleError,
  ConflictError,
  NotFoundError,
} from '../platform/errors/app-error';
import { WorkoutSessionService } from './workout-session.service';
import {
  workoutSessionCompleteSchema,
  workoutSetWriteSchema,
  workoutSetUpdateSchema,
} from './workout-session.dto';

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
  ptAccess?: Partial<Record<string, unknown>> | null;
  medicalHistoryRepo?: Partial<Record<string, unknown>>;
  trainerRepo?: Partial<Record<string, unknown>>;
  employeeRepo?: Partial<Record<string, unknown>>;
  notificationService?: Partial<Record<string, unknown>>;
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
    findExerciseHistory: vi.fn().mockResolvedValue([]),
    findSetInSession: vi.fn(),
    updateSessionExercise: vi.fn(),
    deleteSessionExercise: vi.fn(),
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

  const ptAccess =
    overrides.ptAccess === null
      ? undefined
      : {
          assertTrainerCanWrite: vi.fn().mockResolvedValue(undefined),
          ...overrides.ptAccess,
        };

  const medicalHistoryRepo = {
    insertHistory: vi.fn().mockResolvedValue(1),
    ...overrides.medicalHistoryRepo,
  };

  const trainerRepo = {
    findById: vi.fn().mockImplementation(async (id: number) => {
      if (id === 20) return { id: 20, user_id: 2, first_name: 'Trainer', last_name: 'One' };
      return null;
    }),
    ...overrides.trainerRepo,
  };

  const employeeRepo = {
    findManyFiltered: vi.fn().mockResolvedValue({
      rows: [{ id: 1, user_id: 10, job_title: 'Head Coach', status: 'active' }],
      total: 1,
    }),
    ...overrides.employeeRepo,
  };

  const notificationService = {
    dispatch: vi.fn().mockResolvedValue(1),
    ...overrides.notificationService,
  };

  const service = new WorkoutSessionService(
    sessionRepo as any,
    planRepo as any,
    memberRepo as any,
    eventBus as any,
    paginationHelper as any,
    ptAccess as any,
    medicalHistoryRepo as any,
    trainerRepo as any,
    employeeRepo as any,
    notificationService as any,
  );

  return {
    service,
    sessionRepo,
    planRepo,
    memberRepo,
    eventBus,
    ptAccess,
    medicalHistoryRepo,
    trainerRepo,
    employeeRepo,
    notificationService,
  };
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

    it('rejects trainer without active PT from starting a session', async () => {
      const { service, sessionRepo, ptAccess } = buildService();
      (ptAccess!.assertTrainerCanWrite as ReturnType<typeof vi.fn>).mockRejectedValue(
        new BusinessRuleError('Read-only'),
      );

      await expect(
        service.start({ member_id: 30 }, trainerActor),
      ).rejects.toThrow(BusinessRuleError);

      expect(sessionRepo.insertSession).not.toHaveBeenCalled();
    });

    it('calls assertTrainerCanWrite with the actor and member_id when a trainer starts a session', async () => {
      const { service, sessionRepo, ptAccess } = buildService();

      sessionRepo.insertSession.mockResolvedValue({
        id: 50,
        member_id: 30,
        workout_plan_id: null,
        workout_plan_version_id: null,
        trainer_id: 20,
        started_at: new Date(),
        completed_at: null,
        total_volume_kg: '0.00',
      });

      await service.start({ member_id: 30 }, trainerActor);

      expect(ptAccess!.assertTrainerCanWrite).toHaveBeenCalledWith(trainerActor, 30);
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

    it('logs timed duration set with RIR and exercise notes (PTF-13)', async () => {
      const { service, sessionRepo } = buildService();

      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: null,
      });
      sessionRepo.insertSessionExercise.mockResolvedValue({
        id: 502,
        workout_session_id: 50,
        exercise_id: 2,
        set_number: 1,
        reps_completed: 0,
        weight_lifted_kg: '0.00',
        rpe_score: null,
        actual_rir: '2.0',
        actual_duration_seconds: 60,
        is_completed: true,
        notes: 'Plank hold, good core tension',
      });

      const set = await service.logSet(
        50,
        {
          exercise_id: 2,
          set_number: 1,
          reps_completed: 0,
          weight_lifted_kg: 0,
          actual_rir: 2,
          actual_duration_seconds: 60,
          notes: 'Plank hold, good core tension',
          is_completed: true,
        },
        memberActor,
      );

      expect(sessionRepo.insertSessionExercise).toHaveBeenCalledWith(
        expect.objectContaining({
          workout_session_id: 50,
          exercise_id: 2,
          set_number: 1,
          reps_completed: 0,
          weight_lifted_kg: '0',
          actual_rir: '2',
          actual_duration_seconds: 60,
          notes: 'Plank hold, good core tension',
          is_completed: true,
        }),
      );
      expect(set.id).toBe(502);
    });

    it('falls back to target_rir and target_duration_seconds when actuals are omitted (PTF-13)', async () => {
      const { service, sessionRepo } = buildService();

      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: null,
      });
      sessionRepo.insertSessionExercise.mockResolvedValue({
        id: 503,
        workout_session_id: 50,
        exercise_id: 3,
        set_number: 1,
        reps_completed: 10,
        weight_lifted_kg: '40.00',
        actual_rir: '1.5',
        actual_duration_seconds: 45,
        is_completed: true,
      });

      await service.logSet(
        50,
        {
          exercise_id: 3,
          set_number: 1,
          reps_completed: 10,
          weight_lifted_kg: 40,
          target_rir: 1.5,
          target_duration_seconds: 45,
          is_completed: true,
        },
        memberActor,
      );

      expect(sessionRepo.insertSessionExercise).toHaveBeenCalledWith(
        expect.objectContaining({
          actual_rir: '1.5',
          actual_duration_seconds: 45,
        }),
      );
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

    it('rejects trainer without active PT from logging a set', async () => {
      const { service, sessionRepo, ptAccess } = buildService();

      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: null,
      });
      (ptAccess!.assertTrainerCanWrite as ReturnType<typeof vi.fn>).mockRejectedValue(
        new BusinessRuleError('Read-only'),
      );

      await expect(
        service.logSet(
          50,
          {
            exercise_id: 1,
            set_number: 1,
            reps_completed: 10,
            weight_lifted_kg: 60,
            is_completed: true,
          },
          trainerActor,
        ),
      ).rejects.toThrow(BusinessRuleError);

      expect(sessionRepo.insertSessionExercise).not.toHaveBeenCalled();
    });

    it('calls assertTrainerCanWrite with the actor and session member_id when a trainer logs a set', async () => {
      const { service, sessionRepo, ptAccess } = buildService();

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
        rpe_score: null,
        is_completed: true,
      });

      await service.logSet(
        50,
        {
          exercise_id: 1,
          set_number: 1,
          reps_completed: 10,
          weight_lifted_kg: 60,
          is_completed: true,
        },
        trainerActor,
      );

      expect(ptAccess!.assertTrainerCanWrite).toHaveBeenCalledWith(trainerActor, 30);
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
        expect.objectContaining({
          client_signed_at: expect.any(Date),
        }),
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

    it('rejects trainer without active PT from completing a session', async () => {
      const { service, sessionRepo, ptAccess } = buildService();

      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        started_at: new Date(),
        completed_at: null,
      });
      (ptAccess!.assertTrainerCanWrite as ReturnType<typeof vi.fn>).mockRejectedValue(
        new BusinessRuleError('Read-only'),
      );

      await expect(
        service.complete(50, {}, trainerActor),
      ).rejects.toThrow(BusinessRuleError);

      expect(sessionRepo.completeSession).not.toHaveBeenCalled();
    });

    it('calls assertTrainerCanWrite with the actor and session member_id when a trainer completes a session', async () => {
      const { service, sessionRepo, ptAccess } = buildService();

      const startTime = new Date(Date.now() - 10 * 60 * 1000);
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
          total_volume_kg: '0.00',
          sets: [],
        });

      await service.complete(50, {}, trainerActor);

      expect(ptAccess!.assertTrainerCanWrite).toHaveBeenCalledWith(trainerActor, 30);
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

  describe('active session lookup', () => {
    it('getActive returns session with sets for member\'s own profile', async () => {
      const { service, sessionRepo } = buildService();

      sessionRepo.findActiveSessionForMember.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: null,
      });
      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: null,
        sets: [{ id: 501, set_number: 1 }],
      });

      // member_id arg is ignored for member actors; own profile used instead.
      const session = await service.getActive(999, memberActor);

      expect(sessionRepo.findActiveSessionForMember).toHaveBeenCalledWith(30);
      expect(sessionRepo.findSessionById).toHaveBeenCalledWith(50);
      expect(session.id).toBe(50);
      expect(session.sets).toHaveLength(1);
    });

    it('getActive 404s when none', async () => {
      const { service } = buildService();

      await expect(service.getActive(30, memberActor)).rejects.toThrow(NotFoundError);
    });

    it('getActive lets assigned trainer read even without active PT', async () => {
      const { service, sessionRepo, ptAccess } = buildService();

      sessionRepo.findActiveSessionForMember.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: null,
      });
      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: null,
        sets: [],
      });

      const session = await service.getActive(30, trainerActor);

      expect(session.id).toBe(50);
      expect(ptAccess!.assertTrainerCanWrite).not.toHaveBeenCalled();
    });
  });

  describe('set edit and delete', () => {
    it('updateSet updates reps/weight and returns row', async () => {
      const { service, sessionRepo } = buildService();

      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: null,
      });
      sessionRepo.findSetInSession.mockResolvedValue({
        id: 501,
        workout_session_id: 50,
        reps_completed: 10,
        weight_lifted_kg: '60.00',
      });
      sessionRepo.updateSessionExercise.mockResolvedValue({
        id: 501,
        workout_session_id: 50,
        reps_completed: 12,
        weight_lifted_kg: '65.00',
      });

      const updated = await service.updateSet(
        50,
        501,
        { reps_completed: 12, weight_lifted_kg: 65 },
        memberActor,
      );

      expect(sessionRepo.findSetInSession).toHaveBeenCalledWith(50, 501);
      expect(sessionRepo.updateSessionExercise).toHaveBeenCalledWith(
        501,
        expect.objectContaining({ reps_completed: 12, weight_lifted_kg: '65' }),
      );
      expect(updated.reps_completed).toBe(12);
    });

    it('updateSet updates RIR, timed duration, and notes (PTF-13)', async () => {
      const { service, sessionRepo } = buildService();

      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: null,
      });
      sessionRepo.findSetInSession.mockResolvedValue({
        id: 501,
        workout_session_id: 50,
        reps_completed: 10,
        actual_rir: '3.0',
        actual_duration_seconds: 30,
        notes: null,
      });
      sessionRepo.updateSessionExercise.mockResolvedValue({
        id: 501,
        workout_session_id: 50,
        reps_completed: 10,
        actual_rir: '1.0',
        actual_duration_seconds: 45,
        notes: 'Pushed closer to failure',
      });

      const updated = await service.updateSet(
        50,
        501,
        {
          actual_rir: 1,
          actual_duration_seconds: 45,
          notes: 'Pushed closer to failure',
        },
        memberActor,
      );

      expect(sessionRepo.updateSessionExercise).toHaveBeenCalledWith(
        501,
        expect.objectContaining({
          actual_rir: '1',
          actual_duration_seconds: 45,
          notes: 'Pushed closer to failure',
        }),
      );
      expect(updated.actual_duration_seconds).toBe(45);
    });

    it('updateSet 404s when set belongs to another session', async () => {
      const { service, sessionRepo } = buildService();

      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: null,
      });
      sessionRepo.findSetInSession.mockResolvedValue(null);

      await expect(
        service.updateSet(50, 999, { reps_completed: 1 }, memberActor),
      ).rejects.toThrow(NotFoundError);
      expect(sessionRepo.updateSessionExercise).not.toHaveBeenCalled();
    });

    it('updateSet rejects trainer without active PT', async () => {
      const { service, sessionRepo, ptAccess } = buildService();

      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: null,
      });
      (ptAccess!.assertTrainerCanWrite as ReturnType<typeof vi.fn>).mockRejectedValue(
        new BusinessRuleError('Read-only'),
      );

      await expect(
        service.updateSet(50, 501, { reps_completed: 12 }, trainerActor),
      ).rejects.toThrow(BusinessRuleError);
      expect(sessionRepo.findSetInSession).not.toHaveBeenCalled();
      expect(sessionRepo.updateSessionExercise).not.toHaveBeenCalled();
    });

    it('deleteSet rejects completed session', async () => {
      const { service, sessionRepo } = buildService();

      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: new Date(),
      });

      await expect(service.deleteSet(50, 501, memberActor)).rejects.toThrow(
        BusinessRuleError,
      );
      expect(sessionRepo.deleteSessionExercise).not.toHaveBeenCalled();
    });

    it('updateSet updates notes', async () => {
      const { service, sessionRepo } = buildService();

      sessionRepo.findSessionById.mockResolvedValue({
        id: 50,
        member_id: 30,
        completed_at: null,
      });
      sessionRepo.findSetInSession.mockResolvedValue({
        id: 501,
        workout_session_id: 50,
        exercise_id: 1,
        set_number: 1,
      });
      sessionRepo.updateSessionExercise.mockResolvedValue({
        id: 501,
        notes: 'Adjusted foot placement',
      });

      const updated = await service.updateSet(
        50,
        501,
        { notes: 'Adjusted foot placement' },
        memberActor,
      );

      expect(sessionRepo.updateSessionExercise).toHaveBeenCalledWith(
        501,
        expect.objectContaining({ notes: 'Adjusted foot placement' }),
      );
      expect(updated.notes).toBe('Adjusted foot placement');
    });
  });

  describe('exercise history query', () => {
    it('returns recent session performance for an exercise for member', async () => {
      const { service, sessionRepo } = buildService();
      sessionRepo.findExerciseHistory.mockResolvedValue([
        {
          session_id: 48,
          started_at: new Date('2026-10-09T07:00:00Z'),
          completed_at: new Date('2026-10-09T07:50:00Z'),
          sets: [{ id: 481, set_number: 1, reps_completed: 10, weight_lifted_kg: '60.00' }],
        },
      ]);

      const history = await service.getExerciseHistory(undefined, 1, memberActor);

      expect(sessionRepo.findExerciseHistory).toHaveBeenCalledWith(30, 1);
      expect(history).toHaveLength(1);
      expect(history[0].session_id).toBe(48);
    });

    it('allows assigned trainer to query exercise history for member', async () => {
      const { service, sessionRepo } = buildService();
      sessionRepo.findExerciseHistory.mockResolvedValue([]);

      await service.getExerciseHistory(30, 1, trainerActor);

      expect(sessionRepo.findExerciseHistory).toHaveBeenCalledWith(30, 1);
    });

    it('rejects trainer query when member_id is missing', async () => {
      const { service } = buildService();

      await expect(
        service.getExerciseHistory(undefined, 1, trainerActor),
      ).rejects.toThrow(BadRequestError);
    });
  });

  describe('workoutSetWriteSchema & workoutSetUpdateSchema (PTF-13)', () => {
    it('validates a set with reps, duration, and RIR', () => {
      const parsed = workoutSetWriteSchema.parse({
        exercise_id: 1,
        set_number: 1,
        reps_completed: 12,
        weight_lifted_kg: 50,
        actual_rir: 2.5,
        actual_duration_seconds: 40,
        notes: 'Smooth form',
      });

      expect(parsed.actual_rir).toBe(2.5);
      expect(parsed.actual_duration_seconds).toBe(40);
      expect(parsed.notes).toBe('Smooth form');
    });

    it('allows 0 RIR (reps to failure) and 0 duration', () => {
      const parsed = workoutSetWriteSchema.parse({
        exercise_id: 1,
        set_number: 1,
        actual_rir: 0,
        actual_duration_seconds: 0,
      });

      expect(parsed.actual_rir).toBe(0);
      expect(parsed.actual_duration_seconds).toBe(0);
    });

    it('rejects RIR > 10 or negative duration', () => {
      expect(() =>
        workoutSetWriteSchema.parse({
          exercise_id: 1,
          set_number: 1,
          actual_rir: 11,
        }),
      ).toThrow();

      expect(() =>
        workoutSetWriteSchema.parse({
          exercise_id: 1,
          set_number: 1,
          actual_duration_seconds: -5,
        }),
      ).toThrow();
    });

    it('validates partial update schema with timed duration or RIR', () => {
      const parsed = workoutSetUpdateSchema.parse({
        actual_rir: 1,
        actual_duration_seconds: 60,
      });

      expect(parsed.actual_rir).toBe(1);
      expect(parsed.actual_duration_seconds).toBe(60);
    });

    it('rejects empty object in workoutSetUpdateSchema', () => {
      expect(() => workoutSetUpdateSchema.parse({})).toThrow();
    });
  });

  describe('workoutSessionCompleteSchema (PTF-14)', () => {
    it('validates a complete payload with ratings, pain, notes, and next session plan', () => {
      const parsed = workoutSessionCompleteSchema.parse({
        effort_rating: 8,
        satisfaction_rating: 9,
        pain_discomfort_score: 2,
        pain_notes: 'Mild right shoulder fatigue',
        next_session_plan: 'Warm up rotator cuff with band pull-aparts',
        trainer_notes: 'Good form on top sets',
        session_focus: 'Upper Body Hypertrophy',
        client_signed: true,
        trainer_signed: true,
      });

      expect(parsed.effort_rating).toBe(8);
      expect(parsed.satisfaction_rating).toBe(9);
      expect(parsed.pain_discomfort_score).toBe(2);
      expect(parsed.pain_notes).toBe('Mild right shoulder fatigue');
      expect(parsed.next_session_plan).toBe('Warm up rotator cuff with band pull-aparts');
      expect(parsed.trainer_notes).toBe('Good form on top sets');
      expect(parsed.session_focus).toBe('Upper Body Hypertrophy');
      expect(parsed.client_signed).toBe(true);
      expect(parsed.trainer_signed).toBe(true);
    });

    it('accepts boundary ratings: effort=1, effort=10, satisfaction=1, satisfaction=10, pain=0, pain=10', () => {
      const minRatings = workoutSessionCompleteSchema.parse({
        effort_rating: 1,
        satisfaction_rating: 1,
        pain_discomfort_score: 0,
      });
      expect(minRatings.effort_rating).toBe(1);
      expect(minRatings.satisfaction_rating).toBe(1);
      expect(minRatings.pain_discomfort_score).toBe(0);

      const maxRatings = workoutSessionCompleteSchema.parse({
        effort_rating: 10,
        satisfaction_rating: 10,
        pain_discomfort_score: 10,
      });
      expect(maxRatings.effort_rating).toBe(10);
      expect(maxRatings.satisfaction_rating).toBe(10);
      expect(maxRatings.pain_discomfort_score).toBe(10);
    });

    it('rejects out-of-range effort, satisfaction, and pain scores', () => {
      expect(() => workoutSessionCompleteSchema.parse({ effort_rating: 0 })).toThrow();
      expect(() => workoutSessionCompleteSchema.parse({ effort_rating: 11 })).toThrow();
      expect(() => workoutSessionCompleteSchema.parse({ satisfaction_rating: 0 })).toThrow();
      expect(() => workoutSessionCompleteSchema.parse({ satisfaction_rating: 11 })).toThrow();
      expect(() => workoutSessionCompleteSchema.parse({ pain_discomfort_score: -1 })).toThrow();
      expect(() => workoutSessionCompleteSchema.parse({ pain_discomfort_score: 11 })).toThrow();
    });

    it('allows null and undefined for optional fields', () => {
      const parsed = workoutSessionCompleteSchema.parse({
        effort_rating: null,
        satisfaction_rating: null,
        pain_discomfort_score: null,
        pain_notes: null,
        trainer_notes: null,
      });
      expect(parsed.effort_rating).toBeNull();
      expect(parsed.pain_discomfort_score).toBeNull();
    });
  });

  describe('multi-metric session completion and sign-offs (PTF-14)', () => {
    it('persists all multi-metric rating dimensions and next session plan', async () => {
      const { service, sessionRepo, eventBus } = buildService();

      const startTime = new Date(Date.now() - 60 * 60 * 1000);
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
          effort_rating: 8,
          satisfaction_rating: 9,
          pain_discomfort_score: 3,
          pain_notes: 'Right hamstring tight during Romanian deadlifts',
          next_session_plan: 'Substitute with seated leg curls and foam rolling',
          trainer_notes: 'Pushed through high intensity sets cleanly',
          client_signed_at: new Date(),
          trainer_signed_at: null,
          total_volume_kg: '2400.00',
          duration_minutes: 60,
          sets: [],
        });

      sessionRepo.findSetsBySessionId.mockResolvedValue([
        { reps_completed: 8, weight_lifted_kg: '100.00', is_completed: true },
        { reps_completed: 8, weight_lifted_kg: '100.00', is_completed: true },
        { reps_completed: 8, weight_lifted_kg: '100.00', is_completed: true },
      ]);

      const result = await service.complete(
        50,
        {
          effort_rating: 8,
          satisfaction_rating: 9,
          pain_discomfort_score: 3,
          pain_notes: 'Right hamstring tight during Romanian deadlifts',
          next_session_plan: 'Substitute with seated leg curls and foam rolling',
          trainer_notes: 'Pushed through high intensity sets cleanly',
        },
        memberActor,
      );

      expect(sessionRepo.completeSession).toHaveBeenCalledWith(
        50,
        expect.any(Date),
        '2400.00',
        expect.any(Number),
        undefined,
        undefined,
        expect.objectContaining({
          effort_rating: 8,
          satisfaction_rating: 9,
          pain_discomfort_score: 3,
          pain_notes: 'Right hamstring tight during Romanian deadlifts',
          next_session_plan: 'Substitute with seated leg curls and foam rolling',
          trainer_notes: 'Pushed through high intensity sets cleanly',
          client_signed_at: expect.any(Date),
          trainer_signed_at: null,
        }),
      );

      expect(eventBus.emitSync).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'workout_session.completed',
          payload: expect.objectContaining({
            session_id: 50,
            effort_rating: 8,
            satisfaction_rating: 9,
            pain_discomfort_score: 3,
          }),
        }),
      );

      expect(result.effort_rating).toBe(8);
      expect(result.pain_discomfort_score).toBe(3);
    });

    it('timestamps trainer_signed_at when completed by trainer', async () => {
      const { service, sessionRepo } = buildService();

      const startTime = new Date(Date.now() - 30 * 60 * 1000);
      sessionRepo.findSessionById
        .mockResolvedValueOnce({
          id: 50,
          member_id: 30,
          trainer_id: 20,
          started_at: startTime,
          completed_at: null,
        })
        .mockResolvedValueOnce({
          id: 50,
          member_id: 30,
          trainer_id: 20,
          started_at: startTime,
          completed_at: new Date(),
          trainer_signed_at: new Date(),
          sets: [],
        });

      await service.complete(
        50,
        {
          effort_rating: 7,
          satisfaction_rating: 8,
          pain_discomfort_score: 0,
        },
        trainerActor,
      );

      expect(sessionRepo.completeSession).toHaveBeenCalledWith(
        50,
        expect.any(Date),
        '0.00',
        expect.any(Number),
        undefined,
        undefined,
        expect.objectContaining({
          trainer_signed_at: expect.any(Date),
          client_signed_at: null,
          pain_discomfort_score: 0,
        }),
      );
    });

    it('timestamps both client and trainer signatures when dual sign-offs are provided', async () => {
      const { service, sessionRepo } = buildService();

      const startTime = new Date(Date.now() - 40 * 60 * 1000);
      sessionRepo.findSessionById
        .mockResolvedValueOnce({
          id: 50,
          member_id: 30,
          trainer_id: 20,
          started_at: startTime,
          completed_at: null,
        })
        .mockResolvedValueOnce({
          id: 50,
          member_id: 30,
          trainer_id: 20,
          started_at: startTime,
          completed_at: new Date(),
          client_signed_at: new Date(),
          trainer_signed_at: new Date(),
          sets: [],
        });

      await service.complete(
        50,
        {
          effort_rating: 9,
          satisfaction_rating: 10,
          pain_discomfort_score: 0,
          client_signed: true,
          trainer_signed: true,
        },
        trainerActor,
      );

      expect(sessionRepo.completeSession).toHaveBeenCalledWith(
        50,
        expect.any(Date),
        '0.00',
        expect.any(Number),
        undefined,
        undefined,
        expect.objectContaining({
          client_signed_at: expect.any(Date),
          trainer_signed_at: expect.any(Date),
        }),
      );
    });

    it('preserves explicit client_signed_at and trainer_signed_at dates if passed', async () => {
      const { service, sessionRepo } = buildService();

      const startTime = new Date(Date.now() - 40 * 60 * 1000);
      const explicitClientSign = new Date('2026-10-16T10:30:00.000Z');
      const explicitTrainerSign = new Date('2026-10-16T10:35:00.000Z');

      sessionRepo.findSessionById
        .mockResolvedValueOnce({
          id: 50,
          member_id: 30,
          trainer_id: 20,
          started_at: startTime,
          completed_at: null,
        })
        .mockResolvedValueOnce({
          id: 50,
          member_id: 30,
          trainer_id: 20,
          started_at: startTime,
          completed_at: new Date(),
          client_signed_at: explicitClientSign,
          trainer_signed_at: explicitTrainerSign,
          sets: [],
        });

      await service.complete(
        50,
        {
          effort_rating: 8,
          satisfaction_rating: 8,
          client_signed_at: explicitClientSign,
          trainer_signed_at: explicitTrainerSign,
        },
        memberActor,
      );

      expect(sessionRepo.completeSession).toHaveBeenCalledWith(
        50,
        expect.any(Date),
        '0.00',
        expect.any(Number),
        undefined,
        undefined,
        expect.objectContaining({
          client_signed_at: explicitClientSign,
          trainer_signed_at: explicitTrainerSign,
        }),
      );
    });
  });
});

