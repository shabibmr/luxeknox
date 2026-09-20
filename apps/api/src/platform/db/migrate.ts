import 'dotenv/config';
import * as fs from 'fs';
import * as path from 'path';
import type { Connection } from 'mysql2/promise';
import { createAdminConnectionPool } from './client';

function requireSafeIdentifier(value: string | undefined, name: string): string {
  if (!value || !/^[A-Za-z0-9_]+$/.test(value)) {
    throw new Error(`${name} must be set and match /^[A-Za-z0-9_]+$/ (got: ${value ?? 'undefined'})`);
  }
  return value;
}

/**
 * Splits a SQL migration script by statements, taking into account
 * custom DELIMITER declarations often used for stored procedures or triggers.
 */
export function splitSqlStatements(sqlContent: string): string[] {
  const lines = sqlContent.split(/\r?\n/);
  const statements: string[] = [];
  let currentDelimiter = ';';
  let currentBuffer: string[] = [];

  for (const rawLine of lines) {
    const trimmed = rawLine.trim();
    if (trimmed.startsWith('--') || trimmed.startsWith('/*')) {
      continue;
    }

    // Check for DELIMITER change
    if (trimmed.toUpperCase().startsWith('DELIMITER ')) {
      // Flush previous statement if any non-empty buffer exists
      const stmt = currentBuffer.join('\n').trim();
      if (stmt.length > 0) {
        statements.push(stmt);
        currentBuffer = [];
      }
      const newDelim = trimmed.substring('DELIMITER '.length).trim();
      if (newDelim.length > 0) {
        currentDelimiter = newDelim;
      }
      continue;
    }

    currentBuffer.push(rawLine);

    // Check if the current buffer ends with currentDelimiter
    const joinedBuffer = currentBuffer.join('\n');
    const trimmedBuffer = joinedBuffer.trim();

    if (trimmedBuffer.endsWith(currentDelimiter)) {
      const stmtWithoutDelimiter = trimmedBuffer.substring(
        0,
        trimmedBuffer.length - currentDelimiter.length,
      ).trim();

      if (stmtWithoutDelimiter.length > 0) {
        statements.push(stmtWithoutDelimiter);
      }
      currentBuffer = [];
    }
  }

  const remaining = currentBuffer.join('\n').trim();
  if (remaining.length > 0) {
    statements.push(remaining);
  }

  return statements.filter((s) => s.length > 0 && !s.startsWith('--'));
}

/**
 * Ensures the `__drizzle_migrations` schema tracking table exists.
 */
async function ensureMigrationsTable(connection: Connection): Promise<void> {
  await connection.query(`
    CREATE TABLE IF NOT EXISTS \`__drizzle_migrations\` (
      \`id\` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
      \`name\` VARCHAR(255) NOT NULL UNIQUE,
      \`executed_at\` DATETIME(3) NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);
}

/**
 * Retrieves list of migration file names that have already been executed.
 */
async function getExecutedMigrations(connection: Connection): Promise<Set<string>> {
  const [rows] = await connection.query<any[]>(
    'SELECT `name` FROM `__drizzle_migrations` ORDER BY `id` ASC;',
  );
  return new Set(rows.map((r) => r.name));
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
  const connection = await pool.getConnection();

  try {
    console.log('[Migrate] Connecting to MySQL and ensuring migration table...');
    await ensureMigrationsTable(connection);

    const [collations] = await connection.query<any[]>(
      "SELECT 1 FROM information_schema.COLLATIONS WHERE COLLATION_NAME = 'utf8mb4_0900_ai_ci' LIMIT 1;",
    );
    if (collations.length === 0) {
      throw new Error(
        'Server does not support utf8mb4_0900_ai_ci. MySQL 8.0+ is required (see ADR-0002 and todo/README.md locked decisions).',
      );
    }

    const executed = await getExecutedMigrations(connection);
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
      const statements = splitSqlStatements(sqlContent);

      for (const statement of statements) {
        try {
          await connection.query(statement);
        } catch (err: any) {
          console.error(`[Migrate] Error executing statement in ${file}:\n${statement}\nError: ${err.message}`);
          throw err;
        }
      }

      const nowUtc = new Date().toISOString().replace('T', ' ').replace('Z', '');
      await connection.query(
        'INSERT INTO `__drizzle_migrations` (`name`, `executed_at`) VALUES (?, ?);',
        [file, nowUtc],
      );

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

        for (const statement of splitSqlStatements(sql)) {
          await connection.query(statement);
        }
      }
    }

    console.log('[Migrate] All migrations completed successfully.');
  } finally {
    connection.release();
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
