import { Injectable } from '@nestjs/common';
import type {
  BalanceSheetQueryDto,
  BalanceSheetReportDto,
  DayBookQueryDto,
  DayBookReportDto,
  GstSummaryQueryDto,
  GstSummaryReportDto,
  OpenItemsQueryDto,
  OpenItemsReportDto,
  ProfitAndLossQueryDto,
  ProfitAndLossReportDto,
  TrialBalanceQueryDto,
  TrialBalanceReportDto,
} from './reports.dto';
import { ReportsRepository } from './reports.repository';

@Injectable()
export class ReportsService {
  constructor(private readonly repository: ReportsRepository) {}

  /**
   * ACC-070: Trial balance for a date range.
   * Debit total equals credit total. Uses the same totals query as period lock.
   */
  async getTrialBalance(query: TrialBalanceQueryDto): Promise<TrialBalanceReportDto> {
    const { accounts, totalDebit, totalCredit } = await this.repository.getTrialBalance(
      query.from,
      query.to,
    );

    return {
      from: query.from ?? null,
      to: query.to,
      accounts,
      total_debit: totalDebit,
      total_credit: totalCredit,
    };
  }

  /**
   * ACC-071: Profit and loss for a date range.
   * Only income and expense accounts.
   */
  async getProfitAndLoss(query: ProfitAndLossQueryDto): Promise<ProfitAndLossReportDto> {
    const result = await this.repository.getProfitAndLoss(query.from, query.to);

    return {
      from: query.from,
      to: query.to,
      income_accounts: result.incomeAccounts,
      total_income: result.totalIncome,
      expense_accounts: result.expenseAccounts,
      total_expense: result.totalExpense,
      net_profit: result.netProfit,
    };
  }

  /**
   * ACC-072: Balance sheet as of a date, with current-year earnings under equity.
   * Assets equal liabilities plus equity.
   */
  async getBalanceSheet(query: BalanceSheetQueryDto): Promise<BalanceSheetReportDto> {
    const result = await this.repository.getBalanceSheet(query.as_of);

    return {
      as_of: result.asOf,
      fiscal_year_start: result.fiscalYearStart,
      asset_accounts: result.assetAccounts,
      total_assets: result.totalAssets,
      liability_accounts: result.liabilityAccounts,
      total_liabilities: result.totalLiabilities,
      equity_accounts: result.equityAccounts,
      retained_earnings: result.retainedEarnings,
      current_year_earnings: result.currentYearEarnings,
      total_equity: result.totalEquity,
      total_liabilities_and_equity: result.totalLiabilitiesAndEquity,
    };
  }

  /**
   * ACC-073: Day book for one date.
   * Every journal on that date is listed with its lines.
   */
  async getDayBook(query: DayBookQueryDto): Promise<DayBookReportDto> {
    const result = await this.repository.getDayBook(query.date);

    return {
      date: result.date,
      journals: result.journals,
      total_debit: result.totalDebit,
      total_credit: result.totalCredit,
    };
  }

  /**
   * ACC-074: Open items report.
   * Open AR from unpaid payments. Open AP from bills whose allocations are short.
   * A paid invoice and a fully allocated bill are absent.
   */
  async getOpenItems(query: OpenItemsQueryDto): Promise<OpenItemsReportDto> {
    if (query.kind === 'ar') {
      const { items, totalOpenAmount } = await this.repository.getOpenArItems();
      return {
        kind: 'ar',
        ar_items: items,
        total_open_amount: totalOpenAmount,
      };
    } else {
      const { items, totalOpenAmount } = await this.repository.getOpenApItems();
      return {
        kind: 'ap',
        ap_items: items,
        total_open_amount: totalOpenAmount,
      };
    }
  }

  /**
   * ACC-075: GST summary for a date range.
   * Taxable value and output CGST, SGST, IGST by tax code, input tax credit, net payable.
   * Output tax per component equals that tax account's movement for the range.
   * Net payable equals output minus input.
   */
  async getGstSummary(query: GstSummaryQueryDto): Promise<GstSummaryReportDto> {
    const result = await this.repository.getGstSummary(query.from, query.to);

    return {
      from: query.from,
      to: query.to,
      tax_codes: result.taxCodes,
      total_taxable_value: result.totalTaxableValue,
      output_cgst: result.outputCgst,
      output_sgst: result.outputSgst,
      output_igst: result.outputIgst,
      total_output_tax: result.totalOutputTax,
      input_tax_credit: result.inputTaxCredit,
      net_payable: result.netPayable,
    };
  }
}
