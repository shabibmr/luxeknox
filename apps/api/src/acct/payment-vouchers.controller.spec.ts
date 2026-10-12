import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { PaymentVouchersController } from './payment-vouchers.controller';
import {
  paymentVoucherCreateSchema,
  paymentVoucherUpdateSchema,
  type PaymentVoucherDto,
} from './payment-vouchers.dto';
import { PaymentVouchersService } from './payment-vouchers.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const PAYMENT_VOUCHER: PaymentVoucherDto = {
  id: 1,
  voucher_number: 'PV00000001',
  payment_date: '2026-04-15',
  bank_account_id: 101,
  total_amount: '200.00',
  memo: 'Vendor payment',
  status: 'draft',
  journal_entry_id: null,
  row_version: 1,
  created_at: new Date('2026-04-15T10:00:00.000Z'),
  updated_at: null,
  allocations: [
    {
      id: 1,
      payment_voucher_id: 1,
      purchase_bill_id: 1,
      expense_voucher_id: null,
      amount: '200.00',
    },
  ],
};

describe('PaymentVouchersController', () => {
  let service: Partial<PaymentVouchersService>;
  let controller: PaymentVouchersController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({ data: [PAYMENT_VOUCHER], meta: { total: 1, limit: 20, offset: 0 } }),
      getById: vi.fn().mockResolvedValue(PAYMENT_VOUCHER),
      create: vi.fn().mockResolvedValue(PAYMENT_VOUCHER),
      update: vi.fn().mockResolvedValue({ ...PAYMENT_VOUCHER, memo: 'Updated' }),
      post: vi.fn().mockResolvedValue({ ...PAYMENT_VOUCHER, status: 'posted', journal_entry_id: 99 }),
    };
    controller = new PaymentVouchersController(service as PaymentVouchersService);
  });

  it('requires accounting.read on GET /accounting/payment-vouchers and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, PaymentVouchersController.prototype.list),
    ).toEqual(['accounting.read']);

    const query = { status: 'draft' };
    const result = await controller.list(query, ADMIN_USER);

    expect(service.list).toHaveBeenCalledWith(query, ADMIN_USER);
    expect(result.data).toEqual([PAYMENT_VOUCHER]);
  });

  it('requires accounting.payments_write on POST /accounting/payment-vouchers and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, PaymentVouchersController.prototype.create),
    ).toEqual(['accounting.payments_write']);

    const dto = {
      payment_date: '2026-04-15',
      bank_account_id: 101,
      total_amount: '200.00',
      memo: 'Vendor payment',
      allocations: [
        {
          purchase_bill_id: 1,
          amount: '200.00',
        },
      ],
    };
    const result = await controller.create(dto, ADMIN_USER);

    expect(service.create).toHaveBeenCalledWith(dto, ADMIN_USER);
    expect(result).toEqual(PAYMENT_VOUCHER);
  });

  it('requires accounting.read on GET /accounting/payment-vouchers/:id and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, PaymentVouchersController.prototype.getById),
    ).toEqual(['accounting.read']);

    const result = await controller.getById(1, ADMIN_USER);

    expect(service.getById).toHaveBeenCalledWith(1, ADMIN_USER);
    expect(result).toEqual(PAYMENT_VOUCHER);
  });

  it('requires accounting.payments_write on PATCH /accounting/payment-vouchers/:id and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, PaymentVouchersController.prototype.update),
    ).toEqual(['accounting.payments_write']);

    const dto = { memo: 'Updated' };
    const result = await controller.update(1, dto, ADMIN_USER);

    expect(service.update).toHaveBeenCalledWith(1, dto, ADMIN_USER);
    expect(result.memo).toBe('Updated');
  });

  it('requires accounting.payments_write on POST /accounting/payment-vouchers/:id/post and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, PaymentVouchersController.prototype.post),
    ).toEqual(['accounting.payments_write']);

    const result = await controller.post(1, ADMIN_USER);

    expect(service.post).toHaveBeenCalledWith(1, ADMIN_USER);
    expect(result.status).toBe('posted');
    expect(result.journal_entry_id).toBe(99);
  });

  describe('Zod Validation Pipes', () => {
    it('rejects create body if sum of allocations does not match total_amount', () => {
      const pipe = new ZodValidationPipe(paymentVoucherCreateSchema);

      expect(() =>
        pipe.transform(
          {
            payment_date: '2026-04-15',
            bank_account_id: 101,
            total_amount: '250.00',
            allocations: [{ purchase_bill_id: 1, amount: '200.00' }],
          },
          { type: 'body' } as never,
        ),
      ).toThrow();
    });

    it('rejects create body if allocation has neither or both bill and expense', () => {
      const pipe = new ZodValidationPipe(paymentVoucherCreateSchema);

      expect(() =>
        pipe.transform(
          {
            payment_date: '2026-04-15',
            bank_account_id: 101,
            total_amount: '200.00',
            allocations: [
              {
                purchase_bill_id: 1,
                expense_voucher_id: 2,
                amount: '200.00',
              },
            ],
          },
          { type: 'body' } as never,
        ),
      ).toThrow();
    });

    it('accepts valid create body', () => {
      const pipe = new ZodValidationPipe(paymentVoucherCreateSchema);

      const parsed = pipe.transform(
        {
          payment_date: '2026-04-15',
          bank_account_id: 101,
          total_amount: '200.00',
          allocations: [{ purchase_bill_id: 1, amount: '200.00' }],
        },
        { type: 'body' } as never,
      );

      expect(parsed.total_amount).toBe('200.00');
    });

    it('rejects update body if both total_amount and allocations are provided but do not match', () => {
      const pipe = new ZodValidationPipe(paymentVoucherUpdateSchema);

      expect(() =>
        pipe.transform(
          {
            total_amount: '300.00',
            allocations: [{ purchase_bill_id: 1, amount: '200.00' }],
          },
          { type: 'body' } as never,
        ),
      ).toThrow();
    });
  });
});
