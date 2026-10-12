import type { DrizzleDb } from '../client';
import { membershipProducts, type NewMembershipProduct } from '../schema/memberships';

/** Seed data for the `membership_products` catalog. */
const SEED_MEMBERSHIP_PRODUCTS: Omit<NewMembershipProduct, 'id' | 'created_at' | 'updated_at'>[] = [
  {
    name: 'General Training - Single - 1 Month',
    code: 'GT-S-1M',
    description: 'Full gym access, 1 month.',
    duration_days: 30,
    base_price: '2999.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    package_type: 'single',
    is_active: true,
  },
  {
    name: 'General Training - Single - 3 Months',
    code: 'GT-S-3M',
    description: 'Full gym access, 3 months.',
    duration_days: 90,
    base_price: '7499.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    package_type: 'single',
    is_active: true,
  },
  {
    name: 'General Training - Single - 6 Months',
    code: 'GT-S-6M',
    description: 'Full gym access, 6 months.',
    duration_days: 180,
    base_price: '14399.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    package_type: 'single',
    is_active: true,
  },
  {
    name: 'General Training - Single - 12 Months',
    code: 'GT-S-12M',
    description: 'Full gym access, 12 months.',
    duration_days: 365,
    base_price: '19999.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    package_type: 'single',
    is_active: true,
  },
  {
    name: 'General Training - Couple - 1 Month',
    code: 'GT-C-1M',
    description: 'Full gym access for two members, 1 month.',
    duration_days: 30,
    base_price: '5399.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    package_type: 'couple',
    is_active: true,
  },
  {
    name: 'General Training - Couple - 3 Months',
    code: 'GT-C-3M',
    description: 'Full gym access for two members, 3 months.',
    duration_days: 90,
    base_price: '13799.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    package_type: 'couple',
    is_active: true,
  },
  {
    name: 'General Training - Couple - 6 Months',
    code: 'GT-C-6M',
    description: 'Full gym access for two members, 6 months.',
    duration_days: 180,
    base_price: '25499.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    package_type: 'couple',
    is_active: true,
  },
  {
    name: 'General Training - Couple - 12 Months',
    code: 'GT-C-12M',
    description: 'Full gym access for two members, 12 months.',
    duration_days: 365,
    base_price: '34999.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    package_type: 'couple',
    is_active: true,
  },
  {
    name: 'Community Sessions - Group - 1 Month',
    code: 'COM-1M',
    description: 'Community group sessions, 1 month.',
    duration_days: 30,
    base_price: '2750.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    package_type: 'single',
    is_active: true,
  },
  {
    name: 'Community Sessions - Group - 3 Months',
    code: 'COM-3M',
    description: 'Community group sessions, 3 months.',
    duration_days: 90,
    base_price: '5999.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    package_type: 'single',
    is_active: true,
  },
  {
    name: 'Community Sessions - Group - 6 Months',
    code: 'COM-6M',
    description: 'Community group sessions, 6 months.',
    duration_days: 180,
    base_price: '10999.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    package_type: 'single',
    is_active: true,
  },
  {
    name: 'Community Sessions - Group - 12 Months',
    code: 'COM-12M',
    description: 'Community group sessions, 12 months.',
    duration_days: 365,
    base_price: '19999.00',
    tax_percentage: '0.00',
    max_freeze_days: 0,
    pt_sessions_included: 0,
    access_facilities: null,
    package_type: 'single',
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
