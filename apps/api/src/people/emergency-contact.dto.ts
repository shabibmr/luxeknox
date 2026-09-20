import { z } from 'zod';

export const emergencyContactWriteSchema = z.object({
  contact_name: z.string().trim().min(1).max(150),
  relationship: z.string().trim().max(100).optional().nullable(),
  phone_primary: z.string().trim().min(1).max(32),
  phone_secondary: z.string().trim().max(32).optional().nullable(),
  is_primary: z.boolean().optional().default(false),
});

export type EmergencyContactWriteDto = z.infer<typeof emergencyContactWriteSchema>;

export const emergencyContactUpdateSchema = emergencyContactWriteSchema.partial().strict();

export type EmergencyContactUpdateDto = z.infer<typeof emergencyContactUpdateSchema>;
