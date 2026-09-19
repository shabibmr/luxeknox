import { describe, it, expect, beforeEach, vi } from 'vitest';
import { SettingsController } from './settings.controller';
import type { SettingsService } from './settings.service';

describe('SettingsController', () => {
  let controller: SettingsController;
  let mockSettingsService: Partial<SettingsService>;

  beforeEach(() => {
    mockSettingsService = {
      getTimezone: vi.fn().mockResolvedValue('Asia/Kolkata'),
      getCurrency: vi.fn().mockResolvedValue('INR'),
      getAllSettings: vi.fn().mockResolvedValue({
        timezone: 'Asia/Kolkata',
        currency: 'INR',
        default_page_size: '25',
      }),
    };

    controller = new SettingsController(mockSettingsService as SettingsService);
  });

  describe('getPublicSettings', () => {
    it('returns timezone and currency without authentication requirements', async () => {
      const result = await controller.getPublicSettings();

      expect(result).toEqual({
        timezone: 'Asia/Kolkata',
        currency: 'INR',
      });
      expect(mockSettingsService.getTimezone).toHaveBeenCalledTimes(1);
      expect(mockSettingsService.getCurrency).toHaveBeenCalledTimes(1);
    });
  });

  describe('getAllSettings', () => {
    it('returns all system settings dictionary', async () => {
      const result = await controller.getAllSettings();

      expect(result).toEqual({
        timezone: 'Asia/Kolkata',
        currency: 'INR',
        default_page_size: '25',
      });
      expect(mockSettingsService.getAllSettings).toHaveBeenCalledTimes(1);
    });
  });
});
