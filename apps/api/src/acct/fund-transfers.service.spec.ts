import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { BusinessRuleError } from '../platform/errors/app-error';
import type { PaginationHelper } from '../platform/http/pagination';
import type { AccountingPostingService } from './accounting-posting.service';
import type { AccountsRepository } from './accounts.repository';
import { fundTransferCreateSchema } from './fund-transfers.dto';
import type { FundTransfersRepository } from './fund-transfers.repository';
import { FundTransfersService } from './fund-transfers.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
  getAmbientTransaction: () => null,
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

function account(id: number, code: string, overrides: Record<string, unknown> = {}) {
  return {
    id,
    code,
    name: `Account ${code}`,
    account_type: 'asset',
    parent_id: null,
    is_active: true,
    is_bank: true,
    is_control: false,
    control_role: null,
    created_at: new Date(),
    updated_at: null,
    ...overrides,
  };
}

const CASH = account(1, '1000');
const BANK = account(2, '1010');
const CARD_CLEARING = account(3, '1020');
const FEE_ACCOUNT = account(4, '5500', { account_type: 'expense', is_bank: false });
const INCOME_ACCOUNT = account(5, '4200', { account_type: 'income', is_bank: false });
const ACCOUNTS = [CASH, BANK, CARD_CLEARING, FEE_ACCOUNT, INCOME_ACCOUNT];

function draftTransfer(overrides: Record<string, unknown> = {}) {
  return {
    id: 7,
    transfer_number: 'FT00000007',
    transfer_date: '2026-10-12',
    from_account_id: CASH.id,
    to_account_id: BANK.id,
    amount: '5000.00',
    fee_amount: '0.00',
    fee_account_id: null,
    memo: null,
    status: 'draft',
    journal_entry_id: null,
    row_version: 1,
    created_at: new Date(),
    updated_at: null,
    ...overrides,
  };
}

describe('FundTransfersService', () => {
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let postingService: Record<string, ReturnType<typeof vi.fn>>;
  let accountsRepository: Record<string, ReturnType<typeof vi.fn>>;
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };
  let service: FundTransfersService;

  beforeEach(() => {
    repository = {
      allocateFundTransferNumber: vi.fn().mockResolvedValue('FT00000007'),
      findById: vi.fn(),
      insertTransfer: vi.fn().mockImplementation(async (row: Record<string, unknown>) => ({
        id: 7,
        ...row,
      })),
      updateTransfer: vi
        .fn()
        .mockImplementation(async (id: number, row: Record<string, unknown>) =>
          draftTransfer({ id, ...row }),
        ),
      findMany: vi.fn(),
    };
    postingService = {
      postJournal: vi.fn().mockResolvedValue({ id: 99, journal_number: 'JRN00000099', lines: [] }),
    };
    accountsRepository = {
      findById: vi
        .fn()
        .mockImplementation(async (id: number) => ACCOUNTS.find((a) => a.id === id) ?? null),
      findByCode: vi
        .fn()
        .mockImplementation(async (code: string) => ACCOUNTS.find((a) => a.code === code) ?? null),
    };
    paginationHelper = { normalizeParams: vi.fn() };

    service = new FundTransfersService(
      repository as unknown as FundTransfersRepository,
      postingService as unknown as AccountingPostingService,
      accountsRepository as unknown as AccountsRepository,
      {} as never,
      paginationHelper as unknown as PaginationHelper,
    );
  });

  describe('cash deposit', () => {
    it('creates a draft and posts credit cash, debit bank with no fee line', async () => {
      const created = await service.create(
        {
          transfer_date: '2026-10-12',
          from_account_id: CASH.id,
          to_account_id: BANK.id,
          amount: '5000.00',
        },
        ADMIN_USER,
      );
      expect(created.status).toBe('draft');
      expect(created.fee_amount).toBe('0.00');
      expect(created.fee_account_id).toBeNull();

      repository.findById.mockResolvedValue(draftTransfer());
      const posted = await service.post(7, ADMIN_USER);

      expect(postingService.postJournal).toHaveBeenCalledTimes(1);
      const input = postingService.postJournal.mock.calls[0]![0];
      expect(input.sourceType).toBe('fund_transfer');
      expect(input.sourceId).toBe(7);
      expect(input.lines).toEqual([
        expect.objectContaining({ accountId: BANK.id, debit: '5000.00' }),
        expect.objectContaining({ accountId: CASH.id, credit: '5000.00' }),
      ]);
      expect(repository.updateTransfer).toHaveBeenCalledWith(
        7,
        expect.objectContaining({ status: 'posted', journal_entry_id: 99 }),
      );
      expect(posted.status).toBe('posted');
      expect(posted.journal_entry_id).toBe(99);
    });
  });

  describe('card settlement with a fee', () => {
    it('credits 1020 for gross, debits bank for net, and debits 5500 for the fee', async () => {
      repository.findById.mockResolvedValue(
        draftTransfer({
          from_account_id: CARD_CLEARING.id,
          to_account_id: BANK.id,
          amount: '10000.00',
          fee_amount: '236.00',
          fee_account_id: FEE_ACCOUNT.id,
        }),
      );

      await service.post(7, ADMIN_USER);

      const input = postingService.postJournal.mock.calls[0]![0];
      expect(input.lines).toEqual([
        expect.objectContaining({ accountId: BANK.id, debit: '9764.00' }),
        expect.objectContaining({ accountId: FEE_ACCOUNT.id, debit: '236.00' }),
        expect.objectContaining({ accountId: CARD_CLEARING.id, credit: '10000.00' }),
      ]);
    });

    it('defaults the fee account to 5500 when only an amount is given', async () => {
      const created = await service.create(
        {
          transfer_date: '2026-10-12',
          from_account_id: CARD_CLEARING.id,
          to_account_id: BANK.id,
          amount: '10000.00',
          fee_amount: '236.00',
        },
        ADMIN_USER,
      );
      expect(created.fee_account_id).toBe(FEE_ACCOUNT.id);
      expect(created.fee_amount).toBe('236.00');
    });

    it('rejects a fee equal to or above the amount', async () => {
      await expect(
        service.create(
          {
            transfer_date: '2026-10-12',
            from_account_id: CARD_CLEARING.id,
            to_account_id: BANK.id,
            amount: '100.00',
            fee_amount: '100.00',
          },
          ADMIN_USER,
        ),
      ).rejects.toThrow(BusinessRuleError);
    });
  });

  describe('invalid transfers', () => {
    it('rejects a same-account transfer in the schema', () => {
      const result = fundTransferCreateSchema.safeParse({
        transfer_date: '2026-10-12',
        from_account_id: BANK.id,
        to_account_id: BANK.id,
        amount: '100.00',
      });
      expect(result.success).toBe(false);
    });

    it('rejects a same-account transfer in the service', async () => {
      await expect(
        service.create(
          {
            transfer_date: '2026-10-12',
            from_account_id: BANK.id,
            to_account_id: BANK.id,
            amount: '100.00',
          },
          ADMIN_USER,
        ),
      ).rejects.toThrow('Source and destination accounts must differ');
      expect(repository.insertTransfer).not.toHaveBeenCalled();
    });

    it('rejects an account that is not bank or cash', async () => {
      await expect(
        service.create(
          {
            transfer_date: '2026-10-12',
            from_account_id: INCOME_ACCOUNT.id,
            to_account_id: BANK.id,
            amount: '100.00',
          },
          ADMIN_USER,
        ),
      ).rejects.toThrow('not a bank or cash account');
    });

    it('does not post a transfer twice', async () => {
      repository.findById.mockResolvedValue(
        draftTransfer({ status: 'posted', journal_entry_id: 99 }),
      );
      const result = await service.post(7, ADMIN_USER);
      expect(result.status).toBe('posted');
      expect(postingService.postJournal).not.toHaveBeenCalled();
    });

    it('does not edit a posted transfer', async () => {
      repository.findById.mockResolvedValue(draftTransfer({ status: 'posted' }));
      await expect(service.update(7, { memo: 'x' }, ADMIN_USER)).rejects.toThrow(
        'Only draft fund transfers can be edited',
      );
    });
  });
});
