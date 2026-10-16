import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { eq, inArray, like } from 'drizzle-orm';
import {
  createTestApp,
  seedTestUsers,
  ADMIN_CREDENTIALS,
  type TestAppInstance,
} from './helpers/mysql';
import { seedAccounting } from '../src/platform/db/seed/accounting';
import {
  accounts,
  items,
  journalEntries,
  journalLines,
  taxCodes,
  uoms,
  type Account,
} from '../src/platform/db/schema/accounting';
import {
  counterSaleLines,
  counterSales,
  counterSaleTenders,
  itemStock,
  stockMovements,
} from '../src/platform/db/schema/inventory';
import { paymentMethods } from '../src/platform/db/schema/payments';
import { toCents } from '../src/platform/money/money';

const RUN_TAG = `${Date.now()}`.slice(-8);
const SKU = `IL16-${RUN_TAG}`;
const SALE_DATE = '2026-10-16';

describe('Inventory lite E2E (IL-16)', () => {
  let testApp: TestAppInstance;
  let adminToken: string;
  let cashAccount: Account;
  let incomeAccount: Account;
  let expenseAccount: Account;
  let pcsUomId: number;
  let exemptTaxId: number;
  let paymentMethodId: number;
  let itemId: number;
  let saleId: number;
  let saleNumber: string;
  let journalEntryId: number;

  async function loginAdmin(): Promise<string> {
    const res = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        identifier: ADMIN_CREDENTIALS.email,
        password: ADMIN_CREDENTIALS.password,
      }),
    });
    expect(res.status).toBe(200);
    const data = (await res.json()) as { accessToken: string };
    return data.accessToken;
  }

  async function authJson(
    method: string,
    path: string,
    body?: unknown,
    extraHeaders: Record<string, string> = {},
  ): Promise<Response> {
    const headers: Record<string, string> = {
      Authorization: `Bearer ${adminToken}`,
      ...extraHeaders,
    };
    if (body !== undefined) {
      headers['Content-Type'] = 'application/json';
    }
    return fetch(`${testApp.baseUrl}${path}`, {
      method,
      headers,
      body: body === undefined ? undefined : JSON.stringify(body),
    });
  }

  async function cleanupIl16Rows(): Promise<void> {
    const taggedItems = await testApp.db
      .select({ id: items.id })
      .from(items)
      .where(like(items.sku, 'IL16-%'));
    const itemIds = taggedItems.map((row) => row.id);
    if (itemIds.length === 0) return;

    const saleRows = await testApp.db
      .select({ id: counterSaleLines.counter_sale_id })
      .from(counterSaleLines)
      .where(inArray(counterSaleLines.item_id, itemIds));
    const saleIds = [...new Set(saleRows.map((row) => row.id))];

    if (saleIds.length > 0) {
      const sales = await testApp.db
        .select({
          id: counterSales.id,
          journal_entry_id: counterSales.journal_entry_id,
        })
        .from(counterSales)
        .where(inArray(counterSales.id, saleIds));
      const journalIds = sales
        .map((row) => row.journal_entry_id)
        .filter((id): id is number => id != null);

      await testApp.db
        .delete(counterSaleTenders)
        .where(inArray(counterSaleTenders.counter_sale_id, saleIds));
      await testApp.db
        .delete(counterSaleLines)
        .where(inArray(counterSaleLines.counter_sale_id, saleIds));
      await testApp.db.delete(counterSales).where(inArray(counterSales.id, saleIds));

      if (journalIds.length > 0) {
        await testApp.db.delete(journalLines).where(inArray(journalLines.journal_entry_id, journalIds));
        await testApp.db.delete(journalEntries).where(inArray(journalEntries.id, journalIds));
      }
    }

    await testApp.db.delete(stockMovements).where(inArray(stockMovements.item_id, itemIds));
    await testApp.db.delete(itemStock).where(inArray(itemStock.item_id, itemIds));
    await testApp.db.delete(items).where(inArray(items.id, itemIds));
  }

  beforeAll(async () => {
    testApp = await createTestApp();
    await seedTestUsers(testApp.db);
    await seedAccounting(testApp.db);
    await cleanupIl16Rows();

    adminToken = await loginAdmin();

    const [cash] = await testApp.db.select().from(accounts).where(eq(accounts.name, 'Cash')).limit(1);
    const [income] = await testApp.db.select().from(accounts).where(eq(accounts.name, 'Merchandise sales')).limit(1);
    const [expense] = await testApp.db.select().from(accounts).where(eq(accounts.name, 'Rent')).limit(1);
    const [pcs] = await testApp.db.select().from(uoms).where(eq(uoms.code, 'PCS')).limit(1);
    const [exempt] = await testApp.db.select().from(taxCodes).where(eq(taxCodes.code, 'exempt')).limit(1);

    expect(cash).toBeDefined();
    expect(income).toBeDefined();
    expect(expense).toBeDefined();
    expect(pcs).toBeDefined();
    expect(exempt).toBeDefined();

    cashAccount = cash;
    incomeAccount = income;
    expenseAccount = expense;
    pcsUomId = pcs.id;
    exemptTaxId = exempt.id;

    const existingMethods = await testApp.db.select().from(paymentMethods);
    if (existingMethods.length === 0) {
      const [insertRes] = await testApp.db.insert(paymentMethods).values({
        method_name: 'Cash',
        is_digital: false,
        is_active: true,
        account_id: cashAccount.id,
        created_at: new Date(),
        updated_at: new Date(),
      });
      paymentMethodId = Number((insertRes as { insertId: number }).insertId);
    } else {
      await testApp.db
        .update(paymentMethods)
        .set({ account_id: cashAccount.id, is_active: true })
        .where(eq(paymentMethods.id, existingMethods[0].id));
      paymentMethodId = existingMethods[0].id;
    }
  }, 60_000);

  afterAll(async () => {
    if (testApp?.db) {
      await cleanupIl16Rows();
    }
    if (testApp?.app) {
      await testApp.app.close();
    }
  });

  it('IL-12: creates a goods item with inventory columns', async () => {
    const res = await authJson('POST', '/accounting/items', {
      name: `IL16 Whey ${RUN_TAG}`,
      item_kind: 'goods',
      uom_id: pcsUomId,
      income_account_id: incomeAccount.id,
      expense_account_id: expenseAccount.id,
      sku: SKU,
      sale_rate: '100.00',
      tax_code_id: exemptTaxId,
      inventory_tracked: true,
    });
    if (res.status !== 201) {
      console.error('POST /accounting/items failed:', await res.text());
    }
    expect(res.status).toBe(201);
    const item = (await res.json()) as {
      id: number;
      sku: string;
      uom_id: number;
      inventory_tracked: boolean;
      sale_rate: string;
    };
    expect(item.sku).toBe(SKU);
    expect(item.uom_id).toBe(pcsUomId);
    expect(item.inventory_tracked).toBe(true);
    expect(item.sale_rate).toBe('100.00');
    itemId = item.id;
  });

  it('IL-13: lists and gets the item under /inventory/items', async () => {
    const listRes = await authJson('GET', `/inventory/items?search=${encodeURIComponent(SKU)}`);
    expect(listRes.status).toBe(200);
    const page = (await listRes.json()) as {
      data: Array<{
        id: number;
        sku: string | null;
        uom_code: string;
        name: string;
      }>;
    };
    const found = page.data.find((row) => row.id === itemId);
    expect(found).toBeDefined();
    expect(found!.sku).toBe(SKU);
    expect(found!.uom_code).toBe('PCS');

    const getRes = await authJson('GET', `/inventory/items/${itemId}`);
    expect(getRes.status).toBe(200);
    const detail = (await getRes.json()) as { id: number; sku: string; uom_code: string };
    expect(detail.id).toBe(itemId);
    expect(detail.sku).toBe(SKU);
    expect(detail.uom_code).toBe('PCS');
  });

  it('IL-14: posts a counter sale with a balanced journal and refuses tender mismatch', async () => {
    // IL-31: tracked sales issue stock — seed on-hand so the create path can post COGS.
    await testApp.db.insert(itemStock).values({
      item_id: itemId,
      qty_on_hand: '10.000',
      stock_value: '1000.00',
      avg_cost: '100.0000',
      row_version: 1,
    });

    const mismatch = await authJson(
      'POST',
      '/inventory/sales',
      {
        sale_date: SALE_DATE,
        customer_name: `IL16 Walk-in ${RUN_TAG}`,
        lines: [{ item_id: itemId, quantity: '2' }],
        tenders: [{ payment_method_id: paymentMethodId, amount: '50.00' }],
      },
      { 'Idempotency-Key': `il16-mismatch-${RUN_TAG}` },
    );
    expect(mismatch.status).toBe(422);
    const mismatchBody = (await mismatch.json()) as {
      message: string;
      details?: Array<{ rule?: string }>;
    };
    expect(mismatchBody.message).toMatch(/tender/i);
    expect(mismatchBody.details?.some((d) => d.rule === 'tender_total_mismatch')).toBe(true);

    const createRes = await authJson(
      'POST',
      '/inventory/sales',
      {
        sale_date: SALE_DATE,
        customer_name: `IL16 Walk-in ${RUN_TAG}`,
        lines: [{ item_id: itemId, quantity: '2' }],
        tenders: [
          { payment_method_id: paymentMethodId, amount: '80.00' },
          { payment_method_id: paymentMethodId, amount: '120.00', reference: 'SPLIT' },
        ],
      },
      { 'Idempotency-Key': `il16-sale-${RUN_TAG}` },
    );
    if (createRes.status !== 201) {
      console.error('POST /inventory/sales failed:', await createRes.text());
    }
    expect(createRes.status).toBe(201);
    const sale = (await createRes.json()) as {
      id: number;
      sale_number: string;
      total_amount: string;
      tax_amount: string;
      cogs_amount: string;
      journal_entry_id: number;
      journal_number: string;
      lines: Array<{ unit_cost: string | null; cost_amount: string | null }>;
      tenders: unknown[];
    };
    expect(sale.sale_number).toMatch(/^SAL-/);
    expect(sale.total_amount).toBe('200.00');
    expect(sale.tax_amount).toBe('0.00');
    expect(sale.cogs_amount).toBe('200.00');
    expect(sale.journal_entry_id).toBeGreaterThan(0);
    expect(sale.journal_number).toMatch(/^JRN/);
    expect(sale.lines).toHaveLength(1);
    expect(sale.lines[0]?.unit_cost).toBe('100.0000');
    expect(sale.lines[0]?.cost_amount).toBe('200.00');
    expect(sale.tenders).toHaveLength(2);

    saleId = sale.id;
    saleNumber = sale.sale_number;
    journalEntryId = sale.journal_entry_id;

    const lines = await testApp.db
      .select()
      .from(journalLines)
      .where(eq(journalLines.journal_entry_id, journalEntryId));
    let debit = 0n;
    let credit = 0n;
    for (const line of lines) {
      if (line.debit != null) debit += toCents(String(line.debit));
      if (line.credit != null) credit += toCents(String(line.credit));
    }
    expect(debit).toBe(credit);
    // Sale total 200 + COGS 200
    expect(debit).toBe(toCents('400.00'));

    const replay = await authJson(
      'POST',
      '/inventory/sales',
      {
        sale_date: SALE_DATE,
        customer_name: `IL16 Walk-in ${RUN_TAG}`,
        lines: [{ item_id: itemId, quantity: '2' }],
        tenders: [
          { payment_method_id: paymentMethodId, amount: '80.00' },
          { payment_method_id: paymentMethodId, amount: '120.00', reference: 'SPLIT' },
        ],
      },
      { 'Idempotency-Key': `il16-sale-${RUN_TAG}` },
    );
    expect(replay.status).toBe(201);
    const replayed = (await replay.json()) as { id: number; sale_number: string };
    expect(replayed.id).toBe(saleId);
    expect(replayed.sale_number).toBe(saleNumber);

    const sameNumber = await testApp.db
      .select({ id: counterSales.id })
      .from(counterSales)
      .where(eq(counterSales.sale_number, saleNumber));
    expect(sameNumber).toHaveLength(1);
  });

  it('IL-15: lists headers without lines/tenders and gets full detail', async () => {
    const listRes = await authJson(
      'GET',
      `/inventory/sales?from=${SALE_DATE}&to=${SALE_DATE}&search=${encodeURIComponent(saleNumber)}&item_id=${itemId}`,
    );
    expect(listRes.status).toBe(200);
    const page = (await listRes.json()) as {
      data: Array<Record<string, unknown>>;
      meta: { total: number };
    };
    const row = page.data.find((entry) => entry.id === saleId);
    expect(row).toBeDefined();
    expect(row!.sale_number).toBe(saleNumber);
    expect(row!.journal_number).toMatch(/^JRN/);
    expect(row).not.toHaveProperty('lines');
    expect(row).not.toHaveProperty('tenders');
    expect(row).not.toHaveProperty('returns');

    const getRes = await authJson('GET', `/inventory/sales/${saleId}`);
    expect(getRes.status).toBe(200);
    const detail = (await getRes.json()) as {
      id: number;
      journal_number: string;
      lines: Array<{ returned_quantity: string }>;
      tenders: unknown[];
      returns: unknown[];
    };
    expect(detail.id).toBe(saleId);
    expect(detail.journal_number).toMatch(/^JRN/);
    expect(detail.lines).toHaveLength(1);
    expect(detail.lines[0].returned_quantity).toBe('0.000');
    expect(detail.tenders).toHaveLength(2);
    expect(detail.returns).toEqual([]);

    const missing = await authJson('GET', '/inventory/sales/99999999');
    expect(missing.status).toBe(404);
  });
});
