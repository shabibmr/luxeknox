import { z } from 'zod';

const dateString = z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'must be an ISO date (YYYY-MM-DD)');

const moneySchema = z
  .union([z.string(), z.number()])
  .transform((v) => String(v).trim())
  .refine((v) => /^-?\d+(\.\d+)?$/.test(v), { message: 'Invalid money amount' });

/** Mirrors `docs/openapi/v1.yaml` `#/components/schemas/MembershipCreate`. */
export const membershipCreateSchema = z.object({
  member_id: z.number().int().positive(),
  product_id: z.number().int().positive(),
  start_date: dateString,
  payment_method_id: z.number().int().positive(),
  locker_number: z.string().trim().min(1).optional(),
  auto_renew: z.boolean().optional(),
  partner_member_id: z.number().int().positive().optional(),
  replace_partner_membership: z.boolean().optional(),
  discount_amount: moneySchema.optional(),
});

export type MembershipCreateDto = z.infer<typeof membershipCreateSchema>;

/** Mirrors `#/components/schemas/MembershipReplacementPreview` query. */
export const membershipReplacementPreviewQuerySchema = z.object({
  member_id: z.coerce.number().int().positive(),
});

export type MembershipReplacementPreviewQueryDto = z.infer<
  typeof membershipReplacementPreviewQuerySchema
>;

export interface MembershipReplacementPreview {
  membership_id: number;
  product_name: string;
  status: string;
  end_date: string;
  remaining_days: number;
  is_couple: boolean;
  suggested_credit: string;
}

/**
 * Mirrors `#/components/schemas/MembershipActionRequest`, used by renew/upgrade/cancel.
 * `row_version` is optional on the wire schema but required here — it is the FR-API-009
 * optimistic-concurrency token and every state-changing action must supply it.
 */
export const membershipActionRequestSchema = z.object({
  product_id: z.number().int().positive().optional(),
  row_version: z.number().int().nonnegative(),
  reason: z.string().optional(),
});

export type MembershipActionRequestDto = z.infer<typeof membershipActionRequestSchema>;

/** `POST /memberships/{id}/upgrade` requires `product_id`; reuse the action schema plus this check. */
export const membershipUpgradeRequestSchema = membershipActionRequestSchema.extend({
  product_id: z.number().int().positive(),
});

export type MembershipUpgradeRequestDto = z.infer<typeof membershipUpgradeRequestSchema>;

export const membershipFilterQuerySchema = z.object({
  member_id: z.coerce.number().int().positive().optional(),
  status: z.enum(['active', 'expired', 'frozen', 'cancelled']).optional(),
});

export type MembershipFilterQueryDto = z.infer<typeof membershipFilterQuerySchema>;

/** Mirrors `#/components/schemas/MembershipFreezeWrite`. */
export const membershipFreezeWriteSchema = z.object({
  start_date: dateString,
  end_date: dateString,
  reason: z.string().optional(),
});

export type MembershipFreezeWriteDto = z.infer<typeof membershipFreezeWriteSchema>;

/** Mirrors `#/components/schemas/RejectRequest`. */
export const rejectRequestSchema = z.object({
  reason: z.string().optional(),
});

export type RejectRequestDto = z.infer<typeof rejectRequestSchema>;

/** Mirrors `#/components/schemas/MembershipExtensionWrite`. */
export const membershipExtensionWriteSchema = z.object({
  days_extended: z.number().int().positive(),
  reason: z.string().optional(),
});

export type MembershipExtensionWriteDto = z.infer<typeof membershipExtensionWriteSchema>;
