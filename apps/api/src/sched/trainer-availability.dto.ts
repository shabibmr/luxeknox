import { z } from 'zod';

const timeString = z
  .string()
  .regex(/^\d{2}:\d{2}(:\d{2})?$/, 'must be HH:MM or HH:MM:SS');

export const trainerAvailabilitySlotSchema = z.object({
  id: z.number().int().positive().optional(),
  trainer_id: z.number().int().positive().optional(),
  day_of_week: z.number().int().min(0).max(6).optional(),
  start_time: timeString.optional(),
  end_time: timeString.optional(),
  is_recurring: z.boolean().optional(),
  override_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  is_available: z.boolean(),
});

export const trainerAvailabilityWriteSchema = z.object({
  slots: z.array(trainerAvailabilitySlotSchema).min(1),
});

export type TrainerAvailabilityWriteDto = z.infer<typeof trainerAvailabilityWriteSchema>;
