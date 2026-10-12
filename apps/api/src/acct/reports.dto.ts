import { z } from 'zod';

const dateSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, 'Invalid date format. Expected YYYY-MM-DD');

// --- ACC-070: Trial Balance ---
export const trialBalanceQuerySchema = z.object({
  from: dateSchema.optional(),
  to: dateSchema,
});
export type TrialBalanceQueryDto = z.infer<typeof trialBalanceQuerySchema>;

export interface TrialBalanceAccountDto {
  account_id: number;
  account_code: string;
  account_name: string;
  account_type: string;
  debit: string;
  credit: string;
}

export interface TrialBalanceReportDto {
  from: string | null;
  to: string;
  accounts: TrialBalanceAccountDto[];
  total_debit: string;
  total_credit: string;
}

// --- ACC-071: Profit and Loss ---
export const profitAndLossQuerySchema = z.object({
  from: dateSchema,
  to: dateSchema,
});
export type ProfitAndLossQueryDto = z.infer<typeof profitAndLossQuerySchema>;

export interface ProfitAndLossAccountDto {
  account_id: number;
  account_code: string;
  account_name: string;
  amount: string;
}

export interface ProfitAndLossReportDto {
  from: string;
  to: string;
  income_accounts: ProfitAndLossAccountDto[];
  total_income: string;
  expense_accounts: ProfitAndLossAccountDto[];
  total_expense: string;
  net_profit: string;
}

// --- ACC-072: Balance Sheet ---
export const balanceSheetQuerySchema = z.object({
  as_of: dateSchema,
});
export type BalanceSheetQueryDto = z.infer<typeof balanceSheetQuerySchema>;

export interface BalanceSheetAccountDto {
  account_id: number;
  account_code: string;
  account_name: string;
  amount: string;
}

export interface BalanceSheetReportDto {
  as_of: string;
  fiscal_year_start: string;
  asset_accounts: BalanceSheetAccountDto[];
  total_assets: string;
  liability_accounts: BalanceSheetAccountDto[];
  total_liabilities: string;
  equity_accounts: BalanceSheetAccountDto[];
  current_year_earnings: string;
  total_equity: string;
  total_liabilities_and_equity: string;
}

// --- ACC-073: Day Book ---
export const dayBookQuerySchema = z.object({
  date: dateSchema,
});
export type DayBookQueryDto = z.infer<typeof dayBookQuerySchema>;

export interface DayBookLineDto {
  id: number;
  account_id: number;
  account_code: string;
  account_name: string;
  debit: string;
  credit: string;
  memo: string | null;
  member_id: number | null;
  vendor_id: number | null;
}

export interface DayBookJournalDto {
  id: number;
  journal_number: string;
  entry_date: string;
  source_type: string;
  source_id: number;
  memo: string | null;
  reverses_journal_id: number | null;
  lines: DayBookLineDto[];
}

export interface DayBookReportDto {
  date: string;
  journals: DayBookJournalDto[];
  total_debit: string;
  total_credit: string;
}

// --- ACC-074: Open Items ---
export const openItemsQuerySchema = z.object({
  kind: z.enum(['ar', 'ap']),
});
export type OpenItemsQueryDto = z.infer<typeof openItemsQuerySchema>;

export interface OpenArItemDto {
  payment_id: number;
  invoice_number: string;
  invoice_date: string;
  member_id: number;
  total_amount: string;
  amount_paid: string;
  open_amount: string;
  status: string;
}

export interface OpenApItemDto {
  purchase_bill_id: number;
  bill_number: string;
  bill_date: string;
  due_date: string;
  vendor_id: number;
  total_amount: string;
  allocated_amount: string;
  debit_note_amount: string;
  open_amount: string;
  status: string;
}

export interface OpenItemsReportDto {
  kind: 'ar' | 'ap';
  ar_items?: OpenArItemDto[];
  ap_items?: OpenApItemDto[];
  total_open_amount: string;
}

// --- ACC-075: GST Summary ---
export const gstSummaryQuerySchema = z.object({
  from: dateSchema,
  to: dateSchema,
});
export type GstSummaryQueryDto = z.infer<typeof gstSummaryQuerySchema>;

export interface GstTaxCodeSummaryDto {
  tax_code_id: number;
  tax_code_name: string;
  rate_percent: string;
  taxable_value: string;
  cgst_amount: string;
  sgst_amount: string;
  igst_amount: string;
  total_tax: string;
}

export interface GstSummaryReportDto {
  from: string;
  to: string;
  tax_codes: GstTaxCodeSummaryDto[];
  total_taxable_value: string;
  output_cgst: string;
  output_sgst: string;
  output_igst: string;
  total_output_tax: string;
  input_tax_credit: string;
  net_payable: string;
}
