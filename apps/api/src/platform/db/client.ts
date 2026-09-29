import { Pool, type PoolConfig, types } from 'pg';
import { drizzle, type NodePgDatabase } from 'drizzle-orm/node-postgres';
import * as schema from './schema';

// Decision 4 (ADR-0009): node-postgres returns int8 (OID 20) — every PK/FK/count() in this
// schema — as a string by default, to avoid silent precision loss above Number.MAX_SAFE_INTEGER
// (2^53). This schema's ids are nowhere near that bound, so we register a global parser to get
// back the ergonomic `number` type Drizzle's `bigint({ mode: 'number' })` already assumes on
// typed selects (raw `db.execute()` results and some aggregate paths bypass that cast otherwise).
// `numeric` (OID 1700, e.g. trainers.hourly_rate) is deliberately left as a string — Money must
// never become a float (FR-API-005).
types.setTypeParser(20, (value: string) => Number(value));

export interface DatabaseConfig extends PoolConfig {
  connectionLimit?: number;
}

function requireEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

function parseNumberEnv(val: string | undefined): number | undefined {
  if (val === undefined || val.trim() === '') return undefined;
  const num = Number(val);
  return Number.isNaN(num) ? undefined : num;
}

export function resolveSsl(optionsSsl?: PoolConfig['ssl']): PoolConfig['ssl'] {
  if (optionsSsl !== undefined) {
    if (typeof optionsSsl === 'boolean') {
      if (!optionsSsl) return false;
      return {
        rejectUnauthorized: process.env.DB_SSL_REJECT_UNAUTHORIZED !== 'false',
      };
    }
    return optionsSsl;
  }
  const dbSsl = process.env.DB_SSL;
  if (dbSsl === 'true' || dbSsl === '1') {
    return {
      rejectUnauthorized: process.env.DB_SSL_REJECT_UNAUTHORIZED !== 'false',
    };
  }
  return undefined;
}

// Sets the session `timezone` to UTC via the libpq startup packet on every new connection, so
// `now()`-rendered output and any future non-TIMESTAMPTZ column stay UTC (ADR-0009), even
// though TIMESTAMPTZ storage is offset-correct regardless of session timezone. Deliberately
// not a `pool.on('connect', client => client.query(...))` handler: that fires an unawaited
// query concurrently with whatever query the caller runs on the same freshly-connected client,
// which node-postgres logs as "Calling client.query() when the client is already executing a
// query" — a real race, not just a cosmetic warning.
export const SESSION_OPTIONS = '-c timezone=UTC';

export const DEFAULT_CONNECTION_TIMEOUT_MS = 5000;
export const DEFAULT_IDLE_TIMEOUT_MS = 30000;
export const DEFAULT_POOL_MAX = 20;
export const DEFAULT_STATEMENT_TIMEOUT_MS = 15000;

/**
 * Creates a PostgreSQL connection pool using node-postgres.
 */
export function createConnectionPool(options: PoolConfig | DatabaseConfig | string = {}): Pool {
  const parsedOptions: DatabaseConfig =
    typeof options === 'string' ? { connectionString: options } : { ...options };

  const connectionTimeoutMillis =
    parsedOptions.connectionTimeoutMillis ??
    parseNumberEnv(process.env.DB_CONNECTION_TIMEOUT_MS) ??
    DEFAULT_CONNECTION_TIMEOUT_MS;

  const idleTimeoutMillis =
    parsedOptions.idleTimeoutMillis ?? DEFAULT_IDLE_TIMEOUT_MS;

  const max =
    parsedOptions.max ??
    parsedOptions.connectionLimit ??
    parseNumberEnv(process.env.DB_POOL_MAX) ??
    DEFAULT_POOL_MAX;

  let statementTimeout = parsedOptions.statement_timeout;
  if (statementTimeout === undefined && parsedOptions.options) {
    const match = parsedOptions.options.match(/statement_timeout=(\d+)/);
    if (match) {
      statementTimeout = Number(match[1]);
    }
  }
  if (statementTimeout === undefined) {
    statementTimeout =
      parseNumberEnv(process.env.DB_STATEMENT_TIMEOUT_MS) ?? DEFAULT_STATEMENT_TIMEOUT_MS;
  }

  const ssl = resolveSsl(parsedOptions.ssl);

  if (
    parsedOptions.connectionString ||
    (process.env.DATABASE_URL && !parsedOptions.host && !parsedOptions.user)
  ) {
    const poolOptions: PoolConfig = {
      ...parsedOptions,
      connectionString: parsedOptions.connectionString || process.env.DATABASE_URL,
      max,
      connectionTimeoutMillis,
      idleTimeoutMillis,
      statement_timeout: statementTimeout,
      options: parsedOptions.options ?? SESSION_OPTIONS,
    };
    if (ssl !== undefined) {
      poolOptions.ssl = ssl;
    }
    return new Pool(poolOptions);
  }

  const poolOptions: PoolConfig = {
    ...parsedOptions,
    host: parsedOptions.host || process.env.DB_HOST || '127.0.0.1',
    port: parsedOptions.port ?? (Number(process.env.DB_PORT) || 5432),
    user: parsedOptions.user || requireEnv('DB_USER'),
    password: parsedOptions.password || requireEnv('DB_PASSWORD'),
    database: parsedOptions.database || process.env.DB_NAME || 'luxeknox',
    max,
    connectionTimeoutMillis,
    idleTimeoutMillis,
    statement_timeout: statementTimeout,
    options: parsedOptions.options ?? SESSION_OPTIONS,
  };
  if (ssl !== undefined) {
    poolOptions.ssl = ssl;
  }
  return new Pool(poolOptions);
}

/**
 * Creates a PostgreSQL connection pool authenticated as the DDL-privileged admin user.
 * Used only by migrations/grants — never by the running API — and always connects
 * explicitly (bypassing `DATABASE_URL`) so it can never silently fall back to the
 * least-privilege app user.
 */
export function createAdminConnectionPool(): Pool {
  return createConnectionPool({
    host: process.env.DB_HOST || '127.0.0.1',
    port: Number(process.env.DB_PORT) || 5432,
    user: requireEnv('DB_ADMIN_USER'),
    password: requireEnv('DB_ADMIN_PASSWORD'),
    database: process.env.DB_NAME || 'luxeknox',
  });
}

export type AppSchema = typeof schema;
export type DrizzleDb<TSchema extends Record<string, unknown> = AppSchema> = NodePgDatabase<TSchema>;

/**
 * Creates a Drizzle database instance backed by a node-postgres connection pool.
 *
 * @param pool node-postgres connection pool
 * @param schema Optional Drizzle schema mapping
 */
export function createDrizzleClient<TSchema extends Record<string, unknown> = AppSchema>(
  pool: Pool,
  schema?: TSchema,
): DrizzleDb<TSchema> {
  if (schema) {
    return drizzle(pool, { schema });
  }
  return drizzle(pool) as unknown as DrizzleDb<TSchema>;
}

export interface LeastPrivilegeReport {
  currentUser: string;
  isSuperuser: boolean;
  hasSchemaCreate: boolean;
  ownedTablesCount: number;
  auditHasUpdate: boolean;
  auditHasDelete: boolean;
  auditHasTruncate: boolean;
  violations: string[];
}

/**
 * Inspects the database session and catalog to report on least-privilege compliance:
 * - Connected user is not a superuser
 * - Connected user has no CREATE privilege on schema public (DDL boundary)
 * - Connected user owns 0 tables in schema public (preventing DROP / ALTER TABLE)
 * - audit_logs has UPDATE, DELETE, and TRUNCATE revoked (append-only immutability)
 */
export async function checkLeastPrivilege(pool: Pool): Promise<LeastPrivilegeReport> {
  const result = await pool.query<{
    currentUser: string;
    isSuperuser: string;
    hasSchemaCreate: boolean;
    ownedTablesCount: number;
    auditHasUpdate: boolean;
    auditHasDelete: boolean;
    auditHasTruncate: boolean;
  }>(`
    SELECT
      current_user AS "currentUser",
      current_setting('is_superuser') AS "isSuperuser",
      has_schema_privilege(current_user, 'public', 'CREATE') AS "hasSchemaCreate",
      (SELECT count(*)::int FROM pg_tables WHERE schemaname = 'public' AND tableowner = current_user) AS "ownedTablesCount",
      (SELECT coalesce(bool_or(has_table_privilege(current_user, 'public.audit_logs', 'UPDATE')), false)
       FROM pg_tables WHERE schemaname = 'public' AND tablename = 'audit_logs') AS "auditHasUpdate",
      (SELECT coalesce(bool_or(has_table_privilege(current_user, 'public.audit_logs', 'DELETE')), false)
       FROM pg_tables WHERE schemaname = 'public' AND tablename = 'audit_logs') AS "auditHasDelete",
      (SELECT coalesce(bool_or(has_table_privilege(current_user, 'public.audit_logs', 'TRUNCATE')), false)
       FROM pg_tables WHERE schemaname = 'public' AND tablename = 'audit_logs') AS "auditHasTruncate"
  `);

  const row = result.rows[0];
  const violations: string[] = [];

  const currentUser = row?.currentUser ?? 'unknown';
  const isSuperuser = row?.isSuperuser === 'on';
  const hasSchemaCreate = Boolean(row?.hasSchemaCreate);
  const ownedTablesCount = Number(row?.ownedTablesCount ?? 0);
  const auditHasUpdate = Boolean(row?.auditHasUpdate);
  const auditHasDelete = Boolean(row?.auditHasDelete);
  const auditHasTruncate = Boolean(row?.auditHasTruncate);

  if (isSuperuser) {
    violations.push(`connected user '${currentUser}' is a superuser`);
  }
  if (hasSchemaCreate) {
    violations.push(`user '${currentUser}' has CREATE privilege on schema public (DDL boundary violation)`);
  }
  if (ownedTablesCount > 0) {
    violations.push(`user '${currentUser}' owns ${ownedTablesCount} table(s) in schema public (DDL boundary violation)`);
  }
  if (auditHasUpdate || auditHasDelete || auditHasTruncate) {
    const mutPrivs = [
      auditHasUpdate && 'UPDATE',
      auditHasDelete && 'DELETE',
      auditHasTruncate && 'TRUNCATE',
    ]
      .filter(Boolean)
      .join(', ');
    violations.push(`user '${currentUser}' has mutating privilege on audit_logs (${mutPrivs}; violates append-only immutability)`);
  }

  return {
    currentUser,
    isSuperuser,
    hasSchemaCreate,
    ownedTablesCount,
    auditHasUpdate,
    auditHasDelete,
    auditHasTruncate,
    violations,
  };
}

/**
 * Lightweight verification function to confirm database connection adheres to least privilege:
 * - App user is not a superuser
 * - App user has no CREATE privilege on schema public (DDL boundary)
 * - App user does not own any tables in schema public (cannot ALTER or DROP tables)
 * - audit_logs maintains append-only immutability (UPDATE, DELETE, TRUNCATE are revoked)
 *
 * Throws an Error if any least-privilege boundary is violated.
 */
export async function verifyLeastPrivilege(pool: Pool): Promise<void> {
  const report = await checkLeastPrivilege(pool);
  if (report.violations.length > 0) {
    throw new Error(`Least-privilege verification failed: ${report.violations.join('; ')}`);
  }
}

