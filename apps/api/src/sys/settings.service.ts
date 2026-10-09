import { Injectable } from '@nestjs/common';
import { AuditService } from '../platform/audit/audit.service';
import { AuditService } from '../platform/audit/audit.service';
import { SettingsRepository } from './settings.repository';
import { BadRequestError } from '../platform/errors/app-error';
import { type SettingDto, SETTING_CATALOGUE, getSettingDefinition, parseSettingCategory } from './settings.dto';

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
  // In-memory cache to avoid repeated database lookups for invariant system settings
  private cache: Map<string, string> | null = null;
  private cacheLoadedAt = 0;
  private readonly cacheTtlMs = 30_000;

  constructor(
    private readonly settingsRepository: SettingsRepository,
    private readonly auditService?: AuditService,
  ) {}

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
   * Minimum minutes before a schedule's start_time a member may book it (default: 30).
   */
  async getScheduleBookingLeadTimeMinutes(): Promise<number> {
    const value = await this.getSetting('schedule_booking_lead_time_minutes');
    if (!value) {
      return 30;
    }
    const parsed = parseInt(value, 10);
    return Number.isFinite(parsed) && parsed >= 0 ? parsed : 30;
  }

  /**
   * Minimum minutes before a schedule's start_time a booking may still be cancelled (default: 120).
   */
  async getScheduleCancellationCutoffMinutes(): Promise<number> {
    const value = await this.getSetting('schedule_cancellation_cutoff_minutes');
    if (!value) {
      return 120;
    }
    const parsed = parseInt(value, 10);
    return Number.isFinite(parsed) && parsed >= 0 ? parsed : 120;
  }

  /**
   * Maximum number of concurrent active (booked or waitlisted) upcoming bookings per member (default: 5).
   */
  async getScheduleMemberBookingCap(): Promise<number> {
    const value = await this.getSetting('schedule_member_booking_cap');
    if (!value) {
      return 5;
    }
    const parsed = parseInt(value, 10);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : 5;
  }

  /**
   * Minutes a signed digital attendance pass (QR payload) remains valid before the
   * client must re-fetch `GET /attendance/pass` for a fresh one (default: 5).
   */
  async getAttendancePassTtlMinutes(): Promise<number> {
    const value = await this.getSetting('attendance_pass_ttl_minutes');
    if (!value) {
      return 5;
    }
    const parsed = parseInt(value, 10);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : 5;
  }

  /**
   * Seconds within which a repeated check-in for the same user returns the
   * existing open attendance instead of conflicting (default: 60).
   */
  async getAttendanceDebounceSeconds(): Promise<number> {
    const value = await this.getSetting('attendance_debounce_seconds');
    if (!value) {
      return 60;
    }
    const parsed = parseInt(value, 10);
    return Number.isFinite(parsed) && parsed >= 0 ? parsed : 60;
  }

  /**
   * Maximum gate check-ins per user per UTC calendar day (default: 2).
   */
  async getAttendanceDailyCheckInCap(): Promise<number> {
    const value = await this.getSetting('attendance_daily_checkin_cap');
    if (!value) {
      return 2;
    }
    const parsed = parseInt(value, 10);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : 2;
  }

  /**
   * Default tax rate percent applied to (subtotal - discount) on POS invoices (default: 18).
   */
  async getTaxRatePercent(): Promise<string> {
    const value = await this.getSetting('tax_rate_percent');
    if (!value) {
      return '18.00';
    }
    const parsed = parseFloat(value);
    return Number.isFinite(parsed) && parsed >= 0 ? parsed.toFixed(2) : '18.00';
  }

  /**
   * When true, POS `product_id` assign/renew may run on partial invoices (default: false → paid only).
   */
  async getPaymentsActivateMembershipOnPartial(): Promise<boolean> {
    const value = await this.getSetting('payments_activate_membership_on_partial');
    if (!value) return false;
    return value === 'true' || value === '1';
  }

  /**
   * Hours after which an open gate visit is auto-checked-out by ATT-014 (default: 12).
   */
  async getAttendanceAutoCheckoutHours(): Promise<number> {
    const value = await this.getSetting('attendance_auto_checkout_hours');
    if (!value) {
      return 12;
    }
    const parsed = parseInt(value, 10);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : 12;
  }

  /**
   * Formula used to compute dietary adherence score when not supplied by client (default: 'calorie_ratio').
   * Supported: 'calorie_ratio'.
   */
  async getDietAdherenceFormula(): Promise<string> {
    const value = await this.getSetting('diet_adherence_formula');
    return value ?? 'calorie_ratio';
  }

  /**
   * Metric IDs that must be provided in every measurement session (default: []).
   * Stored as a comma-separated list or JSON array of numbers under 'mandatory_measurement_metrics'.
   */
  async getMandatoryMeasurementMetricIds(): Promise<number[]> {
    const value = await this.getSetting('mandatory_measurement_metrics');
    if (!value) {
      return [];
    }
    try {
      if (value.startsWith('[')) {
        const parsed = JSON.parse(value);
        if (Array.isArray(parsed)) {
          return parsed.map((v) => Number(v)).filter((v) => Number.isFinite(v) && v > 0);
        }
      }
      return value
        .split(',')
        .map((s) => parseInt(s.trim(), 10))
        .filter((v) => Number.isFinite(v) && v > 0);
    } catch {
      return [];
    }
  }

  /**
   * Retrieves a single setting value by key from the warmed cache.
   */
  async getSetting(key: string): Promise<string | null> {
    if (!this.cache || Date.now() - this.cacheLoadedAt > this.cacheTtlMs) {
      await this.refreshCache();
    }
    return this.cache!.get(key) ?? null;
  }

  /**
   * Retrieves all gym settings as a key-value record from the warmed cache.
   */
  async getAllSettings(): Promise<Record<string, string>> {
    if (!this.cache || Date.now() - this.cacheLoadedAt > this.cacheTtlMs) {
      await this.refreshCache();
    }
    return Object.fromEntries(this.cache!.entries());
  }

  /**
   * Returns settings list optionally filtered by category.
   */
  async listSettings(category?: string): Promise<SettingDto[]> {
    const parsedCategory = category ? parseSettingCategory(category) : undefined;
    if (category && !parsedCategory) {
      throw new BadRequestError(`Unsupported settings category "${category}".`);
    }

    const rows = await this.settingsRepository.findAll();
    const stored = new Map(rows.map((row) => [row.setting_key, row]));
    // Defaults are visible even before the seed job runs. Persisted values always win.
    const settings: SettingDto[] = SETTING_CATALOGUE
      .filter((definition) => !parsedCategory || definition.category === parsedCategory)
      .map((definition) => {
        const row = stored.get(definition.setting_key);
        return {
          ...(row ? { id: row.id } : {}),
          setting_key: definition.setting_key,
          setting_value: row?.setting_value ?? definition.default_value,
          category: definition.category,
        };
      });

    return settings;
  }

  /**
   * Upserts one or multiple settings and refreshes the cache.
   */
  async updateSettings(items: Array<{ setting_key: string; setting_value: string }>): Promise<SettingDto[]> {
    const validationErrors: Array<{ setting_key: string; message: string }> = [];
    for (const item of items) {
      const definition = getSettingDefinition(item.setting_key);
      if (!definition) {
        validationErrors.push({ setting_key: item.setting_key, message: 'Unknown or unsupported setting key.' });
      } else if (!definition.validate(item.setting_value)) {
        validationErrors.push({ setting_key: item.setting_key, message: 'Invalid value for this setting.' });
      }
    }
    if (validationErrors.length > 0) {
      throw new BadRequestError('Settings update contains invalid values.', validationErrors);
    }

    const beforeValues = new Map((await this.settingsRepository.findAll()).map((row) => [row.setting_key, row.setting_value]));
    await this.settingsRepository.upsertMany(items);
    await this.refreshCache();
    if (this.auditService) {
      await this.auditService.recordAudit({
        action: 'SETTINGS_UPDATED',
        entityName: 'gym_settings',
        beforeState: Object.fromEntries(items.map((item) => [item.setting_key, beforeValues.get(item.setting_key) ?? null])),
        afterState: Object.fromEntries(items.map((item) => [item.setting_key, item.setting_value])),
      });
    }
    return this.listSettings();
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
    // Keep default-only keys available to typed consumers before database seeding.
    for (const definition of SETTING_CATALOGUE) {
      if (!map.has(definition.setting_key)) map.set(definition.setting_key, definition.default_value);
    }
    this.cache = map;
    this.cacheLoadedAt = Date.now();
  }
}
