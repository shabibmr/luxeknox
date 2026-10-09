import { z } from 'zod';

/**
 * These IDs are part of the Flutter/API contract. Keep them aligned with
 * SettingCategory in app/lib/features/settings/domain/entities/setting_category.dart
 * and docs/openapi/v1.yaml.
 */
export const settingCategorySchema = z.enum([
  'general',
  'membership',
  'attendance_gate',
  'booking_rules',
  'billing',
  'workout',
  'diet',
  'notification',
  'measurement',
]);

export type SettingCategory = z.infer<typeof settingCategorySchema>;

export const settingItemWriteSchema = z.object({
  setting_key: z.string().trim().min(1).max(100),
  setting_value: z.string().max(10000),
});

export const settingsWriteSchema = z.object({
  items: z.array(settingItemWriteSchema).min(1).max(100).refine(
    (items) => new Set(items.map((item) => item.setting_key)).size === items.length,
    'A setting key may only appear once in an update.',
  ),
});

export type SettingsWriteDto = z.infer<typeof settingsWriteSchema>;

export interface SettingDto {
  id?: number;
  setting_key: string;
  setting_value: string;
  category: SettingCategory;
}

export interface SettingsListDto {
  data: SettingDto[];
}

export interface SettingDefinition {
  readonly setting_key: string;
  readonly category: SettingCategory;
  readonly default_value: string;
  readonly description: string;
  readonly validate: (value: string) => boolean;
}

const text = (max = 255) => (value: string) => value.length <= max;
const integer = (min: number, max: number) => (value: string) =>
  /^-?\d+$/.test(value) && Number.isSafeInteger(Number(value)) && Number(value) >= min && Number(value) <= max;
const decimal = (min: number, max: number) => (value: string) =>
  /^\d+(\.\d{1,2})?$/.test(value) && Number.isFinite(Number(value)) && Number(value) >= min && Number(value) <= max;
const boolean = (value: string) => ['true', 'false', '1', '0'].includes(value.toLowerCase());

/**
 * Only settings actually consumed by the backend are registered here.
 * Adding a visible setting is a contract change and requires runtime support.
 */
export const SETTING_CATALOGUE: readonly SettingDefinition[] = [
  { setting_key: 'business_name', category: 'general', default_value: 'LuxeKnox Luxury Gym', description: 'Gym business name', validate: text(255) },
  { setting_key: 'timezone', category: 'general', default_value: 'UTC', description: 'Gym operating time zone', validate: (value) => { try { new Intl.DateTimeFormat('en-US', { timeZone: value }); return true; } catch { return false; } } },
  { setting_key: 'default_page_size', category: 'general', default_value: '20', description: 'Default page size for list endpoints', validate: integer(1, 200) },
  { setting_key: 'currency', category: 'billing', default_value: 'INR', description: 'Billing currency code (ISO 4217)', validate: (value) => /^[A-Z]{3}$/.test(value) },
  { setting_key: 'tax_rate_percent', category: 'billing', default_value: '18.00', description: 'Tax rate percent', validate: decimal(0, 100) },
  { setting_key: 'payments_activate_membership_on_partial', category: 'membership', default_value: 'false', description: 'Activate membership when an invoice is partially paid', validate: boolean },
  { setting_key: 'schedule_booking_lead_time_minutes', category: 'booking_rules', default_value: '30', description: 'Minimum minutes before a session that members may book', validate: integer(0, 10080) },
  { setting_key: 'schedule_cancellation_cutoff_minutes', category: 'booking_rules', default_value: '120', description: 'Minimum minutes before a session that cancellation is allowed', validate: integer(0, 10080) },
  { setting_key: 'schedule_member_booking_cap', category: 'booking_rules', default_value: '5', description: 'Maximum concurrent active bookings per member', validate: integer(1, 100) },
  { setting_key: 'attendance_pass_ttl_minutes', category: 'attendance_gate', default_value: '5', description: 'Validity window for a digital attendance pass', validate: integer(1, 1440) },
  { setting_key: 'attendance_debounce_seconds', category: 'attendance_gate', default_value: '60', description: 'Duplicate check-in debounce window in seconds', validate: integer(0, 86400) },
  { setting_key: 'attendance_daily_checkin_cap', category: 'attendance_gate', default_value: '2', description: 'Maximum gate check-ins per member per day', validate: integer(1, 100) },
  { setting_key: 'attendance_auto_checkout_hours', category: 'attendance_gate', default_value: '12', description: 'Hours before an open gate visit is checked out automatically', validate: integer(1, 168) },
  { setting_key: 'diet_adherence_formula', category: 'diet', default_value: 'calorie_ratio', description: 'Diet adherence calculation formula', validate: (value) => value === 'calorie_ratio' },
  { setting_key: 'mandatory_measurement_metrics', category: 'measurement', default_value: '[]', description: 'Metric IDs required in measurement sessions (JSON array)', validate: (value) => { try { const parsed: unknown = JSON.parse(value); return Array.isArray(parsed) && parsed.every((item) => Number.isSafeInteger(item) && Number(item) > 0); } catch { return false; } },
] as const;

const settingDefinitions = new Map(SETTING_CATALOGUE.map((definition) => [definition.setting_key, definition]));

export function getSettingDefinition(key: string): SettingDefinition | undefined {
  return settingDefinitions.get(key);
}

export function resolveSettingCategory(key: string): SettingCategory {
  return settingDefinitions.get(key)?.category ?? 'general';
}

/** Converts legacy category IDs from older backend versions. */
export function parseSettingCategory(raw: string): SettingCategory | undefined {
  const value = raw.trim().toLowerCase();
  const aliases: Record<string, SettingCategory> = {
    general: 'general',
    billing: 'billing',
    schedule: 'booking_rules',
    attendance: 'attendance_gate',
    workout: 'workout',
    diet: 'diet',
    notification: 'notification',
    security: 'general',
    membership: 'membership',
    attendance_gate: 'attendance_gate',
    booking_rules: 'booking_rules',
    measurement: 'measurement',
    gym: 'general',
  };
  return aliases[value];
}
