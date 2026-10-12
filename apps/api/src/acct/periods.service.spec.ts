import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { AuditService } from '../platform/audit/audit.service';
import type { AccountingPeriod, FiscalYear } from '../platform/db/schema/accounting';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import { PeriodsService } from './periods.service';
import type { PeriodsRepository } from './periods.repository';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

const ADMIN_USER: AuthenticatedUser = {
  id: 42,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const SAMPLE_FISCAL_YEAR: FiscalYear = {
  id: 1,
  label: 'FY 2026-27',
  starts_on: '2026-04-01',
  ends_on: '2027-03-31',
};

const SAMPLE_OPEN_PERIOD: AccountingPeriod = {
  id: 10,
  fiscal_year_id: 1,
  starts_on: '2026-04-01',
  ends_on: '2026-04-30',
  status: 'open',
  closed_at: null,
  closed_by_user_id: null,
};

const SAMPLE_LOCKED_PERIOD: AccountingPeriod = {
  id: 10,
  fiscal_year_id: 1,
  starts_on: '2026-04-01',
  ends_on: '2026-04-30',
  status: 'locked',
  closed_at: new Date('2026-05-01T10:00:00.000Z'),
  closed_by_user_id: 42,
};

describe('PeriodsService', () => {
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let auditService: { recordAudit: ReturnType<typeof vi.fn> };
  let service: PeriodsService;
  const db = {} as any;

  beforeEach(() => {
    repository = {
      listFiscalYears: vi.fn().mockResolvedValue([SAMPLE_FISCAL_YEAR]),
      listPeriods: vi.fn().mockResolvedValue([SAMPLE_OPEN_PERIOD]),
      findPeriodById: vi.fn().mockResolvedValue(SAMPLE_OPEN_PERIOD),
      updatePeriod: vi.fn().mockImplementation(async (_id, data) => ({
        ...SAMPLE_OPEN_PERIOD,
        ...data,
      })),
      calculateTrialBalanceTotals: vi.fn().mockResolvedValue({
        totalDebit: '1000.00',
        totalCredit: '1000.00',
      }),
      countDraftDocuments: vi.fn().mockResolvedValue({
        purchase_bills: 2,
        expense_vouchers: 1,
        payment_vouchers: 0,
        credit_notes: 1,
        debit_notes: 0,
        total: 4,
      }),
    };

    auditService = {
      recordAudit: vi.fn().mockResolvedValue(undefined),
    };

    service = new PeriodsService(
      repository as unknown as PeriodsRepository,
      auditService as unknown as AuditService,
      db,
    );
  });

  describe('listFiscalYears', () => {
    it('returns all fiscal years mapped to DTOs', async () => {
      const result = await service.listFiscalYears(ADMIN_USER);

      expect(repository.listFiscalYears).toHaveBeenCalledOnce();
      expect(result).toEqual([
        {
          id: 1,
          label: 'FY 2026-27',
          starts_on: '2026-04-01',
          ends_on: '2027-03-31',
        },
      ]);
    });
  });

  describe('listPeriods', () => {
    it('returns all periods when no filters provided', async () => {
      const result = await service.listPeriods({}, ADMIN_USER);

      expect(repository.listPeriods).toHaveBeenCalledWith({
        fiscal_year_id: undefined,
        status: undefined,
      });
      expect(result).toEqual([
        {
          id: 10,
          fiscal_year_id: 1,
          starts_on: '2026-04-01',
          ends_on: '2026-04-30',
          status: 'open',
          closed_at: null,
          closed_by_user_id: null,
        },
      ]);
    });

    it('passes fiscal_year_id and status filters to repository', async () => {
      await service.listPeriods(
        { fiscal_year_id: '1', status: 'open' },
        ADMIN_USER,
      );

      expect(repository.listPeriods).toHaveBeenCalledWith({
        fiscal_year_id: 1,
        status: 'open',
      });
    });
  });

  describe('lock', () => {
    it('throws NotFoundError if period does not exist', async () => {
      repository.findPeriodById.mockResolvedValue(null);

      await expect(service.lock(999, ADMIN_USER)).rejects.toThrow(NotFoundError);
      expect(repository.findPeriodById).toHaveBeenCalledWith(999);
    });

    it('throws BusinessRuleError if period is already locked', async () => {
      repository.findPeriodById.mockResolvedValue(SAMPLE_LOCKED_PERIOD);

      await expect(service.lock(10, ADMIN_USER)).rejects.toThrow(
        new BusinessRuleError('Period is already locked'),
      );
    });

    it('throws BusinessRuleError if trial balance through period is unbalanced', async () => {
      repository.calculateTrialBalanceTotals.mockResolvedValue({
        totalDebit: '1000.00',
        totalCredit: '950.00',
      });

      await expect(service.lock(10, ADMIN_USER)).rejects.toThrow(
        new BusinessRuleError(
          'Cannot lock period: trial balance through period is unbalanced',
        ),
      );
      expect(repository.calculateTrialBalanceTotals).toHaveBeenCalledWith('2026-04-30');
      expect(repository.updatePeriod).not.toHaveBeenCalled();
    });

    it('locks period, counts drafts, records audit, and returns DTO with draft counts when balanced', async () => {
      const now = new Date('2026-05-01T12:00:00.000Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      try {
        const result = await service.lock(10, ADMIN_USER);

        expect(repository.calculateTrialBalanceTotals).toHaveBeenCalledWith('2026-04-30');
        expect(repository.countDraftDocuments).toHaveBeenCalledWith(
          '2026-04-01',
          '2026-04-30',
        );
        expect(repository.updatePeriod).toHaveBeenCalledWith(10, {
          status: 'locked',
          closed_at: now,
          closed_by_user_id: 42,
        });
        expect(auditService.recordAudit).toHaveBeenCalledWith({
          actorUserId: 42,
          action: 'accounting.period.lock',
          entityName: 'accounting_period',
          entityId: 10,
          beforeState: { status: 'open' },
          afterState: { status: 'locked' },
        });

        expect(result).toEqual({
          id: 10,
          fiscal_year_id: 1,
          starts_on: '2026-04-01',
          ends_on: '2026-04-30',
          status: 'locked',
          closed_at: now,
          closed_by_user_id: 42,
          draft_document_counts: {
            purchase_bills: 2,
            expense_vouchers: 1,
            payment_vouchers: 0,
            credit_notes: 1,
            debit_notes: 0,
            total: 4,
          },
        });
      } finally {
        vi.useRealTimers();
      }
    });
  });

  describe('unlock', () => {
    it('throws NotFoundError if period does not exist', async () => {
      repository.findPeriodById.mockResolvedValue(null);

      await expect(service.unlock(999, ADMIN_USER)).rejects.toThrow(NotFoundError);
    });

    it('throws BusinessRuleError if period is not locked', async () => {
      repository.findPeriodById.mockResolvedValue(SAMPLE_OPEN_PERIOD);

      await expect(service.unlock(10, ADMIN_USER)).rejects.toThrow(
        new BusinessRuleError('Period is not locked'),
      );
    });

    it('unlocks period, resets closed fields, records audit, and returns updated DTO', async () => {
      repository.findPeriodById.mockResolvedValue(SAMPLE_LOCKED_PERIOD);

      const result = await service.unlock(10, ADMIN_USER);

      expect(repository.updatePeriod).toHaveBeenCalledWith(10, {
        status: 'open',
        closed_at: null,
        closed_by_user_id: null,
      });
      expect(auditService.recordAudit).toHaveBeenCalledWith({
        actorUserId: 42,
        action: 'accounting.period.unlock',
        entityName: 'accounting_period',
        entityId: 10,
        beforeState: { status: 'locked' },
        afterState: { status: 'open' },
      });

      expect(result).toEqual({
        id: 10,
        fiscal_year_id: 1,
        starts_on: '2026-04-01',
        ends_on: '2026-04-30',
        status: 'open',
        closed_at: null,
        closed_by_user_id: null,
      });
    });
  });
});
