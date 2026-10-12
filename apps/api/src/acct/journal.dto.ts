import { z } from 'zod';

const moneySchema = z
  .union([z.string(), z.number()])
  .transform((v) => String(v).trim())
  .refine((v) => /^-?\d+(\.\d+)?$/.test(v), { message: 'Invalid money amount' });

const dateSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, 'Invalid date format. Expected YYYY-MM-DD');

export const journalLineWriteSchema = z
  .object({
    account_id: z.number().int().positive(),
    debit: moneySchema.optional(),
    credit: moneySchema.optional(),
    memo: z.string().max(2000).nullable().optional(),
    member_id: z.number().int().positive().nullable().optional(),
    vendor_id: z.number().int().positive().nullable().optional(),
  })
  .strict();

export const journalCreateSchema = z
  .object({
    entry_date: dateSchema,
    source_type: z.enum(['manual', 'opening_balance']),
    memo: z.string().max(2000).nullable().optional(),
    lines: z.array(journalLineWriteSchema).min(2, 'Journal must have at least two lines'),
  })
  .strict();

export type JournalCreateDto = z.infer<typeof journalCreateSchema>;

export const journalReverseSchema = z
  .object({
    entry_date: dateSchema.optional(),
    memo: z.string().max(2000).nullable().optional(),
  })
  .strict();

export type JournalReverseDto = z.infer<typeof journalReverseSchema>;

/** Filter-only query fields. `limit`/`offset` are validated by `PaginationHelper`. */
export const journalFilterQuerySchema = z.object({
  from: dateSchema.optional(),
  to: dateSchema.optional(),
  source_type: z.string().trim().min(1).max(32).optional(),
  payment_id: z.coerce.number().int().positive().optional(),
});

export type JournalFilterQueryDto = z.infer<typeof journalFilterQuerySchema>;

export interface JournalLineDto {
  id: number;
  journal_entry_id: number;
  account_id: number;
  debit: string;
  credit: string;
  memo: string | null;
  member_id: number | null;
  vendor_id: number | null;
}

export interface JournalDto {
  id: number;
  journal_number: string;
  entry_date: string;
  accounting_period_id: number;
  source_type: string;
  source_id: number;
  memo: string | null;
  posted_at: Date | string;
  posted_by_user_id: number | null;
  reverses_journal_id: number | null;
  row_version: number;
  lines: JournalLineDto[];
}
