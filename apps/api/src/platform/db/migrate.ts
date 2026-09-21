import 'dotenv/config';
import * as fs from 'fs';
import * as path from 'path';
import type { PoolClient } from 'pg';
import { createAdminConnectionPool } from './client';

export function requireSafeIdentifier(value: string | undefined, name: string): string {
  if (!value || !/^[A-Za-z0-9_]+$/.test(value)) {
    throw new Error(`${name} must be set and match /^[A-Za-z0-9_]+$/ (got: ${value ?? 'undefined'})`);
  }
  return value;
}

/**
 * Ensures the `__drizzle_migrations` schema tracking table exists.
 */
async function ensureMigrationsTable(client: PoolClient): Promise<void> {
  await client.query(`
    CREATE TABLE IF NOT EXISTS __drizzle_migrations (
      id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      name VARCHAR(255) NOT NULL UNIQUE,
      executed_at TIMESTAMPTZ(3) NOT NULL
    );
  `);
}

/**
 * Retrieves list of migration file names that have already been executed.
 */
async function getExecutedMigrations(client: PoolClient): Promise<Set<string>> {
  const result = await client.query<{ name: string }>(
    'SELECT name FROM __drizzle_migrations ORDER BY id ASC;',
  );
  return new Set(result.rows.map((r) => r.name));
}

/**
 * Standalone migration runner that executes hand-authored and generated SQL migrations.
 */
export async function runMigrations(options?: { migrationsFolder?: string }): Promise<void> {
  const migrationsFolder =
    options?.migrationsFolder || path.resolve(__dirname, '../../../drizzle');

  if (!fs.existsSync(migrationsFolder)) {
    console.warn(`[Migrate] Migrations directory not found at: ${migrationsFolder}`);
    return;
  }

  const pool = createAdminConnectionPool();
  const client = await pool.connect();

  try {
    console.log('[Migrate] Connecting to PostgreSQL and ensuring migration table...');
    await ensureMigrationsTable(client);

    // Fail fast on a wrong engine/encoding (fix F-04, ported from the utf8mb4_0900_ai_ci
    // guard): PostgreSQL 15+ is required for default-privilege-safe grants (ADR-0009), and
    // UTF8 encoding must be set at initdb — it cannot be changed after the fact.
    const versionCheck = await client.query<{ server_version_num: string; server_encoding: string }>(
      "SELECT current_setting('server_version_num') AS server_version_num, current_setting('server_encoding') AS server_encoding;",
    );
    const serverVersionNum = Number(versionCheck.rows[0]?.server_version_num ?? 0);
    const serverEncoding = versionCheck.rows[0]?.server_encoding;
    if (serverVersionNum < 150000) {
      throw new Error(
        `PostgreSQL 15+ is required (see ADR-0009). Detected server_version_num=${serverVersionNum}.`,
      );
    }
    if (serverEncoding !== 'UTF8') {
      throw new Error(
        `Server encoding must be UTF8 (see ADR-0009). Detected server_encoding=${serverEncoding}.`,
      );
    }

    const executed = await getExecutedMigrations(client);
    const files = fs
      .readdirSync(migrationsFolder)
      .filter((file) => file.endsWith('.sql'))
      .sort();

    console.log(`[Migrate] Found ${files.length} migration file(s). ${executed.size} already applied.`);

    for (const file of files) {
      if (executed.has(file)) {
        console.log(`[Migrate] Skipping already applied: ${file}`);
        continue;
      }

      console.log(`[Migrate] Applying ${file}...`);
      const filePath = path.join(migrationsFolder, file);
      const sqlContent = fs.readFileSync(filePath, 'utf-8');

      // PostgreSQL has transactional DDL, so the whole file runs as one multi-statement
      // query inside an explicit transaction: a failed migration rolls back completely,
      // which MySQL could not offer. This replaces the old DELIMITER-aware
      // `splitSqlStatements` — MySQL client syntax with no PostgreSQL meaning, and it would
      // have mis-split PostgreSQL's dollar-quoted ($$ … $$) bodies if reused.
      await client.query('BEGIN');
      try {
        await client.query(sqlContent);
        const nowUtc = new Date();
        await client.query('INSERT INTO __drizzle_migrations (name, executed_at) VALUES ($1, $2);', [
          file,
          nowUtc,
        ]);
        await client.query('COMMIT');
      } catch (err: any) {
        await client.query('ROLLBACK');
        console.error(`[Migrate] Error executing ${file}:\n${err.message}`);
        throw err;
      }

      console.log(`[Migrate] Successfully applied ${file}`);
    }

    const repeatableFolder = path.join(migrationsFolder, 'repeatable');
    if (fs.existsSync(repeatableFolder)) {
      const appUser = requireSafeIdentifier(process.env.DB_USER, 'DB_USER');
      const dbName = requireSafeIdentifier(process.env.DB_NAME || 'luxeknox', 'DB_NAME');

      for (const file of fs.readdirSync(repeatableFolder).filter((f) => f.endsWith('.sql')).sort()) {
        console.log(`[Migrate] Applying repeatable ${file}...`);
        const sql = fs
          .readFileSync(path.join(repeatableFolder, file), 'utf-8')
          .replace(/\$\{DB_USER\}/g, appUser)
          .replace(/\$\{DB_NAME\}/g, dbName);

        await client.query('BEGIN');
        try {
          await client.query(sql);
          await client.query('COMMIT');
        } catch (err) {
          await client.query('ROLLBACK');
          throw err;
        }
      }
    }

    console.log('[Migrate] All migrations completed successfully.');
  } finally {
    client.release();
    await pool.end();
  }
}

// Auto-run when executed directly via CLI
if (require.main === module) {
  runMigrations()
    .then(() => {
      process.exit(0);
    })
    .catch((err) => {
      console.error('[Migrate] Migration failed:', err);
      process.exit(1);
    });
}
