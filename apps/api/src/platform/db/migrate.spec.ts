import { describe, it, expect } from 'vitest';
import { splitSqlStatements } from './migrate';

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
});
