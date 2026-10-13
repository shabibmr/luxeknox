import { z } from 'zod';
import { cmpMoney, roundMoney } from '../platform/money/money';

const moneySchema = z.union([z.string(), z.number()]).transform((v) => roundMoney(v));

const positiveMoneySchema = moneySchema.refine(
  (v) => {
    try {
      return cmpMoney(v, '0.00') > 0;
    } catch {
      return false;
    }
  },
  { message: 'Amount must be greater than zero' },
);

const nonNegativeMoneySchema = moneySchema.refine(
  (v) => {
    try {
      return cmpMoney(v, '0.00') >= 0;
    } catch {
      return false;
    }
  },
  { message: 'Fee cannot be negative' },
);

const dateSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, 'Invalid date format. Expected YYYY-MM-DD');

export const fundTransferCreateSchema = z
  .object({
    transfer_date: dateSchema,
    from_account_id: z.number().int().positive(),
    to_account_id: z.number().int().positive(),
    amount: positiveMoneySchema,
    fee_amount: nonNegativeMoneySchema.optional(),
    fee_account_id: z.number().int().positive().nullable().optional(),
    memo: z.string().max(2000).nullable().optional(),
  })
  .strict()
  .refine((data) => data.from_account_id !== data.to_account_id, {
    message: 'Source and destination accounts must differ',
    path: ['to_account_id'],
  });

export type FundTransferCreateDto = z.infer<typeof fundTransferCreateSchema>;

export const fundTransferUpdateSchema = z
  .object({
    transfer_date: dateSchema.optional(),
    from_account_id: z.number().int().positive().optional(),
    to_account_id: z.number().int().positive().optional(),
    amount: positiveMoneySchema.optional(),
    fee_amount: nonNegativeMoneySchema.optional(),
    fee_account_id: z.number().int().positive().nullable().optional(),
    memo: z.string().max(2000).nullable().optional(),
  })
  .strict();

export type FundTransferUpdateDto = z.infer<typeof fundTransferUpdateSchema>;

/** Filter-only query fields. limit/offset handled by PaginationHelper */
export const fundTransferFilterQuerySchema = z.object({
  status: z.enum(['draft', 'posted']).optional(),
  from: dateSchema.optional(),
  to: dateSchema.optional(),
  account_id: z.coerce.number().int().positive().optional(),
  search: z.string().trim().min(1).max(100).optional(),
});

export type FundTransferFilterQueryDto = z.infer<typeof fundTransferFilterQuerySchema>;

export interface FundTransferDto {
  id: number;
  transfer_number: string;
  transfer_date: string;
  from_account_id: number;
  to_account_id: number;
  amount: string;
  fee_amount: string;
  fee_account_id: number | null;
  memo: string | null;
  status: 'draft' | 'posted';
  journal_entry_id: number | null;
  row_version: number;
  created_at: Date | string;
  updated_at: Date | string | null;
}
