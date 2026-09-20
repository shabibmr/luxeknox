import { z } from 'zod';

export const memberHealthWriteSchema = z.object({
  blood_group: z.string().trim().max(16).optional().nullable(),
  height_cm: z.number().positive().optional().nullable(),
  baseline_weight_kg: z.number().positive().optional().nullable(),
  allergies: z.string().trim().max(5000).optional().nullable(),
  dietary_preferences: z.string().trim().max(5000).optional().nullable(),
  physician_name: z.string().trim().max(150).optional().nullable(),
  physician_phone: z.string().trim().max(32).optional().nullable(),
});

export type MemberHealthWriteDto = z.infer<typeof memberHealthWriteSchema>;
