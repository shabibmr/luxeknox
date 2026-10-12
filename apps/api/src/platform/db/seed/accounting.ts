import { and, eq, sql } from 'drizzle-orm';
import type { DrizzleDb } from '../client';
import {
  accountingPeriods,
  accounts,
  fiscalYears,
  taxCodeComponents,
  taxCodes,
  type NewAccount,
  type NewAccountingPeriod,
  type NewFiscalYear,
  type NewTaxCode,
  type NewTaxCodeComponent,
} from '../schema/accounting';

/** Seeded chart of accounts — codes are stable lookup keys. */
const SEED_ACCOUNTS: ReadonlyArray<
  Omit<NewAccount, 'id' | 'created_at' | 'updated_at' | 'parent_id'>
> = [
  { code: '1000', name: 'Cash', account_type: 'asset', is_active: true, is_bank: true, is_control: false, control_role: null },
  { code: '1010', name: 'Bank', account_type: 'asset', is_active: true, is_bank: true, is_control: false, control_role: null },
  { code: '1020', name: 'Card/UPI clearing', account_type: 'asset', is_active: true, is_bank: true, is_control: false, control_role: null },
  { code: '1100', name: 'Accounts receivable', account_type: 'asset', is_active: true, is_bank: false, is_control: true, control_role: 'ar' },
  { code: '1300', name: 'Input tax', account_type: 'asset', is_active: true, is_bank: false, is_control: true, control_role: 'input_tax' },
  { code: '2000', name: 'Accounts payable', account_type: 'liability', is_active: true, is_bank: false, is_control: true, control_role: 'ap' },
  { code: '2100', name: 'Output CGST', account_type: 'liability', is_active: true, is_bank: false, is_control: true, control_role: 'output_cgst' },
  { code: '2110', name: 'Output SGST', account_type: 'liability', is_active: true, is_bank: false, is_control: true, control_role: 'output_sgst' },
  { code: '2120', name: 'Output IGST', account_type: 'liability', is_active: true, is_bank: false, is_control: true, control_role: 'output_igst' },
  { code: '2200', name: 'Unearned membership revenue', account_type: 'liability', is_active: true, is_bank: false, is_control: true, control_role: 'unearned_membership' },
  { code: '2210', name: 'Unearned personal training revenue', account_type: 'liability', is_active: true, is_bank: false, is_control: true, control_role: 'unearned_pt' },
  { code: '3000', name: "Owner's capital", account_type: 'equity', is_active: true, is_bank: false, is_control: false, control_role: null },
  { code: '3100', name: 'Retained earnings', account_type: 'equity', is_active: true, is_bank: false, is_control: false, control_role: null },
  { code: '4000', name: 'Membership revenue', account_type: 'income', is_active: true, is_bank: false, is_control: false, control_role: null },
  { code: '4100', name: 'Personal training revenue', account_type: 'income', is_active: true, is_bank: false, is_control: false, control_role: null },
  { code: '4200', name: 'Other sales', account_type: 'income', is_active: true, is_bank: false, is_control: false, control_role: null },
  { code: '4300', name: 'Forfeited membership income', account_type: 'income', is_active: true, is_bank: false, is_control: false, control_role: null },
  { code: '4900', name: 'Sales discounts', account_type: 'income', is_active: true, is_bank: false, is_control: true, control_role: 'discounts' },
  { code: '5000', name: 'Rent', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { code: '5100', name: 'Utilities', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { code: '5200', name: 'Salaries', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { code: '5300', name: 'Supplies', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { code: '5400', name: 'Repairs and maintenance', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { code: '5500', name: 'Bank and processor charges', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { code: '5900', name: 'General expense', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
  { code: '5950', name: 'Rounding off', account_type: 'expense', is_active: true, is_bank: false, is_control: false, control_role: null },
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
  const existing = await db.select({ id: accounts.id, code: accounts.code }).from(accounts);
  const byCode = new Map(existing.map((row) => [row.code, row.id]));

  const missing = SEED_ACCOUNTS.filter((account) => !byCode.has(account.code));
  if (missing.length > 0) {
    await db.insert(accounts).values(missing.map((account) => ({ ...account, created_at: now })));
    const refreshed = await db.select({ id: accounts.id, code: accounts.code }).from(accounts);
    for (const row of refreshed) byCode.set(row.code, row.id);
  }

  return byCode;
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

  const inputTaxId = accountIds.get('1300');
  const cgstId = accountIds.get('2100');
  const sgstId = accountIds.get('2110');
  const igstId = accountIds.get('2120');
  if (!inputTaxId || !cgstId || !sgstId || !igstId) {
    throw new Error('[Seed] Missing tax control accounts (1300/2100/2110/2120)');
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
 * Re-running does not duplicate account codes or tax codes.
 */
export async function seedAccounting(db: DrizzleDb): Promise<{
  accounts: number;
  taxCodes: number;
  fiscalYearLabel: string;
}> {
  const accountIds = await ensureAccounts(db);
  await ensureTaxCodes(db, accountIds);
  await ensureFiscalYear(db);

  const { label } = currentFiscalYearWindow();
  const taxCount = (
    await db.select({ code: taxCodes.code }).from(taxCodes).where(sql`code IN ('exempt','gst_18','igst_18')`)
  ).length;

  return {
    accounts: accountIds.size,
    taxCodes: taxCount,
    fiscalYearLabel: label,
  };
}
