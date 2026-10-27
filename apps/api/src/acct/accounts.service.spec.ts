import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import {
  BusinessRuleError,
  ConflictError,
  NotFoundError,
} from '../platform/errors/app-error';
import type { PaginationHelper } from '../platform/http/pagination';
import type { Account } from '../platform/db/schema/accounting';
import type { AccountsRepository } from './accounts.repository';
import { AccountsService } from './accounts.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const SAMPLE_ACCOUNT: Account = {
  id: 10,
  name: 'Rent',
  account_type: 'expense',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: false,
  control_role: null,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const CONTROL_ACCOUNT: Account = {
  id: 3,
  name: 'Accounts receivable',
  account_type: 'asset',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: true,
  control_role: 'ar',
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

describe('AccountsService', () => {
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };
  let service: AccountsService;

  beforeEach(() => {
    repository = {
      findByName: vi.fn(),
      findById: vi.fn(),
      findByIds: vi.fn(),
      insertAccount: vi.fn(),
      updateAccount: vi.fn(),
      findMany: vi.fn(),
    };
    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ limit: 20, offset: 0 }),
    };
    service = new AccountsService(
      repository as unknown as AccountsRepository,
      paginationHelper as unknown as PaginationHelper,
    );
  });

  describe('list', () => {
    it('returns paginated account list with normalized filters', async () => {
      repository.findMany.mockResolvedValue({
        rows: [SAMPLE_ACCOUNT],
        total: 1,
      });

      const result = await service.list(
        { account_type: 'expense', is_active: 'true', search: 'Rent' },
        ADMIN_USER,
      );

      expect(repository.findMany).toHaveBeenCalledWith({
        accountType: 'expense',
        isActive: true,
        search: 'Rent',
        limit: 20,
        offset: 0,
      });
      expect(result.data).toHaveLength(1);
      expect(result.data[0]).toMatchObject({
        id: 10,
        name: 'Rent',
        account_type: 'expense',
      });
      expect(result.data[0]).not.toHaveProperty('code');
      expect(result.meta.total).toBe(1);
    });
  });

  describe('getById', () => {
    it('returns an account DTO when account exists', async () => {
      repository.findById.mockResolvedValue(SAMPLE_ACCOUNT);

      const result = await service.getById(10, ADMIN_USER);

      expect(repository.findById).toHaveBeenCalledWith(10);
      expect(result.id).toBe(10);
      expect(result.name).toBe('Rent');
      expect(result).not.toHaveProperty('code');
    });

    it('throws NotFoundError when account does not exist', async () => {
      repository.findById.mockResolvedValue(null);

      await expect(service.getById(999, ADMIN_USER)).rejects.toBeInstanceOf(
        NotFoundError,
      );
    });
  });

  describe('create', () => {
    it('creates a new account successfully', async () => {
      repository.findByName.mockResolvedValue(null);
      repository.insertAccount.mockResolvedValue({
        ...SAMPLE_ACCOUNT,
        id: 11,
        name: 'Office Rent',
      });

      const result = await service.create(
        {
          name: 'Office Rent',
          account_type: 'expense',
          is_active: true,
          is_bank: false,
          is_control: false,
        },
        ADMIN_USER,
      );

      expect(repository.findByName).toHaveBeenCalledWith('Office Rent');
      expect(repository.insertAccount).toHaveBeenCalledWith(
        expect.objectContaining({
          name: 'Office Rent',
          account_type: 'expense',
          is_active: true,
          is_bank: false,
          is_control: false,
        }),
      );
      expect(result.id).toBe(11);
      expect(result.name).toBe('Office Rent');
      expect(result).not.toHaveProperty('code');
    });

    it('throws ConflictError when account name already exists', async () => {
      repository.findByName.mockResolvedValue(SAMPLE_ACCOUNT);

      await expect(
        service.create(
          {
            name: 'Rent',
            account_type: 'expense',
            is_active: true,
            is_bank: false,
            is_control: false,
          },
          ADMIN_USER,
        ),
      ).rejects.toBeInstanceOf(ConflictError);
    });

    it('validates parent_id exists when provided on create', async () => {
      repository.findByName.mockResolvedValue(null);
      repository.findById.mockResolvedValue(null);

      await expect(
        service.create(
          {
            name: 'Sub-rent',
            account_type: 'expense',
            parent_id: 999,
            is_active: true,
            is_bank: false,
            is_control: false,
          },
          ADMIN_USER,
        ),
      ).rejects.toBeInstanceOf(NotFoundError);
      expect(repository.findById).toHaveBeenCalledWith(999);
    });
  });

  describe('update', () => {
    it('updates allowed account fields successfully', async () => {
      repository.findById.mockResolvedValue(SAMPLE_ACCOUNT);
      repository.findByName.mockResolvedValue(null);
      repository.updateAccount.mockResolvedValue({
        ...SAMPLE_ACCOUNT,
        name: 'Updated Rent',
      });

      const result = await service.update(
        10,
        { name: 'Updated Rent' },
        ADMIN_USER,
      );

      expect(repository.updateAccount).toHaveBeenCalledWith(
        10,
        expect.objectContaining({ name: 'Updated Rent' }),
      );
      expect(result.name).toBe('Updated Rent');
    });

    it('throws NotFoundError when account does not exist on update', async () => {
      repository.findById.mockResolvedValue(null);

      await expect(
        service.update(999, { name: 'Does not exist' }, ADMIN_USER),
      ).rejects.toBeInstanceOf(NotFoundError);
    });

    it('rejects setting account as its own parent', async () => {
      repository.findById.mockResolvedValue(SAMPLE_ACCOUNT);

      await expect(
        service.update(10, { parent_id: 10 }, ADMIN_USER),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        message: 'Account cannot be its own parent',
      });
    });

    it('rejects setting a non-existent parent_id on update', async () => {
      repository.findById.mockImplementation(async (id: number) => {
        if (id === 10) return SAMPLE_ACCOUNT;
        return null;
      });

      await expect(
        service.update(10, { parent_id: 999 }, ADMIN_USER),
      ).rejects.toBeInstanceOf(NotFoundError);
    });

    it('allows deactivating a non-control account', async () => {
      repository.findById.mockResolvedValue(SAMPLE_ACCOUNT);
      repository.updateAccount.mockResolvedValue({
        ...SAMPLE_ACCOUNT,
        is_active: false,
      });

      const result = await service.update(10, { is_active: false }, ADMIN_USER);

      expect(result.is_active).toBe(false);
      expect(repository.updateAccount).toHaveBeenCalledWith(
        10,
        expect.objectContaining({ is_active: false }),
      );
    });

    it('CRITICAL RULE: rejects deactivating an account when is_control is true', async () => {
      const customControl: Account = {
        ...SAMPLE_ACCOUNT,
        id: 20,
        is_control: true,
        control_role: null,
      };
      repository.findById.mockResolvedValue(customControl);

      await expect(
        service.update(20, { is_active: false }, ADMIN_USER),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        message: 'Control accounts used by the system cannot be deactivated',
      });
      expect(repository.updateAccount).not.toHaveBeenCalled();
    });

    it('CRITICAL RULE: rejects deactivating an account when control_role is set', async () => {
      const roleAccount: Account = {
        ...SAMPLE_ACCOUNT,
        id: 21,
        is_control: false,
        control_role: 'discounts',
      };
      repository.findById.mockResolvedValue(roleAccount);

      await expect(
        service.update(21, { is_active: false }, ADMIN_USER),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        message: 'Control accounts used by the system cannot be deactivated',
      });
      expect(repository.updateAccount).not.toHaveBeenCalled();
    });

    it('allows updating name or is_active: true on control account', async () => {
      repository.findById.mockResolvedValue(CONTROL_ACCOUNT);
      repository.findByName.mockResolvedValue(null);
      repository.updateAccount.mockResolvedValue({
        ...CONTROL_ACCOUNT,
        name: 'Trade Receivables',
        is_active: true,
      });

      const result = await service.update(
        3,
        { name: 'Trade Receivables', is_active: true },
        ADMIN_USER,
      );

      expect(result.name).toBe('Trade Receivables');
      expect(repository.updateAccount).toHaveBeenCalled();
    });

    it('throws ConflictError when renaming to an existing name', async () => {
      repository.findById.mockResolvedValue(SAMPLE_ACCOUNT);
      repository.findByName.mockResolvedValue({
        ...SAMPLE_ACCOUNT,
        id: 99,
        name: 'Utilities',
      });

      await expect(
        service.update(10, { name: 'Utilities' }, ADMIN_USER),
      ).rejects.toBeInstanceOf(ConflictError);
    });
  });
});
