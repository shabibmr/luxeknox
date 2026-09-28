import { z } from 'zod';

const isoDateTime = z.string().datetime({ offset: true }).or(z.string().datetime());

export const scheduleCreateSchema = z.object({
  series_id: z.number().int().positive().optional(),
  schedule_type_id: z.number().int().positive(),
  facility_id: z.number().int().positive().optional(),
  trainer_id: z.number().int().positive().optional(),
  title: z.string().trim().min(1),
  start_time: isoDateTime,
  end_time: isoDateTime,
  max_capacity: z.number().int().positive().optional(),
  notes: z.string().optional(),
  row_version: z.number().int().positive().optional(),
  recur_until: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
});

export type ScheduleCreateDto = z.infer<typeof scheduleCreateSchema>;

export const scheduleUpdateSchema = z.object({
  series_id: z.number().int().positive().optional(),
  schedule_type_id: z.number().int().positive().optional(),
  facility_id: z.number().int().positive().optional(),
  trainer_id: z.number().int().positive().optional(),
  title: z.string().trim().min(1).optional(),
  start_time: isoDateTime.optional(),
  end_time: isoDateTime.optional(),
  max_capacity: z.number().int().positive().optional(),
  notes: z.string().optional(),
  row_version: z.number().int().positive().optional(),
  recur_until: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
});

export type ScheduleUpdateDto = z.infer<typeof scheduleUpdateSchema>;

export const scheduleWriteSchema = scheduleUpdateSchema;
export type ScheduleWriteDto = ScheduleUpdateDto;

export const scheduleFilterQuerySchema = z.object({
  from: isoDateTime.optional(),
  to: isoDateTime.optional(),
  trainer_id: z.coerce.number().int().positive().optional(),
  member_id: z.coerce.number().int().positive().optional(),
});

export type ScheduleFilterQueryDto = z.infer<typeof scheduleFilterQuerySchema>;

export const cancelRequestSchema = z.object({
  reason: z.string().optional(),
  row_version: z.number().int().positive().optional(),
  cancel_series: z.boolean().optional(),
});

export type CancelRequestDto = z.infer<typeof cancelRequestSchema>;

export const scheduleTransitionSchema = z.object({
  row_version: z.number().int().positive().optional(),
  notes: z.string().optional(),
});

export type ScheduleTransitionDto = z.infer<typeof scheduleTransitionSchema>;
