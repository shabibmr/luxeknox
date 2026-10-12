import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { DebitNotesController } from './debit-notes.controller';
import type { DebitNoteCreateDto, DebitNoteDto } from './debit-notes.dto';
import { DebitNotesService } from './debit-notes.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const SAMPLE_DEBIT_NOTE_DTO: DebitNoteDto = {
  id: 5,
  debit_note_number: 'DN00000005',
  purchase_bill_id: 10,
  debit_note_date: '2026-04-20',
  reason: 'Damaged item return',
  subtotal: '50.00',
  tax_amount: '9.00',
  total_amount: '59.00',
  status: 'draft',
  journal_entry_id: null,
  row_version: 1,
  created_at: new Date('2026-04-20T10:00:00.000Z'),
  updated_at: null,
};

describe('DebitNotesController', () => {
  let service: Partial<DebitNotesService>;
  let controller: DebitNotesController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({
        data: [SAMPLE_DEBIT_NOTE_DTO],
        meta: { limit: 20, offset: 0, cursor: null, next_cursor: null, has_more: false, total: 1 },
      }),
      getById: vi.fn().mockResolvedValue(SAMPLE_DEBIT_NOTE_DTO),
      create: vi.fn().mockResolvedValue(SAMPLE_DEBIT_NOTE_DTO),
      post: vi.fn().mockResolvedValue({ ...SAMPLE_DEBIT_NOTE_DTO, status: 'posted', journal_entry_id: 101 }),
    };
    controller = new DebitNotesController(service as DebitNotesService);
  });

  it('declares accounting.read on list', () => {
    const meta = Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, DebitNotesController.prototype.list);
    expect(meta).toEqual(['accounting.read']);
  });

  it('declares accounting.purchases_write on create', () => {
    const meta = Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, DebitNotesController.prototype.create);
    expect(meta).toEqual(['accounting.purchases_write']);
  });

  it('declares accounting.read on getById', () => {
    const meta = Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, DebitNotesController.prototype.getById);
    expect(meta).toEqual(['accounting.read']);
  });

  it('declares accounting.purchases_write on post', () => {
    const meta = Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, DebitNotesController.prototype.post);
    expect(meta).toEqual(['accounting.purchases_write']);
  });

  it('delegates list to service.list', async () => {
    const res = await controller.list({ purchase_bill_id: 10 }, ADMIN_USER);
    expect(service.list).toHaveBeenCalledWith({ purchase_bill_id: 10 }, ADMIN_USER);
    expect(res.data).toHaveLength(1);
  });

  it('delegates getById to service.getById', async () => {
    const res = await controller.getById(5, ADMIN_USER);
    expect(service.getById).toHaveBeenCalledWith(5, ADMIN_USER);
    expect(res.id).toBe(5);
  });

  it('delegates create to service.create', async () => {
    const dto: DebitNoteCreateDto = {
      purchase_bill_id: 10,
      debit_note_date: '2026-04-20',
      subtotal: '50.00',
      tax_amount: '9.00',
      reason: 'Damaged item return',
    };
    const res = await controller.create(dto, ADMIN_USER);
    expect(service.create).toHaveBeenCalledWith(dto, ADMIN_USER);
    expect(res.debit_note_number).toBe('DN00000005');
  });

  it('delegates post to service.post', async () => {
    const res = await controller.post(5, ADMIN_USER);
    expect(service.post).toHaveBeenCalledWith(5, ADMIN_USER);
    expect(res.status).toBe('posted');
    expect(res.journal_entry_id).toBe(101);
  });
});
