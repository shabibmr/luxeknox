/** A PT schedule is one with a PT subscription (BR-HEALTH-003). */
export function isPtSchedule(schedule: { pt_subscription_id?: number | null }): boolean {
  return schedule.pt_subscription_id != null;
}
