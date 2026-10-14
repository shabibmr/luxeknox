import type { DrizzleDb } from '../client';
import { ptProducts, type NewPtProduct } from '../schema/personal-training';

/** Seed data for the `pt_products` catalog. */
const SEED_PT_PRODUCTS: Omit<NewPtProduct, 'id' | 'created_at' | 'updated_at'>[] = [
  {
    name: 'Personal Training - Single - 1 Month',
    code: 'PT-S-1M',
    description: 'Personal training, 1 month. Weekly sessions are set per member.',
    duration_days: 30,
    base_price: '12000.00',
    tax_percentage: '0.00',
    package_type: 'single',
    is_active: true,
  },
  {
    name: 'Personal Training - Single - 3 Months',
    code: 'PT-S-3M',
    description: 'Personal training, 3 months. Weekly sessions are set per member.',
    duration_days: 90,
    base_price: '32500.00',
    tax_percentage: '0.00',
    package_type: 'single',
    is_active: true,
  },
  {
    name: 'Personal Training - Single - 6 Months',
    code: 'PT-S-6M',
    description: 'Personal training, 6 months. Weekly sessions are set per member.',
    duration_days: 180,
    base_price: '60000.00',
    tax_percentage: '0.00',
    package_type: 'single',
    is_active: true,
  },
  {
    name: 'Personal Training - Single - 12 Months',
    code: 'PT-S-12M',
    description: 'Personal training, 12 months. Weekly sessions are set per member.',
    duration_days: 365,
    base_price: '108000.00',
    tax_percentage: '0.00',
    package_type: 'single',
    is_active: true,
  },
  {
    name: 'Personal Training - Couple - 1 Month',
    code: 'PT-C-1M',
    description: 'Personal training for two members sharing one trainer and weekly slot, 1 month.',
    duration_days: 30,
    base_price: '21500.00',
    tax_percentage: '0.00',
    package_type: 'couple',
    is_active: true,
  },
  {
    name: 'Personal Training - Couple - 3 Months',
    code: 'PT-C-3M',
    description: 'Personal training for two members sharing one trainer and weekly slot, 3 months.',
    duration_days: 90,
    base_price: '59000.00',
    tax_percentage: '0.00',
    package_type: 'couple',
    is_active: true,
  },
  {
    name: 'Personal Training - Couple - 6 Months',
    code: 'PT-C-6M',
    description: 'Personal training for two members sharing one trainer and weekly slot, 6 months.',
    duration_days: 180,
    base_price: '108000.00',
    tax_percentage: '0.00',
    package_type: 'couple',
    is_active: true,
  },
  {
    name: 'Personal Training - Couple - 12 Months',
    code: 'PT-C-12M',
    description: 'Personal training for two members sharing one trainer and weekly slot, 12 months.',
    duration_days: 365,
    base_price: '198000.00',
    tax_percentage: '0.00',
    package_type: 'couple',
    is_active: true,
  },
];

/**
 * Idempotent: inserts only products whose `code` is not already present, so re-running
 * never duplicates rows and never overwrites admin edits.
 */
export async function seedPtProducts(db: DrizzleDb): Promise<{ inserted: number; skipped: number }> {
  const existing = await db.select({ code: ptProducts.code }).from(ptProducts);
  const known = new Set(existing.map((r) => r.code));

  const now = new Date();
  const toInsert: NewPtProduct[] = SEED_PT_PRODUCTS.filter((p) => !known.has(p.code)).map((p) => ({
    ...p,
    created_at: now,
  }));

  if (toInsert.length > 0) {
    await db.insert(ptProducts).values(toInsert);
  }

  return { inserted: toInsert.length, skipped: SEED_PT_PRODUCTS.length - toInsert.length };
}
