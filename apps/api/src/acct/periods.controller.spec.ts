import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { PeriodsController } from './periods.controller';
import type {
  AccountingPeriodDto,
  FiscalYearDto,
  PeriodFilterQueryDto,
} from './periods.dto';
import type { PeriodsService } from './periods.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 42,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const SAMPLE_FISCAL_YEAR: FiscalYearDto = {
  id: 1,
  label: 'FY 2026-27',
  starts_on: '2026-04-01',
  ends_on: '2027-03-31',
};

const SAMPLE_PERIOD: AccountingPeriodDto = {
  id: 10,
  fiscal_year_id: 1,
  starts_on: '2026-04-01',
  ends_on: '2026-04-30',
  status: 'open',
  closed_at: null,
  closed_by_user_id: null,
};

const SAMPLE_LOCKED_PERIOD: AccountingPeriodDto = {
  id: 10,
  fiscal_year_id: 1,
  starts_on: '2026-04-01',
  ends_on: '2026-04-30',
  status: 'locked',
  closed_at: new Date('2026-05-01T12:00:00.000Z'),
  closed_by_user_id: 42,
  draft_document_counts: {
    purchase_bills: 1,
    expense_vouchers: 0,
    payment_vouchers: 0,
    credit_notes: 0,
    debit_notes: 0,
    total: 1,
  },
};

describe('PeriodsController', () => {
  let service: Partial<PeriodsService>;
  let controller: PeriodsController;

  beforeEach(() => {
    service = {
      listFiscalYears: vi.fn().mockResolvedValue([SAMPLE_FISCAL_YEAR]),
      listPeriods: vi.fn().mockResolvedValue([SAMPLE_PERIOD]),
      lock: vi.fn().mockResolvedValue(SAMPLE_LOCKED_PERIOD),
      unlock: vi.fn().mockResolvedValue(SAMPLE_PERIOD),
    };

    controller = new PeriodsController(service as PeriodsService);
  });

  describe('listFiscalYears', () => {
    it('requires accounting.read permission and delegates to service', async () => {
      expect(
        Reflect.getMetadata(
          REQUIRE_PERMISSIONS_KEY,
          PeriodsController.prototype.listFiscalYears,
        ),
      ).toEqual(['accounting.read']);

      const result = await controller.listFiscalYears(ADMIN_USER);

      expect(service.listFiscalYears).toHaveBeenCalledWith(ADMIN_USER);
      expect(result).toEqual([SAMPLE_FISCAL_YEAR]);
    });
  });

  describe('listPeriods', () => {
    it('requires accounting.read permission and delegates to service with filters', async () => {
      expect(
        Reflect.getMetadata(
          REQUIRE_PERMISSIONS_KEY,
          PeriodsController.prototype.listPeriods,
        ),
      ).toEqual(['accounting.read']);

      const query: PeriodFilterQueryDto = { fiscal_year_id: 1, status: 'open' };
      const result = await controller.listPeriods(query, ADMIN_USER);

      expect(service.listPeriods).toHaveBeenCalledWith(query, ADMIN_USER);
      expect(result).toEqual([SAMPLE_PERIOD]);
    });
  });

  describe('lock', () => {
    it('requires accounting.periods_close permission and delegates to service', async () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, PeriodsController.prototype.lock),
      ).toEqual(['accounting.periods_close']);

      const result = await controller.lock(10, ADMIN_USER);

      expect(service.lock).toHaveBeenCalledWith(10, ADMIN_USER);
      expect(result).toEqual(SAMPLE_LOCKED_PERIOD);
    });
  });

  describe('unlock', () => {
    it('requires accounting.periods_close permission and delegates to service', async () => {
      expect(
        Reflect.getMetadata(
          REQUIRE_PERMISSIONS_KEY,
          PeriodsController.prototype.unlock,
        ),
      ).toEqual(['accounting.periods_close']);

      const result = await controller.unlock(10, ADMIN_USER);

      expect(service.unlock).toHaveBeenCalledWith(10, ADMIN_USER);
      expect(result).toEqual(SAMPLE_PERIOD);
    });
  });
});
