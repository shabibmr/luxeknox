import { normalizeJsonStringArray } from '../platform/http/normalize-json-string-array';

/**
 * Coerces `exercises.secondary_muscles` to OpenAPI `string[] | null`.
 * @see platform/http/normalize-json-string-array.ts
 */
export function normalizeSecondaryMuscles(raw: unknown): string[] | null {
  return normalizeJsonStringArray(raw);
}
