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
  email: process.env.BOOTSTRAP_ADMIN_EMAIL || 'admin',
  password: process.env.BOOTSTRAP_ADMIN_PASSWORD || '123456',
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

interface ForeignKeyEdge {
  table: string;
  column: string;
  refTable: string;
  refColumn: string;
}

function rowsOf<T>(result: unknown): T[] {
  if (!Array.isArray(result)) return [];
  return (Array.isArray(result[0]) ? result[0] : result) as T[];
}

const ident = (name: string) => sql.raw(`\`${name.replace(/`/g, '``')}\``);

/**
 * Deletes rows of `table` whose `column` is in `values`, first deleting every
 * row that references them (recursively, via the live FK graph).
 */
async function deleteWithDependents(
  db: DrizzleDb<any>,
  edges: ForeignKeyEdge[],
  table: string,
  column: string,
  values: unknown[],
  depth = 0,
): Promise<void> {
  if (values.length === 0) return;
  if (depth > 10) throw new Error(`resetTestData: FK chain too deep at ${table}`);
  const inList = sql.join(
    values.map((v) => sql`${v}`),
    sql`, `,
  );

  for (const edge of edges.filter((e) => e.refTable === table)) {
    const refRows = rowsOf<Record<string, unknown>>(
      await db.execute(
        sql`SELECT DISTINCT ${ident(edge.refColumn)} AS v FROM ${ident(table)} WHERE ${ident(column)} IN (${inList})`,
      ),
    );
    await deleteWithDependents(
      db,
      edges,
      edge.table,
      edge.column,
      refRows.map((r) => r.v).filter((v) => v !== null),
      depth + 1,
    );
  }

  await db.execute(sql`DELETE FROM ${ident(table)} WHERE ${ident(column)} IN (${inList})`);
}

/**
 * Clears per-test rows. Does not touch seeded roles, permissions or settings.
 * audit_logs is intentionally omitted — the app user has no DELETE on it after F-03
 * (it has no FK to users, so it never blocks the cleanup).
 * Every row that transitively references an e2e user is removed first, driven by
 * information_schema so new tables with user/member/trainer FKs are covered.
 */
export async function resetTestData(db: DrizzleDb<any>): Promise<void> {
  const edges = rowsOf<ForeignKeyEdge>(
    await db.execute(sql`
      SELECT TABLE_NAME AS \`table\`, COLUMN_NAME AS \`column\`,
             REFERENCED_TABLE_NAME AS refTable, REFERENCED_COLUMN_NAME AS refColumn
      FROM information_schema.KEY_COLUMN_USAGE
      WHERE TABLE_SCHEMA = DATABASE() AND REFERENCED_TABLE_NAME IS NOT NULL
    `),
  );
  const e2eUsers = rowsOf<{ id: number }>(
    await db.execute(sql`SELECT id FROM users WHERE email LIKE 'e2e_%@luxeknox.test'`),
  );

  await db.execute(sql`DELETE FROM sessions`);
  await deleteWithDependents(
    db,
    edges,
    'users',
    'id',
    e2eUsers.map((u) => u.id),
  );
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
