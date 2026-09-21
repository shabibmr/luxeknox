/**
 * Coerces a JSONB-or-text value to OpenAPI `string[] | null`.
 * Handles arrays, double-encoded JSON array strings, blank → null, and plain
 * strings as a single-element array.
 *
 * Under PostgreSQL's JSONB columns this always round-trips as an already-parsed array, so the
 * string-parsing branches below are dead code on the happy path — kept as a defensive normalizer
 * (covered by tests, costs nothing) in case a caller ever passes a raw driver value through.
 * Previously documented MariaDB/mysql2 TEXT-fallback behaviour no longer applies (ADR-0009).
 */
export function normalizeJsonStringArray(raw: unknown): string[] | null {
  if (raw == null) return null;

  if (Array.isArray(raw)) {
    return raw.map((item) => String(item));
  }

  if (typeof raw === 'string') {
    const trimmed = raw.trim();
    if (trimmed.length === 0) return null;
    try {
      const parsed: unknown = JSON.parse(trimmed);
      if (Array.isArray(parsed)) {
        return parsed.map((item) => String(item));
      }
    } catch {
      // Not JSON — treat the whole string as a single label.
    }
    return [trimmed];
  }

  return null;
}
