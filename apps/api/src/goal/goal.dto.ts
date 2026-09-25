import { z } from 'zod';
import {
  GOAL_METRIC_CATEGORIES,
  GOAL_STATUSES,
  PROGRESS_NOTE_TYPES,
  PROGRESS_PHOTO_POSES,
} from '../platform/db/schema/goals';

// ==================== Goal Metric DTOs ====================
export const goalMetricWriteSchema = z.object({
  name: z.string().trim().min(1).max(100),
  unit_of_measure: z.string().trim().min(1).max(32),
  category: z.enum(GOAL_METRIC_CATEGORIES),
  is_active: z.boolean().optional().default(true),
});

export type GoalMetricWriteDto = z.infer<typeof goalMetricWriteSchema>;

export const goalMetricUpdateSchema = goalMetricWriteSchema.partial();
export type GoalMetricUpdateDto = z.infer<typeof goalMetricUpdateSchema>;

export const goalMetricFilterQuerySchema = z.object({
  category: z.enum(GOAL_METRIC_CATEGORIES).optional(),
  is_active: z
    .enum(['true', 'false'])
    .transform((v) => v === 'true')
    .optional(),
  q: z.string().trim().optional(),
  limit: z.coerce.number().int().positive().max(100).optional().default(50),
  cursor: z.string().optional(),
});

export type GoalMetricFilterQueryDto = z.output<typeof goalMetricFilterQuerySchema>;

// ==================== Goal DTOs ====================
export const goalWriteSchema = z.object({
  metric_id: z.coerce.number().int().positive(),
  baseline_value: z.coerce.number(),
  target_value: z.coerce.number(),
  start_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be in YYYY-MM-DD format'),
  target_date: z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be in YYYY-MM-DD format')
    .optional()
    .nullable(),
  status: z.enum(GOAL_STATUSES).optional().default('in_progress'),
});

export type GoalWriteDto = z.input<typeof goalWriteSchema>;

export const goalUpdateSchema = z.object({
  target_value: z.coerce.number().optional(),
  target_date: z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be in YYYY-MM-DD format')
    .optional()
    .nullable(),
  status: z.enum(GOAL_STATUSES).optional(),
});

export type GoalUpdateDto = z.infer<typeof goalUpdateSchema>;

export const goalCheckInWriteSchema = z.object({
  recorded_value: z.coerce.number(),
  recorded_date: z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be in YYYY-MM-DD format')
    .optional(),
  notes: z.string().trim().optional().nullable(),
});

export type GoalCheckInWriteDto = z.infer<typeof goalCheckInWriteSchema>;

export const goalFilterQuerySchema = z.object({
  status: z.enum(GOAL_STATUSES).optional(),
  metric_id: z.coerce.number().int().positive().optional(),
  limit: z.coerce.number().int().positive().max(100).optional().default(50),
  cursor: z.string().optional(),
});

export type GoalFilterQueryDto = z.input<typeof goalFilterQuerySchema>;

// ==================== Measurement DTOs ====================
export const measurementValueWriteSchema = z.object({
  metric_id: z.coerce.number().int().positive(),
  value: z.coerce.number(),
});

export type MeasurementValueWriteDto = z.infer<typeof measurementValueWriteSchema>;

export const measurementWriteSchema = z.object({
  recorded_at: z.string().datetime({ offset: true }).optional(),
  notes: z.string().trim().optional().nullable(),
  values: z.array(measurementValueWriteSchema).min(1, 'At least one measurement value is required'),
});

export type MeasurementWriteDto = z.infer<typeof measurementWriteSchema>;

export const measurementFilterQuerySchema = z.object({
  limit: z.coerce.number().int().positive().max(100).optional().default(20),
  cursor: z.string().optional(),
  from: z.string().optional(),
  to: z.string().optional(),
});

export type MeasurementFilterQueryDto = z.input<typeof measurementFilterQuerySchema>;

// ==================== Progress Photo DTOs ====================
export const progressPhotoWriteSchema = z.object({
  photo_url: z.string().url().max(512),
  pose: z.enum(PROGRESS_PHOTO_POSES),
  taken_date: z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be in YYYY-MM-DD format')
    .optional(),
  is_private: z.boolean().optional().default(false),
});

export type ProgressPhotoWriteDto = z.input<typeof progressPhotoWriteSchema>;

export const progressPhotoFilterQuerySchema = z.object({
  pose: z.enum(PROGRESS_PHOTO_POSES).optional(),
  limit: z.coerce.number().int().positive().max(100).optional().default(50),
  cursor: z.string().optional(),
});

export type ProgressPhotoFilterQueryDto = z.input<typeof progressPhotoFilterQuerySchema>;

export const progressPhotoComparisonQuerySchema = z.object({
  date1: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'date1 must be YYYY-MM-DD'),
  date2: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'date2 must be YYYY-MM-DD'),
});

export type ProgressPhotoComparisonQueryDto = z.infer<typeof progressPhotoComparisonQuerySchema>;

// ==================== Progress Note DTOs ====================
export const progressNoteWriteSchema = z.object({
  note_text: z.string().trim().min(1, 'Note text cannot be empty'),
  note_type: z.enum(PROGRESS_NOTE_TYPES),
});

export type ProgressNoteWriteDto = z.infer<typeof progressNoteWriteSchema>;

export const progressNoteFilterQuerySchema = z.object({
  cursor: z.string().optional(),
  limit: z.coerce.number().int().positive().max(100).optional().default(50),
});

export type ProgressNoteFilterQueryDto = z.infer<typeof progressNoteFilterQuerySchema>;
