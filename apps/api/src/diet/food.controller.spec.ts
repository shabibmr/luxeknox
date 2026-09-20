import { describe, it, expect, vi, beforeEach } from 'vitest';
import { FoodController } from './food.controller';
import { FoodService } from './food.service';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { Food } from '../platform/db/schema/foods';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const FOOD: Food = {
  id: 1,
  name: 'Chicken Breast',
  serving_unit: 'g',
  serving_size: 100,
  calories: 165,
  protein_grams: 31,
  carbs_grams: 0,
  fat_grams: 3.6,
  fiber_grams: 0,
  is_verified: true,
  is_active: true,
  created_at: new Date(),
  updated_at: null,
};

describe('FoodController', () => {
  let service: Partial<FoodService>;
  let controller: FoodController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({ data: [FOOD], meta: {} }),
      getById: vi.fn().mockResolvedValue(FOOD),
      create: vi.fn().mockResolvedValue(FOOD),
      update: vi.fn().mockResolvedValue(FOOD),
    };
    controller = new FoodController(service as FoodService);
  });

  it('requires diet.read on GET /foods and delegates to the service', async () => {
    expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, FoodController.prototype.list)).toEqual([
      'diet.read',
    ]);

    const query = { q: 'chicken' };
    const result = await controller.list(query, ADMIN_USER);

    expect(service.list).toHaveBeenCalledWith(query, ADMIN_USER);
    expect(result.data).toEqual([FOOD]);
  });

  it('requires diet.create on POST /foods and delegates to the service', async () => {
    expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, FoodController.prototype.create)).toEqual([
      'diet.create',
    ]);

    const dto = { name: 'Chicken Breast', serving_unit: 'g' };
    const result = await controller.create(dto, ADMIN_USER);

    expect(service.create).toHaveBeenCalledWith(dto, ADMIN_USER);
    expect(result).toEqual(FOOD);
  });

  it('requires diet.read on GET /foods/:id and delegates to the service', async () => {
    expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, FoodController.prototype.getById)).toEqual([
      'diet.read',
    ]);

    const result = await controller.getById(1, ADMIN_USER);

    expect(service.getById).toHaveBeenCalledWith(1, ADMIN_USER);
    expect(result).toEqual(FOOD);
  });

  it('requires diet.update on PATCH /foods/:id and delegates to the service', async () => {
    expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, FoodController.prototype.update)).toEqual([
      'diet.update',
    ]);

    const dto = { is_active: false };
    const result = await controller.update(1, dto, ADMIN_USER);

    expect(service.update).toHaveBeenCalledWith(1, dto, ADMIN_USER);
    expect(result).toEqual(FOOD);
  });
});
