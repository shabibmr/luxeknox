import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { FundTransfer, NewFundTransfer } from '../platform/db/schema/accounting';
import { runInTransaction } from '../platform/db/transaction-context';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import { cmpMoney, fromCents, roundMoney, toCents } from '../platform/money/money';
import { AccountingPostingService, type PostJournalLineInput } from './accounting-posting.service';
import { AccountsRepository } from './accounts.repository';
import {
  fundTransferFilterQuerySchema,
  type FundTransferCreateDto,
  type FundTransferDto,
  type FundTransferUpdateDto,
} from './fund-transfers.dto';
import { FundTransfersRepository } from './fund-transfers.repository';

const BANK_CHARGES_ACCOUNT_CODE = '5500';

@Injectable()
export class FundTransfersService {
  constructor(
    private readonly repository: FundTransfersRepository,
    private readonly postingService: AccountingPostingService,
    private readonly accountsRepository: AccountsRepository,
    @Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb<any>,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toDto(transfer: FundTransfer): FundTransferDto {
    return {
      id: transfer.id,
      transfer_number: transfer.transfer_number,
      transfer_date: transfer.transfer_date,
      from_account_id: transfer.from_account_id,
      to_account_id: transfer.to_account_id,
      amount: String(transfer.amount),
      fee_amount: String(transfer.fee_amount),
      fee_account_id: transfer.fee_account_id ?? null,
      memo: transfer.memo ?? null,
      status: transfer.status as 'draft' | 'posted',
      journal_entry_id: transfer.journal_entry_id ?? null,
      row_version: transfer.row_version,
      created_at: transfer.created_at,
      updated_at: transfer.updated_at ?? null,
    };
  }

  async getById(id: number, _actor?: AuthenticatedUser): Promise<FundTransferDto> {
    const transfer = await this.repository.findById(id);
    if (!transfer) {
      throw new NotFoundError(`Fund transfer ${id} not found`);
    }
    return this.toDto(transfer);
  }

  async list(
    rawQuery: Record<string, unknown>,
    _actor?: AuthenticatedUser,
  ): Promise<PaginatedResponse<FundTransferDto>> {
    const filters = fundTransferFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findMany({
      status: filters.status,
      from: filters.from,
      to: filters.to,
      accountId: filters.account_id,
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

  async create(
    dto: FundTransferCreateDto,
    _currentUser?: AuthenticatedUser,
  ): Promise<FundTransferDto> {
    return runInTransaction(this.db, async () => {
      const fee = await this.resolveFee(
        dto.from_account_id,
        dto.to_account_id,
        dto.amount,
        dto.fee_amount ?? '0.00',
        dto.fee_account_id ?? null,
      );

      const transferNumber = await this.repository.allocateFundTransferNumber();
      const created = await this.repository.insertTransfer({
        transfer_number: transferNumber,
        transfer_date: dto.transfer_date,
        from_account_id: dto.from_account_id,
        to_account_id: dto.to_account_id,
        amount: roundMoney(dto.amount),
        fee_amount: fee.amount,
        fee_account_id: fee.accountId,
        memo: dto.memo ?? null,
        status: 'draft',
        journal_entry_id: null,
        row_version: 1,
        created_at: new Date(),
        updated_at: null,
      });
      return this.toDto(created);
    });
  }

  async update(
    id: number,
    dto: FundTransferUpdateDto,
    _currentUser?: AuthenticatedUser,
  ): Promise<FundTransferDto> {
    return runInTransaction(this.db, async () => {
      const transfer = await this.repository.findById(id);
      if (!transfer) {
        throw new NotFoundError(`Fund transfer ${id} not found`);
      }
      if (transfer.status !== 'draft') {
        throw new BusinessRuleError('Only draft fund transfers can be edited');
      }

      const fromAccountId = dto.from_account_id ?? transfer.from_account_id;
      const toAccountId = dto.to_account_id ?? transfer.to_account_id;
      const amount = dto.amount !== undefined ? roundMoney(dto.amount) : String(transfer.amount);
      const feeAmount =
        dto.fee_amount !== undefined ? roundMoney(dto.fee_amount) : String(transfer.fee_amount);
      const feeAccountId =
        dto.fee_account_id !== undefined ? dto.fee_account_id : (transfer.fee_account_id ?? null);

      const fee = await this.resolveFee(fromAccountId, toAccountId, amount, feeAmount, feeAccountId);

      const patch: Partial<NewFundTransfer> = {
        from_account_id: fromAccountId,
        to_account_id: toAccountId,
        amount,
        fee_amount: fee.amount,
        fee_account_id: fee.accountId,
        row_version: transfer.row_version + 1,
        updated_at: new Date(),
      };
      if (dto.transfer_date !== undefined) patch.transfer_date = dto.transfer_date;
      if (dto.memo !== undefined) patch.memo = dto.memo;

      const updated = await this.repository.updateTransfer(transfer.id, patch);
      return this.toDto(updated);
    });
  }

  async post(id: number, currentUser?: AuthenticatedUser): Promise<FundTransferDto> {
    const existing = await this.repository.findById(id);
    if (!existing) {
      throw new NotFoundError(`Fund transfer ${id} not found`);
    }
    if (existing.status === 'posted') {
      return this.toDto(existing);
    }
    if (existing.status !== 'draft') {
      throw new BusinessRuleError('Only draft fund transfers can be posted');
    }

    return runInTransaction(this.db, async () => {
      const transfer = await this.repository.findById(id);
      if (!transfer) {
        throw new NotFoundError(`Fund transfer ${id} not found`);
      }
      if (transfer.status === 'posted') {
        return this.toDto(transfer);
      }
      if (transfer.status !== 'draft') {
        throw new BusinessRuleError('Only draft fund transfers can be posted');
      }

      // Accounts may have changed since the draft was saved.
      const fee = await this.resolveFee(
        transfer.from_account_id,
        transfer.to_account_id,
        String(transfer.amount),
        String(transfer.fee_amount),
        transfer.fee_account_id ?? null,
      );

      const grossCents = toCents(transfer.amount);
      const feeCents = toCents(fee.amount);
      const memo = transfer.memo ?? `Fund transfer ${transfer.transfer_number}`;

      const lines: PostJournalLineInput[] = [
        {
          accountId: transfer.to_account_id,
          debit: fromCents(grossCents - feeCents),
          memo,
        },
      ];
      if (feeCents > 0n && fee.accountId !== null) {
        lines.push({
          accountId: fee.accountId,
          debit: fee.amount,
          memo: `Fee on ${transfer.transfer_number}`,
        });
      }
      lines.push({
        accountId: transfer.from_account_id,
        credit: fromCents(grossCents),
        memo,
      });

      const journal = await this.postingService.postJournal({
        entryDate: transfer.transfer_date,
        sourceType: 'fund_transfer',
        sourceId: transfer.id,
        memo,
        postedByUserId: currentUser?.id ?? null,
        lines,
      });

      const updated = await this.repository.updateTransfer(transfer.id, {
        status: 'posted',
        journal_entry_id: journal.id,
        row_version: transfer.row_version + 1,
        updated_at: new Date(),
      });
      return this.toDto(updated);
    });
  }

  /**
   * Validates both accounts and the fee, and returns the normalised fee.
   * A zero fee clears the fee account; a positive fee defaults to 5500.
   */
  private async resolveFee(
    fromAccountId: number,
    toAccountId: number,
    amount: string,
    feeAmount: string,
    feeAccountId: number | null,
  ): Promise<{ amount: string; accountId: number | null }> {
    if (fromAccountId === toAccountId) {
      throw new BusinessRuleError('Source and destination accounts must differ');
    }
    await this.validateBankAccount(fromAccountId, 'Source');
    await this.validateBankAccount(toAccountId, 'Destination');

    const fee = roundMoney(feeAmount);
    if (cmpMoney(fee, '0.00') < 0) {
      throw new BusinessRuleError('Fee cannot be negative');
    }
    if (cmpMoney(fee, '0.00') === 0) {
      return { amount: '0.00', accountId: null };
    }
    if (cmpMoney(fee, amount) >= 0) {
      throw new BusinessRuleError('Fee must be less than the transfer amount');
    }

    let resolvedId = feeAccountId;
    if (resolvedId === null) {
      const defaultAccount = await this.accountsRepository.findByCode(BANK_CHARGES_ACCOUNT_CODE);
      if (!defaultAccount) {
        throw new BusinessRuleError('Bank and processor charges account (5500) not found');
      }
      resolvedId = defaultAccount.id;
    }

    const feeAccount = await this.accountsRepository.findById(resolvedId);
    if (!feeAccount) {
      throw new NotFoundError(`Fee account ${resolvedId} not found`);
    }
    if (!feeAccount.is_active) {
      throw new BusinessRuleError(`Fee account ${resolvedId} is inactive`);
    }
    return { amount: fee, accountId: resolvedId };
  }

  private async validateBankAccount(accountId: number, label: string): Promise<void> {
    const account = await this.accountsRepository.findById(accountId);
    if (!account) {
      throw new NotFoundError(`${label} account ${accountId} not found`);
    }
    if (!account.is_active) {
      throw new BusinessRuleError(`${label} account ${accountId} is inactive`);
    }
    if (!account.is_bank) {
      throw new BusinessRuleError(`${label} account ${accountId} is not a bank or cash account`);
    }
  }
}
