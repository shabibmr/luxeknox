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

@Injectable()
export class AccountsService {
  constructor(
    private readonly repository: AccountsRepository,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toDto(account: Account): AccountDto {
    return {
      id: account.id,
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
    const existing = await this.repository.findByName(dto.name);
    if (existing) {
      throw new ConflictError(`Account with name '${dto.name}' already exists`);
    }

    if (dto.parent_id !== null && dto.parent_id !== undefined) {
      const parent = await this.repository.findById(dto.parent_id);
      if (!parent) {
        throw new NotFoundError(`Parent account ${dto.parent_id} was not found`);
      }
    }

    const now = new Date();
    const created = await this.repository.insertAccount({
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
      if (account.is_control === true || account.control_role !== null) {
        throw new BusinessRuleError('Control accounts used by the system cannot be deactivated');
      }
    }

    if (dto.name !== undefined && dto.name !== account.name) {
      const conflict = await this.repository.findByName(dto.name);
      if (conflict && conflict.id !== id) {
        throw new ConflictError(`Account with name '${dto.name}' already exists`);
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
