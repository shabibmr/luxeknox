import { describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import {
  BadRequestError,
  BusinessRuleError,
  ConflictError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { DietPlanService } from './diet-plan.service';

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
    insertMeal: vi.fn().mockImplementation(async (meal) => ({ id: 101, ...meal })),
    insertFoods: vi.fn().mockResolvedValue(undefined),
    findMealsByVersionId: vi.fn().mockResolvedValue([]),
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

  const service = new DietPlanService(
    db as any,
    planRepo as any,
    memberRepo as any,
    eventBus as any,
    paginationHelper as any,
  );

  return { service, planRepo, memberRepo, eventBus };
}

describe('DietPlanService', () => {
  describe('create', () => {
    it('creates a draft plan and initial version 1', async () => {
      const { service, planRepo, eventBus } = buildService();
      planRepo.insertPlan.mockResolvedValue({
        id: 1,
        title: 'Keto Cut',
        member_id: 30,
        trainer_id: 20,
        daily_calorie_target: 2000,
        protein_target_g: 150,
        carbs_target_g: 30,
        fat_target_g: 140,
        is_template: false,
        status: 'draft',
        row_version: 1,
        created_at: new Date(),
      });
      planRepo.insertVersion.mockResolvedValue({
        id: 10,
        diet_plan_id: 1,
        version_number: 1,
        changelog: 'Initial draft version',
        created_at: new Date(),
      });

      const result = await service.create(
        {
          title: 'Keto Cut',
          member_id: 30,
          daily_calorie_target: 2000,
          protein_target_g: 150,
          carbs_target_g: 30,
          fat_target_g: 140,
        },
        trainerActor,
      );

      expect(result.id).toBe(1);
      expect(result.status).toBe('draft');
      expect(result.current_version?.version_number).toBe(1);
      expect(planRepo.insertPlan).toHaveBeenCalledWith(
        expect.objectContaining({
          title: 'Keto Cut',
          member_id: 30,
          trainer_id: 20,
          status: 'draft',
          row_version: 1,
        }),
      );
      expect(eventBus.emitSync).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'diet_plan.created',
          payload: expect.objectContaining({ plan_id: 1, member_id: 30 }),
        }),
      );
    });

    it('rejects a template that specifies a member_id', async () => {
      const { service } = buildService();
      await expect(
        service.create(
          {
            title: 'Template Plan',
            is_template: true,
            member_id: 30,
          },
          adminActor,
        ),
      ).rejects.toThrow(BadRequestError);
    });

    it('rejects member attempting to create a template', async () => {
      const { service } = buildService();
      await expect(
        service.create(
          {
            title: 'Member Template',
            is_template: true,
          },
          memberActor,
        ),
      ).rejects.toThrow(ForbiddenError);
    });

    it('rejects trainer creating plan for an unassigned member', async () => {
      const { service } = buildService();
      await expect(
        service.create(
          {
            title: 'Unassigned Plan',
            member_id: 40,
          },
          trainerActor,
        ),
      ).rejects.toThrow(NotFoundError);
    });
  });

  describe('getById', () => {
    it('allows a member to view own diet plan', async () => {
      const { service, planRepo } = buildService();
      planRepo.findPlanById.mockResolvedValue({
        id: 5,
        title: 'Hypertrophy Diet',
        member_id: 30,
        is_template: false,
        status: 'active',
        row_version: 1,
      });

      const plan = await service.getById(5, memberActor);
      expect(plan.id).toBe(5);
    });

    it('denies a member viewing another members plan', async () => {
      const { service, planRepo } = buildService();
      planRepo.findPlanById.mockResolvedValue({
        id: 5,
        title: 'Other Member Diet',
        member_id: 40,
        is_template: false,
        status: 'active',
      });

      await expect(service.getById(5, memberActor)).rejects.toThrow(NotFoundError);
    });

    it('allows anyone to view a template plan', async () => {
      const { service, planRepo } = buildService();
      planRepo.findPlanById.mockResolvedValue({
        id: 99,
        title: 'Master Bulking Template',
        member_id: null,
        is_template: true,
        status: 'active',
      });

      const plan = await service.getById(99, memberActor);
      expect(plan.id).toBe(99);
    });
  });

  describe('update', () => {
    it('updates plan metadata with optimistic row_version check', async () => {
      const { service, planRepo } = buildService();
      planRepo.findPlanById.mockResolvedValueOnce({
        id: 1,
        title: 'Old Title',
        member_id: 30,
        trainer_id: 20,
        status: 'draft',
        row_version: 1,
      }).mockResolvedValueOnce({
        id: 1,
        title: 'New Title',
        member_id: 30,
        trainer_id: 20,
        status: 'draft',
        row_version: 2,
      });

      const updated = await service.update(
        1,
        { title: 'New Title', row_version: 1 },
        trainerActor,
      );

      expect(planRepo.updatePlan).toHaveBeenCalledWith(
        1,
        expect.objectContaining({ title: 'New Title' }),
        1,
      );
      expect(updated.title).toBe('New Title');
    });

    it('rejects updating an archived plan', async () => {
      const { service, planRepo } = buildService();
      planRepo.findPlanById.mockResolvedValue({
        id: 1,
        title: 'Archived Plan',
        member_id: 30,
        trainer_id: 20,
        status: 'archived',
        row_version: 1,
      });

      await expect(
        service.update(1, { title: 'Cannot Update' }, trainerActor),
      ).rejects.toThrow(BusinessRuleError);
    });
  });

  describe('publish', () => {
    it('publishes a draft plan to active', async () => {
      const { service, planRepo, eventBus } = buildService();
      planRepo.findPlanById.mockResolvedValueOnce({
        id: 1,
        title: 'Draft Plan',
        member_id: 30,
        trainer_id: 20,
        status: 'draft',
        is_template: false,
      }).mockResolvedValueOnce({
        id: 1,
        title: 'Draft Plan',
        member_id: 30,
        trainer_id: 20,
        status: 'active',
        is_template: false,
      });

      const published = await service.publish(1, trainerActor);
      expect(planRepo.updatePlan).toHaveBeenCalledWith(1, { status: 'active' });
      expect(eventBus.emitSync).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'diet_plan.published',
          payload: expect.objectContaining({ plan_id: 1 }),
        }),
      );
      expect(published.status).toBe('active');
    });

    it('rejects publishing if member already has an active diet plan (DIT-007)', async () => {
      const { service, planRepo } = buildService();
      planRepo.findPlanById.mockResolvedValue({
        id: 2,
        title: 'New Plan',
        member_id: 30,
        trainer_id: 20,
        status: 'draft',
        is_template: false,
      });
      planRepo.findActivePlanForMember.mockResolvedValue({
        id: 1,
        title: 'Already Active Plan',
        member_id: 30,
        status: 'active',
      });

      await expect(service.publish(2, trainerActor)).rejects.toThrow(ConflictError);
    });
  });

  describe('archive', () => {
    it('sets status to archived and emits event', async () => {
      const { service, planRepo, eventBus } = buildService();
      planRepo.findPlanById.mockResolvedValueOnce({
        id: 1,
        title: 'Plan',
        member_id: 30,
        trainer_id: 20,
        status: 'active',
      }).mockResolvedValueOnce({
        id: 1,
        title: 'Plan',
        member_id: 30,
        trainer_id: 20,
        status: 'archived',
      });

      const archived = await service.archive(1, trainerActor);
      expect(planRepo.updatePlan).toHaveBeenCalledWith(1, { status: 'archived' });
      expect(eventBus.emitSync).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'diet_plan.archived',
        }),
      );
      expect(archived.status).toBe('archived');
    });
  });

  describe('assign', () => {
    it('copies a template onto a member (new plan + version 1 + copied meals and foods)', async () => {
      const { service, planRepo, eventBus } = buildService();
      const template = {
        id: 100,
        title: 'Gold Standard Keto',
        description: 'Template description',
        is_template: true,
        trainer_id: 20,
        daily_calorie_target: 2200,
        protein_target_g: 160,
        carbs_target_g: 25,
        fat_target_g: 150,
        current_version: {
          id: 50,
          diet_plan_id: 100,
          version_number: 1,
          meals: [
            {
              id: 201,
              meal_name: 'Breakfast',
              scheduled_time: '08:00',
              target_calories: 600,
              notes: 'Morning fuel',
              foods: [
                {
                  id: 301,
                  diet_plan_meal_id: 201,
                  food_id: 1,
                  quantity: 3,
                  serving_unit: 'large egg',
                },
              ],
            },
          ],
        },
      };

      planRepo.findPlanById.mockResolvedValueOnce(template).mockResolvedValueOnce({
        id: 200,
        title: 'Gold Standard Keto',
        member_id: 30,
        status: 'active',
        is_template: false,
      });
      planRepo.insertPlan.mockResolvedValue({ id: 200, title: 'Gold Standard Keto' });
      planRepo.insertVersion.mockResolvedValue({ id: 70, diet_plan_id: 200, version_number: 1 });
      planRepo.insertMeal.mockResolvedValue({ id: 501, meal_name: 'Breakfast' });

      const assigned = await service.assign(100, { member_id: 30 }, trainerActor);

      expect(planRepo.insertPlan).toHaveBeenCalledWith(
        expect.objectContaining({
          title: 'Gold Standard Keto',
          member_id: 30,
          is_template: false,
          status: 'active',
        }),
      );
      expect(planRepo.insertMeal).toHaveBeenCalledWith(
        expect.objectContaining({
          diet_plan_version_id: 70,
          meal_name: 'Breakfast',
        }),
      );
      expect(planRepo.insertFoods).toHaveBeenCalledWith(
        expect.arrayContaining([
          expect.objectContaining({
            diet_plan_meal_id: 501,
            food_id: 1,
            quantity: 3,
          }),
        ]),
      );
      expect(eventBus.emitSync).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'diet_plan.assigned',
        }),
      );
      expect(assigned.id).toBe(200);
    });

    it('rejects copy if source plan is not a template', async () => {
      const { service, planRepo } = buildService();
      planRepo.findPlanById.mockResolvedValue({
        id: 10,
        title: 'Non Template',
        is_template: false,
      });

      await expect(
        service.assign(10, { member_id: 30 }, trainerActor),
      ).rejects.toThrow(BadRequestError);
    });

    it('rejects assigning if member already has active diet plan', async () => {
      const { service, planRepo } = buildService();
      planRepo.findPlanById.mockResolvedValue({
        id: 100,
        title: 'Template',
        is_template: true,
      });
      planRepo.findActivePlanForMember.mockResolvedValue({
        id: 1,
        status: 'active',
      });

      await expect(
        service.assign(100, { member_id: 30 }, trainerActor),
      ).rejects.toThrow(ConflictError);
    });
  });

  describe('replaceMeals (Versioning & Nutrition Rollups)', () => {
    it('creates a new version snapshot without mutating previous version (DIT-008, DIT-009, DIT-013)', async () => {
      const { service, planRepo, eventBus } = buildService();
      const existingPlan = {
        id: 1,
        title: 'Diet Plan',
        member_id: 30,
        trainer_id: 20,
        status: 'active',
        row_version: 2,
      };

      planRepo.findPlanById.mockResolvedValueOnce(existingPlan).mockResolvedValueOnce({
        ...existingPlan,
        row_version: 3,
        current_version: {
          id: 12,
          diet_plan_id: 1,
          version_number: 2,
        },
      });
      planRepo.findLatestVersionByPlanId.mockResolvedValue({
        id: 11,
        diet_plan_id: 1,
        version_number: 1,
      });
      planRepo.insertVersion.mockResolvedValue({
        id: 12,
        diet_plan_id: 1,
        version_number: 2,
      });
      planRepo.insertMeal.mockResolvedValue({ id: 20, meal_name: 'Post-workout Shake' });

      await service.replaceMeals(
        1,
        {
          changelog: 'Added post-workout shake',
          row_version: 2,
          meals: [
            {
              meal_name: 'Post-workout Shake',
              scheduled_time: '17:00',
              target_calories: 400,
              foods: [
                {
                  food_id: 5,
                  quantity: 2,
                  serving_unit: 'scoop',
                },
              ],
            },
          ],
        },
        trainerActor,
      );

      // Verifies new version 2 was created
      expect(planRepo.insertVersion).toHaveBeenCalledWith(
        expect.objectContaining({
          diet_plan_id: 1,
          version_number: 2,
          changelog: 'Added post-workout shake',
        }),
      );

      // Verifies meal was inserted for new version 12
      expect(planRepo.insertMeal).toHaveBeenCalledWith(
        expect.objectContaining({
          diet_plan_version_id: 12,
          meal_name: 'Post-workout Shake',
        }),
      );

      // Verifies food line items inserted under new meal 20
      expect(planRepo.insertFoods).toHaveBeenCalledWith([
        expect.objectContaining({
          diet_plan_meal_id: 20,
          food_id: 5,
          quantity: 2,
        }),
      ]);

      expect(eventBus.emitSync).toHaveBeenCalledWith(
        expect.objectContaining({
          eventName: 'diet_plan.version_created',
          payload: expect.objectContaining({ plan_id: 1, version_number: 2 }),
        }),
      );
    });
  });
});
