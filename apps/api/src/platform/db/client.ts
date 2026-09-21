import { Pool, type PoolConfig, types } from 'pg';
import { drizzle, type NodePgDatabase } from 'drizzle-orm/node-postgres';

// Decision 4 (ADR-0009): node-postgres returns int8 (OID 20) — every PK/FK/count() in this
// schema — as a string by default, to avoid silent precision loss above Number.MAX_SAFE_INTEGER
// (2^53). This schema's ids are nowhere near that bound, so we register a global parser to get
// back the ergonomic `number` type Drizzle's `bigint({ mode: 'number' })` already assumes on
// typed selects (raw `db.execute()` results and some aggregate paths bypass that cast otherwise).
// `numeric` (OID 1700, e.g. trainers.hourly_rate) is deliberately left as a string — Money must
// never become a float (FR-API-005).
types.setTypeParser(20, (value: string) => Number(value));

export interface DatabaseConfig {
  host?: string;
  port?: number;
  user?: string;
  password?: string;
  database?: string;
  connectionLimit?: number;
}

function requireEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

/**
 * Creates a PostgreSQL connection pool using node-postgres.
 * Sets the session `timezone` to UTC on every new connection so `now()`-rendered output and
 * any future non-TIMESTAMPTZ column stay UTC, in accordance with ADR-0009 (even though
 * TIMESTAMPTZ storage is offset-correct regardless of session timezone).
 */
export function createConnectionPool(options: DatabaseConfig = {}): Pool {
  let pool: Pool;

  if (process.env.DATABASE_URL && !options.host && !options.user) {
    pool = new Pool({
      connectionString: process.env.DATABASE_URL,
      max: options.connectionLimit ?? 10,
    });
  } else {
    const poolOptions: PoolConfig = {
      host: options.host || process.env.DB_HOST || '127.0.0.1',
      port: options.port ?? (Number(process.env.DB_PORT) || 5432),
      user: options.user || requireEnv('DB_USER'),
      password: options.password || requireEnv('DB_PASSWORD'),
      database: options.database || process.env.DB_NAME || 'luxeknox',
      max: options.connectionLimit ?? 10,
    };
    pool = new Pool(poolOptions);
  }

  pool.on('connect', (client) => {
    client.query("SET TIME ZONE 'UTC'").catch((err) => {
      console.error('[DB] Failed to set session timezone to UTC:', err);
    });
  });

  return pool;
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

export type DrizzleDb<TSchema extends Record<string, unknown> = Record<string, never>> = NodePgDatabase<TSchema>;

/**
 * Creates a Drizzle database instance backed by a node-postgres connection pool.
 *
 * @param pool node-postgres connection pool
 * @param schema Optional Drizzle schema mapping
 */
export function createDrizzleClient<TSchema extends Record<string, unknown> = Record<string, never>>(
  pool: Pool,
  schema?: TSchema,
): DrizzleDb<TSchema> {
  if (schema) {
    return drizzle(pool, { schema });
  }
  return drizzle(pool) as unknown as DrizzleDb<TSchema>;
}
