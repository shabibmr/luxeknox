import { describe, it, expect, vi, beforeEach } from 'vitest';
import { DietPlanController } from './diet-plan.controller';
import { DietPlanService } from './diet-plan.service';
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

describe('DietPlanController', () => {
  let service: Partial<DietPlanService>;
  let controller: DietPlanController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({ data: [], meta: {} }),
      getById: vi.fn().mockResolvedValue({ id: 10, title: 'Diet Plan' }),
      create: vi.fn().mockResolvedValue({ id: 10, title: 'Diet Plan' }),
      update: vi.fn().mockResolvedValue({ id: 10, title: 'Updated' }),
      publish: vi.fn().mockResolvedValue({ id: 10, status: 'active' }),
      archive: vi.fn().mockResolvedValue({ id: 10, status: 'archived' }),
      assign: vi.fn().mockResolvedValue({ id: 11, status: 'active' }),
      listVersions: vi.fn().mockResolvedValue({ data: [], meta: {} }),
      replaceMeals: vi.fn().mockResolvedValue({ id: 10, current_version: { version_number: 2 } }),
    };
    controller = new DietPlanController(service as DietPlanService);
  });

  it('requires diets.read on GET /diet-plans and delegates to service', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, DietPlanController.prototype.list),
    ).toEqual(['diets.read']);

    const query = { is_template: 'true' };
    const result = await controller.list(query, ADMIN_USER);

    expect(service.list).toHaveBeenCalledWith(query, { is_template: true }, ADMIN_USER);
    expect(result.data).toEqual([]);
  });

  it('requires diets.write on POST /diet-plans and delegates to service', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, DietPlanController.prototype.create),
    ).toEqual(['diets.write']);

    const dto = { title: 'Keto Plan', is_template: false };
    const result = await controller.create(dto, ADMIN_USER);

    expect(service.create).toHaveBeenCalledWith(dto, ADMIN_USER);
    expect(result.id).toBe(10);
  });

  it('requires diets.read on GET /diet-plans/:id and delegates to service', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, DietPlanController.prototype.getById),
    ).toEqual(['diets.read']);

    const result = await controller.getById(10, ADMIN_USER);
    expect(service.getById).toHaveBeenCalledWith(10, ADMIN_USER);
    expect(result.id).toBe(10);
  });

  it('requires diets.write on POST /diet-plans/:id/publish', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, DietPlanController.prototype.publish),
    ).toEqual(['diets.write']);

    const result = await controller.publish(10, ADMIN_USER);
    expect(service.publish).toHaveBeenCalledWith(10, ADMIN_USER);
    expect(result.status).toBe('active');
  });

  it('requires diets.write on POST /diet-plans/:id/assign', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, DietPlanController.prototype.assign),
    ).toEqual(['diets.write']);

    const dto = { member_id: 30 };
    const result = await controller.assign(5, dto, ADMIN_USER);
    expect(service.assign).toHaveBeenCalledWith(5, dto, ADMIN_USER);
    expect(result.id).toBe(11);
  });

  it('requires diets.write on PUT /diet-plans/:id/meals', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, DietPlanController.prototype.replaceMeals),
    ).toEqual(['diets.write']);

    const dto = {
      changelog: 'v2 update',
      meals: [
        {
          meal_name: 'Breakfast',
          scheduled_time: '08:00',
        },
      ],
    };
    const result = await controller.replaceMeals(10, dto as any, ADMIN_USER);
    expect(service.replaceMeals).toHaveBeenCalledWith(10, dto, ADMIN_USER);
    expect(result.current_version?.version_number).toBe(2);
  });
});
