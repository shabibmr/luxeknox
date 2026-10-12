import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import type { PaginationHelper } from '../platform/http/pagination';
import type { AccountingPostingService } from './accounting-posting.service';
import type { AccountingRepository } from './accounting.repository';
import { JournalService } from './journal.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const ENTRY_WITH_LINES = {
  id: 50,
  journal_number: 'JRN00000001',
  entry_date: '2026-04-15',
  accounting_period_id: 7,
  source_type: 'manual' as const,
  source_id: 1,
  memo: 'Adjust rent',
  posted_at: new Date('2026-04-15T10:00:00.000Z'),
  posted_by_user_id: 1,
  reverses_journal_id: null,
  row_version: 1,
  created_at: new Date('2026-04-15T10:00:00.000Z'),
  updated_at: null,
  lines: [
    {
      id: 1,
      journal_entry_id: 50,
      account_id: 5000,
      debit: '100.00',
      credit: '0.00',
      memo: null,
      member_id: null,
      vendor_id: null,
    },
    {
      id: 2,
      journal_entry_id: 50,
      account_id: 1000,
      debit: '0.00',
      credit: '100.00',
      memo: null,
      member_id: null,
      vendor_id: null,
    },
  ],
};

describe('JournalService', () => {
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  let postingService: Record<string, ReturnType<typeof vi.fn>>;
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };
  let service: JournalService;

  beforeEach(() => {
    repository = {
      findMany: vi.fn(),
      findEntryWithLines: vi.fn(),
    };
    postingService = {
      postUserJournal: vi.fn().mockResolvedValue(ENTRY_WITH_LINES),
      reverseJournal: vi.fn(),
    };
    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ limit: 20, offset: 0 }),
    };
    service = new JournalService(
      repository as unknown as AccountingRepository,
      postingService as unknown as AccountingPostingService,
      paginationHelper as unknown as PaginationHelper,
    );
  });

  it('creates a balanced manual journal and returns DTO lines', async () => {
    const result = await service.create(
      {
        entry_date: '2026-04-15',
        source_type: 'manual',
        memo: 'Adjust rent',
        lines: [
          { account_id: 5000, debit: '100.00' },
          { account_id: 1000, credit: '100.00' },
        ],
      },
      ADMIN_USER,
    );

    expect(postingService.postUserJournal).toHaveBeenCalledWith({
      entryDate: '2026-04-15',
      sourceType: 'manual',
      memo: 'Adjust rent',
      postedByUserId: 1,
      lines: [
        {
          accountId: 5000,
          debit: '100.00',
          credit: undefined,
          memo: undefined,
          memberId: undefined,
          vendorId: undefined,
        },
        {
          accountId: 1000,
          debit: undefined,
          credit: '100.00',
          memo: undefined,
          memberId: undefined,
          vendorId: undefined,
        },
      ],
    });
    expect(result.id).toBe(50);
    expect(result.lines).toEqual([
      expect.objectContaining({ account_id: 5000, debit: '100.00', credit: '0.00' }),
      expect.objectContaining({ account_id: 1000, debit: '0.00', credit: '100.00' }),
    ]);
  });

  it('propagates unbalanced journal rejection from posting', async () => {
    postingService.postUserJournal.mockRejectedValue(
      new BusinessRuleError('Journal debits must equal credits'),
    );

    await expect(
      service.create(
        {
          entry_date: '2026-04-15',
          source_type: 'manual',
          lines: [
            { account_id: 5000, debit: '100.00' },
            { account_id: 1000, credit: '99.00' },
          ],
        },
        ADMIN_USER,
      ),
    ).rejects.toMatchObject({
      name: 'BusinessRuleError',
      message: 'Journal debits must equal credits',
    });
  });

  it('propagates locked-period rejection from posting on create', async () => {
    postingService.postUserJournal.mockRejectedValue(
      new BusinessRuleError('Accounting period 2026-04-01 to 2026-04-30 is locked'),
    );

    await expect(
      service.create(
        {
          entry_date: '2026-04-15',
          source_type: 'manual',
          lines: [
            { account_id: 5000, debit: '100.00' },
            { account_id: 1000, credit: '100.00' },
          ],
        },
        ADMIN_USER,
      ),
    ).rejects.toMatchObject({
      message: 'Accounting period 2026-04-01 to 2026-04-30 is locked',
    });
  });

  it('reverses a journal and returns swapped DTO lines with reverses_journal_id', async () => {
    const reversal = {
      ...ENTRY_WITH_LINES,
      id: 51,
      journal_number: 'JRN00000002',
      entry_date: '2026-04-16',
      source_type: 'journal_reversal' as const,
      source_id: 50,
      reverses_journal_id: 50,
      lines: [
        {
          id: 3,
          journal_entry_id: 51,
          account_id: 5000,
          debit: '0.00',
          credit: '100.00',
          memo: null,
          member_id: null,
          vendor_id: null,
        },
        {
          id: 4,
          journal_entry_id: 51,
          account_id: 1000,
          debit: '100.00',
          credit: '0.00',
          memo: null,
          member_id: null,
          vendor_id: null,
        },
      ],
    };
    postingService.reverseJournal.mockResolvedValue(reversal);

    const result = await service.reverse(50, { entry_date: '2026-04-16' }, ADMIN_USER);

    expect(postingService.reverseJournal).toHaveBeenCalledWith({
      journalId: 50,
      entryDate: '2026-04-16',
      memo: undefined,
      postedByUserId: 1,
    });
    expect(result.id).toBe(51);
    expect(result.reverses_journal_id).toBe(50);
    expect(result.source_type).toBe('journal_reversal');
    expect(result.lines).toEqual([
      expect.objectContaining({ account_id: 5000, debit: '0.00', credit: '100.00' }),
      expect.objectContaining({ account_id: 1000, debit: '100.00', credit: '0.00' }),
    ]);
  });

  it('propagates locked-period rejection from posting on reverse', async () => {
    postingService.reverseJournal.mockRejectedValue(
      new BusinessRuleError('Accounting period 2026-04-01 to 2026-04-30 is locked'),
    );

    await expect(
      service.reverse(50, { entry_date: '2026-04-16' }, ADMIN_USER),
    ).rejects.toMatchObject({
      message: 'Accounting period 2026-04-01 to 2026-04-30 is locked',
    });
  });

  it('propagates missing journal on getById', async () => {
    repository.findEntryWithLines.mockResolvedValue(null);

    await expect(service.getById(999, ADMIN_USER)).rejects.toBeInstanceOf(NotFoundError);
  });
});
