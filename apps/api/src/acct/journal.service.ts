import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { JournalEntry, JournalLine } from '../platform/db/schema/accounting';
import { NotFoundError } from '../platform/errors/app-error';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import { AccountingPostingService } from './accounting-posting.service';
import { AccountingRepository, type JournalEntryWithLines } from './accounting.repository';
import {
  journalFilterQuerySchema,
  type JournalCreateDto,
  type JournalDto,
  type JournalLineDto,
  type JournalReverseDto,
} from './journal.dto';

@Injectable()
export class JournalService {
  constructor(
    private readonly accountingRepository: AccountingRepository,
    private readonly postingService: AccountingPostingService,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toLineDto(line: JournalLine): JournalLineDto {
    return {
      id: line.id,
      journal_entry_id: line.journal_entry_id,
      account_id: line.account_id,
      debit: String(line.debit),
      credit: String(line.credit),
      memo: line.memo ?? null,
      member_id: line.member_id ?? null,
      vendor_id: line.vendor_id ?? null,
    };
  }

  toDto(entry: JournalEntry, lines: JournalLine[] = []): JournalDto {
    return {
      id: entry.id,
      journal_number: entry.journal_number,
      entry_date: entry.entry_date,
      accounting_period_id: entry.accounting_period_id,
      source_type: entry.source_type,
      source_id: entry.source_id,
      memo: entry.memo ?? null,
      posted_at: entry.posted_at,
      posted_by_user_id: entry.posted_by_user_id ?? null,
      reverses_journal_id: entry.reverses_journal_id ?? null,
      row_version: entry.row_version,
      lines: lines.map((line) => this.toLineDto(line)),
    };
  }

  toDtoWithLines(entry: JournalEntryWithLines): JournalDto {
    return this.toDto(entry, entry.lines);
  }

  async list(
    rawQuery: Record<string, unknown>,
    _actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<JournalDto>> {
    const filters = journalFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;
    const { rows, total } = await this.accountingRepository.findMany({
      from: filters.from,
      to: filters.to,
      sourceType: filters.source_type,
      paymentId: filters.payment_id,
      limit: pagination.limit,
      offset,
    });
    return createPaginatedResponse({
      items: rows.map((row) => this.toDto(row)),
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async getById(id: number, _actor: AuthenticatedUser): Promise<JournalDto> {
    const entry = await this.accountingRepository.findEntryWithLines(id);
    if (!entry) {
      throw new NotFoundError(`Journal entry ${id} was not found`);
    }
    return this.toDtoWithLines(entry);
  }

  async create(dto: JournalCreateDto, actor: AuthenticatedUser): Promise<JournalDto> {
    const entry = await this.postingService.postUserJournal({
      entryDate: dto.entry_date,
      sourceType: dto.source_type,
      memo: dto.memo,
      postedByUserId: actor.id,
      lines: dto.lines.map((line) => ({
        accountId: line.account_id,
        debit: line.debit,
        credit: line.credit,
        memo: line.memo,
        memberId: line.member_id,
        vendorId: line.vendor_id,
      })),
    });
    return this.toDtoWithLines(entry);
  }

  async reverse(
    id: number,
    dto: JournalReverseDto,
    actor: AuthenticatedUser,
  ): Promise<JournalDto> {
    const entry = await this.postingService.reverseJournal({
      journalId: id,
      entryDate: dto.entry_date,
      memo: dto.memo,
      postedByUserId: actor.id,
    });
    return this.toDtoWithLines(entry);
  }
}
