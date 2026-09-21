import { z } from 'zod';

const moneyString = z
  .string()
  .regex(/^\d+\.\d{2}$/, 'must be a two-decimal string, e.g. "1299.00"');

/**
 * Mirrors `docs/openapi/v1.yaml` `#/components/schemas/MembershipProductWrite` field-for-field.
 * Money is always a two-decimal string on the wire (FR-API-005) — never a float.
 */
export const membershipProductWriteSchema = z.object({
  name: z.string().trim().min(1, 'name is required'),
  code: z.string().trim().min(1, 'code is required'),
  description: z.string().optional(),
  duration_days: z.number().int().positive(),
  base_price: moneyString,
  tax_percentage: moneyString.optional(),
  max_freeze_days: z.number().int().min(0).optional(),
  pt_sessions_included: z.number().int().min(0).optional(),
  access_facilities: z.array(z.string()).optional(),
  is_active: z.boolean().optional(),
});

export type MembershipProductWriteDto = z.infer<typeof membershipProductWriteSchema>;

/** `PATCH /membership-products/{id}` — partial update, omitted fields untouched. */
export const membershipProductUpdateSchema = membershipProductWriteSchema.partial();

export type MembershipProductUpdateDto = z.infer<typeof membershipProductUpdateSchema>;

export const membershipProductFilterQuerySchema = z.object({
  q: z.string().trim().min(1).optional(),
});

export type MembershipProductFilterQueryDto = z.infer<typeof membershipProductFilterQuerySchema>;
