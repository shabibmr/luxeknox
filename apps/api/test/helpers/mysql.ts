import 'dotenv/config';
import { INestApplication } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { eq, sql } from 'drizzle-orm';
import { AppModule } from '../../src/app.module';
import { DRIZZLE_DB_TOKEN } from '../../src/platform/db/drizzle.module';
import type { DrizzleDb } from '../../src/platform/db/client';
import { users, type User } from '../../src/platform/db/schema/users';
import { roles } from '../../src/platform/db/schema/roles';
import { hashPassword } from '../../src/auth/password';

export interface TestAppInstance {
  app: INestApplication;
  baseUrl: string;
  db: DrizzleDb<any>;
}

export const ADMIN_CREDENTIALS = {
  email: process.env.BOOTSTRAP_ADMIN_EMAIL || 'admin@luxeknox.com',
  password: process.env.BOOTSTRAP_ADMIN_PASSWORD || 'AdminSecurePassword123!',
};

export const MEMBER_CREDENTIALS = {
  email: 'e2e_member@luxeknox.test',
  password: 'MemberSecurePassword123!',
};

export const TRAINER_CREDENTIALS = {
  email: 'e2e_trainer@luxeknox.test',
  password: 'TrainerSecurePassword123!',
};

export const INACTIVE_USER_CREDENTIALS = {
  email: 'e2e_inactive@luxeknox.test',
  password: 'InactiveSecurePassword123!',
};

/**
 * Clears per-test rows. Does not touch seeded roles, permissions or settings.
 * audit_logs is intentionally omitted — the app user has no DELETE on it after F-03.
 */
export async function resetTestData(db: DrizzleDb<any>): Promise<void> {
  await db.execute(sql`DELETE FROM sessions`);
  await db.execute(sql`DELETE FROM users WHERE email LIKE 'e2e_%@luxeknox.test'`);
}

/**
 * Boots up the Nest application in test mode with global prefix 'v1'.
 * Validation is per-route via ZodValidationPipe (no global pipe).
 */
export async function createTestApp(): Promise<TestAppInstance> {
  const app = await NestFactory.create(AppModule, { logger: false });
  app.setGlobalPrefix('v1');

  await app.init();
  await app.listen(0);

  const address = app.getHttpServer().address();
  const port = typeof address === 'string' ? 3000 : address.port;
  const baseUrl = `http://127.0.0.1:${port}/v1`;

  const db = app.get<DrizzleDb<any>>(DRIZZLE_DB_TOKEN);
  await resetTestData(db);

  return { app, baseUrl, db };
}

/**
 * Seeds test users (e.g. member and inactive user) needed for E2E tests.
 */
export async function seedTestUsers(
  db: DrizzleDb<any>,
): Promise<{ member: User; inactive: User; trainer: User }> {
  // 1. Get Member and Trainer role IDs
  const memberRoleRows = await (db as any)
    .select()
    .from(roles)
    .where(eq(roles.slug, 'member'))
    .limit(1);

  const memberRoleId = memberRoleRows[0]?.id ?? 5;

  const trainerRoleRows = await (db as any)
    .select()
    .from(roles)
    .where(eq(roles.slug, 'trainer'))
    .limit(1);

  const trainerRoleId = trainerRoleRows[0]?.id ?? 3;

  const memberPasswordHash = await hashPassword(MEMBER_CREDENTIALS.password);
  const inactivePasswordHash = await hashPassword(INACTIVE_USER_CREDENTIALS.password);
  const trainerPasswordHash = await hashPassword(TRAINER_CREDENTIALS.password);
  const now = new Date();

  // 2. Insert or update member user
  await (db as any)
    .insert(users)
    .values({
      email: MEMBER_CREDENTIALS.email,
      password_hash: memberPasswordHash,
      user_type: 'member',
      role_id: memberRoleId,
      status: 'active',
      created_at: now,
    })
    .onDuplicateKeyUpdate({
      set: {
        password_hash: memberPasswordHash,
        status: 'active',
        role_id: memberRoleId,
        updated_at: now,
      },
    });

  // 3. Insert or update inactive user
  await (db as any)
    .insert(users)
    .values({
      email: INACTIVE_USER_CREDENTIALS.email,
      password_hash: inactivePasswordHash,
      user_type: 'member',
      role_id: memberRoleId,
      status: 'inactive',
      created_at: now,
    })
    .onDuplicateKeyUpdate({
      set: {
        password_hash: inactivePasswordHash,
        status: 'inactive',
        role_id: memberRoleId,
        updated_at: now,
      },
    });

  // 4. Insert or update trainer user
  await (db as any)
    .insert(users)
    .values({
      email: TRAINER_CREDENTIALS.email,
      password_hash: trainerPasswordHash,
      user_type: 'trainer',
      role_id: trainerRoleId,
      status: 'active',
      created_at: now,
    })
    .onDuplicateKeyUpdate({
      set: {
        password_hash: trainerPasswordHash,
        status: 'active',
        role_id: trainerRoleId,
        updated_at: now,
      },
    });

  const memberRows = await (db as any)
    .select()
    .from(users)
    .where(eq(users.email, MEMBER_CREDENTIALS.email))
    .limit(1);

  const inactiveRows = await (db as any)
    .select()
    .from(users)
    .where(eq(users.email, INACTIVE_USER_CREDENTIALS.email))
    .limit(1);

  const trainerRows = await (db as any)
    .select()
    .from(users)
    .where(eq(users.email, TRAINER_CREDENTIALS.email))
    .limit(1);

  return { member: memberRows[0], inactive: inactiveRows[0], trainer: trainerRows[0] };
}
