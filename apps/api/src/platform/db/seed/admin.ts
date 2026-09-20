import { eq } from 'drizzle-orm';
import type { DrizzleDb } from '../client';
import { users } from '../schema/users';
import { roles } from '../schema/roles';
import { members, membershipNumberCounters } from '../schema/members';
import { trainers } from '../schema/trainers';
import { hashPassword } from '../../../auth/password';

/** Documented bootstrap fallback — matches `.env.example` and e2e helpers. */
export const DEFAULT_BOOTSTRAP_EMAIL = 'admin@luxeknox.com';

/** Shared development password for all seeded demo accounts (admin/trainer/member). */
export const DEFAULT_DEV_USER_PASSWORD = '123456';

/** @deprecated Prefer {@link DEFAULT_DEV_USER_PASSWORD}; kept as an alias for callers. */
export const DEFAULT_BOOTSTRAP_PASSWORD = DEFAULT_DEV_USER_PASSWORD;

/**
 * Seeds the default users (admin, trainer, member) idempotently.
 * Bootstrap admin defaults match `.env.example` / e2e when `BOOTSTRAP_*` is unset.
 *
 * Set `SEED_RESET_PASSWORDS=1` to also rewrite `password_hash` on re-seed
 * (dev convenience; off by default so rotated credentials are preserved).
 */
export async function seedUsers(db: DrizzleDb<any>): Promise<void> {
  const rawBootstrapPassword = process.env.BOOTSTRAP_ADMIN_PASSWORD;
  if (!rawBootstrapPassword) {
    if (process.env.NODE_ENV === 'production') {
      throw new Error('BOOTSTRAP_ADMIN_PASSWORD must be set when seeding in production.');
    }
    console.warn('[Seed] BOOTSTRAP_ADMIN_PASSWORD unset — using the development default.');
  }

  const adminEmail = process.env.BOOTSTRAP_ADMIN_EMAIL || DEFAULT_BOOTSTRAP_EMAIL;
  const adminPassword = rawBootstrapPassword || DEFAULT_BOOTSTRAP_PASSWORD;
  const defaultPassword = DEFAULT_DEV_USER_PASSWORD;
  const resetPasswords = process.env.SEED_RESET_PASSWORDS === '1';

  const roleRows = await db.select().from(roles);
  const superAdminRole = roleRows.find((r) => r.slug === 'super_admin');
  const trainerRole = roleRows.find((r) => r.slug === 'trainer');
  const memberRole = roleRows.find((r) => r.slug === 'member');

  if (!superAdminRole) {
    throw new Error('Cannot seed users: role "super_admin" does not exist. Seed roles first.');
  }
  if (!trainerRole) {
    throw new Error('Cannot seed users: role "trainer" does not exist. Seed roles first.');
  }
  if (!memberRole) {
    throw new Error('Cannot seed users: role "member" does not exist. Seed roles first.');
  }

  const defaultPasswordHash = await hashPassword(defaultPassword);
  const adminPasswordHash =
    adminPassword === defaultPassword ? defaultPasswordHash : await hashPassword(adminPassword);
  const now = new Date();

  const usersToSeed = [
    {
      email: adminEmail,
      password_hash: adminPasswordHash,
      user_type: 'admin' as const,
      role_id: superAdminRole.id,
      status: 'active' as const,
    },
    {
      email: 'trainer',
      password_hash: defaultPasswordHash,
      user_type: 'trainer' as const,
      role_id: trainerRole.id,
      status: 'active' as const,
    },
    {
      email: 'member',
      password_hash: defaultPasswordHash,
      user_type: 'member' as const,
      role_id: memberRole.id,
      status: 'active' as const,
    },
  ];

  for (const u of usersToSeed) {
    await db
      .insert(users)
      .values({
        ...u,
        created_at: now,
        updated_at: now,
      })
      .onDuplicateKeyUpdate({
        set: {
          // password_hash is omitted unless SEED_RESET_PASSWORDS=1 so re-seeding
          // does not clobber a rotated credential.
          ...(resetPasswords ? { password_hash: u.password_hash } : {}),
          user_type: u.user_type,
          role_id: u.role_id,
          status: u.status,
          updated_at: now,
        },
      });
  }

  await seedDemoProfiles(db, now);
}

/**
 * Ensures demo trainer/member login users have matching PEOPLE profile rows.
 * Super Admin intentionally has no employee profile (FR-AUTH-009).
 */
async function seedDemoProfiles(db: DrizzleDb<any>, now: Date): Promise<void> {
  const allUsers = await db.select().from(users);
  const trainerUser = allUsers.find((u) => u.email === 'trainer' && u.user_type === 'trainer');
  const memberUser = allUsers.find((u) => u.email === 'member' && u.user_type === 'member');

  if (trainerUser) {
    const existing = await db
      .select({ id: trainers.id })
      .from(trainers)
      .where(eq(trainers.user_id, trainerUser.id))
      .limit(1);
    if (!existing[0]) {
      await db.insert(trainers).values({
        user_id: trainerUser.id,
        first_name: 'Demo',
        last_name: 'Trainer',
        bio: 'Seeded demo trainer',
        specializations: ['strength', 'conditioning'],
        hourly_rate: '75.00',
        rating: null,
        max_clients_capacity: 20,
        is_active: true,
        created_at: now,
        updated_at: now,
      });
    }
  }

  if (memberUser) {
    const existing = await db
      .select({ id: members.id })
      .from(members)
      .where(eq(members.user_id, memberUser.id))
      .limit(1);
    if (!existing[0]) {
      // Ensure counter row exists, then allocate one membership_number.
      await db
        .insert(membershipNumberCounters)
        .values({ id: 1, next_value: 1 })
        .onDuplicateKeyUpdate({ set: { id: 1 } });

      const counterRows = await db
        .select()
        .from(membershipNumberCounters)
        .where(eq(membershipNumberCounters.id, 1))
        .limit(1);
      const nextValue = Number(counterRows[0]?.next_value ?? 1);
      const membershipNumber = `M${String(nextValue).padStart(8, '0')}`;

      await db
        .update(membershipNumberCounters)
        .set({ next_value: nextValue + 1 })
        .where(eq(membershipNumberCounters.id, 1));

      await db.insert(members).values({
        user_id: memberUser.id,
        membership_number: membershipNumber,
        first_name: 'Demo',
        last_name: 'Member',
        gender: null,
        date_of_birth: null,
        address: null,
        assigned_trainer_id: null,
        joined_date: now.toISOString().slice(0, 10),
        notes: 'Seeded demo member',
        created_at: now,
        updated_at: now,
      });
    }
  }
}

/**
 * Backward compatibility alias for seedUsers.
 */
export const seedAdmin = seedUsers;
