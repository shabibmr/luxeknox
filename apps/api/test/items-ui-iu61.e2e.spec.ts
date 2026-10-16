import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { eq, like } from 'drizzle-orm';
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
  taxCodes,
  uoms,
  type Account,
} from '../src/platform/db/schema/accounting';
import { stockMovements } from '../src/platform/db/schema/inventory';

/**
 * IU-61 real-data pass against a localhost Nest app + MySQL (createTestApp).
 * Covers: create service + tracked goods, search by SKU, detail, edit rate,
 * and has_movements after a stock movement exists.
 *
 * UOM/tracking lock with has_movements is enforced in the Flutter form
 * (IU-51); INV-032 will add API field_frozen later.
 */
const RUN_TAG = `${Date.now()}`.slice(-8);
const SERVICE_SKU = `IU61-SVC-${RUN_TAG}`;
const GOODS_SKU = `IU61-GDS-${RUN_TAG}`;

describe('Items UI IU-61 real-data pass', () => {
  let testApp: TestAppInstance;
  let adminToken: string;
  let incomeAccount: Account;
  let expenseAccount: Account;
  let pcsUomId: number;
  let kgUomId: number;
  let exemptTaxId: number;
  let serviceItemId: number;
  let goodsItemId: number;

  async function authJson(
    method: string,
    path: string,
    body?: unknown,
  ): Promise<Response> {
    const headers: Record<string, string> = {
      Authorization: `Bearer ${adminToken}`,
    };
    if (body !== undefined) headers['Content-Type'] = 'application/json';
    return fetch(`${testApp.baseUrl}${path}`, {
      method,
      headers,
      body: body === undefined ? undefined : JSON.stringify(body),
    });
  }

  async function cleanup(): Promise<void> {
    const tagged = await testApp.db
      .select({ id: items.id })
      .from(items)
      .where(like(items.sku, 'IU61-%'));
    const ids = tagged.map((r) => r.id);
    if (ids.length === 0) return;
    for (const id of ids) {
      await testApp.db.delete(stockMovements).where(eq(stockMovements.item_id, id));
      await testApp.db.delete(items).where(eq(items.id, id));
    }
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

    const [income] = await testApp.db
      .select()
      .from(accounts)
      .where(eq(accounts.name, 'Merchandise sales'))
      .limit(1);
    const [expense] = await testApp.db
      .select()
      .from(accounts)
      .where(eq(accounts.name, 'Rent'))
      .limit(1);
    expect(income).toBeDefined();
    expect(expense).toBeDefined();
    incomeAccount = income!;
    expenseAccount = expense!;

    const [pcs] = await testApp.db.select().from(uoms).where(eq(uoms.code, 'PCS')).limit(1);
    const [kg] = await testApp.db.select().from(uoms).where(eq(uoms.code, 'KG')).limit(1);
    expect(pcs).toBeDefined();
    expect(kg).toBeDefined();
    pcsUomId = pcs!.id;
    kgUomId = kg!.id;

    const [exempt] = await testApp.db
      .select()
      .from(taxCodes)
      .where(eq(taxCodes.code, 'exempt'))
      .limit(1);
    expect(exempt).toBeDefined();
    exemptTaxId = exempt!.id;

    // Confirm catalog reads used by the form exist on this app.
    const uomsRes = await authJson('GET', '/inventory/uoms');
    expect(uomsRes.status).toBe(200);
    const catsRes = await authJson('GET', '/inventory/item-categories');
    expect(catsRes.status).toBe(200);
  }, 60_000);

  afterAll(async () => {
    if (testApp?.db) await cleanup();
    if (testApp?.app) await testApp.app.close();
  });

  it('creates a service item', async () => {
    const res = await authJson('POST', '/accounting/items', {
      name: `IU61 PT Session ${RUN_TAG}`,
      item_kind: 'service',
      uom_id: pcsUomId,
      income_account_id: incomeAccount.id,
      expense_account_id: expenseAccount.id,
      sku: SERVICE_SKU,
      sale_rate: '1500.00',
      tax_code_id: exemptTaxId,
      inventory_tracked: false,
    });
    if (res.status !== 201) console.error(await res.text());
    expect(res.status).toBe(201);
    const item = (await res.json()) as {
      id: number;
      item_kind: string;
      inventory_tracked: boolean;
    };
    expect(item.item_kind).toBe('service');
    expect(item.inventory_tracked).toBe(false);
    serviceItemId = item.id;
  });

  it('creates a tracked goods item', async () => {
    const res = await authJson('POST', '/accounting/items', {
      name: `IU61 Whey ${RUN_TAG}`,
      item_kind: 'goods',
      uom_id: pcsUomId,
      income_account_id: incomeAccount.id,
      expense_account_id: expenseAccount.id,
      sku: GOODS_SKU,
      sale_rate: '100.00',
      purchase_rate: '70.00',
      tax_code_id: exemptTaxId,
      inventory_tracked: true,
    });
    if (res.status !== 201) console.error(await res.text());
    expect(res.status).toBe(201);
    const item = (await res.json()) as {
      id: number;
      inventory_tracked: boolean;
      inventory_account_id: number | null;
      cogs_account_id: number | null;
    };
    expect(item.inventory_tracked).toBe(true);
    expect(item.inventory_account_id).not.toBeNull();
    expect(item.cogs_account_id).not.toBeNull();
    goodsItemId = item.id;
  });

  it('searches by SKU and opens detail', async () => {
    const listRes = await authJson(
      'GET',
      `/inventory/items?search=${encodeURIComponent(GOODS_SKU)}`,
    );
    expect(listRes.status).toBe(200);
    const page = (await listRes.json()) as {
      data: Array<{ id: number; sku: string | null; has_movements: boolean }>;
    };
    const found = page.data.find((r) => r.id === goodsItemId);
    expect(found).toBeDefined();
    expect(found!.sku).toBe(GOODS_SKU);
    expect(found!.has_movements).toBe(false);

    const getRes = await authJson('GET', `/inventory/items/${goodsItemId}`);
    expect(getRes.status).toBe(200);
    const detail = (await getRes.json()) as {
      id: number;
      sku: string;
      sale_rate: string;
      uom_code: string;
      has_movements: boolean;
    };
    expect(detail.id).toBe(goodsItemId);
    expect(detail.sku).toBe(GOODS_SKU);
    expect(detail.sale_rate).toBe('100.00');
    expect(detail.uom_code).toBe('PCS');
    expect(detail.has_movements).toBe(false);
  });

  it('edits the sale rate', async () => {
    const res = await authJson('PATCH', `/accounting/items/${goodsItemId}`, {
      sale_rate: '125.50',
    });
    if (res.status !== 200) console.error(await res.text());
    expect(res.status).toBe(200);
    const updated = (await res.json()) as { sale_rate: string };
    expect(updated.sale_rate).toBe('125.50');

    const getRes = await authJson('GET', `/inventory/items/${goodsItemId}`);
    expect(getRes.status).toBe(200);
    const detail = (await getRes.json()) as { sale_rate: string };
    expect(detail.sale_rate).toBe('125.50');
  });

  it('has_movements becomes true after a stock movement (UI lock signal)', async () => {
    await testApp.db.insert(stockMovements).values({
      item_id: goodsItemId,
      movement_date: '2026-10-16',
      source_type: 'stock_adjustment',
      source_id: 1,
      qty_in: '1.000',
      qty_out: '0.000',
      unit_cost: '70.0000',
      value: '70.00',
      balance_qty: '1.000',
      balance_value: '70.00',
      created_at: new Date(),
    });

    const getRes = await authJson('GET', `/inventory/items/${goodsItemId}`);
    expect(getRes.status).toBe(200);
    const detail = (await getRes.json()) as {
      has_movements: boolean;
      uom_id: number;
      inventory_tracked: boolean;
    };
    expect(detail.has_movements).toBe(true);
    expect(detail.inventory_tracked).toBe(true);
    expect(detail.uom_id).toBe(pcsUomId);

    // API still allows PATCH today; Flutter form locks UOM/tracking (IU-51).
    // Confirm a rate edit still works so business-rule errors stay clear elsewhere.
    const rateRes = await authJson('PATCH', `/accounting/items/${goodsItemId}`, {
      sale_rate: '130.00',
    });
    expect(rateRes.status).toBe(200);

    // Changing UOM while movements exist succeeds on API (deferred INV-032).
    const uomRes = await authJson('PATCH', `/accounting/items/${goodsItemId}`, {
      uom_id: kgUomId,
    });
    expect(uomRes.status).toBe(200);

    // Restore PCS so cleanup stays consistent with PCS-coded expectations.
    await authJson('PATCH', `/accounting/items/${goodsItemId}`, {
      uom_id: pcsUomId,
    });
  });

  it('rejects tracked service with a clear business_rule message', async () => {
    const res = await authJson('POST', '/accounting/items', {
      name: `IU61 Bad Tracked Service ${RUN_TAG}`,
      item_kind: 'service',
      uom_id: pcsUomId,
      income_account_id: incomeAccount.id,
      expense_account_id: expenseAccount.id,
      sku: `IU61-BAD-${RUN_TAG}`,
      inventory_tracked: true,
    });
    expect(res.status).toBe(422);
    const body = (await res.json()) as { message: string; code?: string };
    expect(body.message.toLowerCase()).toMatch(/tracked|goods|item_kind/);
  });
});
