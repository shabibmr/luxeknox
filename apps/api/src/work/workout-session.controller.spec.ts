import { describe, it, expect, vi, beforeEach } from 'vitest';
import { WorkoutSessionController } from './workout-session.controller';
import { WorkoutSessionService } from './workout-session.service';
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

describe('WorkoutSessionController', () => {
  let service: Partial<WorkoutSessionService>;
  let controller: WorkoutSessionController;

  beforeEach(() => {
    service = {
      listSessions: vi.fn().mockResolvedValue({ data: [], meta: {} }),
      getById: vi.fn().mockResolvedValue({ id: 50, member_id: 30 }),
      start: vi.fn().mockResolvedValue({ id: 50, member_id: 30 }),
      logSet: vi.fn().mockResolvedValue({ id: 501, set_number: 1 }),
      complete: vi.fn().mockResolvedValue({ id: 50, completed_at: new Date() }),
      getPersonalRecords: vi.fn().mockResolvedValue([]),
      getActive: vi.fn().mockResolvedValue({ id: 50, member_id: 30 }),
      updateSet: vi.fn().mockResolvedValue({ id: 501, set_number: 1 }),
      deleteSet: vi.fn().mockResolvedValue(undefined),
    };
    controller = new WorkoutSessionController(service as WorkoutSessionService);
  });

  it('requires workouts.read on GET /workout-sessions and delegates to service', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, WorkoutSessionController.prototype.list),
    ).toEqual(['workouts.read']);

    const query = { member_id: '30' };
    const result = await controller.list(query, ADMIN_USER);

    expect(service.listSessions).toHaveBeenCalledWith(query, { member_id: 30 }, ADMIN_USER);
    expect(result.data).toEqual([]);
  });

  it('requires workouts.write on POST /workout-sessions and delegates to service', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, WorkoutSessionController.prototype.start),
    ).toEqual(['workouts.write']);

    const dto = { member_id: 30 };
    const result = await controller.start(dto, ADMIN_USER);

    expect(service.start).toHaveBeenCalledWith(dto, ADMIN_USER);
    expect(result.id).toBe(50);
  });

  it('requires workouts.write on POST /workout-sessions/:id/sets', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, WorkoutSessionController.prototype.logSet),
    ).toEqual(['workouts.write']);

    const dto = { exercise_id: 1, set_number: 1, reps_completed: 10, weight_lifted_kg: 60, is_completed: true };
    const result = await controller.logSet(50, dto, ADMIN_USER);

    expect(service.logSet).toHaveBeenCalledWith(50, dto, ADMIN_USER);
    expect(result.id).toBe(501);
  });

  it('requires workouts.write on POST /workout-sessions/:id/complete', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, WorkoutSessionController.prototype.complete),
    ).toEqual(['workouts.write']);

    const dto = { client_feedback_rating: 5, notes: 'Great pump' };
    const result = await controller.complete(50, dto, ADMIN_USER);

    expect(service.complete).toHaveBeenCalledWith(50, dto, ADMIN_USER);
    expect(result.id).toBe(50);
  });

  it('requires workouts.read on GET /workout-sessions/personal-records', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, WorkoutSessionController.prototype.getPersonalRecords),
    ).toEqual(['workouts.read']);

    const result = await controller.getPersonalRecords('30', '1', ADMIN_USER);

    expect(service.getPersonalRecords).toHaveBeenCalledWith(30, 1, ADMIN_USER);
    expect(result).toEqual([]);
  });

  it('requires workouts.read on GET /workout-sessions/active and delegates to service', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, WorkoutSessionController.prototype.getActive),
    ).toEqual(['workouts.read']);

    const result = await controller.getActive('30', ADMIN_USER);

    expect(service.getActive).toHaveBeenCalledWith(30, ADMIN_USER);
    expect(result.id).toBe(50);
  });

  it('requires workouts.write on PATCH /workout-sessions/:id/sets/:setId and delegates to service', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, WorkoutSessionController.prototype.updateSet),
    ).toEqual(['workouts.write']);

    const dto = { reps_completed: 12 };
    const result = await controller.updateSet(50, 501, dto, ADMIN_USER);

    expect(service.updateSet).toHaveBeenCalledWith(50, 501, dto, ADMIN_USER);
    expect(result.id).toBe(501);
  });

  it('requires workouts.write on DELETE /workout-sessions/:id/sets/:setId and delegates to service', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, WorkoutSessionController.prototype.deleteSet),
    ).toEqual(['workouts.write']);

    await controller.deleteSet(50, 501, ADMIN_USER);

    expect(service.deleteSet).toHaveBeenCalledWith(50, 501, ADMIN_USER);
  });
});
