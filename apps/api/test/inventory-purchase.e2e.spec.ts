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
  debitNotes,
  items,
  journalEntries,
  journalLines,
  purchaseBillLines,
  purchaseBills,
  taxCodes,
  uoms,
  vendors,
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
const SKU_PREFIX = 'IL35-';
const BILL_DATE = '2026-10-16';
const LOCKED_DATE = '2026-07-15';

describe('Inventory lite purchase and stock ledger E2E (IL-35)', () => {
  let testApp: TestAppInstance;
  let adminToken: string;
  let cashAccount: Account;
  let incomeAccount: Account;
  let expenseAccount: Account;
  let inventoryAccount: Account;
  let pcsUomId: number;
  let kgUomId: number;
  let exemptTaxId: number;
  let paymentMethodId: number;
  let vendorId: number;
  let pcsItemId: number;
  let kgItemId: number;
  let serviceItemId: number;
  let nextInvoice = 0;

  const invoiceNo = () => `IL35-${RUN_TAG}-${++nextInvoice}`;

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
    if (body !== undefined) headers['Content-Type'] = 'application/json';
    return fetch(`${testApp.baseUrl}${path}`, {
      method,
      headers,
      body: body === undefined ? undefined : JSON.stringify(body),
    });
  }

  type BillBody = {
    id: number;
    status: string;
    journal_entry_id: number | null;
    supplier_invoice_no: string | null;
    lines: Array<{
      item_id: number | null;
      item_name: string | null;
      uom_code: string | null;
      inventory_tracked: boolean;
      returned_quantity: string;
      account_id: number;
      net_amount: string;
    }>;
  };

  async function postBill(
    lines: unknown[],
    opts: { date?: string; invoice?: string; key?: string } = {},
  ): Promise<Response> {
    return authJson(
      'POST',
      '/accounting/purchase-bills',
      {
        vendor_id: vendorId,
        bill_date: opts.date ?? BILL_DATE,
        supplier_invoice_no: opts.invoice ?? invoiceNo(),
        lines,
      },
      { 'Idempotency-Key': opts.key ?? `il35-${RUN_TAG}-${Math.random().toString(36).slice(2)}` },
    );
  }

  async function postBillOk(
    lines: unknown[],
    opts: { date?: string; invoice?: string; key?: string } = {},
  ): Promise<BillBody> {
    const res = await postBill(lines, opts);
    if (res.status !== 201) console.error('POST purchase-bills failed:', await res.text());
    expect(res.status).toBe(201);
    return (await res.json()) as BillBody;
  }

  async function stockOf(itemId: number): Promise<{ qty: string; value: string } | null> {
    const [row] = await testApp.db.select().from(itemStock).where(eq(itemStock.item_id, itemId));
    return row ? { qty: String(row.qty_on_hand), value: String(row.stock_value) } : null;
  }

  async function expectBalanced(journalEntryId: number | null): Promise<void> {
    expect(journalEntryId).not.toBeNull();
    const lines = await testApp.db
      .select()
      .from(journalLines)
      .where(eq(journalLines.journal_entry_id, journalEntryId!));
    let debit = 0n;
    let credit = 0n;
    for (const line of lines) {
      if (line.debit != null) debit += toCents(String(line.debit));
      if (line.credit != null) credit += toCents(String(line.credit));
    }
    expect(debit).toBe(credit);
    expect(debit).toBeGreaterThan(0n);
  }

  async function debitTo(journalEntryId: number, accountId: number): Promise<bigint> {
    const lines = await testApp.db
      .select()
      .from(journalLines)
      .where(eq(journalLines.journal_entry_id, journalEntryId));
    return lines
      .filter((l) => l.account_id === accountId && l.debit != null)
      .reduce((sum, l) => sum + toCents(String(l.debit)), 0n);
  }

  async function createItem(body: Record<string, unknown>): Promise<number> {
    const res = await authJson('POST', '/accounting/items', {
      item_kind: 'goods',
      income_account_id: incomeAccount.id,
      expense_account_id: expenseAccount.id,
      tax_code_id: exemptTaxId,
      ...body,
    });
    if (res.status !== 201) console.error('POST /accounting/items failed:', await res.text());
    expect(res.status).toBe(201);
    return ((await res.json()) as { id: number }).id;
  }

  async function cleanup(): Promise<void> {
    const tagged = await testApp.db
      .select({ id: items.id })
      .from(items)
      .where(like(items.sku, `${SKU_PREFIX}%`));
    const itemIds = tagged.map((r) => r.id);
    if (itemIds.length === 0) return;

    const journalIds = new Set<number>();

    const saleRows = await testApp.db
      .select({ id: counterSaleLines.counter_sale_id })
      .from(counterSaleLines)
      .where(inArray(counterSaleLines.item_id, itemIds));
    const saleIds = [...new Set(saleRows.map((r) => r.id))];
    if (saleIds.length > 0) {
      const sales = await testApp.db
        .select({ journal_entry_id: counterSales.journal_entry_id })
        .from(counterSales)
        .where(inArray(counterSales.id, saleIds));
      sales.forEach((s) => s.journal_entry_id != null && journalIds.add(s.journal_entry_id));
      await testApp.db
        .delete(counterSaleTenders)
        .where(inArray(counterSaleTenders.counter_sale_id, saleIds));
      await testApp.db
        .delete(counterSaleLines)
        .where(inArray(counterSaleLines.counter_sale_id, saleIds));
      await testApp.db.delete(counterSales).where(inArray(counterSales.id, saleIds));
    }

    const billRows = await testApp.db
      .select({ id: purchaseBills.id, journal_entry_id: purchaseBills.journal_entry_id })
      .from(purchaseBills)
      .where(like(purchaseBills.supplier_invoice_no, 'IL35-%'));
    const billIds = billRows.map((r) => r.id);
    billRows.forEach((b) => b.journal_entry_id != null && journalIds.add(b.journal_entry_id));
    if (billIds.length > 0) {
      const notes = await testApp.db
        .select({ journal_entry_id: debitNotes.journal_entry_id })
        .from(debitNotes)
        .where(inArray(debitNotes.purchase_bill_id, billIds));
      notes.forEach((n) => n.journal_entry_id != null && journalIds.add(n.journal_entry_id));
      await testApp.db.delete(debitNotes).where(inArray(debitNotes.purchase_bill_id, billIds));
    }

    await testApp.db.delete(stockMovements).where(inArray(stockMovements.item_id, itemIds));
    await testApp.db.delete(itemStock).where(inArray(itemStock.item_id, itemIds));
    if (billIds.length > 0) {
      await testApp.db
        .delete(purchaseBillLines)
        .where(inArray(purchaseBillLines.purchase_bill_id, billIds));
      await testApp.db.delete(purchaseBills).where(inArray(purchaseBills.id, billIds));
    }
    const ids = [...journalIds];
    if (ids.length > 0) {
      await testApp.db.delete(journalLines).where(inArray(journalLines.journal_entry_id, ids));
      await testApp.db.delete(journalEntries).where(inArray(journalEntries.id, ids));
    }
    await testApp.db.delete(items).where(inArray(items.id, itemIds));
    await testApp.db.delete(vendors).where(like(vendors.name, 'IL35 Vendor%'));
  }

  beforeAll(async () => {
    testApp = await createTestApp();
    await seedTestUsers(testApp.db);
    await seedAccounting(testApp.db);
    await cleanup();

    const login = await fetch(`${testApp.baseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        identifier: ADMIN_CREDENTIALS.email,
        password: ADMIN_CREDENTIALS.password,
      }),
    });
    expect(login.status).toBe(200);
    adminToken = ((await login.json()) as { accessToken: string }).accessToken;

    const byName = async (name: string) => {
      const [row] = await testApp.db.select().from(accounts).where(eq(accounts.name, name)).limit(1);
      expect(row).toBeDefined();
      return row;
    };
    cashAccount = await byName('Cash');
    incomeAccount = await byName('Merchandise sales');
    expenseAccount = await byName('Rent');
    inventoryAccount = await byName('Inventory');

    const [pcs] = await testApp.db.select().from(uoms).where(eq(uoms.code, 'PCS')).limit(1);
    const [kg] = await testApp.db.select().from(uoms).where(eq(uoms.code, 'KG')).limit(1);
    const [exempt] = await testApp.db
      .select()
      .from(taxCodes)
      .where(eq(taxCodes.code, 'exempt'))
      .limit(1);
    pcsUomId = pcs.id;
    kgUomId = kg.id;
    exemptTaxId = exempt.id;

    const methods = await testApp.db.select().from(paymentMethods);
    if (methods.length === 0) {
      const [res] = await testApp.db.insert(paymentMethods).values({
        method_name: 'Cash',
        is_digital: false,
        is_active: true,
        account_id: cashAccount.id,
        created_at: new Date(),
        updated_at: new Date(),
      });
      paymentMethodId = Number((res as { insertId: number }).insertId);
    } else {
      await testApp.db
        .update(paymentMethods)
        .set({ account_id: cashAccount.id, is_active: true })
        .where(eq(paymentMethods.id, methods[0].id));
      paymentMethodId = methods[0].id;
    }

    const vendorRes = await authJson('POST', '/accounting/vendors', {
      name: `IL35 Vendor ${RUN_TAG}`,
    });
    expect(vendorRes.status).toBe(201);
    vendorId = ((await vendorRes.json()) as { id: number }).id;

    pcsItemId = await createItem({
      name: `IL35 Whey ${RUN_TAG}`,
      uom_id: pcsUomId,
      sku: `${SKU_PREFIX}PCS-${RUN_TAG}`,
      sale_rate: '200.00',
      inventory_tracked: true,
    });
    kgItemId = await createItem({
      name: `IL35 Rice ${RUN_TAG}`,
      uom_id: kgUomId,
      sku: `${SKU_PREFIX}KG-${RUN_TAG}`,
      sale_rate: '60.00',
      inventory_tracked: true,
    });
    serviceItemId = await createItem({
      name: `IL35 Freight ${RUN_TAG}`,
      item_kind: 'service',
      uom_id: pcsUomId,
      sku: `${SKU_PREFIX}SVC-${RUN_TAG}`,
      sale_rate: '30.00',
      inventory_tracked: false,
    });
  }, 60_000);

  afterAll(async () => {
    if (testApp?.db) await cleanup();
    if (testApp?.app) await testApp.app.close();
  });

  it('two bills then a sale: weighted-average cost and COGS, journals balance', async () => {
    const billA = await postBillOk([{ item_id: pcsItemId, quantity: '10', rate: '100.00' }]);
    expect(billA.lines[0]).toMatchObject({
      item_name: `IL35 Whey ${RUN_TAG}`,
      uom_code: 'PCS',
      inventory_tracked: true,
      returned_quantity: '0.000',
      account_id: inventoryAccount.id,
    });
    await expectBalanced(billA.journal_entry_id);
    expect(await debitTo(billA.journal_entry_id!, inventoryAccount.id)).toBe(toCents('1000.00'));
    expect(await stockOf(pcsItemId)).toEqual({ qty: '10.000', value: '1000.00' });

    const billB = await postBillOk([{ item_id: pcsItemId, quantity: '5', rate: '130.00' }]);
    await expectBalanced(billB.journal_entry_id);
    expect(await stockOf(pcsItemId)).toEqual({ qty: '15.000', value: '1650.00' });

    // Average cost is 1650 / 15 = 110, so two units cost 220.
    const saleRes = await authJson(
      'POST',
      '/inventory/sales',
      {
        sale_date: BILL_DATE,
        lines: [{ item_id: pcsItemId, quantity: '2' }],
        tenders: [{ payment_method_id: paymentMethodId, amount: '400.00' }],
      },
      { 'Idempotency-Key': `il35-sale-${RUN_TAG}` },
    );
    if (saleRes.status !== 201) console.error('POST /inventory/sales failed:', await saleRes.text());
    expect(saleRes.status).toBe(201);
    const sale = (await saleRes.json()) as {
      cogs_amount: string;
      journal_entry_id: number;
      lines: Array<{ unit_cost: string | null; cost_amount: string | null }>;
    };
    expect(sale.cogs_amount).toBe('220.00');
    expect(sale.lines[0]).toMatchObject({ unit_cost: '110.0000', cost_amount: '220.00' });
    await expectBalanced(sale.journal_entry_id);
    expect(await stockOf(pcsItemId)).toEqual({ qty: '13.000', value: '1430.00' });
  });

  it('mixed bill: only the tracked line reaches Inventory and stock', async () => {
    const before = await stockOf(pcsItemId);
    const bill = await postBillOk([
      { item_id: pcsItemId, quantity: '1', rate: '50.00' },
      { item_id: serviceItemId, quantity: '1', rate: '30.00' },
    ]);
    await expectBalanced(bill.journal_entry_id);
    expect(await debitTo(bill.journal_entry_id!, inventoryAccount.id)).toBe(toCents('50.00'));
    expect(await debitTo(bill.journal_entry_id!, expenseAccount.id)).toBe(toCents('30.00'));

    expect(await stockOf(pcsItemId)).toEqual({
      qty: (Number(before!.qty) + 1).toFixed(3),
      value: (Number(before!.value) + 50).toFixed(2),
    });
    expect(bill.lines.map((l) => l.inventory_tracked)).toEqual([true, false]);
    expect(await stockOf(serviceItemId)).toBeNull();
  });

  it('UOM decimals: 3dp on KG works, a fractional PCS quantity is refused', async () => {
    const bill = await postBillOk([{ item_id: kgItemId, quantity: '2.500', rate: '40.00' }]);
    await expectBalanced(bill.journal_entry_id);
    expect(await stockOf(kgItemId)).toEqual({ qty: '2.500', value: '100.00' });

    const before = await stockOf(pcsItemId);
    const bad = await postBill([{ item_id: pcsItemId, quantity: '1.5', rate: '10.00' }]);
    expect(bad.status).toBe(422);
    expect(await stockOf(pcsItemId)).toEqual(before);
  });

  it('replay with the same Idempotency-Key and a duplicate supplier invoice receive nothing twice', async () => {
    const key = `il35-replay-${RUN_TAG}`;
    const invoice = invoiceNo();
    const lines = [{ item_id: kgItemId, quantity: '1', rate: '40.00' }];
    const first = await postBillOk(lines, { key, invoice });
    const afterFirst = await stockOf(kgItemId);

    const replay = await postBill(lines, { key, invoice });
    expect(replay.status).toBe(201);
    expect(((await replay.json()) as BillBody).id).toBe(first.id);
    expect(await stockOf(kgItemId)).toEqual(afterFirst);

    const duplicate = await postBill(lines, { invoice });
    expect(duplicate.status).toBe(422);
    expect(await stockOf(kgItemId)).toEqual(afterFirst);
  });

  it('a locked period rolls back journal and stock', async () => {
    const periodsRes = await authJson('GET', '/accounting/periods');
    expect(periodsRes.status).toBe(200);
    const periods = (await periodsRes.json()) as Array<{
      id: number;
      starts_on: string;
      ends_on: string;
      status: string;
    }>;
    const period = periods.find((p) => p.starts_on <= LOCKED_DATE && LOCKED_DATE <= p.ends_on);
    expect(period).toBeDefined();

    const lockRes = await authJson('POST', `/accounting/periods/${period!.id}/lock`);
    expect(lockRes.status).toBe(200);
    try {
      const before = await stockOf(kgItemId);
      const invoice = invoiceNo();
      const res = await postBill([{ item_id: kgItemId, quantity: '1', rate: '40.00' }], {
        date: LOCKED_DATE,
        invoice,
      });
      expect(res.status).toBe(422);
      expect(await stockOf(kgItemId)).toEqual(before);

      const leftovers = await testApp.db
        .select({ id: purchaseBills.id })
        .from(purchaseBills)
        .where(eq(purchaseBills.supplier_invoice_no, invoice));
      expect(leftovers).toHaveLength(0);
    } finally {
      const unlock = await authJson('POST', `/accounting/periods/${period!.id}/unlock`);
      expect(unlock.status).toBe(200);
    }
  });

  it('debit-note guard: service-only bills take one, a tracked bill gives 422', async () => {
    const serviceBill = await postBillOk([{ item_id: serviceItemId, quantity: '1', rate: '30.00' }]);
    const ok = await authJson('POST', '/accounting/debit-notes', {
      purchase_bill_id: serviceBill.id,
      debit_note_date: BILL_DATE,
      amount: '10.00',
    });
    if (ok.status !== 201) console.error('service debit note failed:', await ok.text());
    expect(ok.status).toBe(201);

    const trackedBill = await postBillOk([{ item_id: pcsItemId, quantity: '1', rate: '50.00' }]);
    const refused = await authJson('POST', '/accounting/debit-notes', {
      purchase_bill_id: trackedBill.id,
      debit_note_date: BILL_DATE,
      amount: '10.00',
    });
    expect(refused.status).toBe(422);
    const body = (await refused.json()) as { details?: Array<{ rule?: string }> };
    expect(body.details?.some((d) => d.rule === 'debit_note_tracked_deferred')).toBe(true);
  });
});
