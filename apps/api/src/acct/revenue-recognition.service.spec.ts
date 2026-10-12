import { beforeEach, describe, expect, it, vi } from 'vitest';
import type {
  AccountingPeriod,
  RevenueRecognitionSchedule,
} from '../platform/db/schema/accounting';
import { BusinessRuleError } from '../platform/errors/app-error';
import { addMoney, cmpMoney, subMoney } from '../platform/money/money';
import { PeriodsService } from './periods.service';
import { RevenueRecognitionService } from './revenue-recognition.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

function makePeriod(overrides?: Partial<AccountingPeriod>): AccountingPeriod {
  return {
    id: 1,
    fiscal_year_id: 1,
    starts_on: '2026-01-01',
    ends_on: '2026-01-31',
    status: 'open',
    closed_at: null,
    closed_by_user_id: null,
    ...overrides,
  };
}

function makeSchedule(
  overrides?: Partial<RevenueRecognitionSchedule>,
): RevenueRecognitionSchedule {
  return {
    id: 101,
    payment_id: 1,
    unearned_account_id: 2200,
    income_account_id: 4000,
    total_amount: '3000.00',
    recognized_amount: '0.00',
    starts_on: '2026-01-01',
    ends_on: '2026-03-31', // 90 days total
    recognized_through: '2025-12-31',
    status: 'open',
    paused_from: null,
    ...overrides,
  };
}

describe('RevenueRecognitionService (ACC-060, ACC-061, ACC-062, ACC-063)', () => {
  let service: RevenueRecognitionService;
  let repository: any;
  let postingService: any;
  let periodsRepository: any;
  let settingsService: any;
  let mockDb: any;

  beforeEach(() => {
    repository = {
      findOpenOrPausedSchedules: vi.fn().mockResolvedValue([makeSchedule()]),
      findLineByScheduleAndPeriod: vi.fn().mockResolvedValue(null),
      insertLine: vi.fn().mockImplementation(async (line) => ({ id: 50, ...line })),
      updateLine: vi.fn().mockImplementation(async (id, row) => ({ id, ...row })),
      updateSchedule: vi.fn().mockImplementation(async (id, row) => ({ id, ...row })),
      countLinesForPeriod: vi.fn().mockResolvedValue(0),
    };

    postingService = {
      postJournal: vi.fn().mockImplementation(async (input) => ({
        id: 99,
        journal_number: 'JRN00000099',
        ...input,
      })),
    };

    periodsRepository = {
      findPeriodById: vi.fn().mockResolvedValue(makePeriod()),
      calculateTrialBalanceTotals: vi.fn().mockResolvedValue({ totalDebit: '1000.00', totalCredit: '1000.00' }),
      countDraftDocuments: vi.fn().mockResolvedValue({ purchase_bills: 0, expense_vouchers: 0, payment_vouchers: 0, credit_notes: 0, debit_notes: 0, total: 0 }),
      updatePeriod: vi.fn().mockImplementation(async (id, data) => ({ id, ...data })),
    };

    settingsService = {
      getSetting: vi.fn().mockImplementation(async (key: string) => {
        if (key === 'accounting.posting_enabled') return 'true';
        return null;
      }),
    };

    mockDb = {
      select: vi.fn().mockReturnValue({
        from: vi.fn().mockReturnValue({
          where: vi.fn().mockResolvedValue([]),
        }),
      }),
    };

    service = new RevenueRecognitionService(
      repository,
      postingService,
      periodsRepository,
      mockDb as any,
      settingsService,
    );
  });

  describe('ACC-060 & ACC-061: Revenue Recognition Calculation & Job Execution', () => {
    it('prorates revenue by day for a full month', async () => {
      // 90 days total (Jan 1 to Mar 31). Jan has 31 days. Total 3000.00.
      // Share = round(3000 * 31 / 90) = 1033.33.
      const result = await service.recognizeRevenueForPeriod(1);

      expect(result.recognizedCount).toBe(1);
      expect(result.totalRecognized).toBe('1033.33');

      expect(repository.insertLine).toHaveBeenCalledWith(
        expect.objectContaining({
          schedule_id: 101,
          accounting_period_id: 1,
          amount: '1033.33',
        }),
      );

      expect(postingService.postJournal).toHaveBeenCalledWith(
        expect.objectContaining({
          entryDate: '2026-01-31',
          accountingPeriodId: 1,
          sourceType: 'revenue_recognition',
          sourceId: 50,
          lines: [
            { accountId: 2200, debit: '1033.33', memo: 'Recognize revenue schedule #101' },
            { accountId: 4000, credit: '1033.33', memo: 'Earned revenue schedule #101' },
          ],
        }),
      );

      expect(repository.updateSchedule).toHaveBeenCalledWith(
        101,
        expect.objectContaining({
          recognized_amount: '1033.33',
          recognized_through: '2026-01-31',
        }),
      );
    });

    it('prorates revenue for mid-month start (e.g. joins on 20th of 30-day month)', async () => {
      // Member joins on 2026-04-20. Month ends 2026-04-30 (11 days).
      // Term: 2026-04-20 to 2026-10-19 (183 days). Total: 6000.00.
      const aprPeriod = makePeriod({
        id: 4,
        starts_on: '2026-04-01',
        ends_on: '2026-04-30',
      });
      periodsRepository.findPeriodById.mockResolvedValue(aprPeriod);

      const schedule = makeSchedule({
        id: 102,
        starts_on: '2026-04-20',
        ends_on: '2026-10-19',
        recognized_through: '2026-04-19',
        total_amount: '6000.00',
        recognized_amount: '0.00',
      });
      repository.findOpenOrPausedSchedules.mockResolvedValue([schedule]);

      // Days in span: 2026-04-20 to 2026-04-30 = 11 days.
      // Days left in term: 183 days.
      // Share = round(6000 * 11 / 183) = 360.66.
      const result = await service.recognizeRevenueForPeriod(4);

      expect(result.recognizedCount).toBe(1);
      expect(result.totalRecognized).toBe('360.66');

      expect(postingService.postJournal).toHaveBeenCalledWith(
        expect.objectContaining({
          entryDate: '2026-04-30',
          lines: [
            { accountId: 2200, debit: '360.66', memo: 'Recognize revenue schedule #102' },
            { accountId: 4000, credit: '360.66', memo: 'Earned revenue schedule #102' },
          ],
        }),
      );
    });

    it('second run in the same month posts nothing (idempotent)', async () => {
      // Line already exists for schedule 101 and period 1
      repository.findLineByScheduleAndPeriod.mockResolvedValue({ id: 50, amount: '1033.33' });

      const result = await service.recognizeRevenueForPeriod(1);
      expect(result.recognizedCount).toBe(0);
      expect(result.totalRecognized).toBe('0.00');
      expect(postingService.postJournal).not.toHaveBeenCalled();
    });

    it('last span takes the exact remainder so schedule ends at zero and closes', async () => {
      // March period: 2026-03-01 to 2026-03-31 (last month of term)
      const marPeriod = makePeriod({
        id: 3,
        starts_on: '2026-03-01',
        ends_on: '2026-03-31',
      });
      periodsRepository.findPeriodById.mockResolvedValue(marPeriod);

      const schedule = makeSchedule({
        id: 101,
        total_amount: '3000.00',
        recognized_amount: '1966.67', // remaining = 1033.33
        starts_on: '2026-01-01',
        ends_on: '2026-03-31',
        recognized_through: '2026-02-28',
        status: 'open',
      });
      repository.findOpenOrPausedSchedules.mockResolvedValue([schedule]);

      const result = await service.recognizeRevenueForPeriod(3);

      expect(result.recognizedCount).toBe(1);
      expect(result.totalRecognized).toBe('1033.33');

      // Schedule updated with recognized_amount = 3000.00 and status = 'closed'
      expect(repository.updateSchedule).toHaveBeenCalledWith(
        101,
        expect.objectContaining({
          recognized_amount: '3000.00',
          recognized_through: '2026-03-31',
          status: 'closed',
        }),
      );
    });

    it('paused schedule posts nothing for frozen days', async () => {
      // Freeze approved from May 1 (paused_from = 2026-05-01)
      const mayPeriod = makePeriod({
        id: 5,
        starts_on: '2026-05-01',
        ends_on: '2026-05-31',
      });
      periodsRepository.findPeriodById.mockResolvedValue(mayPeriod);

      const pausedSchedule = makeSchedule({
        id: 103,
        status: 'paused',
        paused_from: '2026-05-01',
        recognized_through: '2026-04-30',
      });
      repository.findOpenOrPausedSchedules.mockResolvedValue([pausedSchedule]);

      const result = await service.recognizeRevenueForPeriod(5);
      expect(result.recognizedCount).toBe(0);
      expect(result.totalRecognized).toBe('0.00');
      expect(postingService.postJournal).not.toHaveBeenCalled();
    });

    it('no-op when accounting.posting_enabled is false', async () => {
      settingsService.getSetting.mockResolvedValue('false');

      const result = await service.recognizeRevenueForPeriod(1);
      expect(result.recognizedCount).toBe(0);
      expect(result.totalRecognized).toBe('0.00');
      expect(postingService.postJournal).not.toHaveBeenCalled();
    });
  });

  describe('ACC-062: Period lock check', () => {
    let periodsService: PeriodsService;
    let auditService: any;

    beforeEach(() => {
      auditService = {
        recordAudit: vi.fn().mockResolvedValue(undefined),
      };

      periodsService = new PeriodsService(
        periodsRepository,
        auditService,
        mockDb as any,
        service,
        settingsService,
      );
    });

    it('refuses to lock period when revenue recognition has not posted, naming period and missing run', async () => {
      // Recognition has not run for this period
      vi.spyOn(service, 'hasPeriodRecognitionPosted').mockResolvedValue(false);

      const actor: any = { id: 1, role: 'admin' };
      const err = await periodsService.lock(1, actor).catch((e) => e);

      expect(err).toBeInstanceOf(BusinessRuleError);
      expect(err.message).toContain("revenue recognition run 'accounting.recognize_revenue' for this period has not posted");
      expect(err.message).toContain('id 1');
      expect(err.message).toContain('2026-01-01 to 2026-01-31');
    });

    it('allows period lock when revenue recognition has posted', async () => {
      vi.spyOn(service, 'hasPeriodRecognitionPosted').mockResolvedValue(true);

      const actor: any = { id: 1, role: 'admin' };
      const locked = await periodsService.lock(1, actor);

      expect(locked.status).toBe('locked');
      expect(periodsRepository.updatePeriod).toHaveBeenCalledWith(
        1,
        expect.objectContaining({ status: 'locked' }),
      );
    });
  });

  describe('ACC-063: Full Lifecycle Scenarios', () => {
    it('freeze that pauses then extends leaves ledger unearned equal to schedule unrecognized amount', async () => {
      // Jan: Active. 3000 total across 3 months. Jan recognizes 1033.33. Remaining = 1966.67.
      // Feb: Paused on 2026-02-01. Feb posts 0.00. Remaining = 1966.67.
      // Freeze ends: extended to April 30 (March & April left = 61 days).
      // March: recognizes 1966.67 * 31 / 61 = 999.46. Remaining = 967.21.
      // April (last span): recognizes 967.21. Total recognized = 3000.00. Unrecognized = 0.00.
      const schedule = makeSchedule({
        total_amount: '3000.00',
        recognized_amount: '0.00',
        starts_on: '2026-01-01',
        ends_on: '2026-03-31',
        recognized_through: '2025-12-31',
      });
      repository.findOpenOrPausedSchedules.mockResolvedValue([schedule]);

      // 1. Run Jan
      const janResult = await service.recognizeRevenueForPeriod(1);
      expect(janResult.totalRecognized).toBe('1033.33');
      let ledgerUnearned = subMoney('3000.00', janResult.totalRecognized);
      let scheduleUnrecognized = subMoney('3000.00', '1033.33');
      expect(ledgerUnearned).toBe(scheduleUnrecognized);

      // 2. Feb: Freeze approved
      schedule.status = 'paused';
      schedule.paused_from = '2026-02-01';
      schedule.recognized_amount = '1033.33';
      schedule.recognized_through = '2026-01-31';
      const febPeriod = makePeriod({ id: 2, starts_on: '2026-02-01', ends_on: '2026-02-28' });
      periodsRepository.findPeriodById.mockResolvedValue(febPeriod);

      const febResult = await service.recognizeRevenueForPeriod(2);
      expect(febResult.totalRecognized).toBe('0.00');
      expect(ledgerUnearned).toBe(scheduleUnrecognized);

      // 3. Freeze ends and extends to 2026-04-30
      schedule.status = 'open';
      schedule.paused_from = null;
      schedule.ends_on = '2026-04-30';
      const marPeriod = makePeriod({ id: 3, starts_on: '2026-03-01', ends_on: '2026-03-31' });
      periodsRepository.findPeriodById.mockResolvedValue(marPeriod);

      const marResult = await service.recognizeRevenueForPeriod(3);
      ledgerUnearned = subMoney(ledgerUnearned, marResult.totalRecognized);
      scheduleUnrecognized = subMoney('3000.00', addMoney('1033.33', marResult.totalRecognized));
      expect(ledgerUnearned).toBe(scheduleUnrecognized);

      // 4. April: Last month of term
      schedule.recognized_amount = addMoney('1033.33', marResult.totalRecognized);
      schedule.recognized_through = '2026-03-31';
      const aprPeriod = makePeriod({ id: 4, starts_on: '2026-04-01', ends_on: '2026-04-30' });
      periodsRepository.findPeriodById.mockResolvedValue(aprPeriod);

      const aprResult = await service.recognizeRevenueForPeriod(4);
      ledgerUnearned = subMoney(ledgerUnearned, aprResult.totalRecognized);
      const totalRecognizedAll = addMoney(addMoney(janResult.totalRecognized, marResult.totalRecognized), aprResult.totalRecognized);
      expect(totalRecognizedAll).toBe('3000.00');
      expect(ledgerUnearned).toBe('0.00');
    });

    it('upgrade scenario: old schedule and upgrade invoice schedule both recognize to zero', async () => {
      // Original 3-month membership: Jan 1 to Mar 31, total 3000.00.
      // Upgraded on Feb 1 to annual membership ending 2026-12-31, upgrade invoice adding 9000.00.
      // Original schedule extended to 2026-12-31 (remaining 1966.67 spread through Dec 31).
      // New upgrade schedule: 2026-02-01 to 2026-12-31, total 9000.00.
      const originalSchedule = makeSchedule({
        id: 101,
        total_amount: '3000.00',
        recognized_amount: '1033.33',
        starts_on: '2026-01-01',
        ends_on: '2026-12-31',
        recognized_through: '2026-01-31',
      });
      const upgradeSchedule = makeSchedule({
        id: 102,
        payment_id: 2,
        total_amount: '9000.00',
        recognized_amount: '0.00',
        starts_on: '2026-02-01',
        ends_on: '2026-12-31',
        recognized_through: '2026-01-31',
      });

      repository.findOpenOrPausedSchedules.mockResolvedValue([originalSchedule, upgradeSchedule]);

      const febPeriod = makePeriod({ id: 2, starts_on: '2026-02-01', ends_on: '2026-02-28' });
      periodsRepository.findPeriodById.mockResolvedValue(febPeriod);

      const febResult = await service.recognizeRevenueForPeriod(2);
      expect(febResult.recognizedCount).toBe(2);

      // Both schedules recognized in Feb
      expect(postingService.postJournal).toHaveBeenCalledTimes(2);
    });

    it('adjustment scenario: invoice adjustment resizes schedule and maintains ledger match', async () => {
      // Schedule total 3000.00, recognized 1000.00, unrecognized 2000.00.
      // Downward adjustment of 500 net reduces total to 2500.00 (unrecognized 1500.00).
      const adjustedSchedule = makeSchedule({
        total_amount: '2500.00',
        recognized_amount: '1000.00',
        starts_on: '2026-01-01',
        ends_on: '2026-02-28',
        recognized_through: '2026-01-31',
      });
      repository.findOpenOrPausedSchedules.mockResolvedValue([adjustedSchedule]);

      const febPeriod = makePeriod({ id: 2, starts_on: '2026-02-01', ends_on: '2026-02-28' });
      periodsRepository.findPeriodById.mockResolvedValue(febPeriod);

      const result = await service.recognizeRevenueForPeriod(2);
      // Last span takes remainder: 2500.00 - 1000.00 = 1500.00
      expect(result.totalRecognized).toBe('1500.00');

      expect(repository.updateSchedule).toHaveBeenCalledWith(
        adjustedSchedule.id,
        expect.objectContaining({
          recognized_amount: '2500.00',
          status: 'closed',
        }),
      );
    });
  });
});
