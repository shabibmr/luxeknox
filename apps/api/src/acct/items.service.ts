import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { Account, Item, NewItem } from '../platform/db/schema/accounting';
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

function blankToNull(value: string | null | undefined): string | null | undefined {
  if (value == null) return value;
  const trimmed = value.trim();
  return trimmed.length === 0 ? null : trimmed;
}

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
      sku: row.sku ?? null,
      hsn_sac: row.hsn_sac ?? null,
      item_kind: row.item_kind as ItemKind,
      category_id: row.category_id ?? null,
      uom_id: row.uom_id,
      inventory_tracked: Boolean(row.inventory_tracked),
      sale_rate: row.sale_rate ?? null,
      purchase_rate: row.purchase_rate ?? null,
      reorder_level: row.reorder_level ?? null,
      income_account_id: row.income_account_id,
      expense_account_id: row.expense_account_id,
      inventory_account_id: row.inventory_account_id ?? null,
      cogs_account_id: row.cogs_account_id ?? null,
      tax_code_id: row.tax_code_id ?? null,
      is_active: Boolean(row.is_active),
      row_version: row.row_version,
      created_at: row.created_at,
      updated_at: row.updated_at ?? null,
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
    const account = await this.requireActiveAccount(accountId, 'Income');
    if (account.account_type !== 'income') {
      throw new BusinessRuleError(
        `Account ${accountId} is not an income account (type: ${account.account_type})`,
      );
    }
  }

  private async validateExpenseAccount(accountId: number): Promise<void> {
    const account = await this.requireActiveAccount(accountId, 'Expense');
    if (account.account_type !== 'expense') {
      throw new BusinessRuleError(
        `Account ${accountId} is not an expense account (type: ${account.account_type})`,
      );
    }
  }

  private async validateAssetAccount(accountId: number): Promise<void> {
    const account = await this.requireActiveAccount(accountId, 'Inventory');
    if (account.account_type !== 'asset') {
      throw new BusinessRuleError(
        `Account ${accountId} is not an asset account (type: ${account.account_type})`,
      );
    }
  }

  private async requireActiveAccount(accountId: number, label: string): Promise<Account> {
    const account = await this.repository.findAccountById(accountId);
    if (!account) {
      throw new BusinessRuleError(`${label} account ${accountId} does not exist`);
    }
    if (!account.is_active) {
      throw new BusinessRuleError(`${label} account ${accountId} is inactive`);
    }
    return account;
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

  private async validateUom(uomId: number): Promise<void> {
    const uom = await this.repository.findUomById(uomId);
    if (!uom) {
      throw new BusinessRuleError(`UOM ${uomId} does not exist`);
    }
    if (!uom.is_active) {
      throw new BusinessRuleError(`UOM ${uomId} is inactive`);
    }
  }

  private async validateCategory(categoryId: number): Promise<void> {
    const category = await this.repository.findCategoryById(categoryId);
    if (!category) {
      throw new BusinessRuleError(`Category ${categoryId} does not exist`);
    }
    if (!category.is_active) {
      throw new BusinessRuleError(`Category ${categoryId} is inactive`);
    }
  }

  private async validateSku(sku: string, exceptItemId?: number): Promise<void> {
    const existing = await this.repository.findBySku(sku);
    if (existing && existing.id !== exceptItemId) {
      throw new BusinessRuleError(`SKU ${sku} is already in use`);
    }
  }

  private trackedRule(message: string, missing: string[]): BusinessRuleError {
    return new BusinessRuleError(message, [{ rule: 'tracked_item_rules', missing }]);
  }

  private async resolveTrackedAccounts(input: {
    inventoryAccountId: number | null | undefined;
    cogsAccountId: number | null | undefined;
  }): Promise<{ inventoryAccountId: number; cogsAccountId: number }> {
    const inventoryAccountId = await this.resolveDefaultAccount(
      input.inventoryAccountId,
      '1400',
      'inventory_account_id',
    );
    await this.validateAssetAccount(inventoryAccountId);

    const cogsAccountId = await this.resolveDefaultAccount(
      input.cogsAccountId,
      '5050',
      'cogs_account_id',
    );
    await this.validateExpenseAccount(cogsAccountId);

    return { inventoryAccountId, cogsAccountId };
  }

  private async resolveDefaultAccount(
    accountId: number | null | undefined,
    code: string,
    field: string,
  ): Promise<number> {
    if (accountId != null) return accountId;
    const account = await this.repository.findAccountByCode(code);
    if (!account || !account.is_active) {
      throw this.trackedRule(`Default account ${code} was not found`, [field]);
    }
    return account.id;
  }

  async create(dto: ItemCreateDto, _actor?: AuthenticatedUser): Promise<ItemDto> {
    await this.validateUom(dto.uom_id);
    await this.validateIncomeAccount(dto.income_account_id);
    await this.validateExpenseAccount(dto.expense_account_id);

    if (dto.category_id != null) {
      await this.validateCategory(dto.category_id);
    }
    if (dto.tax_code_id != null) {
      await this.validateTaxCode(dto.tax_code_id);
    }

    const sku = blankToNull(dto.sku) ?? null;
    if (sku) await this.validateSku(sku);

    const tracked = dto.inventory_tracked === true;
    let inventoryAccountId: number | null = dto.inventory_account_id ?? null;
    let cogsAccountId: number | null = dto.cogs_account_id ?? null;

    if (tracked) {
      if (dto.item_kind !== 'goods') {
        throw this.trackedRule('A tracked item must have item_kind goods', ['item_kind']);
      }
      const resolved = await this.resolveTrackedAccounts({
        inventoryAccountId,
        cogsAccountId,
      });
      inventoryAccountId = resolved.inventoryAccountId;
      cogsAccountId = resolved.cogsAccountId;
    } else {
      if (inventoryAccountId != null) await this.validateAssetAccount(inventoryAccountId);
      if (cogsAccountId != null) await this.validateExpenseAccount(cogsAccountId);
    }

    const created = await this.repository.insertItem({
      name: dto.name,
      sku,
      hsn_sac: blankToNull(dto.hsn_sac) ?? null,
      item_kind: dto.item_kind,
      category_id: dto.category_id ?? null,
      uom_id: dto.uom_id,
      inventory_tracked: tracked,
      sale_rate: dto.sale_rate ?? null,
      purchase_rate: dto.purchase_rate ?? null,
      reorder_level: dto.reorder_level ?? null,
      income_account_id: dto.income_account_id,
      expense_account_id: dto.expense_account_id,
      inventory_account_id: inventoryAccountId,
      cogs_account_id: cogsAccountId,
      tax_code_id: dto.tax_code_id ?? null,
      is_active: dto.is_active ?? true,
      created_at: new Date(),
    });

    return this.toDto(created);
  }

  async update(id: number, dto: ItemUpdateDto, _actor?: AuthenticatedUser): Promise<ItemDto> {
    const existing = await this.repository.findById(id);
    if (!existing) {
      throw new NotFoundError(`Item ${id} was not found`);
    }

    if (dto.uom_id !== undefined) await this.validateUom(dto.uom_id);
    if (dto.income_account_id !== undefined) await this.validateIncomeAccount(dto.income_account_id);
    if (dto.expense_account_id !== undefined) await this.validateExpenseAccount(dto.expense_account_id);
    if (dto.category_id != null) await this.validateCategory(dto.category_id);
    if (dto.tax_code_id != null) await this.validateTaxCode(dto.tax_code_id);

    const sku = dto.sku === undefined ? undefined : blankToNull(dto.sku);
    if (sku) await this.validateSku(sku, id);

    const tracked = dto.inventory_tracked ?? Boolean(existing.inventory_tracked);
    const itemKind = existing.item_kind;
    let inventoryAccountId =
      dto.inventory_account_id !== undefined
        ? dto.inventory_account_id
        : existing.inventory_account_id;
    let cogsAccountId =
      dto.cogs_account_id !== undefined ? dto.cogs_account_id : existing.cogs_account_id;
    const accountsTouched =
      dto.inventory_tracked === true ||
      dto.inventory_account_id !== undefined ||
      dto.cogs_account_id !== undefined;

    if (tracked && accountsTouched) {
      if (itemKind !== 'goods') {
        throw this.trackedRule('A tracked item must have item_kind goods', ['item_kind']);
      }
      const resolved = await this.resolveTrackedAccounts({
        inventoryAccountId,
        cogsAccountId,
      });
      inventoryAccountId = resolved.inventoryAccountId;
      cogsAccountId = resolved.cogsAccountId;
    } else if (!tracked) {
      if (dto.inventory_account_id != null) await this.validateAssetAccount(dto.inventory_account_id);
      if (dto.cogs_account_id != null) await this.validateExpenseAccount(dto.cogs_account_id);
    }

    const patch: Partial<NewItem> = { row_version: existing.row_version + 1 };
    if (dto.name !== undefined) patch.name = dto.name;
    if (sku !== undefined) patch.sku = sku;
    if (dto.hsn_sac !== undefined) patch.hsn_sac = blankToNull(dto.hsn_sac) ?? null;
    if (dto.category_id !== undefined) patch.category_id = dto.category_id;
    if (dto.uom_id !== undefined) patch.uom_id = dto.uom_id;
    if (dto.sale_rate !== undefined) patch.sale_rate = dto.sale_rate;
    if (dto.purchase_rate !== undefined) patch.purchase_rate = dto.purchase_rate;
    if (dto.reorder_level !== undefined) patch.reorder_level = dto.reorder_level;
    if (dto.income_account_id !== undefined) patch.income_account_id = dto.income_account_id;
    if (dto.expense_account_id !== undefined) patch.expense_account_id = dto.expense_account_id;
    if (dto.tax_code_id !== undefined) patch.tax_code_id = dto.tax_code_id;
    if (dto.is_active !== undefined) patch.is_active = dto.is_active;
    if (dto.inventory_tracked !== undefined) patch.inventory_tracked = tracked;
    if (dto.inventory_account_id !== undefined || dto.inventory_tracked === true) {
      patch.inventory_account_id = inventoryAccountId;
    }
    if (dto.cogs_account_id !== undefined || dto.inventory_tracked === true) {
      patch.cogs_account_id = cogsAccountId;
    }

    const updated = await this.repository.updateItem(id, patch);
    return this.toDto(updated);
  }
}
