import { z } from 'zod';

export const dietLogWriteSchema = z.object({
  diet_plan_id: z.number().int().positive().optional().nullable(),
  total_calories_consumed: z.number().nonnegative().optional().default(0),
  adherence_score: z.number().min(0).max(100).optional().nullable(),
  water_intake_ml: z.number().int().nonnegative().optional().nullable(),
  member_notes: z.string().optional().nullable(),
});

export type DietLogWriteDto = z.infer<typeof dietLogWriteSchema>;

export const dietLogFilterQuerySchema = z.object({
  from: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'from must be YYYY-MM-DD').optional(),
  to: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'to must be YYYY-MM-DD').optional(),
});

export type DietLogFilterQueryDto = z.infer<typeof dietLogFilterQuerySchema>;
