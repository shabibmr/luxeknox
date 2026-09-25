import { z } from 'zod';

export const REPORT_TYPES = [
  'members',
  'memberships',
  'attendance',
  'payments',
  'trainers',
  'workouts',
  'diets',
  'progress',
  'trainer_own',
] as const;

export type ReportType = (typeof REPORT_TYPES)[number];

export const REPORT_FORMATS = ['json', 'csv'] as const;
export type ReportFormat = (typeof REPORT_FORMATS)[number];

const dateRegex = /^\d{4}-\d{2}-\d{2}$/;

export const reportQuerySchema = z.object({
  from: z
    .string()
    .regex(dateRegex, { message: 'from must be a valid date in YYYY-MM-DD format' })
    .optional(),
  to: z
    .string()
    .regex(dateRegex, { message: 'to must be a valid date in YYYY-MM-DD format' })
    .optional(),
  product_id: z.coerce.number().int().positive().optional(),
  trainer_id: z.coerce.number().int().positive().optional(),
  format: z.enum(REPORT_FORMATS).default('json'),
});

export type ReportQueryDto = z.infer<typeof reportQuerySchema>;

export const reportTypeParamSchema = z.object({
  type: z.enum(REPORT_TYPES),
});

export type ReportTypeParamDto = z.infer<typeof reportTypeParamSchema>;

export interface ReportResponseDto {
  type: ReportType;
  from: string;
  to: string;
  rows: Array<Record<string, any>>;
}
