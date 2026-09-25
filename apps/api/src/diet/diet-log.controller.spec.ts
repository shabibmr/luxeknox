import { describe, it, expect, vi, beforeEach } from 'vitest';
import { DietLogController } from './diet-log.controller';
import { DietLogService } from './diet-log.service';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';

const MEMBER_USER: AuthenticatedUser = {
  id: 3,
  email: 'member@luxeknox.test',
  phoneNumber: null,
  userType: 'member',
  roleId: 3,
  profileId: 30,
  sessionId: 3,
};

describe('DietLogController', () => {
  let service: Partial<DietLogService>;
  let controller: DietLogController;

  beforeEach(() => {
    service = {
      putLog: vi.fn().mockResolvedValue({ id: 1, logged_date: '2026-09-21' }),
      listLogs: vi.fn().mockResolvedValue({ data: [], meta: {} }),
    };
    controller = new DietLogController(service as DietLogService);
  });

  it('requires diets.write on PUT /members/:id/diet-logs/:date and delegates to service', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, DietLogController.prototype.putLog),
    ).toEqual(['diets.write']);

    const dto = { total_calories_consumed: 2100 };
    const result = await controller.putLog(30, '2026-09-21', dto as any, MEMBER_USER);

    expect(service.putLog).toHaveBeenCalledWith(30, '2026-09-21', dto, MEMBER_USER);
    expect(result.id).toBe(1);
  });

  it('requires diets.read on GET /members/:id/diet-logs and delegates to service', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, DietLogController.prototype.listLogs),
    ).toEqual(['diets.read']);

    const query = { from: '2026-09-01', to: '2026-09-30' };
    const result = await controller.listLogs(30, query, MEMBER_USER);

    expect(service.listLogs).toHaveBeenCalledWith(
      30,
      query,
      { from: '2026-09-01', to: '2026-09-30' },
      MEMBER_USER,
    );
    expect(result.data).toEqual([]);
  });
});
