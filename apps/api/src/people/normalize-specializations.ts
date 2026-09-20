import { normalizeJsonStringArray } from '../platform/http/normalize-json-string-array';

/**
 * Coerces `trainers.specializations` to OpenAPI `string[] | null`.
 * @see platform/http/normalize-json-string-array.ts
 */
export function normalizeSpecializations(raw: unknown): string[] | null {
  return normalizeJsonStringArray(raw);
}
