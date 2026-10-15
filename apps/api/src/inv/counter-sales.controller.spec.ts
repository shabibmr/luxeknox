import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { IDEMPOTENCY_ENABLED_KEY } from '../platform/idempotency/idempotency.interceptor';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { CounterSalesController } from './counter-sales.controller';
import type { CounterSaleDto, SaleWrite } from './counter-sales.dto';
import { CounterSalesService } from './counter-sales.service';

const ACTOR: AuthenticatedUser = {
  id: 7,
  email: 'cashier@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const SALE: CounterSaleDto = {
  id: 50,
  sale_number: 'SAL-00000001',
  sale_date: '2026-10-16',
  member_id: null,
  member_name: null,
  customer_name: null,
  status: 'posted',
  subtotal: '200.00',
  discount_amount: '0.00',
  tax_amount: '36.00',
  total_amount: '236.00',
  cogs_amount: '0.00',
  lines: [],
  tenders: [],
  returns: [],
  journal_entry_id: 77,
  journal_number: 'JRN00000077',
  row_version: 1,
  created_at: new Date('2026-10-16T08:00:00.000Z'),
};

describe('CounterSalesController', () => {
  let service: {
    create: ReturnType<typeof vi.fn>;
    list: ReturnType<typeof vi.fn>;
    getById: ReturnType<typeof vi.fn>;
  };
  let controller: CounterSalesController;

  beforeEach(() => {
    service = {
      create: vi.fn().mockResolvedValue(SALE),
      list: vi.fn().mockResolvedValue({
        data: [SALE],
        meta: { limit: 20, offset: 0, cursor: null, next_cursor: null, has_more: false, total: 1 },
      }),
      getById: vi.fn().mockResolvedValue(SALE),
    };
    controller = new CounterSalesController(service as unknown as CounterSalesService);
  });

  it('requires inventory.sales_write and idempotency on create', () => {
    expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, CounterSalesController.prototype.create)).toEqual([
      'inventory.sales_write',
    ]);
    expect(Reflect.getMetadata(IDEMPOTENCY_ENABLED_KEY, CounterSalesController.prototype.create)).toBe(true);
  });

  it('returns the posted sale from the service', async () => {
    const dto: SaleWrite = {
      customer_name: null,
      lines: [{ item_id: 10, quantity: '2' }],
      tenders: [{ payment_method_id: 1, amount: '236.00', reference: null }],
    };
    await expect(controller.create(dto, ACTOR)).resolves.toBe(SALE);
    expect(service.create).toHaveBeenCalledWith(dto, ACTOR);
  });

  it('requires inventory.read on list and get', () => {
    expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, CounterSalesController.prototype.list)).toEqual([
      'inventory.read',
    ]);
    expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, CounterSalesController.prototype.getById)).toEqual([
      'inventory.read',
    ]);
  });

  it('delegates list and get to the service', async () => {
    const query = { search: 'SAL-', from: '2026-10-01' };
    await controller.list(query, ACTOR);
    await controller.getById(50, ACTOR);

    expect(service.list).toHaveBeenCalledWith(query, ACTOR);
    expect(service.getById).toHaveBeenCalledWith(50, ACTOR);
  });
});
