import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import type { PaginationHelper } from '../platform/http/pagination';
import type { ItemsRepository } from './items.repository';
import { ItemsService } from './items.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const INCOME_ACCOUNT = {
  id: 4000,
  code: '4000',
  name: 'Membership revenue',
  account_type: 'income',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: false,
  control_role: null,
  created_at: new Date(),
  updated_at: null,
};

const EXPENSE_ACCOUNT = {
  id: 5000,
  code: '5000',
  name: 'Rent',
  account_type: 'expense',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: false,
  control_role: null,
  created_at: new Date(),
  updated_at: null,
};

const TAX_CODE = {
  id: 1,
  name: 'GST 18%',
  code: 'gst_18',
  rate_percent: '18.00',
  is_active: true,
};

const ITEM_ROW = {
  id: 10,
  name: 'Personal Training Session',
  item_kind: 'service' as const,
  inventory_tracked: false,
  income_account_id: 4000,
  expense_account_id: 5000,
  tax_code_id: 1,
  is_active: true,
};

describe('ItemsService', () => {
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };
  let service: ItemsService;

  beforeEach(() => {
    repository = {
      findMany: vi.fn().mockResolvedValue({ rows: [ITEM_ROW], total: 1 }),
      findById: vi.fn().mockResolvedValue(ITEM_ROW),
      insertItem: vi.fn().mockResolvedValue(ITEM_ROW),
      updateItem: vi.fn().mockResolvedValue(ITEM_ROW),
      findAccountById: vi.fn().mockImplementation(async (id: number) => {
        if (id === 4000) return INCOME_ACCOUNT;
        if (id === 5000) return EXPENSE_ACCOUNT;
        return null;
      }),
      findTaxCodeById: vi.fn().mockImplementation(async (id: number) => {
        if (id === 1) return TAX_CODE;
        return null;
      }),
    };
    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ limit: 20, offset: 0 }),
    };
    service = new ItemsService(
      repository as unknown as ItemsRepository,
      paginationHelper as unknown as PaginationHelper,
    );
  });

  describe('list', () => {
    it('returns paginated items with filters applied', async () => {
      const result = await service.list(
        { item_kind: 'service', is_active: 'true', search: 'Training', limit: 20, offset: 0 },
        ADMIN_USER,
      );

      expect(paginationHelper.normalizeParams).toHaveBeenCalledWith({
        item_kind: 'service',
        is_active: 'true',
        search: 'Training',
        limit: 20,
        offset: 0,
      });
      expect(repository.findMany).toHaveBeenCalledWith({
        itemKind: 'service',
        isActive: true,
        search: 'Training',
        limit: 20,
        offset: 0,
      });
      expect(result.data).toHaveLength(1);
      expect(result.data[0]).toMatchObject({
        id: 10,
        name: 'Personal Training Session',
        item_kind: 'service',
        inventory_tracked: false,
        income_account_id: 4000,
        expense_account_id: 5000,
        tax_code_id: 1,
        is_active: true,
      });
    });
  });

  describe('getById', () => {
    it('returns item when found', async () => {
      const result = await service.getById(10, ADMIN_USER);
      expect(result.id).toBe(10);
      expect(result.name).toBe('Personal Training Session');
    });

    it('throws NotFoundError when item does not exist', async () => {
      repository.findById.mockResolvedValue(null);
      await expect(service.getById(999, ADMIN_USER)).rejects.toThrow(NotFoundError);
      await expect(service.getById(999, ADMIN_USER)).rejects.toThrow('Item 999 was not found');
    });
  });

  describe('create', () => {
    it('creates an item with active income and expense accounts', async () => {
      const dto = {
        name: 'Gym Towel',
        item_kind: 'goods' as const,
        income_account_id: 4000,
        expense_account_id: 5000,
        tax_code_id: 1,
        is_active: true,
      };

      const result = await service.create(dto, ADMIN_USER);

      expect(repository.insertItem).toHaveBeenCalledWith({
        name: 'Gym Towel',
        item_kind: 'goods',
        inventory_tracked: false,
        income_account_id: 4000,
        expense_account_id: 5000,
        tax_code_id: 1,
        is_active: true,
      });
      expect(result.id).toBe(10);
    });

    it('rejects inventory_tracked: true with BusinessRuleError', async () => {
      const dto = {
        name: 'Protein Shake',
        item_kind: 'goods' as const,
        income_account_id: 4000,
        expense_account_id: 5000,
        inventory_tracked: true as any,
      };

      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow(BusinessRuleError);
      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow(
        'Inventory tracking is not supported',
      );
    });

    it('throws BusinessRuleError if income account is missing', async () => {
      repository.findAccountById.mockImplementation(async (id: number) => {
        if (id === 5000) return EXPENSE_ACCOUNT;
        return null;
      });

      const dto = {
        name: 'Item',
        item_kind: 'service' as const,
        income_account_id: 9999,
        expense_account_id: 5000,
      };

      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow(BusinessRuleError);
      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow('Income account 9999 does not exist');
    });

    it('throws BusinessRuleError if income account is inactive', async () => {
      repository.findAccountById.mockImplementation(async (id: number) => {
        if (id === 4000) return { ...INCOME_ACCOUNT, is_active: false };
        if (id === 5000) return EXPENSE_ACCOUNT;
        return null;
      });

      const dto = {
        name: 'Item',
        item_kind: 'service' as const,
        income_account_id: 4000,
        expense_account_id: 5000,
      };

      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow(BusinessRuleError);
      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow('Income account 4000 is inactive');
    });

    it('throws BusinessRuleError if income account has wrong account_type', async () => {
      repository.findAccountById.mockImplementation(async (id: number) => {
        if (id === 4000) return { ...INCOME_ACCOUNT, account_type: 'expense' };
        if (id === 5000) return EXPENSE_ACCOUNT;
        return null;
      });

      const dto = {
        name: 'Item',
        item_kind: 'service' as const,
        income_account_id: 4000,
        expense_account_id: 5000,
      };

      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow(BusinessRuleError);
      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow(
        'Account 4000 is not an income account',
      );
    });

    it('throws BusinessRuleError if expense account is missing', async () => {
      repository.findAccountById.mockImplementation(async (id: number) => {
        if (id === 4000) return INCOME_ACCOUNT;
        return null;
      });

      const dto = {
        name: 'Item',
        item_kind: 'service' as const,
        income_account_id: 4000,
        expense_account_id: 9999,
      };

      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow(BusinessRuleError);
      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow('Expense account 9999 does not exist');
    });

    it('throws BusinessRuleError if expense account is inactive', async () => {
      repository.findAccountById.mockImplementation(async (id: number) => {
        if (id === 4000) return INCOME_ACCOUNT;
        if (id === 5000) return { ...EXPENSE_ACCOUNT, is_active: false };
        return null;
      });

      const dto = {
        name: 'Item',
        item_kind: 'service' as const,
        income_account_id: 4000,
        expense_account_id: 5000,
      };

      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow(BusinessRuleError);
      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow('Expense account 5000 is inactive');
    });

    it('throws BusinessRuleError if expense account has wrong account_type', async () => {
      repository.findAccountById.mockImplementation(async (id: number) => {
        if (id === 4000) return INCOME_ACCOUNT;
        if (id === 5000) return { ...EXPENSE_ACCOUNT, account_type: 'income' };
        return null;
      });

      const dto = {
        name: 'Item',
        item_kind: 'service' as const,
        income_account_id: 4000,
        expense_account_id: 5000,
      };

      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow(BusinessRuleError);
      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow(
        'Account 5000 is not an expense account',
      );
    });

    it('throws BusinessRuleError if tax code does not exist', async () => {
      repository.findTaxCodeById.mockResolvedValue(null);

      const dto = {
        name: 'Item',
        item_kind: 'service' as const,
        income_account_id: 4000,
        expense_account_id: 5000,
        tax_code_id: 999,
      };

      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow(BusinessRuleError);
      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow('Tax code 999 does not exist');
    });

    it('throws BusinessRuleError if tax code is inactive', async () => {
      repository.findTaxCodeById.mockResolvedValue({ ...TAX_CODE, is_active: false });

      const dto = {
        name: 'Item',
        item_kind: 'service' as const,
        income_account_id: 4000,
        expense_account_id: 5000,
        tax_code_id: 1,
      };

      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow(BusinessRuleError);
      await expect(service.create(dto, ADMIN_USER)).rejects.toThrow('Tax code 1 is inactive');
    });
  });

  describe('update', () => {
    it('updates item fields successfully', async () => {
      const dto = {
        name: 'Updated Session',
        is_active: false,
      };
      repository.updateItem.mockResolvedValue({
        ...ITEM_ROW,
        name: 'Updated Session',
        is_active: false,
      });

      const result = await service.update(10, dto, ADMIN_USER);

      expect(repository.findById).toHaveBeenCalledWith(10);
      expect(repository.updateItem).toHaveBeenCalledWith(10, {
        name: 'Updated Session',
        is_active: false,
        inventory_tracked: false,
      });
      expect(result.name).toBe('Updated Session');
      expect(result.is_active).toBe(false);
    });

    it('rejects inventory_tracked: true on update', async () => {
      await expect(
        service.update(10, { inventory_tracked: true as any }, ADMIN_USER),
      ).rejects.toThrow(BusinessRuleError);
    });

    it('throws NotFoundError if item does not exist', async () => {
      repository.findById.mockResolvedValue(null);

      await expect(service.update(999, { name: 'Item' }, ADMIN_USER)).rejects.toThrow(
        NotFoundError,
      );
    });

    it('validates income account if updated', async () => {
      repository.findAccountById.mockResolvedValue(null);

      await expect(
        service.update(10, { income_account_id: 9999 }, ADMIN_USER),
      ).rejects.toThrow(BusinessRuleError);
    });

    it('validates expense account if updated', async () => {
      repository.findAccountById.mockResolvedValue(null);

      await expect(
        service.update(10, { expense_account_id: 9999 }, ADMIN_USER),
      ).rejects.toThrow(BusinessRuleError);
    });

    it('validates tax code if updated', async () => {
      repository.findTaxCodeById.mockResolvedValue(null);

      await expect(service.update(10, { tax_code_id: 999 }, ADMIN_USER)).rejects.toThrow(
        BusinessRuleError,
      );
    });

    it('allows clearing tax code with null', async () => {
      repository.updateItem.mockResolvedValue({
        ...ITEM_ROW,
        tax_code_id: null,
      });

      const result = await service.update(10, { tax_code_id: null }, ADMIN_USER);

      expect(repository.updateItem).toHaveBeenCalledWith(10, {
        inventory_tracked: false,
        tax_code_id: null,
      });
      expect(result.tax_code_id).toBeNull();
    });
  });
});
