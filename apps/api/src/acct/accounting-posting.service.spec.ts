import { beforeEach, describe, expect, it, vi } from 'vitest';
import { BadRequestError, BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import { AccountingPostingService } from './accounting-posting.service';

vi.mock('../platform/db/transaction-context', () => ({
  runInTransaction: async (_db: unknown, fn: () => Promise<unknown>) => fn(),
}));

describe('AccountingPostingService.postJournal', () => {
  let service: AccountingPostingService;
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  const db = {} as any;

  const openPeriod = {
    id: 7,
    fiscal_year_id: 1,
    starts_on: '2026-04-01',
    ends_on: '2026-04-30',
    status: 'open' as const,
    closed_at: null,
    closed_by_user_id: null,
  };

  const balancedLines = [
    { accountId: 1100, debit: '118.00', credit: '0.00' },
    { accountId: 2200, debit: '0.00', credit: '100.00' },
    { accountId: 2100, debit: '0.00', credit: '9.00' },
    { accountId: 2110, debit: '0.00', credit: '9.00' },
  ];

  beforeEach(() => {
    repository = {
      allocateJournalNumber: vi.fn().mockResolvedValue('JRN00000001'),
      findPeriodForDate: vi.fn().mockResolvedValue(openPeriod),
      findPeriodById: vi.fn().mockResolvedValue(openPeriod),
      findBySource: vi.fn().mockResolvedValue(null),
      insertJournalEntry: vi.fn().mockImplementation(async (row) => ({
        id: 50,
        row_version: 1,
        created_at: new Date('2026-04-15T10:00:00.000Z'),
        updated_at: null,
        reverses_journal_id: null,
        ...row,
      })),
      insertJournalLines: vi.fn().mockImplementation(async (rows) =>
        rows.map((row: Record<string, unknown>, index: number) => ({
          id: index + 1,
          ...row,
        })),
      ),
      findEntryWithLines: vi.fn(),
    };

    service = new AccountingPostingService(repository as any, db);
  });

  it('posts a balanced journal inside a transaction and returns entry with lines', async () => {
    const result = await service.postJournal({
      entryDate: '2026-04-15',
      sourceType: 'manual',
      sourceId: 9001,
      memo: 'Opening cash',
      postedByUserId: 9,
      lines: balancedLines,
    });

    expect(repository.findPeriodForDate).toHaveBeenCalledWith('2026-04-15');
    expect(repository.allocateJournalNumber).toHaveBeenCalledOnce();
    expect(repository.insertJournalEntry).toHaveBeenCalledWith(
      expect.objectContaining({
        journal_number: 'JRN00000001',
        entry_date: '2026-04-15',
        accounting_period_id: 7,
        source_type: 'manual',
        source_id: 9001,
        memo: 'Opening cash',
        posted_by_user_id: 9,
      }),
    );
    expect(repository.insertJournalLines).toHaveBeenCalledWith([
      expect.objectContaining({
        journal_entry_id: 50,
        account_id: 1100,
        debit: '118.00',
        credit: '0.00',
      }),
      expect.objectContaining({
        journal_entry_id: 50,
        account_id: 2200,
        debit: '0.00',
        credit: '100.00',
      }),
      expect.objectContaining({
        journal_entry_id: 50,
        account_id: 2100,
        debit: '0.00',
        credit: '9.00',
      }),
      expect.objectContaining({
        journal_entry_id: 50,
        account_id: 2110,
        debit: '0.00',
        credit: '9.00',
      }),
    ]);
    expect(result.id).toBe(50);
    expect(result.journal_number).toBe('JRN00000001');
    expect(result.lines).toHaveLength(4);
  });

  it('rejects when debit cents do not equal credit cents', async () => {
    await expect(
      service.postJournal({
        entryDate: '2026-04-15',
        sourceType: 'manual',
        sourceId: 1,
        lines: [
          { accountId: 1100, debit: '100.00', credit: '0.00' },
          { accountId: 2200, debit: '0.00', credit: '99.99' },
        ],
      }),
    ).rejects.toBeInstanceOf(BusinessRuleError);

    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
  });

  it('rejects a line that carries both debit and credit', async () => {
    await expect(
      service.postJournal({
        entryDate: '2026-04-15',
        sourceType: 'manual',
        sourceId: 1,
        lines: [
          { accountId: 1100, debit: '50.00', credit: '50.00' },
          { accountId: 2200, debit: '0.00', credit: '0.00' },
        ],
      }),
    ).rejects.toBeInstanceOf(BadRequestError);

    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
  });

  it('rejects a line with neither debit nor credit', async () => {
    await expect(
      service.postJournal({
        entryDate: '2026-04-15',
        sourceType: 'manual',
        sourceId: 1,
        lines: [
          { accountId: 1100, debit: '0.00', credit: '0.00' },
          { accountId: 2200, debit: '100.00', credit: '0.00' },
        ],
      }),
    ).rejects.toBeInstanceOf(BadRequestError);

    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
  });

  it('rejects a non-positive amount on the active side', async () => {
    await expect(
      service.postJournal({
        entryDate: '2026-04-15',
        sourceType: 'manual',
        sourceId: 1,
        lines: [
          { accountId: 1100, debit: '-10.00', credit: '0.00' },
          { accountId: 2200, debit: '0.00', credit: '-10.00' },
        ],
      }),
    ).rejects.toBeInstanceOf(BadRequestError);

    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
  });

  it('rejects when no accounting period covers the entry date', async () => {
    repository.findPeriodForDate.mockResolvedValue(null);

    await expect(
      service.postJournal({
        entryDate: '2099-01-01',
        sourceType: 'manual',
        sourceId: 1,
        lines: balancedLines,
      }),
    ).rejects.toBeInstanceOf(NotFoundError);

    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
  });

  it('returns the original journal on a second post for the same source and writes nothing new', async () => {
    const existing = {
      id: 50,
      journal_number: 'JRN00000001',
      entry_date: '2026-04-15',
      accounting_period_id: 7,
      source_type: 'sales_invoice',
      source_id: 42,
      memo: 'Member invoice',
      posted_at: new Date('2026-04-15T10:00:00.000Z'),
      posted_by_user_id: 9,
      reverses_journal_id: null,
      row_version: 1,
      created_at: new Date('2026-04-15T10:00:00.000Z'),
      updated_at: null,
      lines: [
        { id: 1, journal_entry_id: 50, account_id: 1100, debit: '118.00', credit: '0.00' },
        { id: 2, journal_entry_id: 50, account_id: 2200, debit: '0.00', credit: '100.00' },
        { id: 3, journal_entry_id: 50, account_id: 2100, debit: '0.00', credit: '9.00' },
        { id: 4, journal_entry_id: 50, account_id: 2110, debit: '0.00', credit: '9.00' },
      ],
    };
    repository.findBySource.mockResolvedValue({
      id: 50,
      journal_number: 'JRN00000001',
      source_type: 'sales_invoice',
      source_id: 42,
    });
    repository.findEntryWithLines.mockResolvedValue(existing);

    const result = await service.postJournal({
      entryDate: '2026-04-16',
      sourceType: 'sales_invoice',
      sourceId: 42,
      memo: 'retry',
      lines: balancedLines,
    });

    expect(repository.findBySource).toHaveBeenCalledWith('sales_invoice', 42);
    expect(repository.findEntryWithLines).toHaveBeenCalledWith(50);
    expect(repository.allocateJournalNumber).not.toHaveBeenCalled();
    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
    expect(repository.insertJournalLines).not.toHaveBeenCalled();
    expect(result).toEqual(existing);
  });

  it('rejects a post whose date falls in a locked period', async () => {
    repository.findPeriodForDate.mockResolvedValue({
      ...openPeriod,
      status: 'locked',
      closed_at: new Date('2026-05-01T00:00:00.000Z'),
      closed_by_user_id: 1,
    });

    await expect(
      service.postJournal({
        entryDate: '2026-04-15',
        sourceType: 'manual',
        sourceId: 1,
        lines: balancedLines,
      }),
    ).rejects.toMatchObject({
      name: 'BusinessRuleError',
      message: 'Accounting period 2026-04-01 to 2026-04-30 is locked',
    });

    expect(repository.allocateJournalNumber).not.toHaveBeenCalled();
    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
    expect(repository.insertJournalLines).not.toHaveBeenCalled();
  });

  it('returns the original journal on replay even when the period is locked', async () => {
    const existing = {
      id: 50,
      journal_number: 'JRN00000001',
      entry_date: '2026-04-15',
      accounting_period_id: 7,
      source_type: 'sales_invoice',
      source_id: 42,
      memo: 'Member invoice',
      posted_at: new Date('2026-04-15T10:00:00.000Z'),
      posted_by_user_id: 9,
      reverses_journal_id: null,
      row_version: 1,
      created_at: new Date('2026-04-15T10:00:00.000Z'),
      updated_at: null,
      lines: [
        { id: 1, journal_entry_id: 50, account_id: 1100, debit: '118.00', credit: '0.00' },
        { id: 2, journal_entry_id: 50, account_id: 2200, debit: '0.00', credit: '118.00' },
      ],
    };
    repository.findBySource.mockResolvedValue({
      id: 50,
      journal_number: 'JRN00000001',
      source_type: 'sales_invoice',
      source_id: 42,
    });
    repository.findEntryWithLines.mockResolvedValue(existing);
    repository.findPeriodForDate.mockResolvedValue({
      ...openPeriod,
      status: 'locked',
    });

    const result = await service.postJournal({
      entryDate: '2026-04-15',
      sourceType: 'sales_invoice',
      sourceId: 42,
      lines: balancedLines,
    });

    expect(result).toEqual(existing);
    expect(repository.findPeriodForDate).not.toHaveBeenCalled();
    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
  });

  it('posts into the named accounting period without a date lookup', async () => {
    await service.postJournal({
      entryDate: '2026-04-15',
      accountingPeriodId: 7,
      sourceType: 'revenue_recognition',
      sourceId: 50,
      lines: balancedLines,
    });

    expect(repository.findPeriodById).toHaveBeenCalledWith(7);
    expect(repository.findPeriodForDate).not.toHaveBeenCalled();
    expect(repository.insertJournalEntry).toHaveBeenCalledWith(
      expect.objectContaining({ accounting_period_id: 7 }),
    );
  });

  it('rejects a named accounting period that does not exist', async () => {
    repository.findPeriodById.mockResolvedValue(null);

    await expect(
      service.postJournal({
        entryDate: '2026-04-15',
        accountingPeriodId: 99,
        sourceType: 'revenue_recognition',
        sourceId: 50,
        lines: balancedLines,
      }),
    ).rejects.toBeInstanceOf(NotFoundError);

    expect(repository.findPeriodForDate).not.toHaveBeenCalled();
    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
  });

  it('rejects a named accounting period that does not contain the entry date', async () => {
    await expect(
      service.postJournal({
        entryDate: '2026-05-01',
        accountingPeriodId: 7,
        sourceType: 'revenue_recognition',
        sourceId: 50,
        lines: balancedLines,
      }),
    ).rejects.toMatchObject({
      name: 'BusinessRuleError',
      message: 'Entry date 2026-05-01 is outside accounting period 2026-04-01 to 2026-04-30',
    });

    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
  });

  it('rejects a named accounting period that is locked', async () => {
    repository.findPeriodById.mockResolvedValue({
      ...openPeriod,
      status: 'locked',
    });

    await expect(
      service.postJournal({
        entryDate: '2026-04-15',
        accountingPeriodId: 7,
        sourceType: 'revenue_recognition',
        sourceId: 50,
        lines: balancedLines,
      }),
    ).rejects.toMatchObject({
      name: 'BusinessRuleError',
      message: 'Accounting period 2026-04-01 to 2026-04-30 is locked',
    });

    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
  });
});

describe('AccountingPostingService.reverseJournal', () => {
  let service: AccountingPostingService;
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  const db = {} as any;

  const openPeriod = {
    id: 7,
    fiscal_year_id: 1,
    starts_on: '2026-04-01',
    ends_on: '2026-04-30',
    status: 'open' as const,
    closed_at: null,
    closed_by_user_id: null,
  };

  const original = {
    id: 50,
    journal_number: 'JRN00000001',
    entry_date: '2026-04-15',
    accounting_period_id: 7,
    source_type: 'sales_invoice',
    source_id: 42,
    memo: 'Member invoice',
    posted_at: new Date('2026-04-15T10:00:00.000Z'),
    posted_by_user_id: 9,
    reverses_journal_id: null,
    row_version: 1,
    created_at: new Date('2026-04-15T10:00:00.000Z'),
    updated_at: null,
    lines: [
      {
        id: 1,
        journal_entry_id: 50,
        account_id: 1100,
        debit: '118.00',
        credit: '0.00',
        memo: 'AR',
        member_id: 3,
        vendor_id: null,
      },
      {
        id: 2,
        journal_entry_id: 50,
        account_id: 2200,
        debit: '0.00',
        credit: '100.00',
        memo: 'Unearned',
        member_id: 3,
        vendor_id: null,
      },
      {
        id: 3,
        journal_entry_id: 50,
        account_id: 2100,
        debit: '0.00',
        credit: '9.00',
        memo: null,
        member_id: null,
        vendor_id: null,
      },
      {
        id: 4,
        journal_entry_id: 50,
        account_id: 2110,
        debit: '0.00',
        credit: '9.00',
        memo: null,
        member_id: null,
        vendor_id: null,
      },
    ],
  };

  beforeEach(() => {
    repository = {
      allocateJournalNumber: vi.fn().mockResolvedValue('JRN00000002'),
      findPeriodForDate: vi.fn().mockResolvedValue(openPeriod),
      findBySource: vi.fn().mockResolvedValue(null),
      findEntryWithLines: vi.fn().mockResolvedValue(original),
      insertJournalEntry: vi.fn().mockImplementation(async (row) => ({
        id: 51,
        row_version: 1,
        created_at: new Date('2026-04-16T10:00:00.000Z'),
        updated_at: null,
        ...row,
      })),
      insertJournalLines: vi.fn().mockImplementation(async (rows) =>
        rows.map((row: Record<string, unknown>, index: number) => ({
          id: 100 + index,
          ...row,
        })),
      ),
      update: vi.fn(),
    };

    service = new AccountingPostingService(repository as any, db);
  });

  it('posts a reversing journal that swaps debit and credit and links reverses_journal_id', async () => {
    const result = await service.reverseJournal({
      journalId: 50,
      entryDate: '2026-04-16',
      memo: 'Reverse member invoice',
      postedByUserId: 9,
    });

    expect(repository.findEntryWithLines).toHaveBeenCalledWith(50);
    expect(repository.findBySource).toHaveBeenCalledWith('journal_reversal', 50);
    expect(repository.findPeriodForDate).toHaveBeenCalledWith('2026-04-16');
    expect(repository.allocateJournalNumber).toHaveBeenCalledOnce();
    expect(repository.insertJournalEntry).toHaveBeenCalledWith(
      expect.objectContaining({
        journal_number: 'JRN00000002',
        entry_date: '2026-04-16',
        accounting_period_id: 7,
        source_type: 'journal_reversal',
        source_id: 50,
        memo: 'Reverse member invoice',
        posted_by_user_id: 9,
        reverses_journal_id: 50,
      }),
    );
    expect(repository.insertJournalLines).toHaveBeenCalledWith([
      expect.objectContaining({
        journal_entry_id: 51,
        account_id: 1100,
        debit: '0.00',
        credit: '118.00',
        memo: 'AR',
        member_id: 3,
        vendor_id: null,
      }),
      expect.objectContaining({
        journal_entry_id: 51,
        account_id: 2200,
        debit: '100.00',
        credit: '0.00',
        memo: 'Unearned',
        member_id: 3,
        vendor_id: null,
      }),
      expect.objectContaining({
        journal_entry_id: 51,
        account_id: 2100,
        debit: '9.00',
        credit: '0.00',
      }),
      expect.objectContaining({
        journal_entry_id: 51,
        account_id: 2110,
        debit: '9.00',
        credit: '0.00',
      }),
    ]);
    expect(repository.update).not.toHaveBeenCalled();
    expect(result.id).toBe(51);
    expect(result.reverses_journal_id).toBe(50);
    expect(result.lines).toHaveLength(4);
  });

  it('does not edit the original journal entry or its lines', async () => {
    await service.reverseJournal({
      journalId: 50,
      entryDate: '2026-04-16',
    });

    expect(repository.update).not.toHaveBeenCalled();
    expect(repository.insertJournalEntry).toHaveBeenCalledOnce();
    const inserted = repository.insertJournalEntry.mock.calls[0][0];
    expect(inserted.reverses_journal_id).toBe(50);
    expect(inserted.source_id).toBe(50);
  });

  it('returns the existing reversal on a second reverse and writes nothing new', async () => {
    const existingReversal = {
      id: 51,
      journal_number: 'JRN00000002',
      entry_date: '2026-04-16',
      accounting_period_id: 7,
      source_type: 'journal_reversal',
      source_id: 50,
      memo: 'Reverse member invoice',
      posted_at: new Date('2026-04-16T10:00:00.000Z'),
      posted_by_user_id: 9,
      reverses_journal_id: 50,
      row_version: 1,
      created_at: new Date('2026-04-16T10:00:00.000Z'),
      updated_at: null,
      lines: [
        { id: 100, journal_entry_id: 51, account_id: 1100, debit: '0.00', credit: '118.00' },
        { id: 101, journal_entry_id: 51, account_id: 2200, debit: '100.00', credit: '0.00' },
      ],
    };
    repository.findBySource.mockResolvedValue({
      id: 51,
      source_type: 'journal_reversal',
      source_id: 50,
    });
    repository.findEntryWithLines
      .mockResolvedValueOnce(original)
      .mockResolvedValueOnce(existingReversal);

    const result = await service.reverseJournal({
      journalId: 50,
      entryDate: '2026-04-17',
      memo: 'retry',
    });

    expect(repository.allocateJournalNumber).not.toHaveBeenCalled();
    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
    expect(repository.insertJournalLines).not.toHaveBeenCalled();
    expect(repository.update).not.toHaveBeenCalled();
    expect(result).toEqual(existingReversal);
  });

  it('rejects when the journal to reverse does not exist', async () => {
    repository.findEntryWithLines.mockResolvedValue(null);

    await expect(
      service.reverseJournal({
        journalId: 999,
        entryDate: '2026-04-16',
      }),
    ).rejects.toBeInstanceOf(NotFoundError);

    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
  });

  it('rejects a reverse whose date falls in a locked period', async () => {
    repository.findPeriodForDate.mockResolvedValue({
      ...openPeriod,
      status: 'locked',
      closed_at: new Date('2026-05-01T00:00:00.000Z'),
      closed_by_user_id: 1,
    });

    await expect(
      service.reverseJournal({
        journalId: 50,
        entryDate: '2026-04-16',
      }),
    ).rejects.toMatchObject({
      name: 'BusinessRuleError',
      message: 'Accounting period 2026-04-01 to 2026-04-30 is locked',
    });

    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
  });
});

describe('AccountingPostingService.postUserJournal', () => {
  let service: AccountingPostingService;
  let repository: Record<string, ReturnType<typeof vi.fn>>;
  const db = {} as any;

  const openPeriod = {
    id: 7,
    fiscal_year_id: 1,
    starts_on: '2026-04-01',
    ends_on: '2026-04-30',
    status: 'open' as const,
    closed_at: null,
    closed_by_user_id: null,
  };

  beforeEach(() => {
    repository = {
      allocateJournalNumber: vi.fn().mockResolvedValue('JRN00000001'),
      findPeriodForDate: vi.fn().mockResolvedValue(openPeriod),
      findPeriodById: vi.fn().mockResolvedValue(openPeriod),
      findBySource: vi.fn().mockResolvedValue(null),
      insertJournalEntry: vi.fn().mockImplementation(async (row) => ({
        id: 50,
        row_version: 1,
        created_at: new Date('2026-04-15T10:00:00.000Z'),
        updated_at: null,
        reverses_journal_id: null,
        ...row,
      })),
      insertJournalLines: vi.fn().mockImplementation(async (rows) =>
        rows.map((row: Record<string, unknown>, index: number) => ({
          id: index + 1,
          ...row,
        })),
      ),
      findEntryWithLines: vi.fn(),
    };

    service = new AccountingPostingService(repository as any, db);
  });

  it('rejects fewer than two lines before allocating a journal number', async () => {
    await expect(
      service.postUserJournal({
        entryDate: '2026-04-15',
        sourceType: 'manual',
        lines: [{ accountId: 1000, debit: '100.00', credit: '0.00' }],
      }),
    ).rejects.toBeInstanceOf(BadRequestError);

    expect(repository.allocateJournalNumber).not.toHaveBeenCalled();
    expect(repository.insertJournalEntry).not.toHaveBeenCalled();
  });

  it('posts a manual journal using the journal number digits as source_id', async () => {
    const result = await service.postUserJournal({
      entryDate: '2026-04-15',
      sourceType: 'manual',
      memo: 'Adjust rent',
      postedByUserId: 9,
      lines: [
        { accountId: 5000, debit: '100.00', credit: '0.00' },
        { accountId: 1000, debit: '0.00', credit: '100.00' },
      ],
    });

    expect(repository.findPeriodForDate).toHaveBeenCalledWith('2026-04-15');
    expect(repository.allocateJournalNumber).toHaveBeenCalledOnce();
    expect(repository.insertJournalEntry).toHaveBeenCalledWith(
      expect.objectContaining({
        journal_number: 'JRN00000001',
        source_type: 'manual',
        source_id: 1,
        memo: 'Adjust rent',
        posted_by_user_id: 9,
      }),
    );
    expect(result.journal_number).toBe('JRN00000001');
    expect(result.lines).toHaveLength(2);
  });

  it('rejects an unbalanced user journal before allocating a number', async () => {
    await expect(
      service.postUserJournal({
        entryDate: '2026-04-15',
        sourceType: 'manual',
        lines: [
          { accountId: 5000, debit: '100.00', credit: '0.00' },
          { accountId: 1000, debit: '0.00', credit: '99.00' },
        ],
      }),
    ).rejects.toBeInstanceOf(BusinessRuleError);

    expect(repository.allocateJournalNumber).not.toHaveBeenCalled();
  });

  it('posts an opening_balance journal', async () => {
    repository.allocateJournalNumber.mockResolvedValue('JRN00000042');

    await service.postUserJournal({
      entryDate: '2026-03-31',
      sourceType: 'opening_balance',
      lines: [
        { accountId: 1000, debit: '5000.00', credit: '0.00' },
        { accountId: 3000, debit: '0.00', credit: '5000.00' },
      ],
    });

    expect(repository.insertJournalEntry).toHaveBeenCalledWith(
      expect.objectContaining({
        source_type: 'opening_balance',
        source_id: 42,
        journal_number: 'JRN00000042',
      }),
    );
  });
});
