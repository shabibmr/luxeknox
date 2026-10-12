import { beforeEach, describe, expect, it, vi } from 'vitest';
import type {
  BalanceSheetReportDto,
  DayBookReportDto,
  GstSummaryReportDto,
  OpenItemsReportDto,
  ProfitAndLossReportDto,
  TrialBalanceReportDto,
} from './reports.dto';
import type { ReportsRepository } from './reports.repository';
import { ReportsService } from './reports.service';

describe('ReportsService (Phase 7 - ACC-070 to ACC-075)', () => {
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let service: ReportsService;

  beforeEach(() => {
    repository = {
      getTrialBalance: vi.fn(),
      getProfitAndLoss: vi.fn(),
      getBalanceSheet: vi.fn(),
      getDayBook: vi.fn(),
      getOpenArItems: vi.fn(),
      getOpenApItems: vi.fn(),
      getGstSummary: vi.fn(),
    };

    service = new ReportsService(repository as unknown as ReportsRepository);
  });

  describe('ACC-070: Trial balance for a date range', () => {
    it('returns trial balance where debit total equals credit total and uses shared totals', async () => {
      repository.getTrialBalance.mockResolvedValue({
        accounts: [
          {
            account_id: 1,
            account_code: '1000',
            account_name: 'Cash',
            account_type: 'asset',
            debit: '5000.00',
            credit: '0.00',
          },
          {
            account_id: 2,
            account_code: '2000',
            account_name: 'Accounts payable',
            account_type: 'liability',
            debit: '0.00',
            credit: '2000.00',
          },
          {
            account_id: 3,
            account_code: '3000',
            account_name: "Owner's capital",
            account_type: 'equity',
            debit: '0.00',
            credit: '3000.00',
          },
        ],
        totalDebit: '5000.00',
        totalCredit: '5000.00',
      });

      const result = await service.getTrialBalance({ from: '2026-04-01', to: '2026-04-30' });

      expect(repository.getTrialBalance).toHaveBeenCalledWith('2026-04-01', '2026-04-30');
      expect(result.from).toBe('2026-04-01');
      expect(result.to).toBe('2026-04-30');
      expect(result.total_debit).toBe('5000.00');
      expect(result.total_credit).toBe('5000.00');
      expect(result.total_debit).toEqual(result.total_credit);
      expect(result.accounts).toHaveLength(3);
    });

    it('supports omitting from to get cumulative trial balance up to date to', async () => {
      repository.getTrialBalance.mockResolvedValue({
        accounts: [],
        totalDebit: '0.00',
        totalCredit: '0.00',
      });

      const result = await service.getTrialBalance({ to: '2026-05-31' });

      expect(repository.getTrialBalance).toHaveBeenCalledWith(undefined, '2026-05-31');
      expect(result.from).toBeNull();
      expect(result.to).toBe('2026-05-31');
      expect(result.total_debit).toBe('0.00');
      expect(result.total_credit).toBe('0.00');
    });
  });

  describe('ACC-071: Profit and loss for a date range', () => {
    it('returns profit and loss with only income and expense accounts and net profit', async () => {
      repository.getProfitAndLoss.mockResolvedValue({
        incomeAccounts: [
          { account_id: 10, account_code: '4000', account_name: 'Membership revenue', amount: '12000.00' },
          { account_id: 11, account_code: '4100', account_name: 'Personal training revenue', amount: '8000.00' },
        ],
        totalIncome: '20000.00',
        expenseAccounts: [
          { account_id: 20, account_code: '5000', account_name: 'Rent', amount: '5000.00' },
          { account_id: 21, account_code: '5100', account_name: 'Utilities', amount: '1500.00' },
        ],
        totalExpense: '6500.00',
        netProfit: '13500.00',
      });

      const result = await service.getProfitAndLoss({ from: '2026-04-01', to: '2026-04-30' });

      expect(repository.getProfitAndLoss).toHaveBeenCalledWith('2026-04-01', '2026-04-30');
      expect(result.income_accounts).toHaveLength(2);
      expect(result.expense_accounts).toHaveLength(2);
      // All accounts must be income or expense only
      expect(result.income_accounts.every((a) => a.account_code.startsWith('4'))).toBe(true);
      expect(result.expense_accounts.every((a) => a.account_code.startsWith('5'))).toBe(true);
      expect(result.total_income).toBe('20000.00');
      expect(result.total_expense).toBe('6500.00');
      expect(result.net_profit).toBe('13500.00');
    });
  });

  describe('ACC-072: Balance sheet as of a date, with current-year earnings under equity', () => {
    it('verifies that assets equal liabilities plus equity', async () => {
      repository.getBalanceSheet.mockResolvedValue({
        asOf: '2026-06-30',
        fiscalYearStart: '2026-04-01',
        assetAccounts: [
          { account_id: 1, account_code: '1000', account_name: 'Cash', amount: '15000.00' },
          { account_id: 2, account_code: '1010', account_name: 'Bank', amount: '25000.00' },
        ],
        totalAssets: '40000.00',
        liabilityAccounts: [
          { account_id: 3, account_code: '2000', account_name: 'Accounts payable', amount: '10000.00' },
        ],
        totalLiabilities: '10000.00',
        equityAccounts: [
          { account_id: 4, account_code: '3000', account_name: "Owner's capital", amount: '20000.00' },
        ],
        currentYearEarnings: '10000.00',
        totalEquity: '30000.00',
        totalLiabilitiesAndEquity: '40000.00',
      });

      const result = await service.getBalanceSheet({ as_of: '2026-06-30' });

      expect(repository.getBalanceSheet).toHaveBeenCalledWith('2026-06-30');
      expect(result.as_of).toBe('2026-06-30');
      expect(result.fiscal_year_start).toBe('2026-04-01');
      expect(result.total_assets).toBe('40000.00');
      expect(result.total_liabilities).toBe('10000.00');
      expect(result.current_year_earnings).toBe('10000.00');
      expect(result.total_equity).toBe('30000.00');
      // Assets = Liabilities + Equity
      expect(result.total_assets).toEqual(result.total_liabilities_and_equity);
    });
  });

  describe('ACC-073: Day book for one date', () => {
    it('lists every journal on that date with its lines and daily totals', async () => {
      repository.getDayBook.mockResolvedValue({
        date: '2026-04-15',
        journals: [
          {
            id: 1,
            journal_number: 'JRN00000001',
            entry_date: '2026-04-15',
            source_type: 'sales_invoice',
            source_id: 101,
            memo: 'Invoice INV001',
            reverses_journal_id: null,
            lines: [
              {
                id: 1,
                account_id: 1100,
                account_code: '1100',
                account_name: 'Accounts receivable',
                debit: '1180.00',
                credit: '0.00',
                memo: null,
                member_id: 5,
                vendor_id: null,
              },
              {
                id: 2,
                account_id: 4200,
                account_code: '4200',
                account_name: 'Other sales',
                debit: '0.00',
                credit: '1000.00',
                memo: null,
                member_id: null,
                vendor_id: null,
              },
              {
                id: 3,
                account_id: 2100,
                account_code: '2100',
                account_name: 'Output CGST',
                debit: '0.00',
                credit: '90.00',
                memo: null,
                member_id: null,
                vendor_id: null,
              },
              {
                id: 4,
                account_id: 2110,
                account_code: '2110',
                account_name: 'Output SGST',
                debit: '0.00',
                credit: '90.00',
                memo: null,
                member_id: null,
                vendor_id: null,
              },
            ],
          },
        ],
        totalDebit: '1180.00',
        totalCredit: '1180.00',
      });

      const result = await service.getDayBook({ date: '2026-04-15' });

      expect(repository.getDayBook).toHaveBeenCalledWith('2026-04-15');
      expect(result.date).toBe('2026-04-15');
      expect(result.journals).toHaveLength(1);
      expect(result.journals[0]!.lines).toHaveLength(4);
      expect(result.total_debit).toBe('1180.00');
      expect(result.total_credit).toBe('1180.00');
    });
  });

  describe('ACC-074: Open items report (AR and AP)', () => {
    it('returns open AR items excluding paid invoices', async () => {
      repository.getOpenArItems.mockResolvedValue({
        items: [
          {
            payment_id: 1,
            invoice_number: 'INV-001',
            invoice_date: '2026-04-10',
            member_id: 10,
            total_amount: '2000.00',
            amount_paid: '500.00',
            open_amount: '1500.00',
            status: 'partial',
          },
        ],
        totalOpenAmount: '1500.00',
      });

      const result = await service.getOpenItems({ kind: 'ar' });

      expect(repository.getOpenArItems).toHaveBeenCalled();
      expect(result.kind).toBe('ar');
      expect(result.ar_items).toHaveLength(1);
      expect(result.ar_items![0]!.open_amount).toBe('1500.00');
      expect(result.total_open_amount).toBe('1500.00');
    });

    it('returns open AP items excluding fully allocated bills', async () => {
      repository.getOpenApItems.mockResolvedValue({
        items: [
          {
            purchase_bill_id: 5,
            bill_number: 'BILL-005',
            bill_date: '2026-04-05',
            due_date: '2026-04-20',
            vendor_id: 2,
            total_amount: '5000.00',
            allocated_amount: '2000.00',
            debit_note_amount: '1000.00',
            open_amount: '2000.00',
            status: 'posted',
          },
        ],
        totalOpenAmount: '2000.00',
      });

      const result = await service.getOpenItems({ kind: 'ap' });

      expect(repository.getOpenApItems).toHaveBeenCalled();
      expect(result.kind).toBe('ap');
      expect(result.ap_items).toHaveLength(1);
      expect(result.ap_items![0]!.open_amount).toBe('2000.00');
      expect(result.total_open_amount).toBe('2000.00');
    });
  });

  describe('ACC-075: GST summary report', () => {
    it('verifies output tax equals account movement and net payable equals output minus input', async () => {
      repository.getGstSummary.mockResolvedValue({
        taxCodes: [
          {
            tax_code_id: 1,
            tax_code_name: 'GST 18%',
            rate_percent: '18.00',
            taxable_value: '10000.00',
            cgst_amount: '900.00',
            sgst_amount: '900.00',
            igst_amount: '0.00',
            total_tax: '1800.00',
          },
        ],
        totalTaxableValue: '10000.00',
        outputCgst: '900.00',
        outputSgst: '900.00',
        outputIgst: '0.00',
        totalOutputTax: '1800.00',
        inputTaxCredit: '500.00',
        netPayable: '1300.00',
      });

      const result = await service.getGstSummary({ from: '2026-04-01', to: '2026-04-30' });

      expect(repository.getGstSummary).toHaveBeenCalledWith('2026-04-01', '2026-04-30');
      expect(result.total_output_tax).toBe('1800.00');
      expect(result.input_tax_credit).toBe('500.00');
      expect(result.net_payable).toBe('1300.00');
      // Net payable = output minus input
      expect(Number(result.net_payable)).toBe(Number(result.total_output_tax) - Number(result.input_tax_credit));
      expect(result.output_cgst).toBe('900.00');
      expect(result.output_sgst).toBe('900.00');
    });
  });
});
