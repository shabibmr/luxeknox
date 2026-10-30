import { describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import {
  BadRequestError,
  BusinessRuleError,
  ConflictError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { WorkoutPlanService } from './workout-plan.service';
import {
  workoutPlanCreateSchema,
  workoutPlanExercisesWriteSchema,
  workoutPlanUpdateSchema,
} from './workout-plan.dto';

const adminActor: AuthenticatedUser = {
  id: 1,
  email: 'admin@example.com',
  phoneNumber: null,
  roleId: 1,
  userType: 'admin',
  profileId: null,
  sessionId: 1,
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

function buildService(overrides: {
  planRepo?: Partial<Record<string, unknown>>;
  memberRepo?: Partial<Record<string, unknown>>;
  eventBus?: Partial<Record<string, unknown>>;
  ptAccess?: Partial<Record<string, unknown>> | null;
} = {}) {
  const db = {
    transaction: vi.fn(async (cb: (tx: any) => Promise<any>) => cb({})),
  };

  const planRepo = {
    findPlans: vi.fn().mockResolvedValue({ rows: [], total: 0 }),
    findPlanById: vi.fn(),
    findActivePlanForMember: vi.fn().mockResolvedValue(null),
    insertPlan: vi.fn(),
    updatePlan: vi.fn(),
    insertVersion: vi.fn(),
    findLatestVersionByPlanId: vi.fn(),
    findVersionsByPlanId: vi.fn().mockResolvedValue({ rows: [], total: 0 }),
    insertPlanExercises: vi.fn().mockResolvedValue(undefined),
    findExercisesByVersionId: vi.fn().mockResolvedValue([]),
    ...overrides.planRepo,
  };

  const memberRepo = {
    findById: vi.fn().mockImplementation(async (id: number) => {
      if (id === 30) {
        return { id: 30, user_id: 3, assigned_trainer_id: 20 };
      }
      if (id === 40) {
        return { id: 40, user_id: 4, assigned_trainer_id: 99 };
      }
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

  const service = new WorkoutPlanService(
    db as any,
    planRepo as any,
    memberRepo as any,
    eventBus as any,
    paginationHelper as any,
    ptAccess as any,
  );

  return { service, planRepo, memberRepo, eventBus, ptAccess };
}

describe('WorkoutPlanService', () => {
  describe('create', () => {
    it('creates a workout plan and automatically creates version 1', async () => {
      const { service, planRepo, eventBus } = buildService();

      planRepo.insertPlan.mockResolvedValue({
        id: 10,
        title: 'Hypertrophy Phase 1',
        description: '4-day split',
        member_id: 30,
        trainer_id: 20,
        target_goal: 'muscle_gain',
        difficulty: 'intermediate',
        duration_weeks: 8,
        is_template: false,
        status: 'draft',
        row_version: 1,
        created_at: new Date(),
      });

      planRepo.insertVersion.mockResolvedValue({
        id: 101,
        workout_plan_id: 10,
        version_number: 1,
        changelog: 'Initial draft version',
        created_at: new Date(),
      });

      const result = await service.create(
        {
          title: 'Hypertrophy Phase 1',
          description: '4-day split',
          member_id: 30,
          target_goal: 'muscle_gain',
          difficulty: 'intermediate',
          duration_weeks: 8,
        },
        trainerActor,
      );

      expect(planRepo.insertPlan).toHaveBeenCalledWith(
        expect.objectContaining({
          title: 'Hypertrophy Phase 1',
          member_id: 30,
          trainer_id: 20,
          status: 'draft',
          row_version: 1,
        }),
      );
      expect(planRepo.insertVersion).toHaveBeenCalledWith(
        expect.objectContaining({
          workout_plan_id: 10,
          version_number: 1,
        }),
      );
      expect(result.current_version?.version_number).toBe(1);
      expect(eventBus.emitSync).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'workout_plan.created',
          payload: expect.objectContaining({ plan_id: 10 }),
        }),
      );
    });

    it('rejects a member attempting to create a template', async () => {
      const { service } = buildService();

      await expect(
        service.create(
          {
            title: 'Master Template',
            is_template: true,
          },
          memberActor,
        ),
      ).rejects.toThrow(ForbiddenError);
    });

    it('rejects a trainer creating a plan for an unassigned member', async () => {
      const { service } = buildService();

      await expect(
        service.create(
          {
            title: 'Unassigned Plan',
            member_id: 40, // assigned to trainer 99, not 20
          },
          trainerActor,
        ),
      ).rejects.toThrow(NotFoundError);
    });
  });

  describe('publish and active plan uniqueness (WRK-007, WRK-008)', () => {
    it('publishes a draft plan to active status', async () => {
      const { service, planRepo, eventBus } = buildService();

      planRepo.findPlanById
        .mockResolvedValueOnce({
          id: 10,
          member_id: 30,
          trainer_id: 20,
          status: 'draft',
          is_template: false,
        })
        .mockResolvedValueOnce({
          id: 10,
          member_id: 30,
          trainer_id: 20,
          status: 'active',
          is_template: false,
        });

      const published = await service.publish(10, trainerActor);

      expect(planRepo.updatePlan).toHaveBeenCalledWith(10, { status: 'active' });
      expect(published.status).toBe('active');
      expect(eventBus.emitSync).toHaveBeenCalledWith(
        expect.objectContaining({ eventName: 'workout_plan.published' }),
      );
    });

    it('enforces one active assigned plan per member (WRK-008)', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById.mockResolvedValue({
        id: 10,
        member_id: 30,
        trainer_id: 20,
        status: 'draft',
        is_template: false,
      });

      // Member already has an active plan (plan ID 9)
      planRepo.findActivePlanForMember.mockResolvedValue({
        id: 9,
        member_id: 30,
        status: 'active',
      });

      await expect(service.publish(10, trainerActor)).rejects.toThrow(ConflictError);
    });

    it('rejects publishing an archived workout plan', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById.mockResolvedValue({
        id: 10,
        member_id: 30,
        status: 'archived',
        is_template: false,
      });

      await expect(service.publish(10, trainerActor)).rejects.toThrow(BusinessRuleError);
    });
  });

  describe('template copy-on-assign (WRK-005, WRK-006)', () => {
    it('copies template metadata and version exercises into a new active member plan', async () => {
      const { service, planRepo, eventBus } = buildService();

      const template = {
        id: 5,
        title: 'Beginner Full Body',
        description: '3 days a week foundation',
        is_template: true,
        target_goal: 'strength',
        difficulty: 'beginner',
        duration_weeks: 4,
        status: 'active',
        current_version: {
          id: 50,
          version_number: 1,
          exercises: [
            {
              id: 501,
              workout_plan_version_id: 50,
              exercise_id: 1,
              day_number: 1,
              order_index: 0,
              target_sets: 3,
              target_reps: '10',
              target_weight_kg: '50.00',
              rest_seconds: 60,
              rest_between_exercises_seconds: 90,
              notes: 'Focus on form',
            },
          ],
        },
      };

      planRepo.findPlanById
        .mockResolvedValueOnce(template) // template lookup
        .mockResolvedValueOnce({ // new plan lookup after assign
          id: 12,
          title: 'Beginner Full Body',
          member_id: 30,
          trainer_id: 20,
          is_template: false,
          status: 'active',
          current_version: {
            id: 120,
            version_number: 1,
            exercises: template.current_version.exercises,
          },
        });

      planRepo.insertPlan.mockResolvedValue({ id: 12 });
      planRepo.insertVersion.mockResolvedValue({ id: 120 });

      const assigned = await service.assign(5, { member_id: 30 }, trainerActor);

      expect(planRepo.insertPlan).toHaveBeenCalledWith(
        expect.objectContaining({
          title: 'Beginner Full Body',
          member_id: 30,
          trainer_id: 20,
          is_template: false,
          status: 'active',
        }),
      );

      expect(planRepo.insertPlanExercises).toHaveBeenCalledWith(
        expect.arrayContaining([
          expect.objectContaining({
            workout_plan_version_id: 120,
            exercise_id: 1,
            day_number: 1,
            order_index: 0,
            rest_between_exercises_seconds: 90,
          }),
        ]),
      );

      expect(assigned.member_id).toBe(30);
      expect(eventBus.emitSync).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'workout_plan.assigned',
          payload: expect.objectContaining({
            plan_id: 12,
            template_id: 5,
            member_id: 30,
          }),
        }),
      );
    });

    it('rejects copy-on-assign if member already has an active plan', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById.mockResolvedValue({
        id: 5,
        title: 'Template',
        is_template: true,
      });

      planRepo.findActivePlanForMember.mockResolvedValue({
        id: 8,
        member_id: 30,
        status: 'active',
      });

      await expect(service.assign(5, { member_id: 30 }, trainerActor)).rejects.toThrow(
        ConflictError,
      );
    });
  });

  describe('version snapshot correctness (WRK-009, WRK-010, WRK-017)', () => {
    it('creates a new version snapshot on exercise edit without mutating previous version', async () => {
      const { service, planRepo, eventBus } = buildService();

      const existingPlan = {
        id: 15,
        title: 'Strength Block',
        member_id: 30,
        trainer_id: 20,
        status: 'active',
        row_version: 2,
        is_template: false,
      };

      planRepo.findPlanById
        .mockResolvedValueOnce(existingPlan) // initial check
        .mockResolvedValueOnce({ // refreshed plan after update
          ...existingPlan,
          row_version: 3,
          current_version: {
            id: 152,
            version_number: 2,
            changelog: 'Added deadlifts',
            exercises: [
              {
                id: 999,
                workout_plan_version_id: 152,
                exercise_id: 2,
                day_number: 1,
                order_index: 0,
                target_sets: 4,
                target_reps: '5',
                target_weight_kg: '100.00',
                rest_seconds: 120,
              },
            ],
          },
        });

      // Existing latest version is version 1
      planRepo.findLatestVersionByPlanId.mockResolvedValue({
        id: 151,
        workout_plan_id: 15,
        version_number: 1,
      });

      planRepo.insertVersion.mockResolvedValue({
        id: 152,
        workout_plan_id: 15,
        version_number: 2,
        changelog: 'Added deadlifts',
        created_at: new Date(),
      });

      const result = await service.replaceExercises(
        15,
        {
          changelog: 'Added deadlifts',
          row_version: 2,
          exercises: [
            {
              exercise_id: 2,
              day_number: 1,
              order_index: 0,
              target_sets: 4,
              target_reps: '5',
              target_weight_kg: 100,
              rest_seconds: 120,
              rest_between_exercises_seconds: 180,
            },
          ],
        },
        trainerActor,
      );

      // Verifies row_version concurrency guard was passed
      expect(planRepo.updatePlan).toHaveBeenCalledWith(15, {}, 2);

      // Verifies new version row was created with incremented version_number 2
      expect(planRepo.insertVersion).toHaveBeenCalledWith(
        expect.objectContaining({
          workout_plan_id: 15,
          version_number: 2,
          changelog: 'Added deadlifts',
        }),
      );

      // Verifies new exercises are associated with the new version (152), not the old version (151)
      expect(planRepo.insertPlanExercises).toHaveBeenCalledWith([
        expect.objectContaining({
          workout_plan_version_id: 152,
          exercise_id: 2,
          target_sets: 4,
          rest_between_exercises_seconds: 180,
        }),
      ]);

      expect(result.current_version?.version_number).toBe(2);
      expect(eventBus.emitSync).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'workout_plan.version_created',
          payload: expect.objectContaining({
            plan_id: 15,
            version_number: 2,
          }),
        }),
      );
    });

    it('rejects modifying exercises of an archived plan', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById.mockResolvedValue({
        id: 15,
        status: 'archived',
        trainer_id: 20,
      });

      await expect(
        service.replaceExercises(
          15,
          {
            exercises: [],
          },
          trainerActor,
        ),
      ).rejects.toThrow(BusinessRuleError);
    });
  });

  describe('row-scope and access (WRK-004, WRK-011)', () => {
    it('allows a member to view their own plan', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById.mockResolvedValue({
        id: 20,
        member_id: 30,
        is_template: false,
      });

      const plan = await service.getById(20, memberActor);
      expect(plan.id).toBe(20);
    });

    it('denies a member from viewing another member plan', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById.mockResolvedValue({
        id: 20,
        member_id: 30,
        is_template: false,
      });

      await expect(service.getById(20, otherMemberActor)).rejects.toThrow(NotFoundError);
    });

    it('allows anyone to view a template plan', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById.mockResolvedValue({
        id: 100,
        is_template: true,
      });

      const template = await service.getById(100, memberActor);
      expect(template.id).toBe(100);
    });

    it('rejects an unassigned trainer attempting to update another trainer member plan', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById.mockResolvedValue({
        id: 20,
        member_id: 40, // assigned to trainer 99
        trainer_id: 99,
        is_template: false,
        status: 'draft',
      });

      await expect(
        service.update(20, { title: 'Unauthorized update' }, trainerActor),
      ).rejects.toThrow(NotFoundError);
    });

    it('rejects an unassigned trainer attempting to publish another trainer member plan', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById.mockResolvedValue({
        id: 20,
        member_id: 40, // assigned to trainer 99
        trainer_id: 99,
        is_template: false,
        status: 'draft',
      });

      await expect(service.publish(20, trainerActor)).rejects.toThrow(NotFoundError);
    });

    it('rejects an unassigned trainer attempting to archive another trainer member plan', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById.mockResolvedValue({
        id: 20,
        member_id: 40, // assigned to trainer 99
        trainer_id: 99,
        is_template: false,
        status: 'draft',
      });

      await expect(service.archive(20, trainerActor)).rejects.toThrow(NotFoundError);
    });

    it('rejects a member attempting to manage a workout plan', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById.mockResolvedValue({
        id: 20,
        member_id: 30,
        trainer_id: 20,
        is_template: false,
        status: 'draft',
      });

      await expect(
        service.update(20, { title: 'Unauthorized' }, memberActor),
      ).rejects.toThrow(ForbiddenError);
    });
  });

  describe('PT-gated write access (lapsed PT drops trainer to read-only)', () => {
    it('blocks create for a member when the trainer PT access check fails', async () => {
      const { service, planRepo, ptAccess } = buildService({
        ptAccess: {
          assertTrainerCanWrite: vi.fn().mockRejectedValue(new BusinessRuleError('Read-only')),
        },
      });

      await expect(
        service.create({ title: 'New Plan', member_id: 30 }, trainerActor),
      ).rejects.toThrow(BusinessRuleError);

      expect(ptAccess!.assertTrainerCanWrite).toHaveBeenCalledWith(trainerActor, 30);
      expect(planRepo.insertPlan).not.toHaveBeenCalled();
    });

    it('blocks update for a member plan when the trainer PT access check fails', async () => {
      const { service, planRepo, ptAccess } = buildService({
        ptAccess: {
          assertTrainerCanWrite: vi.fn().mockRejectedValue(new BusinessRuleError('Read-only')),
        },
      });

      planRepo.findPlanById.mockResolvedValue({
        id: 20,
        member_id: 30,
        trainer_id: 20,
        is_template: false,
        status: 'draft',
      });

      await expect(
        service.update(20, { member_id: 30, title: 'Edit' }, trainerActor),
      ).rejects.toThrow(BusinessRuleError);

      expect(ptAccess!.assertTrainerCanWrite).toHaveBeenCalledWith(trainerActor, 30);
      expect(planRepo.updatePlan).not.toHaveBeenCalled();
    });

    it('blocks assign to a member when the trainer PT access check fails', async () => {
      const { service, planRepo, ptAccess } = buildService({
        ptAccess: {
          assertTrainerCanWrite: vi.fn().mockRejectedValue(new BusinessRuleError('Read-only')),
        },
      });

      planRepo.findPlanById.mockResolvedValue({
        id: 5,
        title: 'Template',
        is_template: true,
      });

      await expect(
        service.assign(5, { member_id: 30 }, trainerActor),
      ).rejects.toThrow(BusinessRuleError);

      expect(ptAccess!.assertTrainerCanWrite).toHaveBeenCalledWith(trainerActor, 30);
    });

    it('blocks managing (e.g. publish) an existing member plan when the trainer PT access check fails', async () => {
      const { service, planRepo, ptAccess } = buildService({
        ptAccess: {
          assertTrainerCanWrite: vi.fn().mockRejectedValue(new BusinessRuleError('Read-only')),
        },
      });

      planRepo.findPlanById.mockResolvedValue({
        id: 20,
        member_id: 30,
        trainer_id: 20,
        is_template: false,
        status: 'draft',
      });

      await expect(service.publish(20, trainerActor)).rejects.toThrow(BusinessRuleError);

      expect(ptAccess!.assertTrainerCanWrite).toHaveBeenCalledWith(trainerActor, 30);
    });

    it('allows the write once PT access is restored (active subscription)', async () => {
      const { service, planRepo, ptAccess } = buildService();

      planRepo.insertPlan.mockResolvedValue({
        id: 10,
        title: 'Renewed Plan',
        member_id: 30,
        trainer_id: 20,
        is_template: false,
        status: 'draft',
        row_version: 1,
        created_at: new Date(),
      });
      planRepo.insertVersion.mockResolvedValue({
        id: 101,
        workout_plan_id: 10,
        version_number: 1,
        changelog: 'Initial draft version',
        created_at: new Date(),
      });

      await service.create({ title: 'Renewed Plan', member_id: 30 }, trainerActor);

      expect(ptAccess!.assertTrainerCanWrite).toHaveBeenCalledWith(trainerActor, 30);
      expect(planRepo.insertPlan).toHaveBeenCalled();
    });
  });

  describe('blueprint (PTF-12)', () => {
    const blueprintPayload = {
      primary_objective_12w: 'Squat 100kg',
      milestone_4w: 'Squat 80kg',
      sessions_per_week: 4,
      target_session_duration_minutes: 60,
      split_type: 'upper lower',
      cardio_protocol: 'Zone 2 20 min',
      mobility_protocol: 'hips daily',
      progression_methods: ['load', 'reps'] as const,
      main_success_measure: 'Squat load',
      trainer_programming_notes: 'pause reps',
    };

    it('create_persists_blueprint_fields', async () => {
      const { service, planRepo } = buildService();

      planRepo.insertPlan.mockResolvedValue({
        id: 10,
        title: 'Strength Block',
        ...blueprintPayload,
        status: 'draft',
        row_version: 1,
        created_at: new Date(),
      });
      planRepo.insertVersion.mockResolvedValue({
        id: 101,
        workout_plan_id: 10,
        version_number: 1,
        changelog: 'Initial draft version',
        created_at: new Date(),
      });

      await service.create(
        {
          title: 'Strength Block',
          ...blueprintPayload,
          progression_methods: [...blueprintPayload.progression_methods],
        },
        trainerActor,
      );

      expect(planRepo.insertPlan).toHaveBeenCalledWith(
        expect.objectContaining({
          primary_objective_12w: 'Squat 100kg',
          milestone_4w: 'Squat 80kg',
          sessions_per_week: 4,
          target_session_duration_minutes: 60,
          split_type: 'upper lower',
          cardio_protocol: 'Zone 2 20 min',
          mobility_protocol: 'hips daily',
          progression_methods: ['load', 'reps'],
          main_success_measure: 'Squat load',
          trainer_programming_notes: 'pause reps',
        }),
      );
    });

    it('create_omitted_blueprint_stores_null', async () => {
      const { service, planRepo } = buildService();

      planRepo.insertPlan.mockResolvedValue({
        id: 10,
        title: 'Bare Plan',
        status: 'draft',
        row_version: 1,
        created_at: new Date(),
      });
      planRepo.insertVersion.mockResolvedValue({
        id: 101,
        workout_plan_id: 10,
        version_number: 1,
        changelog: 'Initial draft version',
        created_at: new Date(),
      });

      await service.create({ title: 'Bare Plan' }, trainerActor);

      expect(planRepo.insertPlan).toHaveBeenCalledWith(
        expect.objectContaining({
          primary_objective_12w: null,
          milestone_4w: null,
          sessions_per_week: null,
          target_session_duration_minutes: null,
          split_type: null,
          cardio_protocol: null,
          mobility_protocol: null,
          progression_methods: null,
          main_success_measure: null,
          trainer_programming_notes: null,
        }),
      );
    });

    it('update_title_only_does_not_send_blueprint_keys', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById
        .mockResolvedValueOnce({
          id: 10,
          title: 'Old',
          member_id: 30,
          trainer_id: 20,
          status: 'draft',
          is_template: false,
          row_version: 1,
          primary_objective_12w: 'Keep me',
          progression_methods: ['load'],
        })
        .mockResolvedValueOnce({
          id: 10,
          title: 'Renamed',
          member_id: 30,
          trainer_id: 20,
          status: 'draft',
          is_template: false,
          row_version: 2,
          primary_objective_12w: 'Keep me',
          progression_methods: ['load'],
        });
      planRepo.updatePlan.mockResolvedValue({ id: 10 });

      await service.update(10, { title: 'Renamed', row_version: 1 }, trainerActor);

      const changes = planRepo.updatePlan.mock.calls[0][1] as Record<string, unknown>;
      expect(changes).toEqual(expect.objectContaining({ title: 'Renamed' }));
      expect(changes).not.toHaveProperty('primary_objective_12w');
      expect(changes).not.toHaveProperty('milestone_4w');
      expect(changes).not.toHaveProperty('sessions_per_week');
      expect(changes).not.toHaveProperty('target_session_duration_minutes');
      expect(changes).not.toHaveProperty('split_type');
      expect(changes).not.toHaveProperty('cardio_protocol');
      expect(changes).not.toHaveProperty('mobility_protocol');
      expect(changes).not.toHaveProperty('progression_methods');
      expect(changes).not.toHaveProperty('main_success_measure');
      expect(changes).not.toHaveProperty('trainer_programming_notes');
    });

    it('update_null_clears_objective', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById
        .mockResolvedValueOnce({
          id: 10,
          title: 'Plan',
          member_id: 30,
          trainer_id: 20,
          status: 'draft',
          is_template: false,
          row_version: 1,
          primary_objective_12w: 'Squat 100kg',
        })
        .mockResolvedValueOnce({
          id: 10,
          title: 'Plan',
          member_id: 30,
          trainer_id: 20,
          status: 'draft',
          is_template: false,
          row_version: 2,
          primary_objective_12w: null,
        });
      planRepo.updatePlan.mockResolvedValue({ id: 10 });

      await service.update(10, { primary_objective_12w: null, row_version: 1 }, trainerActor);

      const changes = planRepo.updatePlan.mock.calls[0][1] as Record<string, unknown>;
      expect(changes).toEqual(expect.objectContaining({ primary_objective_12w: null }));
    });

    it('assign_copies_blueprint_from_template', async () => {
      const { service, planRepo } = buildService();

      const template = {
        id: 5,
        title: 'Blueprint Template',
        description: null,
        is_template: true,
        target_goal: null,
        difficulty: null,
        duration_weeks: null,
        trainer_id: 20,
        status: 'active',
        ...blueprintPayload,
        progression_methods: [...blueprintPayload.progression_methods],
        current_version: { id: 50, version_number: 1, exercises: [] },
      };

      planRepo.findPlanById
        .mockResolvedValueOnce(template)
        .mockResolvedValueOnce({
          id: 12,
          title: 'Blueprint Template',
          member_id: 30,
          trainer_id: 20,
          is_template: false,
          status: 'active',
          current_version: { id: 120, version_number: 1, exercises: [] },
        });
      planRepo.insertPlan.mockResolvedValue({ id: 12 });
      planRepo.insertVersion.mockResolvedValue({ id: 120 });

      await service.assign(5, { member_id: 30 }, trainerActor);

      expect(planRepo.insertPlan).toHaveBeenCalledWith(
        expect.objectContaining({
          ...blueprintPayload,
          progression_methods: ['load', 'reps'],
          is_template: false,
          status: 'active',
        }),
      );
    });

    it('create_rejects_blank_and_whitespace_split_type_without_calling_repo', async () => {
      const { service, planRepo } = buildService();

      await expect(
        service.create({ title: 'Plan', split_type: '' }, trainerActor),
      ).rejects.toThrow(BadRequestError);
      expect(planRepo.insertPlan).not.toHaveBeenCalled();

      await expect(
        service.create({ title: 'Plan', split_type: '   ' }, trainerActor),
      ).rejects.toThrow(BadRequestError);
      expect(planRepo.insertPlan).not.toHaveBeenCalled();
    });

    it('update_rejects_blank_and_whitespace_split_type_without_calling_repo', async () => {
      const { service, planRepo } = buildService();

      await expect(
        service.update(10, { split_type: '', row_version: 1 }, trainerActor),
      ).rejects.toThrow(BadRequestError);
      expect(planRepo.findPlanById).not.toHaveBeenCalled();
      expect(planRepo.updatePlan).not.toHaveBeenCalled();

      await expect(
        service.update(10, { split_type: '   ', row_version: 1 }, trainerActor),
      ).rejects.toThrow(BadRequestError);
      expect(planRepo.findPlanById).not.toHaveBeenCalled();
      expect(planRepo.updatePlan).not.toHaveBeenCalled();
    });

    it('create_rejects_blank_and_whitespace_main_success_measure_without_calling_repo', async () => {
      const { service, planRepo } = buildService();

      await expect(
        service.create({ title: 'Plan', main_success_measure: '' }, trainerActor),
      ).rejects.toThrow(BadRequestError);
      expect(planRepo.insertPlan).not.toHaveBeenCalled();

      await expect(
        service.create({ title: 'Plan', main_success_measure: '   ' }, trainerActor),
      ).rejects.toThrow(BadRequestError);
      expect(planRepo.insertPlan).not.toHaveBeenCalled();
    });

    it('update_rejects_blank_and_whitespace_main_success_measure_without_calling_repo', async () => {
      const { service, planRepo } = buildService();

      await expect(
        service.update(10, { main_success_measure: '', row_version: 1 }, trainerActor),
      ).rejects.toThrow(BadRequestError);
      expect(planRepo.findPlanById).not.toHaveBeenCalled();
      expect(planRepo.updatePlan).not.toHaveBeenCalled();

      await expect(
        service.update(10, { main_success_measure: '   ', row_version: 1 }, trainerActor),
      ).rejects.toThrow(BadRequestError);
      expect(planRepo.findPlanById).not.toHaveBeenCalled();
      expect(planRepo.updatePlan).not.toHaveBeenCalled();
    });

    it('bounds_check_1_char_accepted_max_accepted_max_plus_1_rejected', async () => {
      const { service, planRepo } = buildService();

      planRepo.insertPlan.mockResolvedValue({
        id: 10,
        title: 'Plan',
        status: 'draft',
        row_version: 1,
        created_at: new Date(),
      });
      planRepo.insertVersion.mockResolvedValue({
        id: 101,
        workout_plan_id: 10,
        version_number: 1,
        created_at: new Date(),
      });

      // 1 char accepted
      await service.create(
        { title: 'Plan', split_type: 'a', main_success_measure: 'b' },
        trainerActor,
      );
      expect(planRepo.insertPlan).toHaveBeenCalledWith(
        expect.objectContaining({ split_type: 'a', main_success_measure: 'b' }),
      );

      // Max accepted: 64 for split_type, 255 for main_success_measure
      const maxSplit = 's'.repeat(64);
      const maxMeasure = 'm'.repeat(255);
      await service.create(
        { title: 'Plan', split_type: maxSplit, main_success_measure: maxMeasure },
        trainerActor,
      );
      expect(planRepo.insertPlan).toHaveBeenCalledWith(
        expect.objectContaining({ split_type: maxSplit, main_success_measure: maxMeasure }),
      );

      // Max + 1 rejected
      planRepo.insertPlan.mockClear();
      await expect(
        service.create({ title: 'Plan', split_type: 's'.repeat(65) }, trainerActor),
      ).rejects.toThrow(BadRequestError);
      expect(planRepo.insertPlan).not.toHaveBeenCalled();

      await expect(
        service.create({ title: 'Plan', main_success_measure: 'm'.repeat(256) }, trainerActor),
      ).rejects.toThrow(BadRequestError);
      expect(planRepo.insertPlan).not.toHaveBeenCalled();

      // On update max + 1 rejected without calling repo
      await expect(
        service.update(10, { split_type: 's'.repeat(65), row_version: 1 }, trainerActor),
      ).rejects.toThrow(BadRequestError);
      expect(planRepo.findPlanById).not.toHaveBeenCalled();

      await expect(
        service.update(10, { main_success_measure: 'm'.repeat(256), row_version: 1 }, trainerActor),
      ).rejects.toThrow(BadRequestError);
      expect(planRepo.findPlanById).not.toHaveBeenCalled();
    });

    it('values_are_saved_trimmed_on_create_and_update', async () => {
      const { service, planRepo } = buildService();

      planRepo.insertPlan.mockResolvedValue({
        id: 10,
        title: 'Plan',
        status: 'draft',
        row_version: 1,
        created_at: new Date(),
      });
      planRepo.insertVersion.mockResolvedValue({
        id: 101,
        workout_plan_id: 10,
        version_number: 1,
        created_at: new Date(),
      });

      await service.create(
        { title: 'Plan', split_type: '   upper lower   ', main_success_measure: '   squat 100kg   ' },
        trainerActor,
      );
      expect(planRepo.insertPlan).toHaveBeenCalledWith(
        expect.objectContaining({
          split_type: 'upper lower',
          main_success_measure: 'squat 100kg',
        }),
      );

      planRepo.findPlanById
        .mockResolvedValueOnce({
          id: 10,
          title: 'Plan',
          member_id: 30,
          trainer_id: 20,
          status: 'draft',
          is_template: false,
          row_version: 1,
        })
        .mockResolvedValueOnce({
          id: 10,
          title: 'Plan',
          member_id: 30,
          trainer_id: 20,
          status: 'draft',
          is_template: false,
          row_version: 2,
        });
      planRepo.updatePlan.mockResolvedValue({ id: 10 });

      await service.update(
        10,
        { split_type: '   push pull legs   ', main_success_measure: '   bench 120kg   ', row_version: 1 },
        trainerActor,
      );
      expect(planRepo.updatePlan).toHaveBeenCalledWith(
        10,
        expect.objectContaining({
          split_type: 'push pull legs',
          main_success_measure: 'bench 120kg',
        }),
        1,
      );
    });

    it('update_null_clears_split_type_and_main_success_measure', async () => {
      const { service, planRepo } = buildService();

      planRepo.findPlanById
        .mockResolvedValueOnce({
          id: 10,
          title: 'Plan',
          member_id: 30,
          trainer_id: 20,
          status: 'draft',
          is_template: false,
          row_version: 1,
          split_type: 'upper lower',
          main_success_measure: 'squat 100kg',
        })
        .mockResolvedValueOnce({
          id: 10,
          title: 'Plan',
          member_id: 30,
          trainer_id: 20,
          status: 'draft',
          is_template: false,
          row_version: 2,
          split_type: null,
          main_success_measure: null,
        });
      planRepo.updatePlan.mockResolvedValue({ id: 10 });

      await service.update(
        10,
        { split_type: null, main_success_measure: null, row_version: 1 },
        trainerActor,
      );

      const changes = planRepo.updatePlan.mock.calls[0][1];
      expect(changes).toEqual(
        expect.objectContaining({ split_type: null, main_success_measure: null }),
      );
    });

    it('assign_copies_all_blueprint_fields_and_is_not_blocked_by_legacy_blank_values', async () => {
      const { service, planRepo } = buildService();

      const templateWithBlanks = {
        id: 6,
        title: 'Legacy Template With Blanks',
        description: 'Legacy template description',
        is_template: true,
        target_goal: null,
        difficulty: null,
        duration_weeks: null,
        trainer_id: 20,
        status: 'active',
        primary_objective_12w: 'Objective',
        milestone_4w: 'Milestone',
        sessions_per_week: 3,
        target_session_duration_minutes: 45,
        split_type: '',
        cardio_protocol: 'Zone 2',
        mobility_protocol: 'Hips',
        progression_methods: ['load'],
        main_success_measure: '   ',
        trainer_programming_notes: 'Notes',
        current_version: { id: 60, version_number: 1, exercises: [] },
      };

      planRepo.findPlanById
        .mockResolvedValueOnce(templateWithBlanks)
        .mockResolvedValueOnce({
          id: 13,
          title: 'Legacy Template With Blanks',
          member_id: 30,
          trainer_id: 20,
          is_template: false,
          status: 'active',
          current_version: { id: 130, version_number: 1, exercises: [] },
        });
      planRepo.insertPlan.mockResolvedValue({ id: 13 });
      planRepo.insertVersion.mockResolvedValue({ id: 130 });

      const assigned = await service.assign(6, { member_id: 30 }, trainerActor);

      expect(planRepo.insertPlan).toHaveBeenCalledWith(
        expect.objectContaining({
          primary_objective_12w: 'Objective',
          milestone_4w: 'Milestone',
          sessions_per_week: 3,
          target_session_duration_minutes: 45,
          split_type: '',
          cardio_protocol: 'Zone 2',
          mobility_protocol: 'Hips',
          progression_methods: ['load'],
          main_success_measure: '   ',
          trainer_programming_notes: 'Notes',
          is_template: false,
          status: 'active',
        }),
      );
      expect(assigned).toBeDefined();
    });

    it('schema_rejects_bad_blueprint_bounds', () => {
      const base = { title: 'x' };

      expect(workoutPlanCreateSchema.safeParse({ ...base, sessions_per_week: 0 }).success).toBe(
        false,
      );
      expect(workoutPlanCreateSchema.safeParse({ ...base, sessions_per_week: 15 }).success).toBe(
        false,
      );
      expect(workoutPlanCreateSchema.safeParse({ ...base, sessions_per_week: 1 }).success).toBe(
        true,
      );
      expect(workoutPlanCreateSchema.safeParse({ ...base, sessions_per_week: 14 }).success).toBe(
        true,
      );

      expect(
        workoutPlanCreateSchema.safeParse({ ...base, target_session_duration_minutes: 14 }).success,
      ).toBe(false);
      expect(
        workoutPlanCreateSchema.safeParse({ ...base, target_session_duration_minutes: 181 }).success,
      ).toBe(false);
      expect(
        workoutPlanCreateSchema.safeParse({ ...base, target_session_duration_minutes: 15 }).success,
      ).toBe(true);
      expect(
        workoutPlanCreateSchema.safeParse({ ...base, target_session_duration_minutes: 180 }).success,
      ).toBe(true);

      expect(
        workoutPlanCreateSchema.safeParse({ ...base, progression_methods: ['other'] }).success,
      ).toBe(false);
      expect(
        workoutPlanCreateSchema.safeParse({ ...base, progression_methods: ['load', 'load'] })
          .success,
      ).toBe(false);
      expect(workoutPlanCreateSchema.safeParse({ ...base, progression_methods: [] }).success).toBe(
        true,
      );

      expect(workoutPlanCreateSchema.safeParse({ ...base, split_type: '' }).success).toBe(false);
      expect(workoutPlanCreateSchema.safeParse({ ...base, split_type: '   ' }).success).toBe(false);
      expect(workoutPlanCreateSchema.safeParse({ ...base, split_type: 'a' }).success).toBe(true);
      expect(workoutPlanCreateSchema.safeParse({ ...base, split_type: 'a'.repeat(64) }).success).toBe(true);
      expect(
        workoutPlanCreateSchema.safeParse({ ...base, split_type: 'x'.repeat(65) }).success,
      ).toBe(false);

      expect(workoutPlanCreateSchema.safeParse({ ...base, main_success_measure: '' }).success).toBe(false);
      expect(workoutPlanCreateSchema.safeParse({ ...base, main_success_measure: '   ' }).success).toBe(false);
      expect(workoutPlanCreateSchema.safeParse({ ...base, main_success_measure: 'a' }).success).toBe(true);
      expect(workoutPlanCreateSchema.safeParse({ ...base, main_success_measure: 'a'.repeat(255) }).success).toBe(true);
      expect(
        workoutPlanCreateSchema.safeParse({ ...base, main_success_measure: 'a'.repeat(256) }).success,
      ).toBe(false);

      expect(workoutPlanUpdateSchema.safeParse({ split_type: '' }).success).toBe(false);
      expect(workoutPlanUpdateSchema.safeParse({ split_type: '   ' }).success).toBe(false);
      expect(workoutPlanUpdateSchema.safeParse({ split_type: null }).success).toBe(true);
      expect(workoutPlanUpdateSchema.safeParse({ split_type: 'a' }).success).toBe(true);

      expect(workoutPlanUpdateSchema.safeParse({ main_success_measure: '' }).success).toBe(false);
      expect(workoutPlanUpdateSchema.safeParse({ main_success_measure: '   ' }).success).toBe(false);
      expect(workoutPlanUpdateSchema.safeParse({ main_success_measure: null }).success).toBe(true);
      expect(workoutPlanUpdateSchema.safeParse({ main_success_measure: 'a' }).success).toBe(true);

      expect(
        workoutPlanUpdateSchema.safeParse({ primary_objective_12w: null, row_version: 1 }).success,
      ).toBe(true);
    });
  });

  describe('plan exercise prescription', () => {
    const existingPlan = {
      id: 15,
      title: 'Strength Block',
      member_id: 30,
      trainer_id: 20,
      status: 'active',
      row_version: 2,
      is_template: false,
    };

    type Resolvable = {
      mockResolvedValueOnce: (value: unknown) => Resolvable;
      mockResolvedValue: (value: unknown) => unknown;
    };

    function stubReplace(
      planRepo: {
        findPlanById: Resolvable;
        findLatestVersionByPlanId: Resolvable;
        insertVersion: Resolvable;
      },
      readExercise: Record<string, unknown>,
    ) {
      planRepo.findPlanById
        .mockResolvedValueOnce(existingPlan)
        .mockResolvedValueOnce({
          ...existingPlan,
          row_version: 3,
          current_version: {
            id: 152,
            version_number: 2,
            exercises: [readExercise],
          },
        });
      planRepo.findLatestVersionByPlanId.mockResolvedValue({
        id: 151,
        workout_plan_id: 15,
        version_number: 1,
      });
      planRepo.insertVersion.mockResolvedValue({
        id: 152,
        workout_plan_id: 15,
        version_number: 2,
      });
    }

    it('persists target RIR, duration, and notes and returns them on read', async () => {
      const { service, planRepo } = buildService();
      stubReplace(planRepo, {
        id: 1001,
        exercise_id: 2,
        day_number: 1,
        order_index: 0,
        target_rir: '2.0',
        target_duration_seconds: 45,
        notes: '  pause at the bottom  ',
      });

      const result = await service.replaceExercises(
        15,
        {
          exercises: [
            {
              exercise_id: 2,
              day_number: 1,
              order_index: 0,
              target_sets: 3,
              target_reps: '10',
              rest_seconds: 60,
              target_rir: 2,
              target_duration_seconds: 45,
              notes: '  pause at the bottom  ',
            },
            {
              exercise_id: 3,
              day_number: 1,
              order_index: 1,
              target_sets: 1,
              target_reps: '1',
              rest_seconds: 0,
              target_rir: 0,
              target_duration_seconds: 0,
              notes: 'hold',
            },
          ],
        },
        trainerActor,
      );

      expect(planRepo.insertPlanExercises).toHaveBeenCalledWith([
        expect.objectContaining({
          workout_plan_version_id: 152,
          exercise_id: 2,
          target_rir: '2.0',
          target_duration_seconds: 45,
          notes: '  pause at the bottom  ',
        }),
        expect.objectContaining({
          exercise_id: 3,
          target_rir: '0.0',
          target_duration_seconds: 0,
          notes: 'hold',
        }),
      ]);
      expect(result.current_version?.exercises[0]).toEqual(
        expect.objectContaining({
          target_rir: '2.0',
          target_duration_seconds: 45,
          notes: '  pause at the bottom  ',
        }),
      );
    });

    it('stores an omitted or blank prescription as empty on a new line', async () => {
      const { service, planRepo } = buildService();
      stubReplace(planRepo, {
        id: 1002,
        exercise_id: 2,
        day_number: 1,
        order_index: 0,
        target_rir: null,
        target_duration_seconds: null,
        notes: null,
      });

      await service.replaceExercises(
        15,
        {
          exercises: [
            {
              exercise_id: 2,
              day_number: 1,
              order_index: 0,
              target_sets: 3,
              target_reps: '10',
              rest_seconds: 60,
              notes: '   ',
            },
          ],
        },
        trainerActor,
      );

      expect(planRepo.insertPlanExercises).toHaveBeenCalledWith([
        expect.objectContaining({
          target_rir: null,
          target_duration_seconds: null,
          notes: null,
        }),
      ]);
    });

    it('keeps an omitted prescription on update and clears an explicit empty', async () => {
      const { service, planRepo } = buildService();
      stubReplace(planRepo, {
        id: 1003,
        exercise_id: 2,
        day_number: 1,
        order_index: 0,
        target_rir: '1.5',
        target_duration_seconds: null,
        notes: null,
      });
      planRepo.findExercisesByVersionId.mockResolvedValue([
        {
          exercise_id: 2,
          day_number: 1,
          order_index: 0,
          target_rir: '1.5',
          target_duration_seconds: 30,
          notes: 'keep the pause',
        },
      ]);

      await service.replaceExercises(
        15,
        {
          exercises: [
            {
              exercise_id: 2,
              day_number: 1,
              order_index: 0,
              target_sets: 3,
              target_reps: '10',
              rest_seconds: 60,
              target_duration_seconds: null,
              notes: '',
            },
          ],
        },
        trainerActor,
      );

      expect(planRepo.insertPlanExercises).toHaveBeenCalledWith([
        expect.objectContaining({
          target_rir: '1.5',
          target_duration_seconds: null,
          notes: null,
        }),
      ]);
    });

    it('copies prescription onto the plan created from a template', async () => {
      const { service, planRepo } = buildService();
      const template = {
        id: 5,
        title: 'Beginner Full Body',
        description: null,
        is_template: true,
        target_goal: null,
        difficulty: null,
        duration_weeks: null,
        trainer_id: 20,
        status: 'active',
        current_version: {
          id: 50,
          version_number: 1,
          exercises: [
            {
              exercise_id: 1,
              day_number: 1,
              order_index: 0,
              target_sets: 3,
              target_reps: '10',
              target_weight_kg: '50.00',
              target_rir: '1.5',
              target_duration_seconds: 40,
              rest_seconds: 60,
              rest_between_exercises_seconds: null,
              notes: 'slow lower',
            },
          ],
        },
      };

      planRepo.findPlanById
        .mockResolvedValueOnce(template)
        .mockResolvedValueOnce({
          id: 12,
          member_id: 30,
          is_template: false,
          status: 'active',
          current_version: {
            id: 120,
            version_number: 1,
            exercises: [
              {
                target_rir: '1.5',
                target_duration_seconds: 40,
                notes: 'slow lower',
              },
            ],
          },
        });
      planRepo.insertPlan.mockResolvedValue({ id: 12 });
      planRepo.insertVersion.mockResolvedValue({ id: 120 });

      const assigned = await service.assign(5, { member_id: 30 }, trainerActor);

      expect(planRepo.insertPlanExercises).toHaveBeenCalledWith([
        expect.objectContaining({
          workout_plan_version_id: 120,
          target_rir: '1.5',
          target_duration_seconds: 40,
          notes: 'slow lower',
        }),
      ]);
      expect(assigned.current_version?.exercises[0]).toEqual(
        expect.objectContaining({
          target_rir: '1.5',
          target_duration_seconds: 40,
          notes: 'slow lower',
        }),
      );
    });

    it('rejects out-of-range RIR and negative duration at the edge', () => {
      const line = { exercise_id: 1, day_number: 1, order_index: 0 };

      expect(
        workoutPlanExercisesWriteSchema.safeParse({
          exercises: [{ ...line, target_rir: -0.1 }],
        }).success,
      ).toBe(false);
      expect(
        workoutPlanExercisesWriteSchema.safeParse({
          exercises: [{ ...line, target_rir: 10.1 }],
        }).success,
      ).toBe(false);
      expect(
        workoutPlanExercisesWriteSchema.safeParse({
          exercises: [{ ...line, target_rir: 1.25 }],
        }).success,
      ).toBe(false);
      expect(
        workoutPlanExercisesWriteSchema.safeParse({
          exercises: [{ ...line, target_duration_seconds: -1 }],
        }).success,
      ).toBe(false);
      expect(
        workoutPlanExercisesWriteSchema.safeParse({
          exercises: [{ ...line, target_duration_seconds: 1.5 }],
        }).success,
      ).toBe(false);

      expect(
        workoutPlanExercisesWriteSchema.safeParse({
          exercises: [{ ...line, target_rir: 0, target_duration_seconds: 0 }],
        }).success,
      ).toBe(true);
      expect(
        workoutPlanExercisesWriteSchema.safeParse({
          exercises: [{ ...line, target_rir: 10, target_duration_seconds: 45 }],
        }).success,
      ).toBe(true);
      expect(
        workoutPlanExercisesWriteSchema.safeParse({
          exercises: [{ ...line, target_rir: null, target_duration_seconds: null, notes: null }],
        }).success,
      ).toBe(true);
      expect(
        workoutPlanExercisesWriteSchema.safeParse({
          exercises: [{ ...line, target_rir: '', target_duration_seconds: '' }],
        }).success,
      ).toBe(true);
    });
  });
});
