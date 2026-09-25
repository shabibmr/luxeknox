import { z } from 'zod';

const moneySchema = z
  .union([z.string(), z.number()])
  .transform((v) => String(v).trim())
  .refine((v) => /^-?\d+(\.\d+)?$/.test(v), { message: 'Invalid money amount' });

export const paymentMethodWriteSchema = z
  .object({
    method_name: z.string().trim().min(1).max(100),
    is_digital: z.boolean().optional(),
    is_active: z.boolean().optional(),
  })
  .strict();

export type PaymentMethodWriteDto = z.infer<typeof paymentMethodWriteSchema>;

export const tenderLineSchema = z
  .object({
    payment_method_id: z.number().int().positive(),
    amount: moneySchema,
    transaction_reference: z.string().max(150).optional(),
  })
  .strict();

export const paymentCreateSchema = z
  .object({
    member_id: z.number().int().positive(),
    membership_id: z.number().int().positive().optional(),
    product_id: z.number().int().positive().optional(),
    subtotal: moneySchema,
    discount_amount: moneySchema.optional(),
    payment_method_id: z.number().int().positive().optional(),
    tenders: z.array(tenderLineSchema).min(1).optional(),
    transaction_reference: z.string().max(150).optional(),
  })
  .strict()
  .superRefine((val, ctx) => {
    if (!val.tenders?.length && val.payment_method_id == null) {
      // Allow unpaid invoice (pending) with neither — amount_paid stays 0.
      return;
    }
    if (val.tenders?.length && val.payment_method_id != null) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: 'Use either payment_method_id or tenders, not both',
        path: ['tenders'],
      });
    }
  });

export type PaymentCreateDto = z.infer<typeof paymentCreateSchema>;

export const paymentAdjustSchema = z
  .object({
    amount: moneySchema,
    payment_method_id: z.number().int().positive().optional(),
    notes: z.string().max(2000).optional(),
    row_version: z.number().int().positive().optional(),
  })
  .strict();

export type PaymentAdjustDto = z.infer<typeof paymentAdjustSchema>;

export interface PaymentMethodDto {
  id: number;
  method_name: string;
  is_digital: boolean;
  is_active: boolean;
}

export interface PaymentHistoryDto {
  id: number;
  payment_id: number;
  payment_method_id: number | null;
  action: string;
  amount: string;
  notes: string | null;
  timestamp: string;
}

export interface PaymentDto {
  id: number;
  invoice_number: string;
  member_id: number;
  membership_id: number | null;
  payment_method_id: number | null;
  subtotal: string;
  tax_amount: string;
  discount_amount: string;
  total_amount: string;
  amount_paid: string;
  status: string;
  transaction_reference: string | null;
  cashier_user_id: number | null;
  payment_date: string;
  row_version: number;
  histories?: PaymentHistoryDto[];
}

export interface PaymentReceiptDto {
  id: number;
  payment_id: number;
  receipt_number: string;
  receipt_pdf_url: string | null;
  generated_at: string;
  payment?: PaymentDto;
}
