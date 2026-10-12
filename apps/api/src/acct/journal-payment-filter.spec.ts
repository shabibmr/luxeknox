import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { JournalEntry } from '../platform/db/schema/accounting';
import type { PaginationHelper } from '../platform/http/pagination';
import type { AccountingPostingService } from './accounting-posting.service';
import type { AccountingRepository } from './accounting.repository';
import { JournalService } from './journal.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 42,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

describe('ACC-076: Journal list filter by payment_id', () => {
  let accountingRepository: {
    findMany: ReturnType<typeof vi.fn>;
    listLines: ReturnType<typeof vi.fn>;
    findEntryWithLines: ReturnType<typeof vi.fn>;
  };
  let postingService: Record<string, ReturnType<typeof vi.fn>>;
  let paginationHelper: { normalizeParams: ReturnType<typeof vi.fn> };
  let service: JournalService;

  const mockInvoiceJournal: JournalEntry = {
    id: 1,
    journal_number: 'JRN00000001',
    entry_date: '2026-04-10',
    accounting_period_id: 1,
    source_type: 'sales_invoice',
    source_id: 99,
    memo: 'Member sales invoice INV-99',
    posted_at: new Date('2026-04-10T10:00:00Z'),
    posted_by_user_id: 42,
    reverses_journal_id: null,
    row_version: 1,
  };

  const mockReceiptJournal: JournalEntry = {
    id: 2,
    journal_number: 'JRN00000002',
    entry_date: '2026-04-10',
    accounting_period_id: 1,
    source_type: 'sales_receipt',
    source_id: 150,
    memo: 'Collection for INV-99',
    posted_at: new Date('2026-04-10T10:05:00Z'),
    posted_by_user_id: 42,
    reverses_journal_id: null,
    row_version: 1,
  };

  const mockCreditNoteJournal: JournalEntry = {
    id: 3,
    journal_number: 'JRN00000003',
    entry_date: '2026-04-12',
    accounting_period_id: 1,
    source_type: 'credit_note',
    source_id: 20,
    memo: 'Refund credit note for INV-99',
    posted_at: new Date('2026-04-12T11:00:00Z'),
    posted_by_user_id: 42,
    reverses_journal_id: null,
    row_version: 1,
  };

  const mockAdjustmentJournal: JournalEntry = {
    id: 4,
    journal_number: 'JRN00000004',
    entry_date: '2026-04-15',
    accounting_period_id: 1,
    source_type: 'sales_adjustment',
    source_id: 155,
    memo: 'Adjustment for INV-99',
    posted_at: new Date('2026-04-15T12:00:00Z'),
    posted_by_user_id: 42,
    reverses_journal_id: null,
    row_version: 1,
  };

  const mockRecognitionJournal: JournalEntry = {
    id: 5,
    journal_number: 'JRN00000005',
    entry_date: '2026-04-30',
    accounting_period_id: 1,
    source_type: 'revenue_recognition',
    source_id: 301,
    memo: 'Revenue recognition month 1 for INV-99',
    posted_at: new Date('2026-04-30T23:59:00Z'),
    posted_by_user_id: 42,
    reverses_journal_id: null,
    row_version: 1,
  };

  beforeEach(() => {
    accountingRepository = {
      findMany: vi.fn(),
      listLines: vi.fn().mockResolvedValue([]),
      findEntryWithLines: vi.fn(),
    };
    postingService = {};
    paginationHelper = {
      normalizeParams: vi.fn().mockResolvedValue({ limit: 20, offset: 0 }),
    };

    service = new JournalService(
      accountingRepository as unknown as AccountingRepository,
      postingService as unknown as AccountingPostingService,
      paginationHelper as unknown as PaginationHelper,
    );
  });

  it('filters journals by payment_id and returns invoice, receipt, credit note, adjustment, recognition journals', async () => {
    accountingRepository.findMany.mockResolvedValue({
      rows: [
        mockInvoiceJournal,
        mockReceiptJournal,
        mockCreditNoteJournal,
        mockAdjustmentJournal,
        mockRecognitionJournal,
      ],
      total: 5,
    });

    const result = await service.list({ payment_id: '99', limit: '20', offset: '0' }, ADMIN_USER);

    expect(accountingRepository.findMany).toHaveBeenCalledWith({
      from: undefined,
      to: undefined,
      sourceType: undefined,
      paymentId: 99,
      limit: 20,
      offset: 0,
    });

    expect(result.data).toHaveLength(5);
    const sourceTypes = result.data.map((j) => j.source_type);
    expect(sourceTypes).toEqual([
      'sales_invoice',
      'sales_receipt',
      'credit_note',
      'sales_adjustment',
      'revenue_recognition',
    ]);
  });

  it('returns empty list when no journals match payment_id', async () => {
    accountingRepository.findMany.mockResolvedValue({
      rows: [],
      total: 0,
    });

    const result = await service.list({ payment_id: '9999' }, ADMIN_USER);

    expect(accountingRepository.findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        paymentId: 9999,
      }),
    );
    expect(result.data).toHaveLength(0);
    expect(result.meta.total).toBe(0);
  });
});
