import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { Account, RevenueRecognitionSchedule } from '../platform/db/schema/accounting';
import { NotFoundError } from '../platform/errors/app-error';
import { RevenueRecognitionPortService } from './revenue-recognition-port.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

const ACCOUNTS: Record<string, Account> = {
  '2200': {
    id: 2200,
    code: '2200',
    name: 'Unearned membership revenue',
    account_type: 'liability',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: true,
    control_role: 'unearned_membership',
    created_at: new Date(),
    updated_at: null,
  },
  '2210': {
    id: 2210,
    code: '2210',
    name: 'Unearned PT revenue',
    account_type: 'liability',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: true,
    control_role: 'unearned_pt',
    created_at: new Date(),
    updated_at: null,
  },
  '4300': {
    id: 4300,
    code: '4300',
    name: 'Forfeited membership income',
    account_type: 'income',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: false,
    control_role: null,
    created_at: new Date(),
    updated_at: null,
  },
};

function makeSchedule(overrides?: Partial<RevenueRecognitionSchedule>): RevenueRecognitionSchedule {
  return {
    id: 101,
    payment_id: 50,
    unearned_account_id: 2200,
    income_account_id: 4000,
    total_amount: '12000.00',
    recognized_amount: '4000.00',
    starts_on: '2026-01-01',
    ends_on: '2026-12-31',
    recognized_through: '2026-04-30',
    status: 'open',
    paused_from: null,
    ...overrides,
  };
}

describe('RevenueRecognitionPortService', () => {
  let service: RevenueRecognitionPortService;
  let revenueRecognitionRepository: {
    findByMembershipId: ReturnType<typeof vi.fn>;
    findByPtSubscriptionId: ReturnType<typeof vi.fn>;
    updateSchedule: ReturnType<typeof vi.fn>;
  };
  let postingService: {
    postJournal: ReturnType<typeof vi.fn>;
  };
  let accountsRepository: {
    findByCode: ReturnType<typeof vi.fn>;
  };
  let settingsService: {
    getSetting: ReturnType<typeof vi.fn>;
  };

  beforeEach(() => {
    revenueRecognitionRepository = {
      findByMembershipId: vi.fn().mockResolvedValue([makeSchedule()]),
      findByPtSubscriptionId: vi.fn().mockResolvedValue([
        makeSchedule({ unearned_account_id: 2210, income_account_id: 4100 }),
      ]),
      updateSchedule: vi.fn().mockImplementation(async (id, row) => ({ id, ...row })),
    };

    postingService = {
      postJournal: vi.fn().mockResolvedValue({
        id: 999,
        journal_number: 'JRN00000099',
      }),
    };

    accountsRepository = {
      findByCode: vi.fn().mockImplementation(async (code: string) => ACCOUNTS[code] ?? null),
    };

    settingsService = {
      getSetting: vi.fn().mockImplementation(async (key: string) => {
        if (key === 'accounting.posting_enabled') return 'true';
        return null;
      }),
    };

    service = new RevenueRecognitionPortService(
      revenueRecognitionRepository as any,
      postingService as any,
      accountsRepository as any,
      {} as any,
      settingsService as any,
    );
  });

  describe('no-op when posting is disabled', () => {
    beforeEach(() => {
      settingsService.getSetting.mockResolvedValue('false');
    });

    it('onFreezeApproved does nothing', async () => {
      await service.onFreezeApproved({ membershipId: 1, freezeStartDate: '2026-05-01' });
      expect(revenueRecognitionRepository.findByMembershipId).not.toHaveBeenCalled();
      expect(revenueRecognitionRepository.updateSchedule).not.toHaveBeenCalled();
    });

    it('onFreezeEnded does nothing', async () => {
      await service.onFreezeEnded({ membershipId: 1, newEndDate: '2027-01-31' });
      expect(revenueRecognitionRepository.findByMembershipId).not.toHaveBeenCalled();
      expect(revenueRecognitionRepository.updateSchedule).not.toHaveBeenCalled();
    });

    it('onMembershipExtended does nothing', async () => {
      await service.onMembershipExtended({ membershipId: 1, newEndDate: '2027-02-28' });
      expect(revenueRecognitionRepository.findByMembershipId).not.toHaveBeenCalled();
      expect(revenueRecognitionRepository.updateSchedule).not.toHaveBeenCalled();
    });

    it('onPtExtended does nothing', async () => {
      await service.onPtExtended({ ptSubscriptionId: 5, newEndDate: '2026-11-30' });
      expect(revenueRecognitionRepository.findByPtSubscriptionId).not.toHaveBeenCalled();
      expect(revenueRecognitionRepository.updateSchedule).not.toHaveBeenCalled();
    });

    it('onMembershipCancelled does nothing', async () => {
      await service.onMembershipCancelled({ membershipId: 1 });
      expect(revenueRecognitionRepository.findByMembershipId).not.toHaveBeenCalled();
      expect(postingService.postJournal).not.toHaveBeenCalled();
    });

    it('onPtCancelled does nothing', async () => {
      await service.onPtCancelled({ ptSubscriptionId: 5 });
      expect(revenueRecognitionRepository.findByPtSubscriptionId).not.toHaveBeenCalled();
      expect(postingService.postJournal).not.toHaveBeenCalled();
    });
  });

  describe('freeze approval and end (ACC-058)', () => {
    it('pauses open schedule and sets paused_from on freeze approval', async () => {
      const schedule = makeSchedule({ status: 'open', paused_from: null });
      revenueRecognitionRepository.findByMembershipId.mockResolvedValue([schedule]);

      await service.onFreezeApproved({
        membershipId: 10,
        freezeStartDate: '2026-06-01',
      });

      expect(revenueRecognitionRepository.findByMembershipId).toHaveBeenCalledWith(10, ['open']);
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(101, {
        status: 'paused',
        paused_from: '2026-06-01',
      });
    });

    it('unpauses paused schedule, moves ends_on and clears paused_from on freeze end', async () => {
      const schedule = makeSchedule({ status: 'paused', paused_from: '2026-06-01' });
      revenueRecognitionRepository.findByMembershipId.mockResolvedValue([schedule]);

      await service.onFreezeEnded({
        membershipId: 10,
        newEndDate: '2027-01-15',
      });

      expect(revenueRecognitionRepository.findByMembershipId).toHaveBeenCalledWith(10, ['paused']);
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(101, {
        status: 'open',
        ends_on: '2027-01-15',
        paused_from: null,
      });
    });
  });

  describe('membership & PT extension (ACC-058)', () => {
    it('moves ends_on on membership extension', async () => {
      await service.onMembershipExtended({
        membershipId: 10,
        newEndDate: '2027-03-31',
      });

      expect(revenueRecognitionRepository.findByMembershipId).toHaveBeenCalledWith(10, [
        'open',
        'paused',
      ]);
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(101, {
        ends_on: '2027-03-31',
      });
    });

    it('moves ends_on on membership upgrade', async () => {
      await service.onMembershipUpgraded({
        membershipId: 10,
        newEndDate: '2027-04-30',
      });

      expect(revenueRecognitionRepository.findByMembershipId).toHaveBeenCalledWith(10, [
        'open',
        'paused',
      ]);
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(101, {
        ends_on: '2027-04-30',
      });
    });

    it('moves ends_on on PT extension', async () => {
      await service.onPtExtended({
        ptSubscriptionId: 77,
        newEndDate: '2026-10-31',
      });

      expect(revenueRecognitionRepository.findByPtSubscriptionId).toHaveBeenCalledWith(77, [
        'open',
        'paused',
      ]);
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(101, {
        ends_on: '2026-10-31',
      });
    });
  });

  describe('cancellation forfeiture (ACC-059)', () => {
    it('forfeits remaining unearned balance to 4300 and closes schedule on membership cancel', async () => {
      // total = 12000, recognized = 4000, remaining unearned = 8000
      const schedule = makeSchedule({
        id: 101,
        total_amount: '12000.00',
        recognized_amount: '4000.00',
        unearned_account_id: 2200,
      });
      revenueRecognitionRepository.findByMembershipId.mockResolvedValue([schedule]);

      await service.onMembershipCancelled({
        membershipId: 10,
        cancelledByUserId: 1,
        cancelDate: '2026-05-15',
      });

      expect(postingService.postJournal).toHaveBeenCalledTimes(1);
      const postCall = postingService.postJournal.mock.calls[0][0];
      expect(postCall.sourceType).toBe('recognition_forfeit');
      expect(postCall.sourceId).toBe(101);
      expect(postCall.entryDate).toBe('2026-05-15');
      expect(postCall.postedByUserId).toBe(1);

      // Debit 2200 Unearned for 8000.00, Credit 4300 Forfeited income for 8000.00
      expect(postCall.lines).toEqual([
        {
          accountId: 2200,
          debit: '8000.00',
          memo: 'Forfeit unearned balance schedule #101',
        },
        {
          accountId: 4300,
          credit: '8000.00',
          memo: 'Forfeited income from cancelled membership #10',
        },
      ]);

      // Schedule closed with total_amount set to recognized_amount (so unearned remaining is 0)
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(101, {
        status: 'closed',
        total_amount: '4000.00',
      });
    });

    it('forfeits remaining unearned balance to 4300 and closes schedule on PT cancel', async () => {
      // PT unearned = 2210, total = 6000, recognized = 1000, remaining = 5000
      const schedule = makeSchedule({
        id: 202,
        total_amount: '6000.00',
        recognized_amount: '1000.00',
        unearned_account_id: 2210,
      });
      revenueRecognitionRepository.findByPtSubscriptionId.mockResolvedValue([schedule]);

      await service.onPtCancelled({
        ptSubscriptionId: 88,
        cancelledByUserId: 2,
        cancelDate: '2026-07-20',
      });

      expect(postingService.postJournal).toHaveBeenCalledTimes(1);
      const postCall = postingService.postJournal.mock.calls[0][0];
      expect(postCall.sourceType).toBe('recognition_forfeit');
      expect(postCall.sourceId).toBe(202);
      expect(postCall.entryDate).toBe('2026-07-20');
      expect(postCall.lines).toEqual([
        {
          accountId: 2210,
          debit: '5000.00',
          memo: 'Forfeit unearned balance schedule #202',
        },
        {
          accountId: 4300,
          credit: '5000.00',
          memo: 'Forfeited income from cancelled PT #88',
        },
      ]);

      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(202, {
        status: 'closed',
        total_amount: '1000.00',
      });
    });

    it('does not post forfeit journal if remaining unearned is zero, but closes schedule', async () => {
      // Fully recognized schedule: total = 5000, recognized = 5000, remaining = 0
      const schedule = makeSchedule({
        id: 303,
        total_amount: '5000.00',
        recognized_amount: '5000.00',
        unearned_account_id: 2200,
      });
      revenueRecognitionRepository.findByMembershipId.mockResolvedValue([schedule]);

      await service.onMembershipCancelled({ membershipId: 15 });

      expect(postingService.postJournal).not.toHaveBeenCalled();
      expect(revenueRecognitionRepository.updateSchedule).toHaveBeenCalledWith(303, {
        status: 'closed',
        total_amount: '5000.00',
      });
    });

    it('throws NotFoundError if account 4300 is missing when unearned remaining > 0', async () => {
      accountsRepository.findByCode.mockResolvedValue(null);
      const schedule = makeSchedule({
        total_amount: '1000.00',
        recognized_amount: '0.00',
      });
      revenueRecognitionRepository.findByMembershipId.mockResolvedValue([schedule]);

      await expect(
        service.onMembershipCancelled({ membershipId: 20 }),
      ).rejects.toThrow(NotFoundError);
    });
  });
});
