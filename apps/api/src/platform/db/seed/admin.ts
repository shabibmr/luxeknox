import type { DrizzleDb } from '../client';
import { users } from '../schema/users';
import { roles } from '../schema/roles';
import { hashPassword } from '../../../auth/password';

/** Documented bootstrap fallback — matches `.env.example` and e2e helpers. */
export const DEFAULT_BOOTSTRAP_EMAIL = 'admin@luxeknox.com';
export const DEFAULT_BOOTSTRAP_PASSWORD = 'AdminSecurePassword123!';

/** Convenience password for non-bootstrap seed users (trainer/member) in development. */
export const DEFAULT_DEV_USER_PASSWORD = '123456';

/**
 * Seeds the default users (admin, trainer, member) idempotently.
 * Bootstrap admin defaults match `.env.example` / e2e when `BOOTSTRAP_*` is unset.
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
          // password_hash is intentionally not updated: re-seeding must not reset a rotated admin password.
          user_type: u.user_type,
          role_id: u.role_id,
          status: u.status,
          updated_at: now,
        },
      });
  }
}

/**
 * Backward compatibility alias for seedUsers.
 */
export const seedAdmin = seedUsers;
