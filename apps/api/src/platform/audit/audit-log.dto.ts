import { z } from 'zod';

export const auditLogFilterQuerySchema = z.object({
  limit: z.coerce.number().int().positive().max(100).optional().default(50),
  cursor: z.string().optional(),
  actor_user_id: z.coerce.number().int().positive().optional(),
  entity_name: z.string().trim().optional(),
  entity_id: z.coerce.number().int().positive().optional(),
  action: z.string().trim().optional(),
  from: z.string().datetime({ offset: true }).optional(),
  to: z.string().datetime({ offset: true }).optional(),
});

export type AuditLogFilterQueryDto = z.infer<typeof auditLogFilterQuerySchema>;
