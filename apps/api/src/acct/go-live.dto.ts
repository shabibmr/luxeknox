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
  account_code: z.enum(['2200', '2210']),
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
