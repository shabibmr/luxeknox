import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { Account } from '../platform/db/schema/accounting';
import { memberships, membershipProducts } from '../platform/db/schema/memberships';
import { payments, paymentMethods } from '../platform/db/schema/payments';
import { ptSubscriptions, ptProducts } from '../platform/db/schema/personal-training';
import { journalEntries, journalLines, taxCodes } from '../platform/db/schema/accounting';
import { BadRequestError, NotFoundError } from '../platform/errors/app-error';
import { SettingsService } from '../sys/settings.service';
import { GoLiveService } from './go-live.service';

const ACCOUNTS: Record<string, Account> = {
  '2200': {
    id: 2200,
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
    name: 'Unearned personal training revenue',
    account_type: 'liability',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: true,
    control_role: 'unearned_pt',
    created_at: new Date(),
    updated_at: null,
  },
  '4000': {
    id: 4000,
    name: 'Membership revenue',
    account_type: 'income',
    parent_id: null,
    is_active: true,
    is_bank: false,
    is_control: false,
    control_role: null,
    created_at: new Date(),
    updated_at: null,
  },
  '4100': {
    id: 4100,
    name: 'Personal training revenue',
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

describe('GoLiveService (ACC-064 & ACC-099)', () => {
  let goLiveService: GoLiveService;
  let accountsRepository: any;
  let revenueRecognitionRepository: any;
  let mockDb: any;

  beforeEach(() => {
    accountsRepository = {
      findByControlRole: vi.fn().mockImplementation(async (role: string) =>
        Object.values(ACCOUNTS).find((a) => a.control_role === role) ?? null),
      findByName: vi.fn().mockImplementation(async (name: string) =>
        Object.values(ACCOUNTS).find((a) => a.name === name) ?? null),
      findById: vi.fn().mockImplementation(async (id: number) => Object.values(ACCOUNTS).find((a) => a.id === id) ?? null),
    };

    revenueRecognitionRepository = {
      findByPaymentId: vi.fn().mockResolvedValue(null),
      insertSchedule: vi.fn().mockImplementation(async (row) => ({ id: 501, ...row })),
    };

    mockDb = {
      select: vi.fn(),
      update: vi.fn(),
    };

    goLiveService = new GoLiveService(
      accountsRepository,
      revenueRecognitionRepository,
      mockDb as any,
    );
  });

  describe('getUnearnedPreview', () => {
    it('calculates unexpired shares for running memberships and PT terms', async () => {
      // 1st query: running memberships
      // 2nd query: running PT
      mockDb.select
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            innerJoin: vi.fn().mockReturnValue({
              where: vi.fn().mockResolvedValue([
                {
                  membershipId: 10,
                  memberId: 1,
                  startDate: '2026-01-01',
                  endDate: '2026-03-31', // 90 days total
                  status: 'active',
                  productId: null,
                  paymentId: 100,
                  subtotal: '3000.00',
                  amountPaid: '3000.00',
                  paymentStatus: 'paid',
                },
              ]),
            }),
          }),
        })
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            innerJoin: vi.fn().mockReturnValue({
              where: vi.fn().mockResolvedValue([
                {
                  ptSubscriptionId: 20,
                  memberId: 2,
                  startDate: '2026-02-01',
                  endDate: '2026-03-31', // 59 days total
                  status: 'active',
                  ptProductId: null,
                  paymentId: 200,
                  subtotal: '5900.00',
                  amountPaid: '5900.00',
                  paymentStatus: 'paid',
                },
              ]),
            }),
          }),
        });

      // Go live on 2026-03-01.
      // Membership 2026-01-01 to 2026-03-31: 90 days. Unexpired 2026-03-01 to 2026-03-31: 31 days.
      // Membership share = round(3000 * 31 / 90) = 1033.33.
      // PT 2026-02-01 to 2026-03-31: 59 days. Unexpired 2026-03-01 to 2026-03-31: 31 days.
      // PT share = round(5900 * 31 / 59) = 3100.00.
      const preview = await goLiveService.getUnearnedPreview('2026-03-01');

      expect(preview.go_live_date).toBe('2026-03-01');
      expect(preview.items).toHaveLength(2);

      const membItem = preview.items.find((i) => i.kind === 'membership');
      expect(membItem?.unexpired_amount).toBe('1033.33');

      const ptItem = preview.items.find((i) => i.kind === 'pt');
      expect(ptItem?.unexpired_amount).toBe('3100.00');

      expect(preview.totals.unearned_membership_total).toBe('1033.33');
      expect(preview.totals.unearned_pt_total).toBe('3100.00');
      expect(preview.totals.combined_total).toBe('4133.33');
    });
  });

  describe('createGoLiveSchedules', () => {
    it('creates schedules with recognized_through set to day before go-live', async () => {
      const items = [
        {
          kind: 'membership' as const,
          source_id: 10,
          payment_id: 100,
          member_id: 1,
          starts_on: '2026-01-01',
          ends_on: '2026-03-31',
          unearned_account_id: 2200,
          income_account_id: 4000,
          total_net: '3000.00',
          unexpired_amount: '1033.33',
        },
      ];

      await goLiveService.createGoLiveSchedules('2026-03-01', items);

      expect(revenueRecognitionRepository.insertSchedule).toHaveBeenCalledWith(
        expect.objectContaining({
          payment_id: 100,
          unearned_account_id: 2200,
          income_account_id: 4000,
          total_amount: '1033.33',
          recognized_amount: '0.00',
          starts_on: '2026-03-01',
          ends_on: '2026-03-31',
          recognized_through: '2026-02-28', // day before go-live
          status: 'open',
        }),
      );
    });
  });

  describe('validateOpeningJournalMatch', () => {
    it('refuses with both amounts when 2200 or 2210 balances differ from preview', async () => {
      // Mock unearned preview: 2200 total = 1000.00, 2210 total = 2000.00
      vi.spyOn(goLiveService, 'getUnearnedPreview').mockResolvedValue({
        go_live_date: '2026-03-01',
        totals: {
          unearned_membership_total: '1000.00',
          unearned_pt_total: '2000.00',
          combined_total: '3000.00',
        },
        items: [],
      });

      // Opening balance journal exists, but has 2200 = 800.00 and 2210 = 1500.00
      mockDb.select
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockResolvedValue([{ id: 1 }]),
          }),
        })
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockResolvedValue([
              { accountId: 2200, debit: '0.00', credit: '800.00' },
              { accountId: 2210, debit: '0.00', credit: '1500.00' },
            ]),
          }),
        });

      const result = await goLiveService.validateOpeningJournalMatch('2026-03-01');
      expect(result.failingReasons).toHaveLength(2);
      expect(result.failingReasons[0]).toContain(
        'unearned membership balance (800.00) does not match unearned preview (1000.00)',
      );
      expect(result.failingReasons[1]).toContain(
        'unearned personal training balance (1500.00) does not match unearned preview (2000.00)',
      );
      expect(result.openingJournalFound).toBe(true);
      expect(result.openingJournalMatches).toBe(false);
      expect(result.actual2200).toBe('800.00');
      expect(result.actual2210).toBe('1500.00');
    });

    it('passes when opening journal balances match the preview totals', async () => {
      vi.spyOn(goLiveService, 'getUnearnedPreview').mockResolvedValue({
        go_live_date: '2026-03-01',
        totals: {
          unearned_membership_total: '1000.00',
          unearned_pt_total: '2000.00',
          combined_total: '3000.00',
        },
        items: [],
      });

      mockDb.select
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockResolvedValue([{ id: 1 }]),
          }),
        })
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockResolvedValue([
              { accountId: 2200, debit: '0.00', credit: '1000.00' },
              { accountId: 2210, debit: '0.00', credit: '2000.00' },
            ]),
          }),
        });

      const result = await goLiveService.validateOpeningJournalMatch('2026-03-01');
      expect(result.failingReasons).toHaveLength(0);
      expect(result.openingJournalFound).toBe(true);
      expect(result.openingJournalMatches).toBe(true);
      expect(result.actual2200).toBe('1000.00');
      expect(result.actual2210).toBe('2000.00');
    });

    it('refuses when opening balance journal is missing', async () => {
      vi.spyOn(goLiveService, 'getUnearnedPreview').mockResolvedValue({
        go_live_date: '2026-03-01',
        totals: {
          unearned_membership_total: '1000.00',
          unearned_pt_total: '2000.00',
          combined_total: '3000.00',
        },
        items: [],
      });

      mockDb.select.mockReturnValueOnce({
        from: vi.fn().mockReturnValue({
          where: vi.fn().mockResolvedValue([]),
        }),
      });

      const result = await goLiveService.validateOpeningJournalMatch('2026-03-01');
      expect(result.failingReasons).toContain('No posted opening balance journal found.');
      expect(result.openingJournalFound).toBe(false);
      expect(result.openingJournalMatches).toBe(false);
    });
  });

  describe('getGoLiveChecklist (ACC-099)', () => {
    it('returns checklist when prerequisites pass and opening journal matches', async () => {
      const mockSettingsService: any = {
        getSetting: vi.fn().mockImplementation(async (key: string) => {
          if (key === 'accounting.posting_enabled') return 'false';
          if (key === 'tax_rate_percent') return '18.00';
          if (key === 'accounting.default_tax_code') return 'gst_18';
          return null;
        }),
        checkPostingPrerequisites: vi.fn().mockResolvedValue([]),
        setPostingPrerequisiteHook: vi.fn(),
      };

      const svc = new GoLiveService(
        accountsRepository,
        revenueRecognitionRepository,
        mockDb as any,
        mockSettingsService,
      );

      vi.spyOn(svc, 'getUnearnedPreview').mockResolvedValue({
        go_live_date: '2026-03-01',
        totals: {
          unearned_membership_total: '1000.00',
          unearned_pt_total: '2000.00',
          combined_total: '3000.00',
        },
        items: [],
      });

      // 1. paymentMethods leftJoin accounts
      // 2. taxCodes
      // 3. openingJournals
      // 4. journalLines
      mockDb.select
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            leftJoin: vi.fn().mockReturnValue({
              where: vi.fn().mockReturnValue({
                orderBy: vi.fn().mockResolvedValue([
                  {
                    id: 1,
                    method_name: 'Credit Card',
                    is_active: true,
                    is_digital: true,
                    account_id: 1010,
                    account_name: 'Bank Account',
                  },
                ]),
              }),
            }),
          }),
        })
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockResolvedValue([
              { id: 1, code: 'gst_18', rate_percent: '18.00', is_active: true },
            ]),
          }),
        })
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockResolvedValue([{ id: 1 }]),
          }),
        })
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockResolvedValue([
              { accountId: 2200, debit: '0.00', credit: '1000.00' },
              { accountId: 2210, debit: '0.00', credit: '2000.00' },
            ]),
          }),
        });

      const checklist = await svc.getGoLiveChecklist('2026-03-01');

      expect(checklist.go_live_date).toBe('2026-03-01');
      expect(checklist.posting_enabled).toBe(false);
      expect(checklist.can_enable).toBe(true);
      expect(checklist.failing_reasons).toEqual([]);
      expect(checklist.opening_journal_found).toBe(true);
      expect(checklist.opening_journal_matches).toBe(true);
      expect(checklist.unearned_membership).toEqual({
        preview: '1000.00',
        actual: '1000.00',
        matched: true,
      });
      expect(checklist.unearned_pt).toEqual({
        preview: '2000.00',
        actual: '2000.00',
        matched: true,
      });
      expect(checklist.tax_match).toEqual({
        gym_tax_rate: '18.00',
        default_tax_code: 'gst_18',
        default_tax_rate: '18.00',
        matched: true,
      });
      expect(checklist.payment_methods).toHaveLength(1);
      expect(mockSettingsService.checkPostingPrerequisites).toHaveBeenCalledWith({
        goLiveDate: '2026-03-01',
      });
    });

    it('returns failing checks and can_enable = false when prerequisites fail', async () => {
      const mockSettingsService: any = {
        getSetting: vi.fn().mockResolvedValue(null),
        checkPostingPrerequisites: vi.fn().mockResolvedValue([
          'Active payment method "Cash" has no mapped accounting account.',
          'No posted opening balance journal found.',
        ]),
        setPostingPrerequisiteHook: vi.fn(),
      };

      const svc = new GoLiveService(
        accountsRepository,
        revenueRecognitionRepository,
        mockDb as any,
        mockSettingsService,
      );

      vi.spyOn(svc, 'getUnearnedPreview').mockResolvedValue({
        go_live_date: '2026-03-01',
        totals: {
          unearned_membership_total: '1000.00',
          unearned_pt_total: '2000.00',
          combined_total: '3000.00',
        },
        items: [],
      });

      // 1. paymentMethods (unmapped)
      // 2. taxCodes (missing)
      // 3. openingJournals (empty)
      mockDb.select
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            leftJoin: vi.fn().mockReturnValue({
              where: vi.fn().mockReturnValue({
                orderBy: vi.fn().mockResolvedValue([
                  {
                    id: 1,
                    method_name: 'Cash',
                    is_active: true,
                    is_digital: false,
                    account_id: null,
                    account_name: null,
                  },
                ]),
              }),
            }),
          }),
        })
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockResolvedValue([]),
          }),
        })
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockResolvedValue([]),
          }),
        });

      const checklist = await svc.getGoLiveChecklist('2026-03-01');

      expect(checklist.can_enable).toBe(false);
      expect(checklist.failing_reasons).toHaveLength(2);
      expect(checklist.opening_journal_found).toBe(false);
      expect(checklist.opening_journal_matches).toBe(false);
      expect(checklist.unearned_membership.matched).toBe(false);
      expect(checklist.tax_match.matched).toBe(false);
    });
  });

  describe('mapPaymentMethodAccount (ACC-099)', () => {
    it('throws NotFoundError when payment method does not exist', async () => {
      mockDb.select.mockReturnValueOnce({
        from: vi.fn().mockReturnValue({
          where: vi.fn().mockResolvedValue([]),
        }),
      });

      await expect(
        goLiveService.mapPaymentMethodAccount(999, 1010),
      ).rejects.toThrow(NotFoundError);
    });

    it('throws NotFoundError when account does not exist', async () => {
      mockDb.select.mockReturnValueOnce({
        from: vi.fn().mockReturnValue({
          where: vi.fn().mockResolvedValue([{ id: 1 }]),
        }),
      });
      accountsRepository.findById = vi.fn().mockResolvedValue(null);

      await expect(
        goLiveService.mapPaymentMethodAccount(1, 9999),
      ).rejects.toThrow(NotFoundError);
    });

    it('successfully updates mapping and returns payment method with account details', async () => {
      mockDb.select
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockResolvedValue([{ id: 1 }]),
          }),
        })
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            leftJoin: vi.fn().mockReturnValue({
              where: vi.fn().mockResolvedValue([
                {
                  id: 1,
                  method_name: 'Cash',
                  is_active: true,
                  is_digital: false,
                  account_id: 1000,
                  account_name: 'Cash on hand',
                },
              ]),
            }),
          }),
        });

      mockDb.update = vi.fn().mockReturnValue({
        set: vi.fn().mockReturnValue({
          where: vi.fn().mockResolvedValue(undefined),
        }),
      });

      accountsRepository.findById = vi.fn().mockResolvedValue({
        id: 1000,
        name: 'Cash on hand',
      });

      const result = await goLiveService.mapPaymentMethodAccount(1, 1000);

      expect(result.id).toBe(1);
      expect(result.account_id).toBe(1000);
      expect(result.account_name).toBe('Cash on hand');
      expect(mockDb.update).toHaveBeenCalled();
    });

    it('successfully unmaps account when accountId is null', async () => {
      mockDb.select
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockResolvedValue([{ id: 1 }]),
          }),
        })
        .mockReturnValueOnce({
          from: vi.fn().mockReturnValue({
            leftJoin: vi.fn().mockReturnValue({
              where: vi.fn().mockResolvedValue([
                {
                  id: 1,
                  method_name: 'Cash',
                  is_active: true,
                  is_digital: false,
                  account_id: null,
                  account_name: null,
                },
              ]),
            }),
          }),
        });

      mockDb.update = vi.fn().mockReturnValue({
        set: vi.fn().mockReturnValue({
          where: vi.fn().mockResolvedValue(undefined),
        }),
      });

      const result = await goLiveService.mapPaymentMethodAccount(1, null);

      expect(result.account_id).toBeNull();
      expect(result.account_name).toBeNull();
      expect(accountsRepository.findById).not.toHaveBeenCalled();
    });
  });

  describe('enablePosting (ACC-099)', () => {
    it('calls settingsService.updateSettings and returns success', async () => {
      const mockSettingsService: any = {
        updateSettings: vi.fn().mockResolvedValue([]),
        setPostingPrerequisiteHook: vi.fn(),
      };

      const svc = new GoLiveService(
        accountsRepository,
        revenueRecognitionRepository,
        mockDb as any,
        mockSettingsService,
      );

      const result = await svc.enablePosting('2026-03-01');

      expect(mockSettingsService.updateSettings).toHaveBeenCalledWith([
        { setting_key: 'accounting.posting_enabled', setting_value: 'true' },
      ]);
      expect(result).toEqual({ success: true, posting_enabled: true });
    });

    it('throws error when settingsService is missing', async () => {
      await expect(goLiveService.enablePosting()).rejects.toThrow(
        'SettingsService is required to enable posting.',
      );
    });
  });

  describe('SettingsService integration via posting hook (ACC-064)', () => {
    it('refuses to enable posting when opening journal balance fails', async () => {
      const mockSettingsRepo: any = {
        findAll: vi.fn().mockResolvedValue([]),
        upsertMany: vi.fn().mockResolvedValue(undefined),
      };

      const settingsSvc = new SettingsService(mockSettingsRepo, {
        select: vi.fn().mockReturnValue({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockResolvedValue([
              { id: 1, method_name: 'Cash', account_id: 10, is_active: true },
            ]),
          }),
        }),
      } as any);

      settingsSvc.setPostingPrerequisiteHook(async () => ({
        failingReasons: [
          'Opening balance journal 2200 unearned membership balance (500.00) does not match unearned preview (1200.00).',
        ],
      }));

      const err = await settingsSvc.updateSettings([
        { setting_key: 'accounting.posting_enabled', setting_value: 'true' },
      ]).catch((e) => e);

      expect(err).toBeInstanceOf(BadRequestError);
      expect(err.message).toContain('500.00');
      expect(err.message).toContain('1200.00');
    });

    it('writes go-live schedules when enabling posting succeeds', async () => {
      const mockSettingsRepo: any = {
        findAll: vi.fn().mockResolvedValue([]),
        upsertMany: vi.fn().mockResolvedValue(undefined),
      };

      const settingsSvc = new SettingsService(mockSettingsRepo, {
        select: vi.fn().mockReturnValue({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockImplementation((cond: any) => {
              // Return valid payment method and valid tax code
              return Promise.resolve([
                { id: 1, method_name: 'Cash', account_id: 10, is_active: true, code: 'gst_18', rate_percent: '18.00' },
              ]);
            }),
          }),
        }),
      } as any);

      const createSchedulesSpy = vi.fn().mockResolvedValue(undefined);
      settingsSvc.setPostingPrerequisiteHook(async () => ({
        failingReasons: [],
        createGoLiveSchedules: createSchedulesSpy,
      }));

      await settingsSvc.updateSettings([
        { setting_key: 'accounting.posting_enabled', setting_value: 'true' },
      ]);

      expect(createSchedulesSpy).toHaveBeenCalled();
    });
  });
});
