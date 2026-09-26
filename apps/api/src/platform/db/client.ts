import { createPool, type Pool, type PoolOptions } from 'mysql2/promise';
import { drizzle, type MySql2Database } from 'drizzle-orm/mysql2';

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
 * Creates a MySQL connection pool using mysql2/promise.
 * Strictly enforces `timezone: '+00:00'` to ensure all session interactions
 * operate in UTC, in accordance with ADR-0002.
 */
export function createConnectionPool(options: DatabaseConfig = {}): Pool {
  if (process.env.DATABASE_URL && !options.host && !options.user) {
    return createPool({
      uri: process.env.DATABASE_URL,
      waitForConnections: true,
      connectionLimit: options.connectionLimit ?? 10,
      queueLimit: 0,
      timezone: '+00:00',
      dateStrings: false,
    });
  }

  const poolOptions: PoolOptions = {
    host: options.host || process.env.DB_HOST || '127.0.0.1',
    port: options.port ?? (Number(process.env.DB_PORT) || 3306),
    user: options.user || requireEnv('DB_USER'),
    password: options.password || requireEnv('DB_PASSWORD'),
    database: options.database || process.env.DB_NAME || 'luxeknox',
    waitForConnections: true,
    connectionLimit: options.connectionLimit ?? 10,
    queueLimit: 0,
    timezone: '+00:00',
    dateStrings: false,
  };

  return createPool(poolOptions);
}

/**
 * Creates a MySQL connection pool authenticated as the DDL-privileged admin user.
 * Used only by migrations/grants — never by the running API — and always connects
 * explicitly (bypassing `DATABASE_URL`) so it can never silently fall back to the
 * least-privilege app user.
 */
export function createAdminConnectionPool(): Pool {
  return createConnectionPool({
    host: process.env.DB_HOST || '127.0.0.1',
    port: Number(process.env.DB_PORT) || 3306,
    user: requireEnv('DB_ADMIN_USER'),
    password: requireEnv('DB_ADMIN_PASSWORD'),
    database: process.env.DB_NAME || 'luxeknox',
  });
}

import * as schema from './schema';

export type AppSchema = typeof schema;
export type DrizzleDb<TSchema extends Record<string, unknown> = AppSchema> = MySql2Database<TSchema>;

/**
 * Creates a Drizzle database instance backed by a mysql2 connection pool.
 * Uses mode: 'default' for standard relational and SQL operations.
 *
 * @param pool mysql2/promise connection pool
 * @param schema Optional Drizzle schema mapping
 */
export function createDrizzleClient<TSchema extends Record<string, unknown> = AppSchema>(
  pool: Pool,
  schema?: TSchema,
): DrizzleDb<TSchema> {
  if (schema) {
    return drizzle(pool, {
      schema,
      mode: 'default',
    });
  }
  return drizzle(pool, {
    mode: 'default',
  }) as unknown as DrizzleDb<TSchema>;
}
