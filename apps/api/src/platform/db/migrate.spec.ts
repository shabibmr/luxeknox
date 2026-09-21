import { describe, it, expect } from 'vitest';
import { requireSafeIdentifier } from './migrate';

// The previous MySQL-only `splitSqlStatements` (DELIMITER-aware statement splitting) has no
// PostgreSQL equivalent and was deleted (ADR-0009 / PG-15) — migrations now run as one
// multi-statement query inside an explicit transaction, relying on PostgreSQL's transactional
// DDL rather than manual statement splitting. `requireSafeIdentifier` is the remaining pure,
// unit-testable piece of the runner: it guards the `${DB_USER}` / `${DB_NAME}` substitution in
// repeatable migrations against SQL injection via environment variables.
describe('requireSafeIdentifier', () => {
  it('accepts alphanumeric/underscore identifiers', () => {
    expect(requireSafeIdentifier('luxeknox_app', 'DB_USER')).toBe('luxeknox_app');
    expect(requireSafeIdentifier('luxeknox', 'DB_NAME')).toBe('luxeknox');
  });

  it('rejects undefined', () => {
    expect(() => requireSafeIdentifier(undefined, 'DB_USER')).toThrow(/DB_USER must be set/);
  });

  it('rejects values containing SQL metacharacters', () => {
    expect(() => requireSafeIdentifier("luxeknox'; DROP TABLE users; --", 'DB_USER')).toThrow(
      /DB_USER must be set/,
    );
    expect(() => requireSafeIdentifier('luxeknox; --', 'DB_USER')).toThrow(/DB_USER must be set/);
    expect(() => requireSafeIdentifier('luxeknox admin', 'DB_USER')).toThrow(/DB_USER must be set/);
  });
});
