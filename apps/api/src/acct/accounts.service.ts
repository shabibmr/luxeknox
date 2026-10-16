import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import {
  BusinessRuleError,
  ConflictError,
  NotFoundError,
} from '../platform/errors/app-error';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import type { Account, AccountType, NewAccount } from '../platform/db/schema/accounting';
import { AccountsRepository } from './accounts.repository';
import {
  accountFilterQuerySchema,
  type AccountCreateDto,
  type AccountDto,
  type AccountUpdateDto,
} from './accounts.dto';

const CONTROL_ACCOUNT_CODES = new Set([
  '1100',
  '1300',
  '2000',
  '2100',
  '2110',
  '2120',
  '2200',
  '2210',
  '4900',
]);

/** Starting code band per type; matches seeded CoA thousands. */
const ACCOUNT_TYPE_CODE_BASE: Record<AccountType, number> = {
  asset: 1000,
  liability: 2000,
  equity: 3000,
  income: 4000,
  expense: 5000,
};

@Injectable()
export class AccountsService {
  constructor(
    private readonly repository: AccountsRepository,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  async allocateCode(accountType: AccountType): Promise<string> {
    const base = ACCOUNT_TYPE_CODE_BASE[accountType];
    const codes = await this.repository.listCodesByAccountType(accountType);
    let max = base - 10;
    for (const code of codes) {
      if (!/^\d+$/.test(code)) continue;
      const n = Number(code);
      if (n >= base && n > max) max = n;
    }
    let next = max + 10;
    for (let i = 0; i < 100; i++) {
      const candidate = String(next);
      const existing = await this.repository.findByCode(candidate);
      if (!existing) return candidate;
      next += 10;
    }
    throw new BusinessRuleError('Unable to allocate a unique account code');
  }

  toDto(account: Account): AccountDto {
    return {
      id: account.id,
      code: account.code,
      name: account.name,
      account_type: account.account_type as AccountType,
      parent_id: account.parent_id ?? null,
      is_active: account.is_active,
      is_bank: account.is_bank,
      is_control: account.is_control,
      control_role: account.control_role ?? null,
      created_at: account.created_at,
      updated_at: account.updated_at ?? null,
    };
  }

  async list(
    rawQuery: Record<string, unknown>,
    _actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<AccountDto>> {
    const filters = accountFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findMany({
      accountType: filters.account_type,
      isActive: filters.is_active,
      search: filters.search,
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

  async getById(id: number, _actor: AuthenticatedUser): Promise<AccountDto> {
    const account = await this.repository.findById(id);
    if (!account) {
      throw new NotFoundError(`Account ${id} was not found`);
    }
    return this.toDto(account);
  }

  async create(dto: AccountCreateDto, _actor: AuthenticatedUser): Promise<AccountDto> {
    const code =
      dto.code !== undefined && dto.code.trim() !== ''
        ? dto.code.trim()
        : await this.allocateCode(dto.account_type);

    const existing = await this.repository.findByCode(code);
    if (existing) {
      throw new ConflictError(`Account with code '${code}' already exists`);
    }

    if (dto.parent_id !== null && dto.parent_id !== undefined) {
      const parent = await this.repository.findById(dto.parent_id);
      if (!parent) {
        throw new NotFoundError(`Parent account ${dto.parent_id} was not found`);
      }
    }

    const now = new Date();
    const created = await this.repository.insertAccount({
      code,
      name: dto.name,
      account_type: dto.account_type,
      parent_id: dto.parent_id ?? null,
      is_active: dto.is_active ?? true,
      is_bank: dto.is_bank ?? false,
      is_control: dto.is_control ?? false,
      control_role: dto.control_role ?? null,
      created_at: now,
      updated_at: null,
    });

    return this.toDto(created);
  }

  async update(
    id: number,
    dto: AccountUpdateDto,
    _actor: AuthenticatedUser,
  ): Promise<AccountDto> {
    const account = await this.repository.findById(id);
    if (!account) {
      throw new NotFoundError(`Account ${id} was not found`);
    }

    if (dto.parent_id !== null && dto.parent_id !== undefined) {
      if (dto.parent_id === id) {
        throw new BusinessRuleError('Account cannot be its own parent');
      }
      const parent = await this.repository.findById(dto.parent_id);
      if (!parent) {
        throw new NotFoundError(`Parent account ${dto.parent_id} was not found`);
      }
    }

    if (dto.is_active === false) {
      const isControlCode = CONTROL_ACCOUNT_CODES.has(account.code);
      if (account.is_control === true || account.control_role !== null || isControlCode) {
        throw new BusinessRuleError('Control accounts used by the system cannot be deactivated');
      }
    }

    const values: Partial<NewAccount> = {};
    if (dto.name !== undefined) values.name = dto.name;
    if (dto.parent_id !== undefined) values.parent_id = dto.parent_id;
    if (dto.is_active !== undefined) values.is_active = dto.is_active;
    if (dto.is_bank !== undefined) values.is_bank = dto.is_bank;
    values.updated_at = new Date();

    const updated = await this.repository.updateAccount(id, values);
    return this.toDto(updated);
  }
}
