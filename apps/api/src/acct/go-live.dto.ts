import { z } from 'zod';

export const unearnedPreviewItemSchema = z.object({
  kind: z.enum(['membership', 'pt']),
  source_id: z.number(),
  payment_id: z.number(),
  member_id: z.number(),
  starts_on: z.string(),
  ends_on: z.string(),
  unearned_account_id: z.number(),
  income_account_id: z.number(),
  total_net: z.string(),
  unexpired_amount: z.string(),
});

export type UnearnedPreviewItemDto = z.infer<typeof unearnedPreviewItemSchema>;

export const unearnedPreviewResponseSchema = z.object({
  go_live_date: z.string(),
  totals: z.object({
    unearned_membership_total: z.string(),
    unearned_pt_total: z.string(),
    combined_total: z.string(),
  }),
  items: z.array(unearnedPreviewItemSchema),
});

export type UnearnedPreviewResponseDto = z.infer<typeof unearnedPreviewResponseSchema>;

export const goLivePaymentMethodSchema = z.object({
  id: z.number(),
  method_name: z.string(),
  is_active: z.boolean(),
  is_digital: z.boolean(),
  account_id: z.number().nullable(),
  account_name: z.string().nullable(),
});

export type GoLivePaymentMethodDto = z.infer<typeof goLivePaymentMethodSchema>;

export const goLiveChecklistResponseSchema = z.object({
  go_live_date: z.string(),
  posting_enabled: z.boolean(),
  can_enable: z.boolean(),
  failing_reasons: z.array(z.string()),
  opening_journal_found: z.boolean(),
  opening_journal_matches: z.boolean(),
  unearned_membership: z.object({
    preview: z.string(),
    actual: z.string(),
    matched: z.boolean(),
  }),
  unearned_pt: z.object({
    preview: z.string(),
    actual: z.string(),
    matched: z.boolean(),
  }),
  tax_match: z.object({
    gym_tax_rate: z.string(),
    default_tax_code: z.string(),
    default_tax_rate: z.string(),
    matched: z.boolean(),
  }),
  payment_methods: z.array(goLivePaymentMethodSchema),
});

export type GoLiveChecklistResponseDto = z.infer<typeof goLiveChecklistResponseSchema>;

export const mapPaymentMethodSchema = z.object({
  account_id: z.number().int().positive().nullable(),
});

export type MapPaymentMethodDto = z.infer<typeof mapPaymentMethodSchema>;

export const enablePostingSchema = z.object({
  go_live_date: z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be formatted as YYYY-MM-DD')
    .optional(),
});

export type EnablePostingDto = z.infer<typeof enablePostingSchema>;

export const enablePostingResponseSchema = z.object({
  success: z.boolean(),
  posting_enabled: z.boolean(),
});

export type EnablePostingResponseDto = z.infer<typeof enablePostingResponseSchema>;
