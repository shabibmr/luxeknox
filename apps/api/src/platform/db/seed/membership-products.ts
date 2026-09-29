import type { DrizzleDb } from '../client';
import { membershipProducts, type NewMembershipProduct } from '../schema/memberships';

/** Seed data for the `membership_products` catalog. */
const SEED_MEMBERSHIP_PRODUCTS: Omit<NewMembershipProduct, 'id' | 'created_at' | 'updated_at'>[] = [
  {
    name: 'Monthly',
    code: 'MEMB-MONTHLY',
    description: 'Full gym access, billed monthly.',
    duration_days: 30,
    base_price: '1999.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    is_active: true,
  },
  {
    name: 'Quarterly',
    code: 'MEMB-QUARTERLY',
    description: 'Full gym access, billed every 3 months.',
    duration_days: 90,
    base_price: '5499.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    is_active: true,
  },
  {
    name: 'Annual',
    code: 'MEMB-ANNUAL',
    description: 'Full gym access, billed once a year.',
    duration_days: 365,
    base_price: '18999.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    is_active: true,
  },
];

/**
 * Idempotent: inserts only products whose `code` is not already present, so re-running
 * never duplicates rows and never overwrites admin edits.
 */
export async function seedMembershipProducts(
  db: DrizzleDb,
): Promise<{ inserted: number; skipped: number }> {
  const existing = await db.select({ code: membershipProducts.code }).from(membershipProducts);
  const known = new Set(existing.map((r) => r.code));

  const now = new Date();
  const toInsert: NewMembershipProduct[] = SEED_MEMBERSHIP_PRODUCTS.filter(
    (p) => !known.has(p.code),
  ).map((p) => ({ ...p, created_at: now }));

  if (toInsert.length > 0) {
    await db.insert(membershipProducts).values(toInsert);
  }

  return { inserted: toInsert.length, skipped: SEED_MEMBERSHIP_PRODUCTS.length - toInsert.length };
}
