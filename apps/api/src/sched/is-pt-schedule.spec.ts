import { describe, expect, it } from 'vitest';
import { isPtSchedule } from './is-pt-schedule';

describe('isPtSchedule', () => {
  it('is true when a PT subscription is present', () => {
    expect(isPtSchedule({ pt_subscription_id: 7 })).toBe(true);
  });

  it('is false when the subscription is missing', () => {
    expect(isPtSchedule({ pt_subscription_id: null })).toBe(false);
    expect(isPtSchedule({})).toBe(false);
  });
});
