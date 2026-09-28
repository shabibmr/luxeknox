import { z } from 'zod';

export const facilityWriteSchema = z.object({
  name: z.string().trim().min(1, 'name is required'),
  capacity: z.number().int().positive().optional(),
  location_details: z.string().optional(),
  is_active: z.boolean().optional(),
});

export type FacilityWriteDto = z.infer<typeof facilityWriteSchema>;

export const facilityUpdateSchema = facilityWriteSchema.partial();

export type FacilityUpdateDto = z.infer<typeof facilityUpdateSchema>;
