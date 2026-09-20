import { z } from 'zod';

/**
 * Mirrors `docs/openapi/v1.yaml` `#/components/schemas/FoodWrite` field-for-field.
 * Field names are snake_case on the wire — do not camelCase at this boundary.
 */
export const foodWriteSchema = z.object({
  name: z.string().trim().min(1, 'name is required'),
  serving_unit: z.string().trim().min(1, 'serving_unit is required'),
  serving_size: z.number().optional(),
  calories: z.number().optional(),
  protein_grams: z.number().optional(),
  carbs_grams: z.number().optional(),
  fat_grams: z.number().optional(),
  fiber_grams: z.number().optional(),
  is_verified: z.boolean().optional(),
  is_active: z.boolean().optional(),
});

export type FoodWriteDto = z.infer<typeof foodWriteSchema>;

/**
 * `PATCH /foods/{id}` — partial update. Omitted fields leave existing values untouched.
 */
export const foodUpdateSchema = foodWriteSchema.partial();

export type FoodUpdateDto = z.infer<typeof foodUpdateSchema>;

/** Coerce common query-string boolean forms (`true`/`false`/`1`/`0`). */
const booleanQuery = z
  .union([z.boolean(), z.enum(['true', 'false', '1', '0'])])
  .optional()
  .transform((value) => {
    if (value === undefined) return undefined;
    if (typeof value === 'boolean') return value;
    return value === 'true' || value === '1';
  });

/**
 * Filter-only query fields. `limit`/`offset` are validated by `PaginationHelper`.
 */
export const foodFilterQuerySchema = z.object({
  q: z.string().trim().min(1).optional(),
  is_verified: booleanQuery,
  is_active: booleanQuery,
});

export type FoodFilterQueryDto = z.infer<typeof foodFilterQuerySchema>;
