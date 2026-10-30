import { describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { ParQController } from './par-q.controller';
import { parQSubmitSchema } from './dto/par-q.dto';
import { ParQService } from './par-q.service';

const ADMIN: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const SIGNATURE = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAAB';

const SCREENING = {
  id: 5,
  member_id: 100,
  version: '2024.1',
  q1_heart_condition: false,
  q1_details: null,
  q2_chest_pain_activity: false,
  q2_details: null,
  q3_chest_pain_rest: false,
  q3_details: null,
  q4_dizziness_consciousness: false,
  q4_details: null,
  q5_bone_joint_problem: false,
  q5_details: null,
  q6_medication_condition: false,
  q6_details: null,
  q7_other_reason: false,
  q7_details: null,
  has_positive_answer: false,
  trainer_screening_notes: null,
  referral_required: false,
  referral_reason: null,
  declaration_accepted: true,
  client_signature: SIGNATURE,
  client_signed_at: '2026-01-01T00:00:00.000Z',
  trainer_signed_at: null,
  clearance_status: 'passed' as const,
  cleared_at: null,
  cleared_by_user_id: null,
  created_at: '2026-01-01T00:00:00.000Z',
  updated_at: null,
};

describe('ParQController', () => {
  it('round-trips the member signature on submit and latest read', async () => {
    const service = {
      submit: vi.fn().mockResolvedValue(SCREENING),
      getLatest: vi.fn().mockResolvedValue(SCREENING),
    };
    const controller = new ParQController(service as unknown as ParQService);
    const dto = parQSubmitSchema.parse({
      q1_heart_condition: false,
      q2_chest_pain_activity: false,
      q3_chest_pain_rest: false,
      q4_dizziness_consciousness: false,
      q5_bone_joint_problem: false,
      q6_medication_condition: false,
      q7_other_reason: false,
      declaration_accepted: true,
      client_signature: SIGNATURE,
    });

    const submitted = await controller.submit(100, dto, ADMIN);
    const latest = await controller.getLatest(100, ADMIN);

    expect(service.submit).toHaveBeenCalledWith(100, dto, ADMIN);
    expect(submitted.client_signature).toBe(SIGNATURE);
    expect(latest.client_signature).toBe(SIGNATURE);
  });

  it('requires health.lifestyle to submit and health.read to read latest', () => {
    expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ParQController.prototype.submit)).toEqual([
      'health.lifestyle',
    ]);
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ParQController.prototype.getLatest),
    ).toEqual(['health.read']);
  });
});
