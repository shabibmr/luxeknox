import { z } from 'zod';
import { cmpMoney, roundMoney } from '../platform/money/money';

export const DEBIT_NOTE_STATUSES = ['draft', 'posted', 'void'] as const;
export type DebitNoteStatus = (typeof DEBIT_NOTE_STATUSES)[number];

const dateSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, 'Invalid date format. Expected YYYY-MM-DD');

const moneyPositiveSchema = z
  .union([z.string(), z.number()])
  .transform((v) => String(v).trim())
  .refine((v) => /^\d+(\.\d+)?$/.test(v), { message: 'Invalid money amount' })
  .transform((v) => roundMoney(v))
  .refine((v) => cmpMoney(v, '0.00') > 0, { message: 'Amount must be greater than 0' });

export const debitNoteCreateSchema = z
  .object({
    purchase_bill_id: z.number().int().positive('purchase_bill_id must be a positive integer'),
    debit_note_date: dateSchema,
    reason: z
      .string()
      .trim()
      .max(1000, 'reason must be at most 1000 characters')
      .nullable()
      .optional(),
    /** Net (pre-tax) amount. Tax is computed server-side from `tax_code_id`. */
    amount: moneyPositiveSchema,
    tax_code_id: z.number().int().positive().nullable().optional(),
  })
  .strict();

export type DebitNoteCreateDto = z.infer<typeof debitNoteCreateSchema>;

export const debitNoteFilterQuerySchema = z.object({
  status: z.enum(DEBIT_NOTE_STATUSES).optional(),
  purchase_bill_id: z
    .preprocess((val) => {
      if (typeof val === 'string' && val.trim() !== '') return Number(val);
      return val;
    }, z.number().int().positive().optional())
    .optional(),
  from: dateSchema.optional(),
  to: dateSchema.optional(),
  search: z.string().trim().optional(),
});

export type DebitNoteFilterQueryDto = z.infer<typeof debitNoteFilterQuerySchema>;

export interface DebitNoteDto {
  id: number;
  debit_note_number: string;
  purchase_bill_id: number;
  debit_note_date: string;
  reason: string | null;
  subtotal: string;
  tax_amount: string;
  total_amount: string;
  status: DebitNoteStatus;
  journal_entry_id: number | null;
  row_version: number;
  created_at: Date | string;
  updated_at: Date | string | null;
}
