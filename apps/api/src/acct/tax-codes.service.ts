import { Inject, Injectable } from '@nestjs/common';
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
import { roundMoney, toCents } from '../platform/money/money';
import { runInTransaction } from '../platform/db/transaction-context';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type {
  NewTaxCode,
  TaxCodeComponent,
} from '../platform/db/schema/accounting';
import { AccountsRepository } from './accounts.repository';
import {
  taxCodeFilterQuerySchema,
  type TaxCodeComponentDto,
  type TaxCodeComponentWriteDto,
  type TaxCodeCreateDto,
  type TaxCodeDto,
  type TaxCodeUpdateDto,
} from './tax-codes.dto';
import {
  TaxCodesRepository,
  type TaxCodeWithComponents,
} from './tax-codes.repository';

@Injectable()
export class TaxCodesService {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb<any>,
    private readonly repository: TaxCodesRepository,
    private readonly accountsRepository: AccountsRepository,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toComponentDto(component: TaxCodeComponent): TaxCodeComponentDto {
    return {
      id: component.id,
      tax_code_id: component.tax_code_id,
      name: component.name,
      rate_percent: String(component.rate_percent),
      output_account_id: component.output_account_id,
      input_account_id: component.input_account_id,
    };
  }

  toDto(taxCode: TaxCodeWithComponents): TaxCodeDto {
    return {
      id: taxCode.id,
      name: taxCode.name,
      code: taxCode.code,
      rate_percent: String(taxCode.rate_percent),
      is_active: taxCode.is_active,
      components: (taxCode.components || []).map((c) => this.toComponentDto(c)),
    };
  }

  async list(
    rawQuery: Record<string, unknown>,
    _actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<TaxCodeDto>> {
    const filters = taxCodeFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findMany({
      isActive: filters.is_active,
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

  async getById(id: number, _actor: AuthenticatedUser): Promise<TaxCodeDto> {
    const taxCode = await this.repository.findByIdWithComponents(id);
    if (!taxCode) {
      throw new NotFoundError(`Tax code ${id} was not found`);
    }
    return this.toDto(taxCode);
  }

  private async validateComponents(
    components: TaxCodeComponentWriteDto[],
    taxCodeRatePercent: string,
  ): Promise<void> {
    const componentSum = components.reduce(
      (sum, comp) => sum + toCents(comp.rate_percent),
      0n,
    );
    if (componentSum !== toCents(taxCodeRatePercent)) {
      throw new BusinessRuleError('Tax component rates must sum to the tax code rate');
    }

    if (components.length > 0) {
      const accountIds = new Set<number>();
      for (const comp of components) {
        accountIds.add(comp.output_account_id);
        accountIds.add(comp.input_account_id);
      }

      const accounts = await this.accountsRepository.findByIds(Array.from(accountIds));
      const accountsMap = new Map(accounts.map((a) => [a.id, a]));

      for (const accountId of accountIds) {
        const account = accountsMap.get(accountId);
        if (!account || !account.is_active) {
          throw new BusinessRuleError('Tax component account is invalid or inactive');
        }
      }
    }
  }

  async create(dto: TaxCodeCreateDto, _actor: AuthenticatedUser): Promise<TaxCodeDto> {
    return runInTransaction(this.db, async () => {
      const existing = await this.repository.findByCode(dto.code);
      if (existing) {
        throw new ConflictError(`Tax code with code '${dto.code}' already exists`);
      }

      const components = dto.components || [];
      await this.validateComponents(components, dto.rate_percent);

      const created = await this.repository.insertTaxCode({
        name: dto.name,
        code: dto.code,
        rate_percent: roundMoney(dto.rate_percent),
        is_active: dto.is_active ?? true,
      });

      let createdComponents: TaxCodeComponent[] = [];
      if (components.length > 0) {
        createdComponents = await this.repository.insertComponents(
          components.map((c) => ({
            tax_code_id: created.id,
            name: c.name,
            rate_percent: roundMoney(c.rate_percent),
            output_account_id: c.output_account_id,
            input_account_id: c.input_account_id,
          })),
        );
      }

      return this.toDto({ ...created, components: createdComponents });
    });
  }

  async update(
    id: number,
    dto: TaxCodeUpdateDto,
    _actor: AuthenticatedUser,
  ): Promise<TaxCodeDto> {
    return runInTransaction(this.db, async () => {
      const existing = await this.repository.findByIdWithComponents(id);
      if (!existing) {
        throw new NotFoundError(`Tax code ${id} was not found`);
      }

      const targetRatePercent =
        dto.rate_percent !== undefined
          ? roundMoney(dto.rate_percent)
          : String(existing.rate_percent);

      if (dto.components !== undefined) {
        await this.validateComponents(dto.components, targetRatePercent);
      } else if (dto.rate_percent !== undefined) {
        const existingComponentSum = (existing.components || []).reduce(
          (sum, comp) => sum + toCents(comp.rate_percent),
          0n,
        );
        if (existingComponentSum !== toCents(targetRatePercent)) {
          throw new BusinessRuleError(
            'Tax component rates must sum to the tax code rate',
          );
        }
      }

      const values: Partial<NewTaxCode> = {};
      if (dto.name !== undefined) values.name = dto.name;
      if (dto.rate_percent !== undefined) values.rate_percent = targetRatePercent;
      if (dto.is_active !== undefined) values.is_active = dto.is_active;

      if (Object.keys(values).length > 0) {
        await this.repository.updateTaxCode(id, values);
      }

      if (dto.components !== undefined) {
        await this.repository.deleteComponentsByTaxCodeId(id);
        if (dto.components.length > 0) {
          await this.repository.insertComponents(
            dto.components.map((c) => ({
              tax_code_id: id,
              name: c.name,
              rate_percent: roundMoney(c.rate_percent),
              output_account_id: c.output_account_id,
              input_account_id: c.input_account_id,
            })),
          );
        }
      }

      const updated = await this.repository.findByIdWithComponents(id);
      if (!updated) {
        throw new Error(`Failed to reload tax code ${id}`);
      }
      return this.toDto(updated);
    });
  }
}
