import { z } from 'zod';
import { cmpMoney, roundMoney, toCents } from '../platform/money/money';

const positiveMoneySchema = z
  .union([z.string(), z.number()])
  .transform((v) => roundMoney(v))
  .refine(
    (v) => {
      try {
        return cmpMoney(v, '0.00') > 0;
      } catch {
        return false;
      }
    },
    { message: 'Amount must be greater than zero' },
  );

const dateSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, 'Invalid date format. Expected YYYY-MM-DD');

export const paymentAllocationWriteSchema = z
  .object({
    purchase_bill_id: z.number().int().positive().nullable().optional(),
    expense_voucher_id: z.number().int().positive().nullable().optional(),
    amount: positiveMoneySchema,
  })
  .strict()
  .refine(
    (data) => {
      const hasBill = data.purchase_bill_id !== undefined && data.purchase_bill_id !== null;
      const hasExpense = data.expense_voucher_id !== undefined && data.expense_voucher_id !== null;
      return (hasBill && !hasExpense) || (!hasBill && hasExpense);
    },
    {
      message: 'Each allocation must specify exactly one of purchase_bill_id or expense_voucher_id',
    },
  );

export type PaymentAllocationWriteDto = z.infer<typeof paymentAllocationWriteSchema>;

export const paymentVoucherCreateSchema = z
  .object({
    payment_date: dateSchema,
    bank_account_id: z.number().int().positive(),
    total_amount: positiveMoneySchema,
    memo: z.string().max(2000).nullable().optional(),
    allocations: z
      .array(paymentAllocationWriteSchema)
      .min(1, 'At least one allocation is required'),
  })
  .strict()
  .refine(
    (data) => {
      const sumCents = data.allocations.reduce((acc, alloc) => acc + toCents(alloc.amount), 0n);
      return toCents(data.total_amount) === sumCents;
    },
    {
      message: 'Total amount must equal the sum of allocation amounts',
      path: ['total_amount'],
    },
  );

export type PaymentVoucherCreateDto = z.infer<typeof paymentVoucherCreateSchema>;

export const paymentVoucherUpdateSchema = z
  .object({
    payment_date: dateSchema.optional(),
    bank_account_id: z.number().int().positive().optional(),
    total_amount: positiveMoneySchema.optional(),
    memo: z.string().max(2000).nullable().optional(),
    allocations: z.array(paymentAllocationWriteSchema).min(1).optional(),
  })
  .strict()
  .refine(
    (data) => {
      if (data.total_amount !== undefined && data.allocations !== undefined) {
        const sumCents = data.allocations.reduce((acc, alloc) => acc + toCents(alloc.amount), 0n);
        return toCents(data.total_amount) === sumCents;
      }
      return true;
    },
    {
      message: 'Total amount must equal the sum of allocation amounts',
      path: ['total_amount'],
    },
  );

export type PaymentVoucherUpdateDto = z.infer<typeof paymentVoucherUpdateSchema>;

/** Filter-only query fields. limit/offset handled by PaginationHelper */
export const paymentVoucherFilterQuerySchema = z.object({
  status: z.enum(['draft', 'posted']).optional(),
  from: dateSchema.optional(),
  to: dateSchema.optional(),
  bank_account_id: z.coerce.number().int().positive().optional(),
  search: z.string().trim().min(1).max(100).optional(),
});

export type PaymentVoucherFilterQueryDto = z.infer<typeof paymentVoucherFilterQuerySchema>;

export interface PaymentAllocationDto {
  id: number;
  payment_voucher_id: number;
  purchase_bill_id: number | null;
  expense_voucher_id: number | null;
  amount: string;
}

export interface PaymentVoucherDto {
  id: number;
  voucher_number: string;
  payment_date: string;
  bank_account_id: number;
  total_amount: string;
  memo: string | null;
  status: 'draft' | 'posted';
  journal_entry_id: number | null;
  row_version: number;
  created_at: Date | string;
  updated_at: Date | string | null;
  allocations: PaymentAllocationDto[];
}
