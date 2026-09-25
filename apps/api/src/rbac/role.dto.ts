import { z } from 'zod';

export const roleWriteSchema = z.object({
  name: z.string().trim().min(1).max(100),
  description: z.string().trim().max(1000).optional().nullable(),
});

export type RoleWriteDto = z.infer<typeof roleWriteSchema>;

export const rolePermissionsWriteSchema = z.object({
  permission_ids: z.array(z.coerce.number().int().positive()).min(1),
});

export type RolePermissionsWriteDto = z.infer<typeof rolePermissionsWriteSchema>;
