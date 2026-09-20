/**
 * Coerces MariaDB/mysql2 JSON-or-TEXT values to OpenAPI `string[] | null`.
 * Handles arrays, double-encoded JSON array strings, blank → null, and plain
 * strings as a single-element array.
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
