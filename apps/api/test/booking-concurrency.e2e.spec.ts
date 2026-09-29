import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { sql } from 'drizzle-orm';
import { createTestApp, resetTestData, type TestAppInstance } from './helpers/postgres';
import { BookingService } from '../src/sched/booking.service';
import { users } from '../src/platform/db/schema/users';
import { roles } from '../src/platform/db/schema/roles';
import { members } from '../src/platform/db/schema/members';
import { scheduleTypes, schedules, scheduleParticipants } from '../src/platform/db/schema/scheduling';
import { hashPassword } from '../src/auth/password';
import type { AuthenticatedUser } from '../src/auth/auth.guard';

const RUN_ID = Date.now();

/**
 * SCH-019 — proves last-seat booking is race-safe under real concurrent DB connections.
 *
 * Two members attempt to book the same schedule at the same instant when only one seat
 * remains. A check-then-insert race (SELECT COUNT(*) then INSERT with no row lock) would
 * let both connections read "1 seat left" under MySQL's default REPEATABLE READ isolation
 * and both insert a 'booked' participant, overbooking the schedule. This test asserts
 * exactly one booking lands as 'booked' and the other as 'waitlisted'.
 */
describe('Booking concurrency E2E (SCH-019)', () => {
  let testApp: TestAppInstance;
  let bookingService: BookingService;
  let userAId: number;
  let userBId: number;
  let memberAId: number;
  let memberBId: number;
  let scheduleId: number;

  beforeAll(async () => {
    testApp = await createTestApp();
    bookingService = testApp.app.get(BookingService);

    const db = testApp.db as any;

    const memberRoleRows = await db.select().from(roles).where(sql`${roles.slug} = 'member'`).limit(1);
    const memberRoleId = memberRoleRows[0]?.id ?? 5;

    const passwordHash = await hashPassword('ConcurrentSecurePassword123!');
    const now = new Date();

    async function createMember(email: string, membershipNumber: string): Promise<{ userId: number; memberId: number }> {
      const userInsert = await db.insert(users).values({
        email,
        password_hash: passwordHash,
        user_type: 'member',
        role_id: memberRoleId,
        status: 'active',
        created_at: now,
      }).returning({ id: users.id });
      const userId = userInsert[0].id;

      const memberInsert = await db.insert(members).values({
        user_id: userId,
        membership_number: membershipNumber,
        first_name: 'Concurrent',
        last_name: 'Tester',
        joined_date: now.toISOString().slice(0, 10),
        created_at: now,
      }).returning({ id: members.id });
      return { userId, memberId: memberInsert[0].id };
    }

    ({ userId: userAId, memberId: memberAId } = await createMember(`e2e_race_a_${RUN_ID}@luxeknox.test`, `RACEA${RUN_ID}`.slice(0, 16)));
    ({ userId: userBId, memberId: memberBId } = await createMember(`e2e_race_b_${RUN_ID}@luxeknox.test`, `RACEB${RUN_ID}`.slice(0, 16)));

    const typeInsert = await db.insert(scheduleTypes).values({
      name: `Race Test Type ${RUN_ID}`,
      default_duration_minutes: 60,
      requires_trainer: false,
      created_at: now,
    }).returning({ id: scheduleTypes.id });
    const scheduleTypeId = typeInsert[0].id;

    const start = new Date(Date.now() + 24 * 60 * 60_000);
    const end = new Date(start.getTime() + 60 * 60_000);

    const scheduleInsert = await db.insert(schedules).values({
      schedule_type_id: scheduleTypeId,
      title: `Race Test Schedule ${RUN_ID}`,
      start_time: start,
      end_time: end,
      max_capacity: 1,
      status: 'scheduled',
      row_version: 1,
      created_at: now,
    }).returning({ id: schedules.id });
    scheduleId = scheduleInsert[0].id;
  });

  afterAll(async () => {
    if (testApp?.db) {
      await resetTestData(testApp.db);
    }
    if (testApp?.app) {
      await testApp.app.close();
    }
  });

  it('only books one member when two concurrent requests race for the last seat', async () => {
    function actorFor(userId: number, memberId: number): AuthenticatedUser {
      return {
        id: userId,
        email: `race-${memberId}@luxeknox.test`,
        phoneNumber: null,
        roleId: 2,
        userType: 'member',
        profileId: memberId,
        sessionId: 1,
      };
    }

    const [resultA, resultB] = await Promise.allSettled([
      bookingService.book(scheduleId, {}, actorFor(userAId, memberAId)),
      bookingService.book(scheduleId, {}, actorFor(userBId, memberBId)),
    ]);

    const outcomes = [resultA, resultB]
      .filter((r): r is PromiseFulfilledResult<Awaited<ReturnType<typeof bookingService.book>>> => r.status === 'fulfilled')
      .map((r) => r.value.booking_status);

    // Both requests must succeed as bookings (no exception raised for a legitimate
    // first-come booking or waitlist), but never both as 'booked'.
    expect(outcomes).toHaveLength(2);
    const bookedCount = outcomes.filter((status) => status === 'booked').length;
    const waitlistedCount = outcomes.filter((status) => status === 'waitlisted').length;
    expect(bookedCount).toBe(1);
    expect(waitlistedCount).toBe(1);

    const db = testApp.db as any;
    const rows = await db
      .select()
      .from(scheduleParticipants)
      .where(sql`${scheduleParticipants.schedule_id} = ${scheduleId} AND ${scheduleParticipants.booking_status} = 'booked'`);
    expect(rows.length).toBe(1);
  });
});
