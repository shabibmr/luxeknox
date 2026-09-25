import { z } from 'zod';

export const bookRequestSchema = z.object({
  member_id: z.number().int().positive().optional(),
});

export type BookRequestDto = z.infer<typeof bookRequestSchema>;

export const cancelBookingRequestSchema = z.object({
  reason: z.string().optional(),
});

export type CancelBookingRequestDto = z.infer<typeof cancelBookingRequestSchema>;
