import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { JournalController } from './journal.controller';
import type { JournalDto } from './journal.dto';
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

const JOURNAL: JournalDto = {
  id: 50,
  journal_number: 'JRN00000001',
  entry_date: '2026-04-15',
  accounting_period_id: 7,
  source_type: 'manual',
  source_id: 1,
  memo: 'Adjust rent',
  posted_at: new Date('2026-04-15T10:00:00.000Z'),
  posted_by_user_id: 1,
  reverses_journal_id: null,
  row_version: 1,
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

describe('JournalController', () => {
  let service: Partial<JournalService>;
  let controller: JournalController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({ data: [JOURNAL], meta: {} }),
      getById: vi.fn().mockResolvedValue(JOURNAL),
      create: vi.fn().mockResolvedValue(JOURNAL),
      reverse: vi.fn().mockResolvedValue({ ...JOURNAL, id: 51, source_type: 'journal_reversal' }),
    };
    controller = new JournalController(service as JournalService);
  });

  it('requires accounting.read on GET /accounting/journals and delegates', async () => {
    expect(Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, JournalController.prototype.list)).toEqual([
      'accounting.read',
    ]);

    const query = { from: '2026-04-01' };
    const result = await controller.list(query, ADMIN_USER);

    expect(service.list).toHaveBeenCalledWith(query, ADMIN_USER);
    expect(result.data).toEqual([JOURNAL]);
  });

  it('requires accounting.journals_write on POST /accounting/journals and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, JournalController.prototype.create),
    ).toEqual(['accounting.journals_write']);

    const dto = {
      entry_date: '2026-04-15',
      source_type: 'manual' as const,
      lines: [
        { account_id: 5000, debit: '100.00' },
        { account_id: 1000, credit: '100.00' },
      ],
    };
    const result = await controller.create(dto, ADMIN_USER);

    expect(service.create).toHaveBeenCalledWith(dto, ADMIN_USER);
    expect(result).toEqual(JOURNAL);
  });

  it('requires accounting.read on GET /accounting/journals/:id and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, JournalController.prototype.getById),
    ).toEqual(['accounting.read']);

    const result = await controller.getById(50, ADMIN_USER);

    expect(service.getById).toHaveBeenCalledWith(50, ADMIN_USER);
    expect(result).toEqual(JOURNAL);
  });

  it('requires accounting.journals_write on POST /accounting/journals/:id/reverse and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, JournalController.prototype.reverse),
    ).toEqual(['accounting.journals_write']);

    const dto = { entry_date: '2026-04-16' };
    const result = await controller.reverse(50, dto, ADMIN_USER);

    expect(service.reverse).toHaveBeenCalledWith(50, dto, ADMIN_USER);
    expect(result.id).toBe(51);
  });
});
