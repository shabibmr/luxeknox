import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DebitNote } from '../platform/db/schema/accounting';
import { runInTransaction } from '../platform/db/transaction-context';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import {
  addMoney,
  cmpMoney,
  fromCents,
  mulMoneyPercent,
  subMoney,
  toCents,
} from '../platform/money/money';
import { AccountingPostingService, type PostJournalLineInput } from './accounting-posting.service';
import { AccountsRepository } from './accounts.repository';
import {
  debitNoteFilterQuerySchema,
  type DebitNoteCreateDto,
  type DebitNoteDto,
  type DebitNoteStatus,
} from './debit-notes.dto';
import { DebitNotesRepository } from './debit-notes.repository';
import { PurchaseBillsRepository } from './purchase-bills.repository';
import { TaxCodesRepository } from './tax-codes.repository';

@Injectable()
export class DebitNotesService {
  constructor(
    private readonly repository: DebitNotesRepository,
    private readonly purchaseBillsRepository: PurchaseBillsRepository,
    private readonly accountingPostingService: AccountingPostingService,
    private readonly accountsRepository: AccountsRepository,
    private readonly taxCodesRepository: TaxCodesRepository,
    @Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb<any>,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toDto(row: DebitNote): DebitNoteDto {
    return {
      id: row.id,
      debit_note_number: row.debit_note_number,
      purchase_bill_id: row.purchase_bill_id,
      debit_note_date: row.debit_note_date,
      reason: row.reason ?? null,
      subtotal: String(row.subtotal),
      tax_amount: String(row.tax_amount),
      total_amount: String(row.total_amount),
      status: row.status as DebitNoteStatus,
      journal_entry_id: row.journal_entry_id ?? null,
      row_version: row.row_version,
      created_at: row.created_at,
      updated_at: row.updated_at ?? null,
    };
  }

  /** Open balance = bill total - posted debit notes - posted payment allocations (same as the AP report). */
  private async openBillBalance(bill: { id: number; total_amount: string }): Promise<string> {
    const postedDebitNotes = await this.repository.sumPostedDebitNotesForBill(bill.id);
    const postedAllocations = await this.repository.sumPostedAllocationsForBill(bill.id);
    return subMoney(subMoney(bill.total_amount, postedDebitNotes), postedAllocations);
  }

  async create(
    dto: DebitNoteCreateDto,
    _currentUser?: AuthenticatedUser,
  ): Promise<DebitNoteDto> {
    const bill = await this.purchaseBillsRepository.findById(dto.purchase_bill_id);
    if (!bill) {
      throw new NotFoundError(`Purchase bill ${dto.purchase_bill_id} was not found`);
    }

    if (bill.status !== 'posted') {
      throw new BusinessRuleError('Debit notes can only be issued against posted purchase bills');
    }

    let taxAmount = '0.00';
    if (dto.tax_code_id != null) {
      const taxCode = await this.taxCodesRepository.findById(dto.tax_code_id);
      if (!taxCode) {
        throw new NotFoundError(`Tax code ${dto.tax_code_id} was not found`);
      }
      if (!taxCode.is_active) {
        throw new BusinessRuleError('Tax code is inactive');
      }
      taxAmount = mulMoneyPercent(dto.amount, taxCode.rate_percent);
    }
    const totalAmount = addMoney(dto.amount, taxAmount);

    const openBalance = await this.openBillBalance(bill);

    if (cmpMoney(totalAmount, openBalance) > 0) {
      throw new BusinessRuleError(
        `Debit note amount (${totalAmount}) exceeds open bill balance (${openBalance})`,
      );
    }

    return runInTransaction(this.db, async () => {
      const debitNoteNumber = await this.repository.allocateDebitNoteNumber();

      const created = await this.repository.insertDebitNote({
        debit_note_number: debitNoteNumber,
        purchase_bill_id: bill.id,
        debit_note_date: dto.debit_note_date,
        reason: dto.reason ?? null,
        subtotal: dto.amount,
        tax_amount: taxAmount,
        total_amount: totalAmount,
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
      });

      return this.toDto(created);
    });
  }

  async post(id: number, currentUser?: AuthenticatedUser): Promise<DebitNoteDto> {
    const debitNote = await this.repository.findById(id);
    if (!debitNote) {
      throw new NotFoundError(`Debit note ${id} was not found`);
    }

    if (debitNote.status === 'posted') {
      return this.toDto(debitNote);
    }

    if (debitNote.status === 'void') {
      throw new BusinessRuleError('Void debit notes cannot be posted');
    }

    if (debitNote.status !== 'draft') {
      throw new BusinessRuleError(`Debit note with status "${debitNote.status}" cannot be posted`);
    }

    return runInTransaction(this.db, async () => {
      const bill = await this.purchaseBillsRepository.findWithLines(debitNote.purchase_bill_id);
      if (!bill) {
        throw new NotFoundError(`Referenced purchase bill ${debitNote.purchase_bill_id} was not found`);
      }

      if (bill.status !== 'posted') {
        throw new BusinessRuleError('Referenced purchase bill is not posted');
      }

      if (!bill.lines || bill.lines.length === 0) {
        throw new BusinessRuleError('Referenced purchase bill has no lines');
      }

      const openBalance = await this.openBillBalance(bill);

      if (cmpMoney(debitNote.total_amount, openBalance) > 0) {
        throw new BusinessRuleError(
          `Debit note amount (${debitNote.total_amount}) exceeds open bill balance (${openBalance})`,
        );
      }

      let apAcc = await this.accountsRepository.findByControlRole('ap');
      if (!apAcc) {
        apAcc = await this.accountsRepository.findByCode('2000');
      }
      if (!apAcc) {
        throw new BusinessRuleError(
          'Accounts payable control account (ap / 2000) not found',
        );
      }
      const apAccountId = apAcc.id;

      let inputTaxAccountId: number | null = null;
      if (cmpMoney(debitNote.tax_amount, '0.00') > 0) {
        let inputTaxAcc = await this.accountsRepository.findByControlRole('input_tax');
        if (!inputTaxAcc) {
          inputTaxAcc = await this.accountsRepository.findByCode('1300');
        }
        if (!inputTaxAcc) {
          throw new BusinessRuleError(
            'Input tax control account (input_tax / 1300) not found',
          );
        }
        inputTaxAccountId = inputTaxAcc.id;
      }

      const journalLines: PostJournalLineInput[] = [];

      // DR Accounts Payable for total_amount
      journalLines.push({
        accountId: apAccountId,
        debit: debitNote.total_amount,
        credit: '0.00',
        memo: `Debit note ${debitNote.debit_note_number} for bill ${bill.bill_number}`,
        vendorId: bill.vendor_id,
      });

      // CR Input Tax for tax_amount
      if (cmpMoney(debitNote.tax_amount, '0.00') > 0 && inputTaxAccountId != null) {
        journalLines.push({
          accountId: inputTaxAccountId,
          debit: '0.00',
          credit: debitNote.tax_amount,
          memo: `Input tax reversal for debit note ${debitNote.debit_note_number}`,
          vendorId: bill.vendor_id,
        });
      }

      // CR line accounts for debitNote.subtotal
      if (bill.lines.length === 1) {
        journalLines.push({
          accountId: bill.lines[0].account_id,
          debit: '0.00',
          credit: debitNote.subtotal,
          memo: bill.lines[0].description ?? `Debit note ${debitNote.debit_note_number} line reduction`,
          vendorId: bill.vendor_id,
        });
      } else {
        const dnSubtotalCents = toCents(debitNote.subtotal);
        const billSubtotalCents = toCents(bill.subtotal);
        let allocatedCents = 0n;

        for (let i = 0; i < bill.lines.length; i++) {
          const line = bill.lines[i];
          const isLast = i === bill.lines.length - 1;
          let lineCreditCents: bigint;

          if (isLast) {
            lineCreditCents = dnSubtotalCents - allocatedCents;
          } else {
            if (billSubtotalCents > 0n) {
              const lineNetCents = toCents(line.net_amount);
              const num = dnSubtotalCents * lineNetCents;
              const half = billSubtotalCents / 2n;
              lineCreditCents = (num + half) / billSubtotalCents;
            } else {
              lineCreditCents = 0n;
            }
            allocatedCents += lineCreditCents;
          }

          if (lineCreditCents > 0n) {
            journalLines.push({
              accountId: line.account_id,
              debit: '0.00',
              credit: fromCents(lineCreditCents),
              memo: line.description ?? `Debit note ${debitNote.debit_note_number} line reduction`,
              vendorId: bill.vendor_id,
            });
          }
        }
      }

      const journal = await this.accountingPostingService.postJournal({
        entryDate: debitNote.debit_note_date,
        sourceType: 'debit_note',
        sourceId: debitNote.id,
        memo: `Debit note ${debitNote.debit_note_number} for bill ${bill.bill_number}`,
        postedByUserId: currentUser?.id ?? null,
        lines: journalLines,
      });

      const updated = await this.repository.updateDebitNote(debitNote.id, {
        status: 'posted',
        journal_entry_id: journal.id,
        row_version: debitNote.row_version + 1,
        updated_at: new Date(),
      });

      return this.toDto(updated);
    });
  }

  async getById(id: number, _currentUser?: AuthenticatedUser): Promise<DebitNoteDto> {
    const debitNote = await this.repository.findById(id);
    if (!debitNote) {
      throw new NotFoundError(`Debit note ${id} was not found`);
    }
    return this.toDto(debitNote);
  }

  async list(
    rawQuery: Record<string, unknown>,
    _currentUser?: AuthenticatedUser,
  ): Promise<PaginatedResponse<DebitNoteDto>> {
    const filters = debitNoteFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findMany({
      status: filters.status,
      purchaseBillId: filters.purchase_bill_id,
      from: filters.from,
      to: filters.to,
      search: filters.search,
      limit: pagination.limit,
      offset,
    });

    return createPaginatedResponse({
      items: rows.map((r) => this.toDto(r)),
      limit: pagination.limit,
      offset,
      total,
    });
  }
}
