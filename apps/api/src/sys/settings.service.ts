import { Injectable, Logger } from '@nestjs/common';
import { SettingsRepository } from './settings.repository';

/**
 * SettingsService provides typed access to system settings configured in `gym_settings`.
 *
 * Per ADR-0004:
 * `gym_settings` is read exclusively through SettingsService, never by direct table access.
 * This guarantees a single control point if settings become tenant-scoped in the future.
 * No mutation/upsert API is exposed in Module 0.
 */
@Injectable()
export class SettingsService {
  private readonly logger = new Logger(SettingsService.name);

  // In-memory cache to avoid repeated database lookups for invariant system settings
  private cache: Map<string, string> | null = null;

  constructor(private readonly settingsRepository: SettingsRepository) {}

  /**
   * Gym canonical operating time zone (default: 'UTC').
   */
  async getTimezone(): Promise<string> {
    const value = await this.getSetting('timezone');
    return value ?? 'UTC';
  }

  /**
   * Default billing and ledger currency code (ISO 4217, default: 'INR').
   */
  async getCurrency(): Promise<string> {
    const value = await this.getSetting('currency');
    return value ?? 'INR';
  }

  /**
   * Default pagination limit for listing endpoints (default: 20).
   */
  async getDefaultPageSize(): Promise<number> {
    const value = await this.getSetting('default_page_size');
    if (!value) {
      return 20;
    }
    const parsed = parseInt(value, 10);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : 20;
  }

  /**
   * Retrieves a single setting value by key.
   * Checks the in-memory cache first; falls back to repository query if cache not initialized.
   */
  async getSetting(key: string): Promise<string | null> {
    if (this.cache) {
      return this.cache.get(key) ?? null;
    }

    const row = await this.settingsRepository.findByKey(key);
    return row?.setting_value ?? null;
  }

  /**
   * Retrieves all gym settings as a key-value record.
   * Loads from and populates the in-memory cache.
   */
  async getAllSettings(): Promise<Record<string, string>> {
    if (this.cache) {
      return Object.fromEntries(this.cache.entries());
    }

    await this.refreshCache();
    return Object.fromEntries(this.cache!.entries());
  }

  /**
   * Clears and repopulates the in-memory cache from the database.
   */
  async refreshCache(): Promise<void> {
    const rows = await this.settingsRepository.findAll();
    const map = new Map<string, string>();
    for (const row of rows) {
      map.set(row.setting_key, row.setting_value);
    }
    this.cache = map;
  }
}
