import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { PurchaseBillsController } from './purchase-bills.controller';
import type { PurchaseBillCreateDto, PurchaseBillDto } from './purchase-bills.dto';
import { PurchaseBillsService } from './purchase-bills.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const SAMPLE_BILL_DTO: PurchaseBillDto = {
  id: 10,
  bill_number: 'BIL00000010',
  vendor_id: 1,
  bill_date: '2026-04-15',
  due_date: '2026-04-30',
  status: 'posted',
  subtotal: '100.00',
  tax_amount: '18.00',
  total_amount: '118.00',
  journal_entry_id: 100,
  row_version: 2,
  created_at: new Date('2026-04-15T10:00:00.000Z'),
  updated_at: null,
  lines: [
    {
      id: 1,
      purchase_bill_id: 10,
      item_id: null,
      account_id: 50,
      description: 'Equipment repair',
      quantity: '1.00',
      rate: '100.00',
      tax_code_id: 5,
      net_amount: '100.00',
      tax_amount: '18.00',
    },
  ],
};

describe('PurchaseBillsController', () => {
  let service: Partial<PurchaseBillsService>;
  let controller: PurchaseBillsController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({
        data: [SAMPLE_BILL_DTO],
        meta: { limit: 20, offset: 0, cursor: null, next_cursor: null, has_more: false, total: 1 },
      }),
      getById: vi.fn().mockResolvedValue(SAMPLE_BILL_DTO),
      create: vi.fn().mockResolvedValue(SAMPLE_BILL_DTO),
    };
    controller = new PurchaseBillsController(service as PurchaseBillsService);
  });

  it('declares accounting.read on list', () => {
    const meta = Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, PurchaseBillsController.prototype.list);
    expect(meta).toEqual(['accounting.read']);
  });

  it('declares accounting.purchases_write on create', () => {
    const meta = Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, PurchaseBillsController.prototype.create);
    expect(meta).toEqual(['accounting.purchases_write']);
  });

  it('declares accounting.read on getById', () => {
    const meta = Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, PurchaseBillsController.prototype.getById);
    expect(meta).toEqual(['accounting.read']);
  });

  it('delegates list to service.list', async () => {
    const res = await controller.list({ status: 'posted' }, ADMIN_USER);
    expect(service.list).toHaveBeenCalledWith({ status: 'posted' }, ADMIN_USER);
    expect(res.data).toHaveLength(1);
  });

  it('delegates getById to service.getById', async () => {
    const res = await controller.getById(10, ADMIN_USER);
    expect(service.getById).toHaveBeenCalledWith(10, ADMIN_USER);
    expect(res.id).toBe(10);
  });

  it('delegates create to service.create', async () => {
    const dto: PurchaseBillCreateDto = {
      vendor_id: 1,
      bill_date: '2026-04-15',
      lines: [
        {
          account_id: 50,
          quantity: '1.00',
          rate: '100.00',
        },
      ],
    };
    const res = await controller.create(dto, ADMIN_USER);
    expect(service.create).toHaveBeenCalledWith(dto, ADMIN_USER);
    expect(res.bill_number).toBe('BIL00000010');
  });

  it('has no separate update or post routes', () => {
    expect((PurchaseBillsController.prototype as unknown as Record<string, unknown>).update).toBeUndefined();
    expect((PurchaseBillsController.prototype as unknown as Record<string, unknown>).post).toBeUndefined();
  });
});
