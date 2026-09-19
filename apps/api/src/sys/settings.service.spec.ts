import { describe, it, expect, vi, beforeEach } from 'vitest';
import { SettingsService } from './settings.service';
import { SettingsRepository } from './settings.repository';
import type { GymSetting } from '../platform/db/schema/gym-settings';

describe('SettingsService', () => {
  let mockRepository: Partial<SettingsRepository>;
  let service: SettingsService;

  beforeEach(() => {
    mockRepository = {
      findByKey: vi.fn(),
      findAll: vi.fn(),
    };
    service = new SettingsService(mockRepository as SettingsRepository);
  });

  describe('getTimezone', () => {
    it('returns seeded timezone from repository when present', async () => {
      vi.mocked(mockRepository.findByKey!).mockResolvedValue({
        id: 1,
        setting_key: 'timezone',
        setting_value: 'Asia/Kolkata',
        description: 'Gym canonical operating time zone',
        created_at: new Date(),
        updated_at: new Date(),
      } as GymSetting);

      const tz = await service.getTimezone();
      expect(tz).toBe('Asia/Kolkata');
      expect(mockRepository.findByKey).toHaveBeenCalledWith('timezone');
    });

    it('returns default UTC when timezone setting is absent in repository', async () => {
      vi.mocked(mockRepository.findByKey!).mockResolvedValue(null);

      const tz = await service.getTimezone();
      expect(tz).toBe('UTC');
    });
  });

  describe('getCurrency', () => {
    it('returns seeded currency from repository when present', async () => {
      vi.mocked(mockRepository.findByKey!).mockResolvedValue({
        id: 2,
        setting_key: 'currency',
        setting_value: 'USD',
        description: 'Billing currency',
        created_at: new Date(),
        updated_at: new Date(),
      } as GymSetting);

      const currency = await service.getCurrency();
      expect(currency).toBe('USD');
      expect(mockRepository.findByKey).toHaveBeenCalledWith('currency');
    });

    it('returns default INR when currency setting is absent in repository', async () => {
      vi.mocked(mockRepository.findByKey!).mockResolvedValue(null);

      const currency = await service.getCurrency();
      expect(currency).toBe('INR');
    });
  });

  describe('getDefaultPageSize', () => {
    it('returns seeded page size parsed as number', async () => {
      vi.mocked(mockRepository.findByKey!).mockResolvedValue({
        id: 3,
        setting_key: 'default_page_size',
        setting_value: '50',
        description: 'Page limit',
        created_at: new Date(),
        updated_at: new Date(),
      } as GymSetting);

      const pageSize = await service.getDefaultPageSize();
      expect(pageSize).toBe(50);
      expect(mockRepository.findByKey).toHaveBeenCalledWith('default_page_size');
    });

    it('returns default 20 when default_page_size setting is absent in repository', async () => {
      vi.mocked(mockRepository.findByKey!).mockResolvedValue(null);

      const pageSize = await service.getDefaultPageSize();
      expect(pageSize).toBe(20);
    });

    it('returns default 20 when setting value is invalid or non-numeric', async () => {
      vi.mocked(mockRepository.findByKey!).mockResolvedValue({
        id: 3,
        setting_key: 'default_page_size',
        setting_value: 'invalid_number',
        description: 'Page limit',
        created_at: new Date(),
        updated_at: new Date(),
      } as GymSetting);

      const pageSize = await service.getDefaultPageSize();
      expect(pageSize).toBe(20);
    });
  });

  describe('getSetting', () => {
    it('returns specific setting value when key exists', async () => {
      vi.mocked(mockRepository.findByKey!).mockResolvedValue({
        id: 4,
        setting_key: 'business_name',
        setting_value: 'LuxeKnox Luxury Gym',
        description: 'Business name',
        created_at: new Date(),
        updated_at: new Date(),
      } as GymSetting);

      const value = await service.getSetting('business_name');
      expect(value).toBe('LuxeKnox Luxury Gym');
    });

    it('returns null when key does not exist', async () => {
      vi.mocked(mockRepository.findByKey!).mockResolvedValue(null);

      const value = await service.getSetting('unknown_key');
      expect(value).toBeNull();
    });
  });

  describe('getAllSettings and cache', () => {
    it('fetches all settings, populates cache and returns record', async () => {
      const mockSettings: GymSetting[] = [
        {
          id: 1,
          setting_key: 'timezone',
          setting_value: 'UTC',
          description: 'Timezone',
          created_at: new Date(),
          updated_at: new Date(),
        },
        {
          id: 2,
          setting_key: 'currency',
          setting_value: 'INR',
          description: 'Currency',
          created_at: new Date(),
          updated_at: new Date(),
        },
      ];
      vi.mocked(mockRepository.findAll!).mockResolvedValue(mockSettings);

      const all = await service.getAllSettings();
      expect(all).toEqual({
        timezone: 'UTC',
        currency: 'INR',
      });
      expect(mockRepository.findAll).toHaveBeenCalledTimes(1);

      // Second call reads from memory cache without hitting repository again
      const cached = await service.getAllSettings();
      expect(cached).toEqual({
        timezone: 'UTC',
        currency: 'INR',
      });
      expect(mockRepository.findAll).toHaveBeenCalledTimes(1);

      // getSetting also reads from cached values
      const tz = await service.getSetting('timezone');
      expect(tz).toBe('UTC');
      expect(mockRepository.findByKey).not.toHaveBeenCalled();
    });
  });
});
