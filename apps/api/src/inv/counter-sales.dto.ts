import { z } from 'zod';
import { cmpMoney, roundMoney } from '../platform/money/money';

const moneyNonNegativeSchema = z
  .union([z.string(), z.number()])
  .transform((v) => String(v).trim())
  .refine((v) => /^\d+(\.\d+)?$/.test(v), { message: 'Invalid money amount' })
  .transform((v) => roundMoney(v))
  .refine((v) => cmpMoney(v, '0.00') >= 0, { message: 'Amount cannot be negative' });

const moneyPositiveSchema = moneyNonNegativeSchema.refine((v) => cmpMoney(v, '0.00') > 0, {
  message: 'Amount must be greater than 0',
});

const quantitySchema = z
  .union([z.string(), z.number()])
  .transform((v) => String(v).trim())
  .refine((v) => /^\d+(\.\d{1,3})?$/.test(v), {
    message: 'Quantity must be a positive number with at most 3 decimal places',
  })
  .refine((v) => Number(v) > 0, { message: 'Quantity must be greater than 0' });

const dateSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, 'Invalid date format. Expected YYYY-MM-DD');

const optionalText = (max: number, label: string) =>
  z
    .string()
    .trim()
    .max(max, `${label} must be at most ${max} characters`)
    .nullish()
    .transform((v) => (v == null || v === '' ? null : v));

export const saleLineWriteSchema = z
  .object({
    item_id: z.number().int().positive('item_id must be a positive integer'),
    quantity: quantitySchema,
    rate: moneyNonNegativeSchema.nullish(),
    discount_amount: moneyNonNegativeSchema.nullish(),
    tax_code_id: z
      .number()
      .int()
      .positive('tax_code_id must be a positive integer')
      .nullish(),
  })
  .strict();

export type SaleLineWrite = z.infer<typeof saleLineWriteSchema>;

export const saleTenderWriteSchema = z
  .object({
    payment_method_id: z.number().int().positive('payment_method_id must be a positive integer'),
    amount: moneyPositiveSchema,
    reference: optionalText(150, 'reference'),
  })
  .strict();

export type SaleTenderWrite = z.infer<typeof saleTenderWriteSchema>;

/** `SaleWrite` from the inventory contract. Totals are not accepted. */
export const saleWriteSchema = z
  .object({
    sale_date: dateSchema.optional(),
    member_id: z.number().int().positive('member_id must be a positive integer').nullish(),
    customer_name: optionalText(150, 'customer_name'),
    lines: z.array(saleLineWriteSchema).min(1, 'At least one sale line is required'),
    tenders: z.array(saleTenderWriteSchema).min(1, 'At least one tender is required'),
  })
  .strict();

export type SaleWrite = z.infer<typeof saleWriteSchema>;

export interface SaleLineDto {
  id: number;
  item_id: number;
  item_name: string;
  uom_code: string;
  quantity: string;
  rate: string;
  discount_amount: string;
  tax_code_id: number | null;
  net_amount: string;
  tax_amount: string;
  line_total: string;
  unit_cost: string | null;
  cost_amount: string | null;
  returned_quantity: string;
}

export interface TenderDto {
  id: number;
  payment_method_id: number;
  payment_method_name: string;
  amount: string;
  reference: string | null;
}

export interface CounterSaleReturnSummaryDto {
  id: number;
  return_number: string;
  return_date: string;
  total_amount: string;
}

export interface CounterSaleDto {
  id: number;
  sale_number: string;
  sale_date: string;
  member_id: number | null;
  member_name: string | null;
  customer_name: string | null;
  status: 'posted';
  subtotal: string;
  discount_amount: string;
  tax_amount: string;
  total_amount: string;
  cogs_amount: string;
  lines: SaleLineDto[];
  tenders: TenderDto[];
  returns: CounterSaleReturnSummaryDto[];
  journal_entry_id: number;
  journal_number: string;
  row_version: number;
  created_at: Date;
}
