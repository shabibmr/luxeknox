import type { DrizzleDb } from '../client';
import { ptProducts, type NewPtProduct } from '../schema/personal-training';

/** Seed data for the `pt_products` catalog. */
const SEED_PT_PRODUCTS: Omit<NewPtProduct, 'id' | 'created_at' | 'updated_at'>[] = [
  {
    name: 'Personal Training - 1 Month',
    code: 'PT-1M',
    description: 'Personal training, 1 month. Weekly sessions are set per member.',
    duration_days: 30,
    base_price: '3999.00',
    tax_percentage: '0.00',
    package_type: 'single',
    is_active: true,
  },
  {
    name: 'Personal Training - 3 Months',
    code: 'PT-3M',
    description: 'Personal training, 3 months. Weekly sessions are set per member.',
    duration_days: 90,
    base_price: '14999.00',
    tax_percentage: '0.00',
    package_type: 'single',
    is_active: true,
  },
  {
    name: 'Couple PT 1 Month',
    code: 'CPT-1M',
    description:
      'Personal training for two members sharing one trainer and weekly slot, 1 month.',
    duration_days: 30,
    base_price: '6999.00',
    tax_percentage: '0.00',
    package_type: 'couple',
    is_active: true,
  },
  {
    name: 'Couple PT 3 Month',
    code: 'CPT-3M',
    description:
      'Personal training for two members sharing one trainer and weekly slot, 3 months.',
    duration_days: 90,
    base_price: '24999.00',
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
