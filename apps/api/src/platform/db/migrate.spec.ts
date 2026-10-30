import 'dotenv/config';
import * as fs from 'fs';
import * as path from 'path';
import { describe, it, expect } from 'vitest';
import { createConnectionPool } from './client';
import { splitSqlStatements, statementForServer } from './migrate';

const drizzleDir = path.resolve(__dirname, '../../../drizzle');

describe('splitSqlStatements', () => {
  it('splits simple statements on semicolons', () => {
    const sql = 'CREATE TABLE a (id INT);\nCREATE TABLE b (id INT);';
    expect(splitSqlStatements(sql)).toEqual([
      'CREATE TABLE a (id INT)',
      'CREATE TABLE b (id INT)',
    ]);
  });

  it('respects DELIMITER changes for procedures', () => {
    const sql = `
DELIMITER $$
CREATE PROCEDURE p()
BEGIN
  SELECT 1;
END$$
DELIMITER ;
SELECT 2;
`;
    const statements = splitSqlStatements(sql);
    expect(statements).toHaveLength(2);
    expect(statements[0]).toContain('CREATE PROCEDURE p()');
    expect(statements[1]).toBe('SELECT 2');
  });

  it('preserves the locked utf8mb4_0900_ai_ci collation verbatim', () => {
    const sql = "CREATE TABLE t (name VARCHAR(10)) COLLATE utf8mb4_0900_ai_ci;";
    const statements = splitSqlStatements(sql);
    expect(statements[0]).toBe('CREATE TABLE t (name VARCHAR(10)) COLLATE utf8mb4_0900_ai_ci');
  });

  it('keeps utf8mb4_0900_ai_ci on MySQL 8 and rewrites it only when that collation is missing', () => {
    const sql = 'CREATE TABLE t (name VARCHAR(10)) COLLATE utf8mb4_0900_ai_ci';
    expect(statementForServer(sql, true)).toBe(sql);
    expect(statementForServer(sql, false)).toBe(
      'CREATE TABLE t (name VARCHAR(10)) COLLATE utf8mb4_unicode_ci',
    );
  });
});

describe('PT client-file notes migration', () => {
  it('does not ship the unjournaled notes script as an apply path', () => {
    expect(
      fs.existsSync(path.join(drizzleDir, '0027_workout_session_exercise_notes.sql')),
    ).toBe(false);
  });

  it('adds workout_session_exercises.notes only when the column is missing', () => {
    const sql = fs.readFileSync(path.join(drizzleDir, '0032_pt_client_file_schema.sql'), 'utf8');
    expect(sql).toContain('workout_session_exercises');
    expect(sql).toContain('COLUMN_NAME = \'notes\'');
    expect(sql).toContain('information_schema.COLUMNS');
    expect(sql).not.toMatch(
      /ALTER TABLE `workout_session_exercises` ADD `notes` text;--> statement-breakpoint/,
    );
  });

  const canConnect = Boolean(process.env.DATABASE_URL || process.env.DB_USER);

  it.skipIf(!canConnect)(
    'leaves exactly one notes column whether or not the column already exists',
    async () => {
      const pool = createConnectionPool();
      const conn = await pool.getConnection();
      const table = '_mig_wse_notes_probe';
      const ensureSql = `
DROP PROCEDURE IF EXISTS \`__migrate_notes_probe\`;
DELIMITER $$
CREATE PROCEDURE \`__migrate_notes_probe\`()
BEGIN
  DECLARE v_exists INT DEFAULT 0;
  SELECT COUNT(*) INTO v_exists FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = '${table}'
      AND COLUMN_NAME = 'notes';
  IF v_exists = 0 THEN
    ALTER TABLE \`${table}\` ADD \`notes\` text;
  END IF;
END$$
DELIMITER ;
CALL \`__migrate_notes_probe\`();
DROP PROCEDURE \`__migrate_notes_probe\`;
`;
      try {
        await conn.query(`DROP TABLE IF EXISTS \`${table}\``);
        await conn.query(`CREATE TABLE \`${table}\` (\`id\` int)`);
        for (const statement of splitSqlStatements(ensureSql)) {
          await conn.query(statement);
        }
        for (const statement of splitSqlStatements(ensureSql)) {
          await conn.query(statement);
        }
        const [withColumn] = await conn.query<any[]>(
          `SELECT COLUMN_NAME FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = 'notes'`,
          [table],
        );

        await conn.query(`DROP TABLE IF EXISTS \`${table}\``);
        await conn.query(`CREATE TABLE \`${table}\` (\`id\` int, \`notes\` text)`);
        for (const statement of splitSqlStatements(ensureSql)) {
          await conn.query(statement);
        }
        const [alreadyPresent] = await conn.query<any[]>(
          `SELECT COLUMN_NAME FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = 'notes'`,
          [table],
        );

        expect(withColumn).toHaveLength(1);
        expect(alreadyPresent).toHaveLength(1);
      } finally {
        await conn.query(`DROP TABLE IF EXISTS \`${table}\``);
        await conn.query('DROP PROCEDURE IF EXISTS `__migrate_notes_probe`');
        conn.release();
        await pool.end();
      }
    },
  );
});
