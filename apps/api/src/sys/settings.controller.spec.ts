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
      listSettings: vi.fn().mockResolvedValue([
        { id: 1, setting_key: 'timezone', setting_value: 'Asia/Kolkata', category: 'GENERAL' },
        { id: 2, setting_key: 'currency', setting_value: 'INR', category: 'BILLING' },
      ]),
      updateSettings: vi.fn().mockResolvedValue([
        { id: 1, setting_key: 'timezone', setting_value: 'Asia/Kolkata', category: 'GENERAL' },
        { id: 2, setting_key: 'currency', setting_value: 'USD', category: 'BILLING' },
      ]),
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
    it('returns settings list wrapped in data', async () => {
      const result = await controller.getAllSettings('GENERAL');

      expect(result).toEqual({
        data: [
          { id: 1, setting_key: 'timezone', setting_value: 'Asia/Kolkata', category: 'GENERAL' },
          { id: 2, setting_key: 'currency', setting_value: 'INR', category: 'BILLING' },
        ],
      });
      expect(mockSettingsService.listSettings).toHaveBeenCalledWith('GENERAL');
    });
  });

  describe('putSettings', () => {
    it('updates settings and returns updated list', async () => {
      const result = await controller.putSettings({
        items: [{ setting_key: 'currency', setting_value: 'USD' }],
      });

      expect(result).toEqual({
        data: [
          { id: 1, setting_key: 'timezone', setting_value: 'Asia/Kolkata', category: 'GENERAL' },
          { id: 2, setting_key: 'currency', setting_value: 'USD', category: 'BILLING' },
        ],
      });
      expect(mockSettingsService.updateSettings).toHaveBeenCalledWith([
        { setting_key: 'currency', setting_value: 'USD' },
      ]);
    });
  });
});
