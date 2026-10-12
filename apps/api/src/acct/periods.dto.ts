import { z } from 'zod';

export interface FiscalYearDto {
  id: number;
  label: string;
  starts_on: string;
  ends_on: string;
}

export interface DraftDocumentCountsDto {
  purchase_bills: number;
  expense_vouchers: number;
  payment_vouchers: number;
  credit_notes: number;
  debit_notes: number;
  total: number;
}

export interface AccountingPeriodDto {
  id: number;
  fiscal_year_id: number;
  starts_on: string;
  ends_on: string;
  status: string;
  closed_at: Date | string | null;
  closed_by_user_id: number | null;
  draft_document_counts?: DraftDocumentCountsDto;
}

export const periodFilterQuerySchema = z.object({
  fiscal_year_id: z
    .preprocess((val) => {
      if (val === undefined || val === null || val === '') return undefined;
      const num = Number(val);
      return Number.isFinite(num) ? num : val;
    }, z.number().int().positive().optional()),
  status: z.enum(['open', 'locked']).optional(),
});

export type PeriodFilterQueryDto = z.infer<typeof periodFilterQuerySchema>;
