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

  const service = new WorkoutPlanService(
    db as any,
    planRepo as any,
    memberRepo as any,
    eventBus as any,
    paginationHelper as any,
  );

  return { service, planRepo, memberRepo, eventBus };
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
  });
});
