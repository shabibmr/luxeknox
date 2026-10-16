import { and, eq, isNull, sql } from 'drizzle-orm';
import type { DrizzleDb } from '../client';
import {
  accountingPeriods,
  accounts,
  fiscalYears,
  items,
  taxCodeComponents,
  taxCodes,
  uoms,
  type NewAccount,
  type NewAccountingPeriod,
  type NewFiscalYear,
  type NewTaxCode,
  type NewTaxCodeComponent,
  type NewUom,
} from '../schema/accounting';

/** Seeded chart of accounts — names are stable unique lookup keys. */
const SEED_ACCOUNTS: ReadonlyArray<
  Omit<NewAccount, 'id' | 'created_at' | 'updated_at' | 'parent_id'>
> = [
  { name: 'Cash', account_type: 'asset', is_active: true, is_bank: true, is_control: false, control_role: null },
  { name: 'Bank', account_type: 'asset', is_active: true, is_bank: true, is_control: false, control_role: null },
  { name: 'Card/UPI clearing', account_type: 'asset', is_active: true, is_bank: true, is_control: false, control_role: null },
  { name: 'Accounts receivable', account_type: 'asset', is_active: true, is_bank: false, is_control: true, control_role: 'ar' },
  { name: 'Input tax', account_type: 'asset', is_active: true, is_bank: false, is_control: true, control_role: 'input_tax' },
  { name: 'Inventory', account_type: 'asset', is_active: true, is_bank: false, is_control: true, control_role: 'inventory' },
  { name: 'Accounts payable', account_type: 'liability', is_active: true, is_bank: false, is_control: true, control_role: 'ap' },
  { name: 'Output CGST', account_type: 'liability', is_active: true, is_bank: false, is_control: true, control_role: 'output_cgst' },
  { name: 'Output SGST', account_type: 'liability', is_active: true, is_bank: false, is_control: true, control_role: 'output_sgst' },
  { name: 'Output IGST', account_type: 'liability', is_active: true, is_bank: false, is_control: true, control_role: 'output_igst' },
  { name: 'Unearned membership revenue', account_type: 'liability', is_active: true, is_bank: false, is_control: true, control_role: 'unearned_membership' },
  { name: 'Unearned personal training revenue', account_type: 'liability', is_active: true, is_bank: false, is_control: true, control_role: 'unearned_pt' },
  { name: "Owner's capital", account_type: 'equity', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Retained earnings', account_type: 'equity', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Membership revenue', account_type: 'income', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Personal training revenue', account_type: 'income', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Other sales', account_type: 'income', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Merchandise sales', account_type: 'income', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Forfeited membership income', account_type: 'income', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Sales discounts', account_type: 'income', is_active: true, is_bank: false, is_control: true, control_role: 'discounts' },
  { name: 'Rent', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Cost of goods sold', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Utilities', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Salaries', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Supplies', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Repairs and maintenance', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Bank and processor charges', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'General expense', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Inventory adjustments', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { name: 'Rounding off', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
];

const SEED_UOMS: ReadonlyArray<Omit<NewUom, 'id' | 'created_at' | 'updated_at' | 'is_active'>> = [
  { code: 'PCS', name: 'Pieces', decimal_places: 0 },
  { code: 'BOX', name: 'Box', decimal_places: 0 },
  { code: 'PKT', name: 'Packet', decimal_places: 0 },
  { code: 'BTL', name: 'Bottle', decimal_places: 0 },
  { code: 'KG', name: 'Kilogram', decimal_places: 3 },
  { code: 'G', name: 'Gram', decimal_places: 0 },
  { code: 'LTR', name: 'Litre', decimal_places: 3 },
  { code: 'ML', name: 'Millilitre', decimal_places: 0 },
];

const SEED_TAX_CODES: ReadonlyArray<Omit<NewTaxCode, 'id'>> = [
  { name: 'Exempt', code: 'exempt', rate_percent: '0.00', is_active: true },
  { name: 'GST 18%', code: 'gst_18', rate_percent: '18.00', is_active: true },
  { name: 'IGST 18%', code: 'igst_18', rate_percent: '18.00', is_active: true },
];

/** Fiscal year start month (April). Matches `accounting.fiscal_year_start_month` default. */
const FISCAL_YEAR_START_MONTH = 4;

function currentFiscalYearWindow(now = new Date()): {
  label: string;
  startsOn: string;
  endsOn: string;
} {
  const year = now.getUTCFullYear();
  const month = now.getUTCMonth() + 1;
  const startYear = month >= FISCAL_YEAR_START_MONTH ? year : year - 1;
  const endYear = startYear + 1;
  const label = `${startYear}-${String(endYear).slice(-2)}`;
  const startsOn = `${startYear}-04-01`;
  const endsOn = `${endYear}-03-31`;
  return { label, startsOn, endsOn };
}

function monthEndsOn(year: number, month: number): string {
  // month is 1-based; day 0 of next month = last day of this month
  const last = new Date(Date.UTC(year, month, 0));
  const y = last.getUTCFullYear();
  const m = String(last.getUTCMonth() + 1).padStart(2, '0');
  const d = String(last.getUTCDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

function buildFiscalPeriods(startsOn: string): Array<Pick<NewAccountingPeriod, 'starts_on' | 'ends_on' | 'status'>> {
  const start = new Date(`${startsOn}T00:00:00.000Z`);
  const periods: Array<Pick<NewAccountingPeriod, 'starts_on' | 'ends_on' | 'status'>> = [];
  for (let i = 0; i < 12; i++) {
    const y = start.getUTCFullYear();
    const m = start.getUTCMonth() + 1 + i;
    const year = y + Math.floor((m - 1) / 12);
    const month = ((m - 1) % 12) + 1;
    const starts = `${year}-${String(month).padStart(2, '0')}-01`;
    periods.push({ starts_on: starts, ends_on: monthEndsOn(year, month), status: 'open' });
  }
  return periods;
}

async function ensureAccounts(db: DrizzleDb): Promise<Map<string, number>> {
  const now = new Date();
  const existing = await db.select({ id: accounts.id, name: accounts.name }).from(accounts);
  const byName = new Map(existing.map((row) => [row.name, row.id]));

  const missing = SEED_ACCOUNTS.filter((account) => !byName.has(account.name));
  if (missing.length > 0) {
    await db.insert(accounts).values(missing.map((account) => ({ ...account, created_at: now })));
    const refreshed = await db.select({ id: accounts.id, name: accounts.name }).from(accounts);
    for (const row of refreshed) byName.set(row.name, row.id);
  }

  return byName;
}

async function ensureUoms(db: DrizzleDb): Promise<number> {
  const now = new Date();
  const existing = await db.select({ id: uoms.id, code: uoms.code }).from(uoms);
  const byCode = new Map(existing.map((row) => [row.code, row.id]));
  const missing = SEED_UOMS.filter((uom) => !byCode.has(uom.code));
  if (missing.length > 0) {
    await db.insert(uoms).values(
      missing.map((uom) => ({ ...uom, is_active: true, created_at: now })),
    );
    const refreshed = await db.select({ id: uoms.id, code: uoms.code }).from(uoms);
    for (const row of refreshed) byCode.set(row.code, row.id);
  }

  const pcsId = byCode.get('PCS');
  if (!pcsId) {
    throw new Error('[Seed] Missing UOM PCS');
  }

  await db.update(items).set({ uom_id: pcsId, updated_at: now }).where(isNull(items.uom_id));
  return byCode.size;
}

async function ensureTaxCodes(
  db: DrizzleDb,
  accountIds: Map<string, number>,
): Promise<void> {
  const existing = await db.select({ id: taxCodes.id, code: taxCodes.code }).from(taxCodes);
  const byCode = new Map(existing.map((row) => [row.code, row.id]));

  const missing = SEED_TAX_CODES.filter((tax) => !byCode.has(tax.code));
  if (missing.length > 0) {
    await db.insert(taxCodes).values([...missing]);
    const refreshed = await db.select({ id: taxCodes.id, code: taxCodes.code }).from(taxCodes);
    for (const row of refreshed) byCode.set(row.code, row.id);
  }

  const inputTaxId = accountIds.get('Input tax');
  const cgstId = accountIds.get('Output CGST');
  const sgstId = accountIds.get('Output SGST');
  const igstId = accountIds.get('Output IGST');
  if (!inputTaxId || !cgstId || !sgstId || !igstId) {
    throw new Error('[Seed] Missing tax control accounts (Input tax / Output CGST/SGST/IGST)');
  }

  const gst18Id = byCode.get('gst_18');
  const igst18Id = byCode.get('igst_18');
  if (!gst18Id || !igst18Id) {
    throw new Error('[Seed] Missing tax codes gst_18 / igst_18');
  }

  const componentSeeds: NewTaxCodeComponent[] = [
    {
      tax_code_id: gst18Id,
      name: 'CGST',
      rate_percent: '9.00',
      output_account_id: cgstId,
      input_account_id: inputTaxId,
    },
    {
      tax_code_id: gst18Id,
      name: 'SGST',
      rate_percent: '9.00',
      output_account_id: sgstId,
      input_account_id: inputTaxId,
    },
    {
      tax_code_id: igst18Id,
      name: 'IGST',
      rate_percent: '18.00',
      output_account_id: igstId,
      input_account_id: inputTaxId,
    },
  ];

  for (const component of componentSeeds) {
    const found = await db
      .select({ id: taxCodeComponents.id })
      .from(taxCodeComponents)
      .where(
        and(
          eq(taxCodeComponents.tax_code_id, component.tax_code_id),
          eq(taxCodeComponents.name, component.name),
        ),
      )
      .limit(1);
    if (found.length === 0) {
      await db.insert(taxCodeComponents).values(component);
    }
  }
}

async function ensureFiscalYear(db: DrizzleDb): Promise<void> {
  const { label, startsOn, endsOn } = currentFiscalYearWindow();
  const existingFy = await db
    .select({ id: fiscalYears.id })
    .from(fiscalYears)
    .where(eq(fiscalYears.label, label))
    .limit(1);

  let fiscalYearId: number;
  if (existingFy.length > 0) {
    fiscalYearId = existingFy[0].id;
  } else {
    const values: NewFiscalYear = { label, starts_on: startsOn, ends_on: endsOn };
    await db.insert(fiscalYears).values(values);
    const again = await db
      .select({ id: fiscalYears.id })
      .from(fiscalYears)
      .where(eq(fiscalYears.label, label))
      .limit(1);
    fiscalYearId = again[0]?.id;
  }

  if (!fiscalYearId) {
    throw new Error(`[Seed] Failed to resolve fiscal year ${label}`);
  }

  const existingPeriods = await db
    .select({ starts_on: accountingPeriods.starts_on })
    .from(accountingPeriods)
    .where(eq(accountingPeriods.fiscal_year_id, fiscalYearId));
  const knownStarts = new Set(existingPeriods.map((p) => p.starts_on));

  const toInsert = buildFiscalPeriods(startsOn)
    .filter((p) => !knownStarts.has(p.starts_on))
    .map((p) => ({
      fiscal_year_id: fiscalYearId,
      starts_on: p.starts_on,
      ends_on: p.ends_on,
      status: p.status,
    }));

  if (toInsert.length > 0) {
    await db.insert(accountingPeriods).values(toInsert);
  }
}

/**
 * Idempotent accounting seed: chart, tax codes (GST/IGST/exempt), current FY + months.
 * Re-running does not duplicate account names or tax codes.
 */
export async function seedAccounting(db: DrizzleDb): Promise<{
  accounts: number;
  taxCodes: number;
  uoms: number;
  fiscalYearLabel: string;
}> {
  const accountIds = await ensureAccounts(db);
  const uomCount = await ensureUoms(db);
  await ensureTaxCodes(db, accountIds);
  await ensureFiscalYear(db);

  const { label } = currentFiscalYearWindow();
  const taxCount = (
    await db.select({ code: taxCodes.code }).from(taxCodes).where(sql`code IN ('exempt','gst_18','igst_18')`)
  ).length;

  return {
    accounts: accountIds.size,
    taxCodes: taxCount,
    uoms: uomCount,
    fiscalYearLabel: label,
  };
}
