import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { ReportsController } from './reports.controller';
import type {
  BalanceSheetReportDto,
  DayBookReportDto,
  GstSummaryReportDto,
  OpenItemsReportDto,
  ProfitAndLossReportDto,
  TrialBalanceReportDto,
} from './reports.dto';
import type { ReportsService } from './reports.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 42,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

describe('ReportsController', () => {
  let service: Partial<ReportsService>;
  let controller: ReportsController;

  const mockTrialBalance: TrialBalanceReportDto = {
    from: '2026-04-01',
    to: '2026-04-30',
    accounts: [],
    total_debit: '1000.00',
    total_credit: '1000.00',
  };

  const mockPnl: ProfitAndLossReportDto = {
    from: '2026-04-01',
    to: '2026-04-30',
    income_accounts: [],
    total_income: '5000.00',
    expense_accounts: [],
    total_expense: '2000.00',
    net_profit: '3000.00',
  };

  const mockBalanceSheet: BalanceSheetReportDto = {
    as_of: '2026-04-30',
    fiscal_year_start: '2026-04-01',
    asset_accounts: [],
    total_assets: '10000.00',
    liability_accounts: [],
    total_liabilities: '4000.00',
    equity_accounts: [],
    retained_earnings: '0.00',
    current_year_earnings: '3000.00',
    total_equity: '6000.00',
    total_liabilities_and_equity: '10000.00',
  };

  const mockDayBook: DayBookReportDto = {
    date: '2026-04-15',
    journals: [],
    total_debit: '500.00',
    total_credit: '500.00',
  };

  const mockOpenItems: OpenItemsReportDto = {
    kind: 'ar',
    ar_items: [],
    total_open_amount: '0.00',
  };

  const mockGstSummary: GstSummaryReportDto = {
    from: '2026-04-01',
    to: '2026-04-30',
    tax_codes: [],
    total_taxable_value: '10000.00',
    output_cgst: '900.00',
    output_sgst: '900.00',
    output_igst: '0.00',
    total_output_tax: '1800.00',
    input_tax_credit: '500.00',
    net_payable: '1300.00',
  };

  beforeEach(() => {
    service = {
      getTrialBalance: vi.fn().mockResolvedValue(mockTrialBalance),
      getProfitAndLoss: vi.fn().mockResolvedValue(mockPnl),
      getBalanceSheet: vi.fn().mockResolvedValue(mockBalanceSheet),
      getDayBook: vi.fn().mockResolvedValue(mockDayBook),
      getOpenItems: vi.fn().mockResolvedValue(mockOpenItems),
      getGstSummary: vi.fn().mockResolvedValue(mockGstSummary),
    };

    controller = new ReportsController(service as ReportsService);
  });

  describe('getTrialBalance', () => {
    it('requires accounting.read permission and delegates to service', async () => {
      expect(
        Reflect.getMetadata(
          REQUIRE_PERMISSIONS_KEY,
          ReportsController.prototype.getTrialBalance,
        ),
      ).toEqual(['accounting.read']);

      const query = { from: '2026-04-01', to: '2026-04-30' };
      const result = await controller.getTrialBalance(query, ADMIN_USER);

      expect(service.getTrialBalance).toHaveBeenCalledWith(query);
      expect(result).toEqual(mockTrialBalance);
    });
  });

  describe('getProfitAndLoss', () => {
    it('requires accounting.read permission and delegates to service', async () => {
      expect(
        Reflect.getMetadata(
          REQUIRE_PERMISSIONS_KEY,
          ReportsController.prototype.getProfitAndLoss,
        ),
      ).toEqual(['accounting.read']);

      const query = { from: '2026-04-01', to: '2026-04-30' };
      const result = await controller.getProfitAndLoss(query, ADMIN_USER);

      expect(service.getProfitAndLoss).toHaveBeenCalledWith(query);
      expect(result).toEqual(mockPnl);
    });
  });

  describe('getBalanceSheet', () => {
    it('requires accounting.read permission and delegates to service', async () => {
      expect(
        Reflect.getMetadata(
          REQUIRE_PERMISSIONS_KEY,
          ReportsController.prototype.getBalanceSheet,
        ),
      ).toEqual(['accounting.read']);

      const query = { as_of: '2026-04-30' };
      const result = await controller.getBalanceSheet(query, ADMIN_USER);

      expect(service.getBalanceSheet).toHaveBeenCalledWith(query);
      expect(result).toEqual(mockBalanceSheet);
    });
  });

  describe('getDayBook', () => {
    it('requires accounting.read permission and delegates to service', async () => {
      expect(
        Reflect.getMetadata(
          REQUIRE_PERMISSIONS_KEY,
          ReportsController.prototype.getDayBook,
        ),
      ).toEqual(['accounting.read']);

      const query = { date: '2026-04-15' };
      const result = await controller.getDayBook(query, ADMIN_USER);

      expect(service.getDayBook).toHaveBeenCalledWith(query);
      expect(result).toEqual(mockDayBook);
    });
  });

  describe('getOpenItems', () => {
    it('requires accounting.read permission and delegates to service', async () => {
      expect(
        Reflect.getMetadata(
          REQUIRE_PERMISSIONS_KEY,
          ReportsController.prototype.getOpenItems,
        ),
      ).toEqual(['accounting.read']);

      const query = { kind: 'ar' as const };
      const result = await controller.getOpenItems(query, ADMIN_USER);

      expect(service.getOpenItems).toHaveBeenCalledWith(query);
      expect(result).toEqual(mockOpenItems);
    });
  });

  describe('getGstSummary', () => {
    it('requires accounting.read permission and delegates to service', async () => {
      expect(
        Reflect.getMetadata(
          REQUIRE_PERMISSIONS_KEY,
          ReportsController.prototype.getGstSummary,
        ),
      ).toEqual(['accounting.read']);

      const query = { from: '2026-04-01', to: '2026-04-30' };
      const result = await controller.getGstSummary(query, ADMIN_USER);

      expect(service.getGstSummary).toHaveBeenCalledWith(query);
      expect(result).toEqual(mockGstSummary);
    });
  });
});
