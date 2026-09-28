import { describe, it, expect, vi, beforeEach } from 'vitest';
import { WorkoutPlanController } from './workout-plan.controller';
import { WorkoutPlanService } from './workout-plan.service';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

describe('WorkoutPlanController', () => {
  let service: Partial<WorkoutPlanService>;
  let controller: WorkoutPlanController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({ data: [], meta: {} }),
      getById: vi.fn().mockResolvedValue({ id: 10, title: 'Plan' }),
      create: vi.fn().mockResolvedValue({ id: 10, title: 'Plan' }),
      update: vi.fn().mockResolvedValue({ id: 10, title: 'Updated' }),
      publish: vi.fn().mockResolvedValue({ id: 10, status: 'active' }),
      archive: vi.fn().mockResolvedValue({ id: 10, status: 'archived' }),
      assign: vi.fn().mockResolvedValue({ id: 11, status: 'active' }),
      listVersions: vi.fn().mockResolvedValue({ data: [], meta: {} }),
      replaceExercises: vi.fn().mockResolvedValue({ id: 10, current_version: { version_number: 2 } }),
    };
    controller = new WorkoutPlanController(service as WorkoutPlanService);
  });

  it('requires workouts.read on GET /workout-plans and delegates to service', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, WorkoutPlanController.prototype.list),
    ).toEqual(['workouts.read']);

    const query = { is_template: 'true' };
    const result = await controller.list(query, ADMIN_USER);

    expect(service.list).toHaveBeenCalledWith(query, { is_template: true }, ADMIN_USER);
    expect(result.data).toEqual([]);
  });

  it('requires workouts.write on POST /workout-plans and delegates to service', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, WorkoutPlanController.prototype.create),
    ).toEqual(['workouts.write']);

    const dto = { title: 'New Plan', is_template: false };
    const result = await controller.create(dto, ADMIN_USER);

    expect(service.create).toHaveBeenCalledWith(dto, ADMIN_USER);
    expect(result.id).toBe(10);
  });

  it('requires workouts.write on POST /workout-plans/:id/publish', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, WorkoutPlanController.prototype.publish),
    ).toEqual(['workouts.write']);

    const result = await controller.publish(10, ADMIN_USER);
    expect(service.publish).toHaveBeenCalledWith(10, ADMIN_USER);
    expect(result.status).toBe('active');
  });

  it('requires workouts.write on POST /workout-plans/:id/assign', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, WorkoutPlanController.prototype.assign),
    ).toEqual(['workouts.write']);

    const dto = { member_id: 30 };
    const result = await controller.assign(5, dto, ADMIN_USER);
    expect(service.assign).toHaveBeenCalledWith(5, dto, ADMIN_USER);
    expect(result.id).toBe(11);
  });

  it('requires workouts.write on PUT /workout-plans/:id/exercises', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, WorkoutPlanController.prototype.replaceExercises),
    ).toEqual(['workouts.write']);

    const dto = {
      changelog: 'v2 update',
      exercises: [
        {
          exercise_id: 1,
          day_number: 1,
          order_index: 0,
        },
      ],
    };
    const result = await controller.replaceExercises(10, dto as any, ADMIN_USER);
    expect(service.replaceExercises).toHaveBeenCalledWith(10, dto, ADMIN_USER);
    expect(result.current_version?.version_number).toBe(2);
  });
});
