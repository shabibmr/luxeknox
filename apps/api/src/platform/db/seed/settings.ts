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
    setting_key: 'business_name',
    setting_value: 'LuxeKnox Luxury Gym',
    description: 'Official registered gym business name for receipts and communications',
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
