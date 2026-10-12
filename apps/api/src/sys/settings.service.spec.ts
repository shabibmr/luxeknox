import { describe, it, expect, vi, beforeEach } from 'vitest';
import { SettingsService } from './settings.service';
import { SettingsRepository } from './settings.repository';
import { BadRequestError } from '../platform/errors/app-error';
import type { GymSetting } from '../platform/db/schema/gym-settings';
import { SETTING_CATALOGUE, parseSettingCategory } from './settings.dto';
import { SEED_GYM_SETTINGS } from '../platform/db/seed/settings';
import { paymentMethods } from '../platform/db/schema/payments';
import { taxCodes } from '../platform/db/schema/accounting';

describe('SettingsService', () => {
  let mockRepository: Partial<SettingsRepository>;
  let service: SettingsService;

  const mockSettings: GymSetting[] = [
    {
      id: 1,
      setting_key: 'timezone',
      setting_value: 'Asia/Kolkata',
      description: 'Timezone',
      created_at: new Date(),
      updated_at: new Date(),
    },
    {
      id: 2,
      setting_key: 'currency',
      setting_value: 'USD',
      description: 'Currency',
      created_at: new Date(),
      updated_at: new Date(),
    },
    {
      id: 3,
      setting_key: 'default_page_size',
      setting_value: '50',
      description: 'Page limit',
      created_at: new Date(),
      updated_at: new Date(),
    },
    {
      id: 4,
      setting_key: 'business_name',
      setting_value: 'LuxeKnox Luxury Gym',
      description: 'Business name',
      created_at: new Date(),
      updated_at: new Date(),
    },
  ];

  beforeEach(() => {
    mockRepository = {
      findAll: vi.fn().mockResolvedValue(mockSettings),
    };
    service = new SettingsService(mockRepository as SettingsRepository);
  });

  describe('getTimezone', () => {
    it('returns seeded timezone from cache when present', async () => {
      const tz = await service.getTimezone();
      expect(tz).toBe('Asia/Kolkata');
      expect(mockRepository.findAll).toHaveBeenCalledTimes(1);
    });

    it('returns default UTC when timezone setting is absent', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValueOnce([]);
      const tz = await service.getTimezone();
      expect(tz).toBe('UTC');
    });
  });

  describe('getCurrency', () => {
    it('returns seeded currency from cache when present', async () => {
      const currency = await service.getCurrency();
      expect(currency).toBe('USD');
    });

    it('returns default INR when currency setting is absent', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValueOnce([]);
      const currency = await service.getCurrency();
      expect(currency).toBe('INR');
    });
  });

  describe('getDefaultPageSize', () => {
    it('returns seeded page size parsed as number', async () => {
      const pageSize = await service.getDefaultPageSize();
      expect(pageSize).toBe(50);
    });

    it('returns default 20 when default_page_size setting is absent', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValueOnce([]);
      const pageSize = await service.getDefaultPageSize();
      expect(pageSize).toBe(20);
    });

    it('returns default 20 when setting value is invalid or non-numeric', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValueOnce([
        {
          id: 3,
          setting_key: 'default_page_size',
          setting_value: 'invalid_number',
          description: 'Page limit',
          created_at: new Date(),
          updated_at: new Date(),
        },
      ]);
      const pageSize = await service.getDefaultPageSize();
      expect(pageSize).toBe(20);
    });
  });

  describe('getScheduleBookingLeadTimeMinutes', () => {
    it('returns default 30 when setting is absent', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValueOnce([]);
      expect(await service.getScheduleBookingLeadTimeMinutes()).toBe(30);
    });

    it('returns seeded value when present', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValueOnce([
        {
          id: 5,
          setting_key: 'schedule_booking_lead_time_minutes',
          setting_value: '45',
          description: 'Lead time',
          created_at: new Date(),
          updated_at: new Date(),
        },
      ]);
      expect(await service.getScheduleBookingLeadTimeMinutes()).toBe(45);
    });
  });

  describe('getScheduleCancellationCutoffMinutes', () => {
    it('returns default 120 when setting is absent', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValueOnce([]);
      expect(await service.getScheduleCancellationCutoffMinutes()).toBe(120);
    });
  });

  describe('getScheduleMemberBookingCap', () => {
    it('returns default 5 when setting is absent', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValueOnce([]);
      expect(await service.getScheduleMemberBookingCap()).toBe(5);
    });

    it('returns default 5 when setting value is invalid', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValueOnce([
        {
          id: 6,
          setting_key: 'schedule_member_booking_cap',
          setting_value: 'not_a_number',
          description: 'Cap',
          created_at: new Date(),
          updated_at: new Date(),
        },
      ]);
      expect(await service.getScheduleMemberBookingCap()).toBe(5);
    });
  });

  describe('getAttendanceDebounceSeconds', () => {
    it('returns default 60 when setting is absent', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValueOnce([]);
      expect(await service.getAttendanceDebounceSeconds()).toBe(60);
    });
  });

  describe('getAttendanceDailyCheckInCap', () => {
    it('returns default 2 when setting is absent', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValueOnce([]);
      expect(await service.getAttendanceDailyCheckInCap()).toBe(2);
    });
  });

  describe('getAttendanceAutoCheckoutHours', () => {
    it('returns default 12 when setting is absent', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValueOnce([]);
      expect(await service.getAttendanceAutoCheckoutHours()).toBe(12);
    });
  });

  describe('getTaxRatePercent', () => {
    it('returns default 18.00 when setting is absent', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValueOnce([]);
      expect(await service.getTaxRatePercent()).toBe('18.00');
    });
  });

  describe('getSetting', () => {
    it('returns specific setting value when key exists', async () => {
      const value = await service.getSetting('business_name');
      expect(value).toBe('LuxeKnox Luxury Gym');
    });

    it('returns null when key does not exist', async () => {
      const value = await service.getSetting('unknown_key');
      expect(value).toBeNull();
    });
  });

  describe('cache coherence', () => {
    it('warms the whole cache on the first read and queries once', async () => {
      await service.getSetting('timezone');
      await service.getSetting('currency');
      await service.getDefaultPageSize();
      expect(mockRepository.findAll).toHaveBeenCalledTimes(1);
    });

    it('fetches all settings, populates cache and returns record', async () => {
      const all = await service.getAllSettings();
      expect(all.timezone).toBe('Asia/Kolkata');
      expect(all.currency).toBe('USD');
      expect(mockRepository.findAll).toHaveBeenCalledTimes(1);

      const cached = await service.getAllSettings();
      expect(cached.timezone).toBe('Asia/Kolkata');
      expect(mockRepository.findAll).toHaveBeenCalledTimes(1);
    });

    it('expires cached values after the 30-second consistency window', async () => {
      vi.useFakeTimers();
      try {
        await service.getSetting('timezone');
        mockRepository.findAll = vi.fn().mockResolvedValue([
          {
            id: 1,
            setting_key: 'timezone',
            setting_value: 'Asia/Dubai',
            description: 'Timezone',
            created_at: new Date(),
            updated_at: new Date(),
          },
        ]);

        vi.advanceTimersByTime(30_001);
        expect(await service.getSetting('timezone')).toBe('Asia/Dubai');
        expect(mockRepository.findAll).toHaveBeenCalledTimes(1);
      } finally {
        vi.useRealTimers();
      }
    });
  });

  describe('listSettings', () => {
    it('returns all settings with categories', async () => {
      const list = await service.listSettings();
      expect(list.length).toBeGreaterThanOrEqual(15);
      const tz = list.find((s) => s.setting_key === 'timezone');
      expect(tz?.category).toBe('general');
      const cur = list.find((s) => s.setting_key === 'currency');
      expect(cur?.category).toBe('billing');
    });

    it('filters settings by category', async () => {
      const billingSettings = await service.listSettings('billing');
      expect(billingSettings.every((s) => s.category === 'billing')).toBe(true);
      expect(billingSettings.some((s) => s.setting_key === 'currency')).toBe(true);
    });
  });

  describe('catalogue and update validation', () => {
    it('returns default values for configured keys that are not seeded yet', async () => {
      vi.mocked(mockRepository.findAll!).mockResolvedValue([]);
      const list = await service.listSettings('attendance_gate');
      expect(list.map((setting) => setting.setting_key)).toEqual([
        'attendance_pass_ttl_minutes',
        'attendance_debounce_seconds',
        'attendance_daily_checkin_cap',
        'attendance_auto_checkout_hours',
      ]);
      expect(list[0].setting_value).toBe('5');
    });

    it('rejects unsupported keys', async () => {
      await expect(service.updateSettings([
        { setting_key: 'new_arbitrary_setting', setting_value: 'x' },
      ])).rejects.toBeInstanceOf(BadRequestError);
    });

    it('rejects invalid typed values', async () => {
      await expect(service.updateSettings([
        { setting_key: 'attendance_daily_checkin_cap', setting_value: '-1' },
      ])).rejects.toBeInstanceOf(BadRequestError);
    });
  });

  describe('updateSettings', () => {
    it('upserts items, refreshes cache and returns updated list', async () => {
      mockRepository.upsertMany = vi.fn().mockResolvedValue([]);
      mockRepository.findAll = vi.fn().mockResolvedValue([
        { id: 1, setting_key: 'timezone', setting_value: 'Asia/Dubai', description: null, created_at: new Date(), updated_at: new Date() },
        { id: 2, setting_key: 'currency', setting_value: 'INR', description: null, created_at: new Date(), updated_at: new Date() },
      ]);

      const updated = await service.updateSettings([
        { setting_key: 'timezone', setting_value: 'Asia/Dubai' },
      ]);

      expect(mockRepository.upsertMany).toHaveBeenCalledWith([
        { setting_key: 'timezone', setting_value: 'Asia/Dubai' },
      ]);
      expect(updated.find((setting) => setting.setting_key === 'timezone')?.setting_value).toBe('Asia/Dubai');

      const tz = await service.getTimezone();
      expect(tz).toBe('Asia/Dubai');
    });
  });

  describe('settings catalogue contract', () => {
    it('keeps seeded keys and default values aligned with the runtime catalogue', () => {
      const seeded = new Map(
        SEED_GYM_SETTINGS.map((setting) => [setting.setting_key, setting.setting_value] as const),
      );

      expect([...seeded.keys()].sort()).toEqual(
        SETTING_CATALOGUE.map((definition) => definition.setting_key).sort(),
      );
      for (const definition of SETTING_CATALOGUE) {
        expect(seeded.get(definition.setting_key)).toBe(definition.default_value);
      }
    });

    it('normalizes documented legacy category aliases', () => {
      expect(parseSettingCategory('schedule')).toBe('booking_rules');
      expect(parseSettingCategory('attendance')).toBe('attendance_gate');
      expect(parseSettingCategory('security')).toBe('general');
      expect(parseSettingCategory('gym')).toBe('general');
      expect(parseSettingCategory(' WORKOUT ')).toBe('workout');
      expect(parseSettingCategory('unknown')).toBeUndefined();
    });
  });

  describe('ACC-054 accounting.posting_enabled prerequisite validation', () => {
    const createMockDb = (options: {
      paymentMethods?: Array<{ id: number; method_name: string; account_id: number | null; is_active: boolean }>;
      taxCodes?: Array<{ id: number; code: string; rate_percent: string; is_active: boolean }>;
    }) => {
      const pms = options.paymentMethods ?? [
        { id: 1, method_name: 'Cash', account_id: 10, is_active: true },
        { id: 2, method_name: 'Card', account_id: 20, is_active: true },
      ];
      const tcs = options.taxCodes ?? [
        { id: 1, code: 'gst_18', rate_percent: '18.00', is_active: true },
      ];

      return {
        select: vi.fn().mockImplementation(() => ({
          from: vi.fn().mockImplementation((table: any) => ({
            where: vi.fn().mockImplementation(() => {
              if (table === paymentMethods) {
                return Promise.resolve(pms.filter((p) => p.is_active));
              }
              if (table === taxCodes) {
                return Promise.resolve(tcs);
              }
              return Promise.resolve([]);
            }),
          })),
        })),
      };
    };

    it('refuses to enable posting when an active payment method has no account_id', async () => {
      const mockDb = createMockDb({
        paymentMethods: [
          { id: 1, method_name: 'Cash', account_id: 10, is_active: true },
          { id: 2, method_name: 'Card/UPI', account_id: null, is_active: true },
        ],
      });
      const svc = new SettingsService(mockRepository as SettingsRepository, mockDb as any);

      const err = await svc.updateSettings([
        { setting_key: 'accounting.posting_enabled', setting_value: 'true' },
      ]).catch((e) => e);

      expect(err).toBeInstanceOf(BadRequestError);
      expect(err.message).toContain('Active payment method "Card/UPI" has no mapped accounting account');
      expect(err.details).toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            setting_key: 'accounting.posting_enabled',
            message: 'Active payment method "Card/UPI" has no mapped accounting account.',
          }),
        ]),
      );
    });

    it('returns every failing payment method at once when multiple methods lack accounts', async () => {
      const mockDb = createMockDb({
        paymentMethods: [
          { id: 1, method_name: 'Cash', account_id: null, is_active: true },
          { id: 2, method_name: 'Card/UPI', account_id: null, is_active: true },
        ],
      });
      const svc = new SettingsService(mockRepository as SettingsRepository, mockDb as any);

      const err = await svc.updateSettings([
        { setting_key: 'accounting.posting_enabled', setting_value: 'true' },
      ]).catch((e) => e);

      expect(err).toBeInstanceOf(BadRequestError);
      expect(err.message).toContain('Cash');
      expect(err.message).toContain('Card/UPI');
      expect(err.details).toHaveLength(2);
    });

    it('ignores inactive payment methods without account_id', async () => {
      const mockDb = createMockDb({
        paymentMethods: [
          { id: 1, method_name: 'Cash', account_id: 10, is_active: true },
          { id: 2, method_name: 'Deprecated Method', account_id: null, is_active: false },
        ],
      });
      mockRepository.upsertMany = vi.fn().mockResolvedValue([]);
      mockRepository.findAll = vi.fn().mockResolvedValue([
        { id: 1, setting_key: 'accounting.posting_enabled', setting_value: 'true', description: null, created_at: new Date(), updated_at: new Date() },
      ]);
      const svc = new SettingsService(mockRepository as SettingsRepository, mockDb as any);

      const res = await svc.updateSettings([
        { setting_key: 'accounting.posting_enabled', setting_value: 'true' },
      ]);

      expect(mockRepository.upsertMany).toHaveBeenCalled();
      expect(res.find((s) => s.setting_key === 'accounting.posting_enabled')?.setting_value).toBe('true');
    });

    it('refuses to enable posting when tax_rate_percent differs from rate on accounting.default_tax_code', async () => {
      const mockDb = createMockDb({
        taxCodes: [
          { id: 1, code: 'gst_18', rate_percent: '12.00', is_active: true },
        ],
      });
      const svc = new SettingsService(mockRepository as SettingsRepository, mockDb as any);

      const err = await svc.updateSettings([
        { setting_key: 'accounting.posting_enabled', setting_value: 'true' },
      ]).catch((e) => e);

      expect(err).toBeInstanceOf(BadRequestError);
      expect(err.message).toContain('Gym tax rate (18.00%) differs from default tax code "gst_18" rate (12.00%)');
    });

    it('refuses returning BOTH unmapped payment methods and tax mismatch at once', async () => {
      const mockDb = createMockDb({
        paymentMethods: [
          { id: 1, method_name: 'Cash', account_id: null, is_active: true },
        ],
        taxCodes: [
          { id: 1, code: 'gst_18', rate_percent: '5.00', is_active: true },
        ],
      });
      const svc = new SettingsService(mockRepository as SettingsRepository, mockDb as any);

      const err = await svc.updateSettings([
        { setting_key: 'accounting.posting_enabled', setting_value: 'true' },
      ]).catch((e) => e);

      expect(err).toBeInstanceOf(BadRequestError);
      expect(err.message).toContain('Active payment method "Cash" has no mapped accounting account');
      expect(err.message).toContain('Gym tax rate (18.00%) differs from default tax code "gst_18" rate (5.00%)');
      expect(err.details).toHaveLength(2);
    });

    it('refuses when accounting.default_tax_code is missing or inactive in tax codes', async () => {
      const mockDb = createMockDb({
        taxCodes: [
          { id: 1, code: 'gst_18', rate_percent: '18.00', is_active: false },
        ],
      });
      const svc = new SettingsService(mockRepository as SettingsRepository, mockDb as any);

      const err = await svc.updateSettings([
        { setting_key: 'accounting.posting_enabled', setting_value: 'true' },
      ]).catch((e) => e);

      expect(err).toBeInstanceOf(BadRequestError);
      expect(err.message).toContain('Default tax code "gst_18" is inactive');
    });

    it('allows enabling posting when tax_rate_percent and payment methods are valid', async () => {
      const mockDb = createMockDb({
        paymentMethods: [
          { id: 1, method_name: 'Cash', account_id: 10, is_active: true },
          { id: 2, method_name: 'UPI', account_id: 20, is_active: true },
        ],
        taxCodes: [
          { id: 1, code: 'gst_18', rate_percent: '18.00', is_active: true },
        ],
      });
      mockRepository.upsertMany = vi.fn().mockResolvedValue([]);
      mockRepository.findAll = vi.fn().mockResolvedValue([
        { id: 1, setting_key: 'accounting.posting_enabled', setting_value: 'true', description: null, created_at: new Date(), updated_at: new Date() },
      ]);
      const svc = new SettingsService(mockRepository as SettingsRepository, mockDb as any);

      const res = await svc.updateSettings([
        { setting_key: 'accounting.posting_enabled', setting_value: 'true' },
      ]);

      expect(mockRepository.upsertMany).toHaveBeenCalledWith([
        { setting_key: 'accounting.posting_enabled', setting_value: 'true' },
      ]);
      expect(res.find((s) => s.setting_key === 'accounting.posting_enabled')?.setting_value).toBe('true');
    });

    it('allows enabling posting when updating tax_rate_percent in the same payload to match tax code', async () => {
      const mockDb = createMockDb({
        paymentMethods: [
          { id: 1, method_name: 'Cash', account_id: 10, is_active: true },
        ],
        taxCodes: [
          { id: 1, code: 'gst_5', rate_percent: '5.00', is_active: true },
        ],
      });
      mockRepository.upsertMany = vi.fn().mockResolvedValue([]);
      mockRepository.findAll = vi.fn().mockResolvedValue([
        { id: 1, setting_key: 'accounting.posting_enabled', setting_value: 'true', description: null, created_at: new Date(), updated_at: new Date() },
        { id: 2, setting_key: 'tax_rate_percent', setting_value: '5.00', description: null, created_at: new Date(), updated_at: new Date() },
        { id: 3, setting_key: 'accounting.default_tax_code', setting_value: 'gst_5', description: null, created_at: new Date(), updated_at: new Date() },
      ]);
      const svc = new SettingsService(mockRepository as SettingsRepository, mockDb as any);

      await expect(svc.updateSettings([
        { setting_key: 'accounting.posting_enabled', setting_value: 'true' },
        { setting_key: 'tax_rate_percent', setting_value: '5.00' },
        { setting_key: 'accounting.default_tax_code', setting_value: 'gst_5' },
      ])).resolves.toBeDefined();
    });

    it('allows setting accounting.posting_enabled to false even if prerequisites fail', async () => {
      const mockDb = createMockDb({
        paymentMethods: [
          { id: 1, method_name: 'Cash', account_id: null, is_active: true },
        ],
      });
      mockRepository.upsertMany = vi.fn().mockResolvedValue([]);
      mockRepository.findAll = vi.fn().mockResolvedValue([
        { id: 1, setting_key: 'accounting.posting_enabled', setting_value: 'false', description: null, created_at: new Date(), updated_at: new Date() },
      ]);
      const svc = new SettingsService(mockRepository as SettingsRepository, mockDb as any);

      await expect(svc.updateSettings([
        { setting_key: 'accounting.posting_enabled', setting_value: 'false' },
      ])).resolves.toBeDefined();
    });

    it('checkPostingPrerequisites directly returns failing check array', async () => {
      const mockDb = createMockDb({
        paymentMethods: [
          { id: 1, method_name: 'Cash', account_id: null, is_active: true },
        ],
        taxCodes: [
          { id: 1, code: 'gst_18', rate_percent: '5.00', is_active: true },
        ],
      });
      const svc = new SettingsService(mockRepository as SettingsRepository, mockDb as any);

      const failures = await svc.checkPostingPrerequisites();
      expect(failures).toHaveLength(2);
      expect(failures[0]).toContain('Active payment method "Cash" has no mapped accounting account');
      expect(failures[1]).toContain('Gym tax rate (18.00%) differs from default tax code "gst_18" rate (5.00%)');
    });
  });
});
