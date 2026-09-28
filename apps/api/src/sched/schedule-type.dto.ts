import { z } from 'zod';

export const scheduleTypeWriteSchema = z.object({
  name: z.string().trim().min(1, 'name is required'),
  color_code: z.string().trim().min(1).optional(),
  default_duration_minutes: z.number().int().positive().optional(),
  requires_trainer: z.boolean().optional(),
});

export type ScheduleTypeWriteDto = z.infer<typeof scheduleTypeWriteSchema>;

export const scheduleTypeUpdateSchema = scheduleTypeWriteSchema.partial();

export type ScheduleTypeUpdateDto = z.infer<typeof scheduleTypeUpdateSchema>;
