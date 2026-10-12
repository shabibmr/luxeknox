import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { Item, NewItem } from '../platform/db/schema/accounting';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import {
  itemFilterQuerySchema,
  type ItemCreateDto,
  type ItemDto,
  type ItemKind,
  type ItemUpdateDto,
} from './items.dto';
import { ItemsRepository } from './items.repository';

@Injectable()
export class ItemsService {
  constructor(
    private readonly repository: ItemsRepository,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toDto(row: Item): ItemDto {
    return {
      id: row.id,
      name: row.name,
      item_kind: row.item_kind as ItemKind,
      inventory_tracked: Boolean(row.inventory_tracked),
      income_account_id: row.income_account_id,
      expense_account_id: row.expense_account_id,
      tax_code_id: row.tax_code_id ?? null,
      is_active: Boolean(row.is_active),
    };
  }

  async list(
    rawQuery: Record<string, unknown>,
    _actor?: AuthenticatedUser,
  ): Promise<PaginatedResponse<ItemDto>> {
    const filters = itemFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findMany({
      itemKind: filters.item_kind,
      search: filters.search,
      isActive: filters.is_active,
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

  async getById(id: number, _actor?: AuthenticatedUser): Promise<ItemDto> {
    const item = await this.repository.findById(id);
    if (!item) {
      throw new NotFoundError(`Item ${id} was not found`);
    }
    return this.toDto(item);
  }

  private async validateIncomeAccount(accountId: number): Promise<void> {
    const account = await this.repository.findAccountById(accountId);
    if (!account) {
      throw new BusinessRuleError(`Income account ${accountId} does not exist`);
    }
    if (!account.is_active) {
      throw new BusinessRuleError(`Income account ${accountId} is inactive`);
    }
    if (account.account_type !== 'income') {
      throw new BusinessRuleError(
        `Account ${accountId} is not an income account (type: ${account.account_type})`,
      );
    }
  }

  private async validateExpenseAccount(accountId: number): Promise<void> {
    const account = await this.repository.findAccountById(accountId);
    if (!account) {
      throw new BusinessRuleError(`Expense account ${accountId} does not exist`);
    }
    if (!account.is_active) {
      throw new BusinessRuleError(`Expense account ${accountId} is inactive`);
    }
    if (account.account_type !== 'expense') {
      throw new BusinessRuleError(
        `Account ${accountId} is not an expense account (type: ${account.account_type})`,
      );
    }
  }

  private async validateTaxCode(taxCodeId: number): Promise<void> {
    const taxCode = await this.repository.findTaxCodeById(taxCodeId);
    if (!taxCode) {
      throw new BusinessRuleError(`Tax code ${taxCodeId} does not exist`);
    }
    if (!taxCode.is_active) {
      throw new BusinessRuleError(`Tax code ${taxCodeId} is inactive`);
    }
  }

  async create(dto: ItemCreateDto, _actor?: AuthenticatedUser): Promise<ItemDto> {
    if (dto.inventory_tracked === true) {
      throw new BusinessRuleError('Inventory tracking is not supported');
    }

    await this.validateIncomeAccount(dto.income_account_id);
    await this.validateExpenseAccount(dto.expense_account_id);

    if (dto.tax_code_id != null) {
      await this.validateTaxCode(dto.tax_code_id);
    }

    const created = await this.repository.insertItem({
      name: dto.name,
      item_kind: dto.item_kind,
      inventory_tracked: false,
      income_account_id: dto.income_account_id,
      expense_account_id: dto.expense_account_id,
      tax_code_id: dto.tax_code_id ?? null,
      is_active: dto.is_active ?? true,
    });

    return this.toDto(created);
  }

  async update(id: number, dto: ItemUpdateDto, _actor?: AuthenticatedUser): Promise<ItemDto> {
    const existing = await this.repository.findById(id);
    if (!existing) {
      throw new NotFoundError(`Item ${id} was not found`);
    }

    if (dto.inventory_tracked === true) {
      throw new BusinessRuleError('Inventory tracking is not supported');
    }

    if (dto.income_account_id !== undefined) {
      await this.validateIncomeAccount(dto.income_account_id);
    }

    if (dto.expense_account_id !== undefined) {
      await this.validateExpenseAccount(dto.expense_account_id);
    }

    if (dto.tax_code_id !== undefined && dto.tax_code_id !== null) {
      await this.validateTaxCode(dto.tax_code_id);
    }

    const patch: Partial<NewItem> = {
      inventory_tracked: false,
    };
    if (dto.name !== undefined) patch.name = dto.name;
    if (dto.income_account_id !== undefined) patch.income_account_id = dto.income_account_id;
    if (dto.expense_account_id !== undefined) patch.expense_account_id = dto.expense_account_id;
    if (dto.tax_code_id !== undefined) patch.tax_code_id = dto.tax_code_id ?? null;
    if (dto.is_active !== undefined) patch.is_active = dto.is_active;

    const updated = await this.repository.updateItem(id, patch);
    return this.toDto(updated);
  }
}
