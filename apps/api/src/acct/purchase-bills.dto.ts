import { z } from 'zod';
import { cmpMoney, roundMoney } from '../platform/money/money';

export const PURCHASE_BILL_STATUSES = ['draft', 'posted', 'void'] as const;
export type PurchaseBillStatus = (typeof PURCHASE_BILL_STATUSES)[number];

/** Quantity up to 3 decimal places; UOM scale is enforced in the service. */
export const quantitySchema = z
  .union([z.string(), z.number()])
  .transform((v) => String(v).trim())
  .refine((v) => /^\d+(\.\d{1,3})?$/.test(v), {
    message: 'Quantity must be a positive number with at most 3 decimal places',
  })
  .refine((v) => Number(v) > 0, { message: 'Quantity must be greater than 0' });

export const rateSchema = z
  .union([z.string(), z.number()])
  .transform((v) => String(v).trim())
  .refine((v) => /^\d+(\.\d+)?$/.test(v), { message: 'Invalid rate' })
  .transform((v) => roundMoney(v))
  .refine((v) => cmpMoney(v, '0.00') >= 0, { message: 'Rate must be greater than or equal to 0' });

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

export const purchaseBillLineWriteSchema = z
  .object({
    item_id: z.number().int().positive('item_id must be a positive integer').nullable().optional(),
    account_id: z
      .number()
      .int()
      .positive('account_id must be a positive integer')
      .nullable()
      .optional(),
    description: z
      .string()
      .trim()
      .max(255, 'description must be at most 255 characters')
      .nullable()
      .optional(),
    quantity: quantitySchema.optional().default('1.000'),
    rate: rateSchema.optional(),
    tax_code_id: z
      .number()
      .int()
      .positive('tax_code_id must be a positive integer')
      .nullable()
      .optional(),
  })
  .strict();

export type PurchaseBillLineWriteDto = z.infer<typeof purchaseBillLineWriteSchema>;

export const purchaseBillCreateSchema = z
  .object({
    vendor_id: z.number().int().positive('vendor_id must be a positive integer'),
    bill_date: dateSchema,
    due_date: dateSchema.nullable().optional(),
    supplier_invoice_no: optionalText(64, 'supplier_invoice_no'),
    lines: z
      .array(purchaseBillLineWriteSchema)
      .min(1, 'At least one purchase bill line is required'),
  })
  .strict();

export type PurchaseBillCreateDto = z.infer<typeof purchaseBillCreateSchema>;

export const purchaseBillUpdateSchema = z
  .object({
    vendor_id: z.number().int().positive('vendor_id must be a positive integer').optional(),
    bill_date: dateSchema.optional(),
    due_date: dateSchema.nullable().optional(),
    supplier_invoice_no: optionalText(64, 'supplier_invoice_no'),
    lines: z
      .array(purchaseBillLineWriteSchema)
      .min(1, 'At least one purchase bill line is required')
      .optional(),
  })
  .strict();

export type PurchaseBillUpdateDto = z.infer<typeof purchaseBillUpdateSchema>;

export const purchaseBillFilterQuerySchema = z.object({
  status: z.enum(PURCHASE_BILL_STATUSES).optional(),
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

export type PurchaseBillFilterQueryDto = z.infer<typeof purchaseBillFilterQuerySchema>;

export interface PurchaseBillLineDto {
  id: number;
  purchase_bill_id: number;
  item_id: number | null;
  account_id: number;
  description: string | null;
  quantity: string;
  rate: string;
  tax_code_id: number | null;
  net_amount: string;
  tax_amount: string;
}

export interface PurchaseBillDto {
  id: number;
  bill_number: string;
  vendor_id: number;
  bill_date: string;
  due_date: string | null;
  supplier_invoice_no: string | null;
  status: PurchaseBillStatus;
  subtotal: string;
  tax_amount: string;
  total_amount: string;
  journal_entry_id: number | null;
  row_version: number;
  created_at: Date | string;
  updated_at: Date | string | null;
  lines: PurchaseBillLineDto[];
}
