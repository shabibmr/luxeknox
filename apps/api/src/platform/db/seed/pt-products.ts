import type { DrizzleDb } from '../client';
import { ptProducts, type NewPtProduct } from '../schema/personal-training';

/** Seed data for the `pt_products` catalog. */
const SEED_PT_PRODUCTS: Omit<NewPtProduct, 'id' | 'created_at' | 'updated_at'>[] = [
  {
    name: 'PT 2x/week - 1 Month',
    code: 'PT-2X-1M',
    description: 'Personal training, 2 sessions per week, 1 month.',
    duration_days: 30,
    sessions_per_week: 2,
    base_price: '3999.00',
    tax_percentage: '0.00',
    is_active: true,
  },
  {
    name: 'PT 3x/week - 1 Month',
    code: 'PT-3X-1M',
    description: 'Personal training, 3 sessions per week, 1 month.',
    duration_days: 30,
    sessions_per_week: 3,
    base_price: '5499.00',
    tax_percentage: '0.00',
    is_active: true,
  },
  {
    name: 'PT 3x/week - 3 Months',
    code: 'PT-3X-3M',
    description: 'Personal training, 3 sessions per week, 3 months.',
    duration_days: 90,
    sessions_per_week: 3,
    base_price: '14999.00',
    tax_percentage: '0.00',
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
