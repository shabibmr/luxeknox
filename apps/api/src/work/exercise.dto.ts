import { z } from 'zod';

/**
 * Mirrors `docs/openapi/v1.yaml` `#/components/schemas/ExerciseWrite` field-for-field.
 * Field names are snake_case on the wire — do not camelCase at this boundary.
 */
export const exerciseWriteSchema = z.object({
  name: z.string().trim().min(1, 'name is required'),
  primary_muscle_group: z.string().trim().min(1).optional(),
  secondary_muscles: z.array(z.string()).optional(),
  equipment_needed: z.string().trim().min(1).optional(),
  instructions: z.string().optional(),
  video_url: z.string().url().optional(),
  gif_url: z.string().url().optional(),
  difficulty_level: z.string().trim().min(1).optional(),
  is_active: z.boolean().optional(),
});

export type ExerciseWriteDto = z.infer<typeof exerciseWriteSchema>;

/**
 * `PATCH /exercises/{id}` — partial update. `name`, when omitted, leaves the existing value
 * untouched (see `ExerciseService.update`); the wire schema is otherwise identical to `ExerciseWrite`.
 */
export const exerciseUpdateSchema = exerciseWriteSchema.partial();

export type ExerciseUpdateDto = z.infer<typeof exerciseUpdateSchema>;

/**
 * Filter-only query fields. `limit`/`offset` are validated and normalized separately by
 * `PaginationHelper` (see `docs/openapi/v1.yaml` shared `Limit`/`Offset` parameters) — this
 * schema is `z.object` (not `.strict()`), so passing it the same raw query NestJS gives
 * `PaginationHelper.normalizeParams` is safe; unrecognized keys are stripped, not rejected.
 */
export const exerciseFilterQuerySchema = z.object({
  q: z.string().trim().min(1).optional(),
  primary_muscle_group: z.string().trim().min(1).optional(),
  equipment_needed: z.string().trim().min(1).optional(),
  difficulty_level: z.string().trim().min(1).optional(),
});

export type ExerciseFilterQueryDto = z.infer<typeof exerciseFilterQuerySchema>;
