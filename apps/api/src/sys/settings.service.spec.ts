import { describe, it, expect, vi, beforeEach } from 'vitest';
import { SettingsService } from './settings.service';
import { SettingsRepository } from './settings.repository';
import type { GymSetting } from '../platform/db/schema/gym-settings';

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
  });
});
