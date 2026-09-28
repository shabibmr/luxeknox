import { z } from 'zod';

const dateString = z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'must be an ISO date (YYYY-MM-DD)');

/** Mirrors `docs/openapi/v1.yaml` `#/components/schemas/MembershipCreate`. */
export const membershipCreateSchema = z.object({
  member_id: z.number().int().positive(),
  product_id: z.number().int().positive(),
  start_date: dateString,
  locker_number: z.string().trim().min(1).optional(),
  auto_renew: z.boolean().optional(),
});

export type MembershipCreateDto = z.infer<typeof membershipCreateSchema>;

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
