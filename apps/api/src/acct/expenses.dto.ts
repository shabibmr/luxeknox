import { z } from 'zod';
import { cmpMoney, roundMoney } from '../platform/money/money';

const moneyPositiveSchema = z
  .union([z.string(), z.number()])
  .transform((v) => String(v).trim())
  .refine((v) => /^\d+(\.\d+)?$/.test(v), { message: 'Invalid money amount' })
  .transform((v) => roundMoney(v))
  .refine((v) => cmpMoney(v, '0.00') > 0, { message: 'Amount must be greater than 0' });

const dateSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, 'Invalid date format. Expected YYYY-MM-DD');

export const EXPENSE_STATUSES = ['draft', 'posted'] as const;
export type ExpenseStatus = (typeof EXPENSE_STATUSES)[number];

export const expenseLineCreateSchema = z
  .object({
    account_id: z.number().int().positive('account_id must be a positive integer'),
    description: z
      .string()
      .trim()
      .max(255, 'description must be at most 255 characters')
      .nullable()
      .optional(),
    amount: moneyPositiveSchema,
    tax_code_id: z
      .number()
      .int()
      .positive('tax_code_id must be a positive integer')
      .nullable()
      .optional(),
  })
  .strict();

export type ExpenseLineCreateDto = z.infer<typeof expenseLineCreateSchema>;

export const expenseCreateSchema = z
  .object({
    expense_date: dateSchema,
    paid_from_account_id: z
      .number()
      .int()
      .positive('paid_from_account_id must be a positive integer')
      .nullable()
      .optional(),
    vendor_id: z
      .number()
      .int()
      .positive('vendor_id must be a positive integer')
      .nullable()
      .optional(),
    payee_name: z
      .string()
      .trim()
      .max(150, 'payee_name must be at most 150 characters')
      .nullable()
      .optional(),
    lines: z
      .array(expenseLineCreateSchema)
      .min(1, 'At least one expense line is required'),
  })
  .strict()
  .refine(
    (data) => {
      if (data.paid_from_account_id == null) {
        return data.vendor_id != null;
      }
      return true;
    },
    {
      message: 'vendor_id is required when paid_from_account_id is not provided',
      path: ['vendor_id'],
    },
  );

export type ExpenseCreateDto = z.infer<typeof expenseCreateSchema>;

export const expenseUpdateSchema = z
  .object({
    expense_date: dateSchema.optional(),
    paid_from_account_id: z
      .number()
      .int()
      .positive('paid_from_account_id must be a positive integer')
      .nullable()
      .optional(),
    vendor_id: z
      .number()
      .int()
      .positive('vendor_id must be a positive integer')
      .nullable()
      .optional(),
    payee_name: z
      .string()
      .trim()
      .max(150, 'payee_name must be at most 150 characters')
      .nullable()
      .optional(),
    lines: z
      .array(expenseLineCreateSchema)
      .min(1, 'At least one expense line is required')
      .optional(),
  })
  .strict();

export type ExpenseUpdateDto = z.infer<typeof expenseUpdateSchema>;

export const expenseFilterQuerySchema = z.object({
  status: z.enum(EXPENSE_STATUSES).optional(),
  vendor_id: z
    .preprocess((val) => {
      if (typeof val === 'string' && val.trim() !== '') return Number(val);
      return val;
    }, z.number().int().positive().optional())
    .optional(),
  from: dateSchema.optional(),
  to: dateSchema.optional(),
  search: z.string().trim().optional(),
});

export type ExpenseFilterQueryDto = z.infer<typeof expenseFilterQuerySchema>;

export interface ExpenseVoucherLineDto {
  id: number;
  expense_voucher_id: number;
  account_id: number;
  description: string | null;
  amount: string;
  tax_code_id: number | null;
  tax_amount: string;
}

export interface ExpenseVoucherDto {
  id: number;
  expense_number: string;
  vendor_id: number | null;
  payee_name: string | null;
  expense_date: string;
  paid_from_account_id: number | null;
  status: ExpenseStatus;
  subtotal: string;
  tax_amount: string;
  total_amount: string;
  journal_entry_id: number | null;
  row_version: number;
  created_at: Date | string;
  updated_at: Date | string | null;
  lines: ExpenseVoucherLineDto[];
}
