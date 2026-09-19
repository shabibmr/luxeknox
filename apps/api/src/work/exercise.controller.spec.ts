import { describe, it, expect, vi, beforeEach } from 'vitest';
import { ExerciseController } from './exercise.controller';
import { ExerciseService } from './exercise.service';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { Exercise } from '../platform/db/schema/exercises';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const EXERCISE: Exercise = {
  id: 1,
  name: 'Bench Press',
  primary_muscle_group: 'chest',
  secondary_muscles: null,
  equipment_needed: 'barbell',
  instructions: null,
  video_url: null,
  gif_url: null,
  difficulty_level: 'beginner',
  is_active: true,
  created_at: new Date(),
  updated_at: null,
};

describe('ExerciseController', () => {
  let service: Partial<ExerciseService>;
  let controller: ExerciseController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({ data: [EXERCISE], meta: {} }),
      getById: vi.fn().mockResolvedValue(EXERCISE),
      create: vi.fn().mockResolvedValue(EXERCISE),
      update: vi.fn().mockResolvedValue(EXERCISE),
    };
    controller = new ExerciseController(service as ExerciseService);
  });

  it('requires exercises.read on GET /exercises and delegates to the service', async () => {
    expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ExerciseController.prototype.list)).toEqual([
      'exercises.read',
    ]);

    const query = { q: 'bench' };
    const result = await controller.list(query, ADMIN_USER);

    expect(service.list).toHaveBeenCalledWith(query, ADMIN_USER);
    expect(result.data).toEqual([EXERCISE]);
  });

  it('requires exercises.create on POST /exercises and delegates to the service', async () => {
    expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ExerciseController.prototype.create)).toEqual([
      'exercises.create',
    ]);

    const dto = { name: 'Bench Press' };
    const result = await controller.create(dto, ADMIN_USER);

    expect(service.create).toHaveBeenCalledWith(dto, ADMIN_USER);
    expect(result).toEqual(EXERCISE);
  });

  it('requires exercises.read on GET /exercises/:id and delegates to the service', async () => {
    expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ExerciseController.prototype.getById)).toEqual([
      'exercises.read',
    ]);

    const result = await controller.getById(1, ADMIN_USER);

    expect(service.getById).toHaveBeenCalledWith(1, ADMIN_USER);
    expect(result).toEqual(EXERCISE);
  });

  it('requires exercises.update on PATCH /exercises/:id and delegates to the service', async () => {
    expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ExerciseController.prototype.update)).toEqual([
      'exercises.update',
    ]);

    const dto = { is_active: false };
    const result = await controller.update(1, dto, ADMIN_USER);

    expect(service.update).toHaveBeenCalledWith(1, dto, ADMIN_USER);
    expect(result).toEqual(EXERCISE);
  });
});
