import { describe, it, expect, vi, beforeEach } from 'vitest';
import { LifestyleIntakeController } from './lifestyle-intake.controller';
import { LifestyleIntakeService } from './lifestyle-intake.service';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { LifestyleIntakeDto, LifestyleIntakePutDto } from './lifestyle-intake.dto';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const SAMPLE_DTO: LifestyleIntakeDto = {
  id: 7,
  member_id: 42,
  activity_level: 'moderate',
  training_history: null,
  current_pain_discomfort: null,
  sleep_hours_typical: '7.5',
  stress_level: 5,
  work_activity_demands: null,
  typical_daily_steps: null,
  nutrition_approach: null,
  hydration_habits: null,
  recovery_habits: null,
  other_notes: null,
  lifestyle_priorities: [
    { priority: 'sleep', current_status: 'ok', first_action: 'earlier bed' },
    { priority: 'nutrition', current_status: 'ok', first_action: 'protein' },
    { priority: 'activity', current_status: 'ok', first_action: 'walk' },
    { priority: 'recovery', current_status: 'ok', first_action: 'stretch' },
  ],
  conducted_by_trainer_id: null,
  created_at: '2026-01-01T00:00:00.000Z',
  updated_at: null,
};

const PUT_BODY: LifestyleIntakePutDto = {
  stress_level: 5,
  lifestyle_priorities: SAMPLE_DTO.lifestyle_priorities!,
};

describe('LifestyleIntakeController', () => {
  let service: Partial<LifestyleIntakeService>;
  let controller: LifestyleIntakeController;

  beforeEach(() => {
    service = {
      get: vi.fn().mockResolvedValue(SAMPLE_DTO),
      put: vi.fn().mockResolvedValue(SAMPLE_DTO),
    };
    controller = new LifestyleIntakeController(service as LifestyleIntakeService);
  });

  it('get_and_put_delegate', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, LifestyleIntakeController.prototype.get),
    ).toEqual(['health.read']);
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, LifestyleIntakeController.prototype.put),
    ).toEqual(['health.lifestyle']);

    const got = await controller.get(42, ADMIN_USER);
    expect(service.get).toHaveBeenCalledWith(42, ADMIN_USER);
    expect(got).toEqual(SAMPLE_DTO);

    const saved = await controller.put(42, PUT_BODY, ADMIN_USER);
    expect(service.put).toHaveBeenCalledWith(42, PUT_BODY, ADMIN_USER);
    expect(saved).toEqual(SAMPLE_DTO);
  });
});
