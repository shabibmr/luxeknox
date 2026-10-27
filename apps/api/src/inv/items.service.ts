import { Injectable } from '@nestjs/common';
import { TaxCodesRepository } from '../acct/tax-codes.repository';
import { mapItemDto } from '../acct/items.mapper';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { NotFoundError } from '../platform/errors/app-error';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import {
  inventoryItemFilterQuerySchema,
  type InventoryItemDto,
} from './items.dto';
import { InventoryItemsRepository, type InventoryItemRow } from './items.repository';
import { StockRepository } from './stock.repository';

@Injectable()
export class InventoryItemsService {
  constructor(
    private readonly repository: InventoryItemsRepository,
    private readonly stockRepository: StockRepository,
    private readonly taxCodesRepository: TaxCodesRepository,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toDto(
    row: InventoryItemRow,
    hasMovements: boolean,
    extras: { taxRatePercent: string | null; qtyOnHand: string | null },
  ): InventoryItemDto {
    return {
      ...mapItemDto(row),
      category_name: row.category_name ?? null,
      uom_code: row.uom_code,
      uom_decimal_places: Number(row.uom_decimal_places),
      has_movements: hasMovements,
      tax_rate_percent: extras.taxRatePercent,
      qty_on_hand: extras.qtyOnHand,
    };
  }

  private async enrichRows(rows: InventoryItemRow[]): Promise<InventoryItemDto[]> {
    const withMovements = await this.stockRepository.findItemIdsWithMovements(
      rows.map((row) => row.id),
    );
    const trackedIds = rows.filter((row) => row.inventory_tracked).map((row) => row.id);
    const taxIds = [
      ...new Set(
        rows
          .map((row) => row.tax_code_id)
          .filter((id): id is number => id != null),
      ),
    ];
    const [qtys, rates] = await Promise.all([
      this.stockRepository.findQtyOnHandByItemIds(trackedIds),
      this.taxCodesRepository.findRatePercentsByIds(taxIds),
    ]);

    return rows.map((row) =>
      this.toDto(row, withMovements.has(row.id), {
        taxRatePercent:
          row.tax_code_id != null ? (rates.get(row.tax_code_id) ?? null) : null,
        qtyOnHand: row.inventory_tracked
          ? (qtys.get(row.id) ?? '0.000')
          : null,
      }),
    );
  }

  async list(
    rawQuery: Record<string, unknown>,
    _actor?: AuthenticatedUser,
  ): Promise<PaginatedResponse<InventoryItemDto>> {
    const filters = inventoryItemFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const requestCursor = typeof rawQuery.cursor === 'string' ? rawQuery.cursor : null;
    const filterParams = {
      itemKind: filters.item_kind,
      search: filters.search,
      categoryId: filters.category_id,
      isActive: filters.is_active,
      inventoryTracked: filters.inventory_tracked,
    };

    if (pagination.mode === 'cursor' && pagination.cursor) {
      const { rows, total } = await this.repository.findMany({
        ...filterParams,
        limit: pagination.limit + 1,
        cursor: pagination.cursor,
      });

      const items = await this.enrichRows(rows);

      return createPaginatedResponse({
        items,
        limit: pagination.limit,
        requestCursor,
        total,
        cursorExtractor: (item) => ({
          createdAt:
            item.created_at instanceof Date
              ? item.created_at.toISOString()
              : String(item.created_at),
          id: item.id,
        }),
      });
    }

    const offset = pagination.offset ?? 0;
    const { rows, total } = await this.repository.findMany({
      ...filterParams,
      limit: pagination.limit,
      offset,
    });

    const items = await this.enrichRows(rows);

    return createPaginatedResponse({
      items,
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async getById(id: number, _actor?: AuthenticatedUser): Promise<InventoryItemDto> {
    const item = await this.repository.findReadById(id);
    if (!item) {
      throw new NotFoundError(`Item ${id} was not found`);
    }
    const [dto] = await this.enrichRows([item]);
    return dto!;
  }
}
