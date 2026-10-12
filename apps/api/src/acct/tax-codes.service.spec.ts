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
import type { TaxCodesRepository, TaxCodeWithComponents } from './tax-codes.repository';
import { TaxCodesService } from './tax-codes.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const CGST_ACCOUNT: Account = {
  id: 2100,
  code: '2100',
  name: 'Output CGST',
  account_type: 'liability',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: true,
  control_role: 'output_cgst',
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const SGST_ACCOUNT: Account = {
  id: 2110,
  code: '2110',
  name: 'Output SGST',
  account_type: 'liability',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: true,
  control_role: 'output_sgst',
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const INPUT_TAX_ACCOUNT: Account = {
  id: 1300,
  code: '1300',
  name: 'Input tax',
  account_type: 'asset',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: true,
  control_role: 'input_tax',
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

const SAMPLE_TAX_CODE: TaxCodeWithComponents = {
  id: 2,
  name: 'GST 18%',
  code: 'gst_18',
  rate_percent: '18.00',
  is_active: true,
  components: [
    {
      id: 1,
      tax_code_id: 2,
      name: 'CGST',
      rate_percent: '9.00',
      output_account_id: 2100,
      input_account_id: 1300,
    },
    {
      id: 2,
      tax_code_id: 2,
      name: 'SGST',
      rate_percent: '9.00',
      output_account_id: 2110,
      input_account_id: 1300,
    },
  ],
};

describe('TaxCodesService', () => {
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let accountsRepository: Record<string, ReturnType<typeof vi.fn>>;
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };
  let service: TaxCodesService;
  const mockDb = {} as any;

  beforeEach(() => {
    repository = {
      findByCode: vi.fn(),
      findById: vi.fn(),
      findByIdWithComponents: vi.fn(),
      insertTaxCode: vi.fn(),
      updateTaxCode: vi.fn(),
      insertComponents: vi.fn(),
      deleteComponentsByTaxCodeId: vi.fn(),
      listComponents: vi.fn(),
      findMany: vi.fn(),
    };
    accountsRepository = {
      findByIds: vi.fn().mockResolvedValue([CGST_ACCOUNT, SGST_ACCOUNT, INPUT_TAX_ACCOUNT]),
    };
    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ limit: 20, offset: 0 }),
    };
    service = new TaxCodesService(
      mockDb,
      repository as unknown as TaxCodesRepository,
      accountsRepository as unknown as AccountsRepository,
      paginationHelper as unknown as PaginationHelper,
    );
  });

  describe('list', () => {
    it('returns paginated tax codes with components included', async () => {
      repository.findMany.mockResolvedValue({
        rows: [SAMPLE_TAX_CODE],
        total: 1,
      });

      const result = await service.list({ is_active: 'true' }, ADMIN_USER);

      expect(repository.findMany).toHaveBeenCalledWith({
        isActive: true,
        limit: 20,
        offset: 0,
      });
      expect(result.data).toHaveLength(1);
      expect(result.data[0].components).toHaveLength(2);
      expect(result.data[0].components[0]).toMatchObject({
        name: 'CGST',
        rate_percent: '9.00',
      });
    });
  });

  describe('getById', () => {
    it('returns tax code with components when found', async () => {
      repository.findByIdWithComponents.mockResolvedValue(SAMPLE_TAX_CODE);

      const result = await service.getById(2, ADMIN_USER);

      expect(repository.findByIdWithComponents).toHaveBeenCalledWith(2);
      expect(result.id).toBe(2);
      expect(result.components).toHaveLength(2);
    });

    it('throws NotFoundError when tax code does not exist', async () => {
      repository.findByIdWithComponents.mockResolvedValue(null);

      await expect(service.getById(999, ADMIN_USER)).rejects.toBeInstanceOf(
        NotFoundError,
      );
    });
  });

  describe('create', () => {
    it('creates tax code and components when rates sum properly and accounts are active', async () => {
      repository.findByCode.mockResolvedValue(null);
      repository.insertTaxCode.mockResolvedValue({
        id: 2,
        name: 'GST 18%',
        code: 'gst_18',
        rate_percent: '18.00',
        is_active: true,
      });
      repository.insertComponents.mockResolvedValue(SAMPLE_TAX_CODE.components);

      const result = await service.create(
        {
          name: 'GST 18%',
          code: 'gst_18',
          rate_percent: '18.00',
          is_active: true,
          components: [
            {
              name: 'CGST',
              rate_percent: '9.00',
              output_account_id: 2100,
              input_account_id: 1300,
            },
            {
              name: 'SGST',
              rate_percent: '9.00',
              output_account_id: 2110,
              input_account_id: 1300,
            },
          ],
        },
        ADMIN_USER,
      );

      expect(repository.findByCode).toHaveBeenCalledWith('gst_18');
      expect(accountsRepository.findByIds).toHaveBeenCalledWith([2100, 1300, 2110]);
      expect(repository.insertTaxCode).toHaveBeenCalledWith({
        name: 'GST 18%',
        code: 'gst_18',
        rate_percent: '18.00',
        is_active: true,
      });
      expect(repository.insertComponents).toHaveBeenCalledWith([
        {
          tax_code_id: 2,
          name: 'CGST',
          rate_percent: '9.00',
          output_account_id: 2100,
          input_account_id: 1300,
        },
        {
          tax_code_id: 2,
          name: 'SGST',
          rate_percent: '9.00',
          output_account_id: 2110,
          input_account_id: 1300,
        },
      ]);
      expect(result.components).toHaveLength(2);
    });

    it('allows creating 0% tax code without components', async () => {
      repository.findByCode.mockResolvedValue(null);
      repository.insertTaxCode.mockResolvedValue({
        id: 1,
        name: 'Exempt',
        code: 'exempt',
        rate_percent: '0.00',
        is_active: true,
      });

      const result = await service.create(
        {
          name: 'Exempt',
          code: 'exempt',
          rate_percent: '0.00',
          components: [],
        },
        ADMIN_USER,
      );

      expect(result.code).toBe('exempt');
      expect(result.components).toEqual([]);
      expect(repository.insertComponents).not.toHaveBeenCalled();
    });

    it('throws ConflictError when tax code code already exists', async () => {
      repository.findByCode.mockResolvedValue(SAMPLE_TAX_CODE);

      await expect(
        service.create(
          {
            name: 'Duplicate',
            code: 'gst_18',
            rate_percent: '18.00',
            components: [],
          },
          ADMIN_USER,
        ),
      ).rejects.toBeInstanceOf(ConflictError);
    });

    it('CRITICAL RULE: rejects create when component rates do not sum to tax code rate', async () => {
      repository.findByCode.mockResolvedValue(null);

      await expect(
        service.create(
          {
            name: 'Bad Sum',
            code: 'bad_sum',
            rate_percent: '18.00',
            components: [
              {
                name: 'CGST',
                rate_percent: '9.00',
                output_account_id: 2100,
                input_account_id: 1300,
              },
              {
                name: 'SGST',
                rate_percent: '8.00',
                output_account_id: 2110,
                input_account_id: 1300,
              },
            ],
          },
          ADMIN_USER,
        ),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        message: 'Tax component rates must sum to the tax code rate',
      });
      expect(repository.insertTaxCode).not.toHaveBeenCalled();
    });

    it('CRITICAL RULE: rejects create when a component account is inactive', async () => {
      repository.findByCode.mockResolvedValue(null);
      accountsRepository.findByIds.mockResolvedValue([
        { ...CGST_ACCOUNT, is_active: false },
        SGST_ACCOUNT,
        INPUT_TAX_ACCOUNT,
      ]);

      await expect(
        service.create(
          {
            name: 'GST 18%',
            code: 'gst_18',
            rate_percent: '18.00',
            components: [
              {
                name: 'CGST',
                rate_percent: '9.00',
                output_account_id: 2100,
                input_account_id: 1300,
              },
              {
                name: 'SGST',
                rate_percent: '9.00',
                output_account_id: 2110,
                input_account_id: 1300,
              },
            ],
          },
          ADMIN_USER,
        ),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        message: 'Tax component account is invalid or inactive',
      });
      expect(repository.insertTaxCode).not.toHaveBeenCalled();
    });

    it('CRITICAL RULE: rejects create when a component account does not exist', async () => {
      repository.findByCode.mockResolvedValue(null);
      accountsRepository.findByIds.mockResolvedValue([CGST_ACCOUNT, INPUT_TAX_ACCOUNT]); // missing 2110

      await expect(
        service.create(
          {
            name: 'GST 18%',
            code: 'gst_18',
            rate_percent: '18.00',
            components: [
              {
                name: 'CGST',
                rate_percent: '9.00',
                output_account_id: 2100,
                input_account_id: 1300,
              },
              {
                name: 'SGST',
                rate_percent: '9.00',
                output_account_id: 2110,
                input_account_id: 1300,
              },
            ],
          },
          ADMIN_USER,
        ),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        message: 'Tax component account is invalid or inactive',
      });
      expect(repository.insertTaxCode).not.toHaveBeenCalled();
    });
  });

  describe('update', () => {
    it('updates name and is_active without altering components', async () => {
      repository.findByIdWithComponents
        .mockResolvedValueOnce(SAMPLE_TAX_CODE)
        .mockResolvedValueOnce({ ...SAMPLE_TAX_CODE, name: 'Goods & Services Tax 18%' });

      const result = await service.update(
        2,
        { name: 'Goods & Services Tax 18%' },
        ADMIN_USER,
      );

      expect(repository.updateTaxCode).toHaveBeenCalledWith(2, {
        name: 'Goods & Services Tax 18%',
      });
      expect(repository.deleteComponentsByTaxCodeId).not.toHaveBeenCalled();
      expect(result.name).toBe('Goods & Services Tax 18%');
    });

    it('updates components with validation inside transaction', async () => {
      repository.findByIdWithComponents
        .mockResolvedValueOnce(SAMPLE_TAX_CODE)
        .mockResolvedValueOnce({
          ...SAMPLE_TAX_CODE,
          components: [
            {
              id: 3,
              tax_code_id: 2,
              name: 'IGST',
              rate_percent: '18.00',
              output_account_id: 2100,
              input_account_id: 1300,
            },
          ],
        });

      const result = await service.update(
        2,
        {
          components: [
            {
              name: 'IGST',
              rate_percent: '18.00',
              output_account_id: 2100,
              input_account_id: 1300,
            },
          ],
        },
        ADMIN_USER,
      );

      expect(repository.deleteComponentsByTaxCodeId).toHaveBeenCalledWith(2);
      expect(repository.insertComponents).toHaveBeenCalled();
      expect(result.components).toHaveLength(1);
    });

    it('rejects update if modified rate_percent does not match existing components', async () => {
      repository.findByIdWithComponents.mockResolvedValue(SAMPLE_TAX_CODE); // components sum to 18.00

      await expect(
        service.update(2, { rate_percent: '20.00' }, ADMIN_USER),
      ).rejects.toMatchObject({
        name: 'BusinessRuleError',
        message: 'Tax component rates must sum to the tax code rate',
      });
    });

    it('throws NotFoundError when tax code does not exist on update', async () => {
      repository.findByIdWithComponents.mockResolvedValue(null);

      await expect(
        service.update(999, { name: 'Not Found' }, ADMIN_USER),
      ).rejects.toBeInstanceOf(NotFoundError);
    });
  });
});
