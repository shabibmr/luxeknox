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

export interface ForeignKeyEdge {
  child: string;
  child_columns: string[];
  parent: string;
  parent_columns: string[];
  is_self_referencing: boolean;
  conname?: string;
  child_column: string;
  parent_column: string;
}

export class ForeignKeyGraph extends Map<string, ForeignKeyEdge[]> {
  public allTables: string[] = [];
  public edges: ForeignKeyEdge[] = [];
  public topologicalOrder: string[] = [];
  public selfReferencingEdges: ForeignKeyEdge[] = [];
}

/**
 * System and seed tables that must be preserved during test data resets.
 * audit_logs is intentionally omitted — the app user has no DELETE on it after F-03.
 */
export const SYSTEM_TABLES = new Set<string>([
  '__drizzle_migrations',
  'audit_logs',
  'roles',
  'permissions',
  'role_permissions',
  'gym_settings',
  'notification_types',
  'invoice_number_counters',
  'membership_number_counters',
  'receipt_number_counters',
]);

export const SEEDED_USER_EMAILS = [
  ADMIN_CREDENTIALS.email,
  'admin@luxeknox.com',
  'trainer',
  'member',
];

/**
 * Strips schema qualifiers like 'public.' and quotes from table names.
 */
function cleanTableName(name: string): string {
  return name.replace(/^public\./, '').replace(/"/g, '');
}

/**
 * Reads foreign key constraints and table dependencies directly from the PostgreSQL
 * catalogue. Computes a topological sort (reverse topological order: dependents/children first,
 * root parents last) so cleanup cannot suffer foreign key constraint violations.
 * Correctly handles multi-column (compound) foreign keys, self-referential relations,
 * and deep cascade chains (PG-48 / HARDEN-03).
 */
export async function loadForeignKeyGraph(db: DrizzleDb<any>): Promise<ForeignKeyGraph> {
  const tablesResult: any = await db.execute(sql`
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
    ORDER BY table_name
  `);
  const allTables: string[] = (tablesResult.rows ?? []).map((r: any) => cleanTableName(r.table_name));

  const fkResult: any = await db.execute(sql`
    SELECT c.conname,
           c.conrelid::regclass::text AS child,
           c.confrelid::regclass::text AS parent,
           json_agg(ca.attname ORDER BY u.ord) AS child_columns,
           json_agg(pa.attname ORDER BY u.ord) AS parent_columns
    FROM pg_constraint c
    CROSS JOIN LATERAL unnest(c.conkey, c.confkey) WITH ORDINALITY AS u(attnum, fattnum, ord)
    JOIN pg_attribute ca ON ca.attrelid = c.conrelid AND ca.attnum = u.attnum
    JOIN pg_attribute pa ON pa.attrelid = c.confrelid AND pa.attnum = u.fattnum
    WHERE c.contype = 'f'
    GROUP BY c.oid, c.conname, c.conrelid, c.confrelid
  `);

  const inDegree = new Map<string, number>();
  const parentToChildren = new Map<string, Set<string>>();
  const childToParents = new Map<string, Set<string>>();

  for (const t of allTables) {
    inDegree.set(t, 0);
    parentToChildren.set(t, new Set());
    childToParents.set(t, new Set());
  }

  const allEdges: ForeignKeyEdge[] = [];
  const selfRefEdges: ForeignKeyEdge[] = [];

  for (const row of (fkResult.rows ?? []) as any[]) {
    const child = cleanTableName(row.child);
    const parent = cleanTableName(row.parent);
    const childCols: string[] = Array.isArray(row.child_columns) ? row.child_columns : [row.child_columns];
    const parentCols: string[] = Array.isArray(row.parent_columns) ? row.parent_columns : [row.parent_columns];
    const isSelf = child === parent;

    const edge: ForeignKeyEdge = {
      conname: row.conname,
      child,
      parent,
      child_columns: childCols,
      parent_columns: parentCols,
      is_self_referencing: isSelf,
      child_column: childCols[0],
      parent_column: parentCols[0],
    };

    allEdges.push(edge);
    if (isSelf) {
      selfRefEdges.push(edge);
      continue;
    }

    if (allTables.includes(child) && allTables.includes(parent)) {
      if (!childToParents.get(child)!.has(parent)) {
        childToParents.get(child)!.add(parent);
        parentToChildren.get(parent)!.add(child);
      }
    }
  }

  // Calculate in-degree for deletion (number of child tables referencing table)
  for (const t of allTables) {
    inDegree.set(t, parentToChildren.get(t)!.size);
  }

  // Kahn's algorithm: tables with inDegree 0 have no children referencing them (leaves).
  // They can be deleted/truncated first without violating FK constraints.
  const queue: string[] = [];
  for (const [t, deg] of inDegree.entries()) {
    if (deg === 0) {
      queue.push(t);
    }
  }

  const topologicalOrder: string[] = [];
  while (queue.length > 0) {
    const node = queue.shift()!;
    topologicalOrder.push(node);

    for (const p of childToParents.get(node) ?? []) {
      const newDeg = inDegree.get(p)! - 1;
      inDegree.set(p, newDeg);
      if (newDeg === 0) {
        queue.push(p);
      }
    }
  }

  // If any unvisited tables remain, append them safely
  for (const t of allTables) {
    if (!topologicalOrder.includes(t)) {
      topologicalOrder.push(t);
    }
  }

  const topoRank = new Map<string, number>();
  topologicalOrder.forEach((t, i) => topoRank.set(t, i));

  const graph = new ForeignKeyGraph();
  graph.allTables = allTables;
  graph.edges = allEdges;
  graph.topologicalOrder = topologicalOrder;
  graph.selfReferencingEdges = selfRefEdges;

  for (const edge of allEdges) {
    if (edge.is_self_referencing) continue;
    const edges = graph.get(edge.parent) ?? [];
    edges.push(edge);
    graph.set(edge.parent, edges);
  }

  // Sort child edges by topological rank so deeper dependents are purged first
  for (const [, edges] of graph.entries()) {
    edges.sort((a, b) => (topoRank.get(a.child) ?? 999) - (topoRank.get(b.child) ?? 999));
  }

  return graph;
}

/**
 * Deletes rows matching `where` from `table`, children first, following the FK graph.
 * Handles single and compound foreign keys, self-referential cycles, and deep cascade chains.
 */
export async function purge(
  db: DrizzleDb<any>,
  graph: ForeignKeyGraph,
  table: string,
  where: string,
  visited = new Set<string>(),
): Promise<void> {
  const visitKey = `${table}:${where}`;
  if (visited.has(visitKey)) {
    return;
  }
  visited.add(visitKey);

  // Traverse child tables in topological order (deeper children first)
  for (const edge of graph.get(table) ?? []) {
    if (edge.is_self_referencing || edge.child === table) {
      continue;
    }

    let childWhere: string;
    if (edge.child_columns.length === 1 && edge.parent_columns.length === 1) {
      childWhere = `"${edge.child_columns[0]}" IN (SELECT "${edge.parent_columns[0]}" FROM "${table}" WHERE ${where})`;
    } else {
      const childCols = edge.child_columns.map((c) => `"${c}"`).join(', ');
      const parentCols = edge.parent_columns.map((c) => `"${c}"`).join(', ');
      childWhere = `(${childCols}) IN (SELECT ${parentCols} FROM "${table}" WHERE ${where})`;
    }

    await purge(db, graph, edge.child, childWhere, visited);
  }

  // Null out any self-referential relations before deleting from the table
  const selfEdges = graph.selfReferencingEdges.filter((e) => e.child === table);
  for (const edge of selfEdges) {
    for (const col of edge.child_columns) {
      await db.execute(sql.raw(`UPDATE "${table}" SET "${col}" = NULL WHERE ${where}`));
    }
  }

  await db.execute(sql.raw(`DELETE FROM "${table}" WHERE ${where}`));
}

/**
 * Clears per-test rows in reverse topological order (leaves/dependents first, root tables last).
 * Does not touch seeded roles, permissions or settings.
 * audit_logs is intentionally omitted — the app user has no DELETE on it after F-03.
 *
 * Traverses the complete catalogue foreign-key DAG to ensure zero FK constraint violations
 * during test teardowns and isolation resets (HARDEN-03).
 */
export async function resetTestData(db: DrizzleDb<any>): Promise<void> {
  const graph = await loadForeignKeyGraph(db);

  for (const table of graph.topologicalOrder) {
    if (SYSTEM_TABLES.has(table)) {
      continue;
    }

    // Break any self-referential foreign keys before deleting
    const selfEdges = graph.selfReferencingEdges.filter((e) => e.child === table);
    for (const edge of selfEdges) {
      for (const col of edge.child_columns) {
        await db.execute(sql.raw(`UPDATE "${table}" SET "${col}" = NULL`));
      }
    }

    if (table === 'users') {
      const preserved = SEEDED_USER_EMAILS.map((e) => `'${e.replace(/'/g, "''")}'`).join(', ');
      await db.execute(sql.raw(`DELETE FROM "users" WHERE "email" NOT IN (${preserved})`));
    } else if (table === 'trainers') {
      const preserved = SEEDED_USER_EMAILS.map((e) => `'${e.replace(/'/g, "''")}'`).join(', ');
      await db.execute(
        sql.raw(`
          DELETE FROM "trainers"
          WHERE "user_id" NOT IN (SELECT "id" FROM "users" WHERE "email" IN (${preserved}))
             OR "user_id" IS NULL
        `),
      );
    } else if (table === 'members') {
      const preserved = SEEDED_USER_EMAILS.map((e) => `'${e.replace(/'/g, "''")}'`).join(', ');
      await db.execute(
        sql.raw(`
          DELETE FROM "members"
          WHERE "user_id" NOT IN (SELECT "id" FROM "users" WHERE "email" IN (${preserved}))
             OR "user_id" IS NULL
        `),
      );
    } else {
      await db.execute(sql.raw(`DELETE FROM "${table}"`));
    }
  }
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
    .onConflictDoUpdate({
      target: users.email,
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
    .onConflictDoUpdate({
      target: users.email,
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
    .onConflictDoUpdate({
      target: users.email,
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
