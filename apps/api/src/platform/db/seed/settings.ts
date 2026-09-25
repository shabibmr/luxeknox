import { sql } from 'drizzle-orm';
import type { DrizzleDb } from '../client';
import { gymSettings } from '../schema/gym-settings';

export interface GymSettingDefinition {
  setting_key: string;
  setting_value: string;
  description: string;
}

export const SEED_GYM_SETTINGS: readonly GymSettingDefinition[] = [
  {
    setting_key: 'timezone',
    setting_value: 'UTC',
    description: 'Gym canonical operating time zone',
  },
  {
    setting_key: 'currency',
    setting_value: 'INR',
    description: 'Default billing and ledger currency code (ISO 4217)',
  },
  {
    setting_key: 'default_page_size',
    setting_value: '20',
    description: 'Default pagination limit for listing endpoints',
  },
  {
    setting_key: 'tax_rate_percent',
    setting_value: '18.00',
    description: 'Applicable GST/VAT tax percentage for invoices',
  },
  {
    setting_key: 'payments_activate_membership_on_partial',
    setting_value: 'false',
    description: 'When true, POS product_id assign/renew runs on partial invoices; default only when paid',
  },
  {
    setting_key: 'business_name',
    setting_value: 'LuxeKnox Luxury Gym',
    description: 'Official registered gym business name for receipts and communications',
  },
  {
    setting_key: 'schedule_booking_lead_time_minutes',
    setting_value: '30',
    description: 'Minimum minutes before a schedule start time a member may book it',
  },
  {
    setting_key: 'schedule_cancellation_cutoff_minutes',
    setting_value: '120',
    description: 'Minimum minutes before a schedule start time a booking may still be cancelled',
  },
  {
    setting_key: 'schedule_member_booking_cap',
    setting_value: '5',
    description: 'Maximum concurrent active bookings a member may hold at once',
  },
  {
    setting_key: 'attendance_pass_ttl_minutes',
    setting_value: '5',
    description: 'Minutes a signed digital attendance QR pass remains valid',
  },
  {
    setting_key: 'attendance_debounce_seconds',
    setting_value: '60',
    description: 'Seconds within which a repeated gate check-in returns the existing open visit',
  },
  {
    setting_key: 'attendance_daily_checkin_cap',
    setting_value: '2',
    description: 'Maximum gate check-ins per user per UTC calendar day',
  },
  {
    setting_key: 'attendance_auto_checkout_hours',
    setting_value: '12',
    description: 'Hours after which an open gate visit is automatically checked out',
  },
] as const;

/**
 * Seeds default gym settings idempotently.
 * Uses ON DUPLICATE KEY UPDATE on `setting_key`.
 */
export async function seedSettings(db: DrizzleDb<any>): Promise<void> {
  const now = new Date();

  for (const setting of SEED_GYM_SETTINGS) {
    await db
      .insert(gymSettings)
      .values({
        setting_key: setting.setting_key,
        setting_value: setting.setting_value,
        description: setting.description,
        created_at: now,
        updated_at: now,
      })
      .onDuplicateKeyUpdate({
        set: {
          setting_value: sql`VALUES(\`setting_value\`)`,
          description: sql`VALUES(\`description\`)`,
          updated_at: now,
        },
      });
  }
}
