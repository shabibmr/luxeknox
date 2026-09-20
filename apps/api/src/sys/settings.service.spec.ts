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
