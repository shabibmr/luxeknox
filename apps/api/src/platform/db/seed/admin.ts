import { eq, sql } from 'drizzle-orm';
import * as argon2 from 'argon2';
import type { DrizzleDb } from '../client';
import { users } from '../schema/users';
import { roles } from '../schema/roles';

/**
 * Seeds the bootstrap Super Admin user idempotently.
 *
 * Requirements:
 * - email from process.env.BOOTSTRAP_ADMIN_EMAIL || 'admin@luxeknox.com'
 * - password hashed with argon2 from process.env.BOOTSTRAP_ADMIN_PASSWORD || 'AdminSecurePassword123!'
 * - user_type = 'admin', status = 'active', role_id = super_admin role.
 * - NO employees row created.
 */
export async function seedAdmin(db: DrizzleDb<any>): Promise<void> {
  const email = process.env.BOOTSTRAP_ADMIN_EMAIL || 'admin@luxeknox.com';
  const rawPassword = process.env.BOOTSTRAP_ADMIN_PASSWORD || 'AdminSecurePassword123!';

  // Locate the super_admin role
  const [superAdminRole] = await db
    .select()
    .from(roles)
    .where(eq(roles.slug, 'super_admin'))
    .limit(1);

  if (!superAdminRole) {
    throw new Error('Cannot seed super admin: role "super_admin" does not exist. Seed roles first.');
  }

  // Hash password using argon2 (Argon2id default)
  const passwordHash = await argon2.hash(rawPassword);
  const now = new Date();

  await db
    .insert(users)
    .values({
      email,
      password_hash: passwordHash,
      user_type: 'admin',
      role_id: superAdminRole.id,
      status: 'active',
      created_at: now,
      updated_at: now,
    })
    .onDuplicateKeyUpdate({
      set: {
        password_hash: passwordHash,
        user_type: 'admin',
        role_id: superAdminRole.id,
        status: 'active',
        updated_at: now,
      },
    });
}
