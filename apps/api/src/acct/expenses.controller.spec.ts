import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { ExpensesController } from './expenses.controller';
import type { ExpenseCreateDto, ExpenseUpdateDto, ExpenseVoucherDto } from './expenses.dto';
import { ExpensesService } from './expenses.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const SAMPLE_VOUCHER_DTO: ExpenseVoucherDto = {
  id: 10,
  expense_number: 'EXP00000010',
  vendor_id: null,
  payee_name: 'Store',
  expense_date: '2026-04-15',
  paid_from_account_id: 1,
  status: 'draft',
  subtotal: '100.00',
  tax_amount: '18.00',
  total_amount: '118.00',
  journal_entry_id: null,
  row_version: 1,
  created_at: new Date('2026-04-15T10:00:00.000Z'),
  updated_at: null,
  lines: [
    {
      id: 1,
      expense_voucher_id: 10,
      account_id: 50,
      description: 'Office stuff',
      amount: '100.00',
      tax_code_id: 5,
      tax_amount: '18.00',
    },
  ],
};

describe('ExpensesController', () => {
  let service: Partial<ExpensesService>;
  let controller: ExpensesController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({
        data: [SAMPLE_VOUCHER_DTO],
        meta: { limit: 20, offset: 0, cursor: null, next_cursor: null, has_more: false, total: 1 },
      }),
      getById: vi.fn().mockResolvedValue(SAMPLE_VOUCHER_DTO),
      create: vi.fn().mockResolvedValue(SAMPLE_VOUCHER_DTO),
      update: vi.fn().mockResolvedValue({ ...SAMPLE_VOUCHER_DTO, payee_name: 'Updated Store' }),
      post: vi.fn().mockResolvedValue({ ...SAMPLE_VOUCHER_DTO, status: 'posted', journal_entry_id: 100 }),
    };
    controller = new ExpensesController(service as ExpensesService);
  });

  describe('permissions and route metadata', () => {
    it('requires accounting.read on GET /accounting/expenses', () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ExpensesController.prototype.list),
      ).toEqual(['accounting.read']);
    });

    it('requires accounting.expenses_write on POST /accounting/expenses', () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ExpensesController.prototype.create),
      ).toEqual(['accounting.expenses_write']);
    });

    it('requires accounting.read on GET /accounting/expenses/:id', () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ExpensesController.prototype.getById),
      ).toEqual(['accounting.read']);
    });

    it('requires accounting.expenses_write on PATCH /accounting/expenses/:id', () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ExpensesController.prototype.update),
      ).toEqual(['accounting.expenses_write']);
    });

    it('requires accounting.expenses_write on POST /accounting/expenses/:id/post', () => {
      expect(
        Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, ExpensesController.prototype.post),
      ).toEqual(['accounting.expenses_write']);
    });
  });

  describe('controller methods', () => {
    it('delegates list to service', async () => {
      const result = await controller.list({ status: 'draft' }, ADMIN_USER);
      expect(service.list).toHaveBeenCalledWith({ status: 'draft' }, ADMIN_USER);
      expect(result.data).toHaveLength(1);
    });

    it('delegates create to service', async () => {
      const dto: ExpenseCreateDto = {
        expense_date: '2026-04-15',
        paid_from_account_id: 1,
        lines: [{ account_id: 50, amount: '100.00' }],
      };
      const result = await controller.create(dto, ADMIN_USER);
      expect(service.create).toHaveBeenCalledWith(dto, ADMIN_USER);
      expect(result.id).toBe(10);
    });

    it('delegates getById to service', async () => {
      const result = await controller.getById(10, ADMIN_USER);
      expect(service.getById).toHaveBeenCalledWith(10, ADMIN_USER);
      expect(result.id).toBe(10);
    });

    it('delegates update to service', async () => {
      const patchDto: ExpenseUpdateDto = { payee_name: 'Updated Store' };
      const result = await controller.update(10, patchDto, ADMIN_USER);
      expect(service.update).toHaveBeenCalledWith(10, patchDto, ADMIN_USER);
      expect(result.payee_name).toBe('Updated Store');
    });

    it('delegates post to service', async () => {
      const result = await controller.post(10, ADMIN_USER);
      expect(service.post).toHaveBeenCalledWith(10, ADMIN_USER);
      expect(result.status).toBe('posted');
    });
  });
});
