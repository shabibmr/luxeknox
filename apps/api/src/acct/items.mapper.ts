import type { ItemDto, ItemKind } from './items.dto';

/** Shared item columns present on both accounting and inventory reads. */
export type ItemCoreRow = {
  id: number;
  name: string;
  sku: string | null;
  hsn_sac: string | null;
  item_kind: string;
  category_id: number | null;
  uom_id: number;
  inventory_tracked: boolean | number;
  sale_rate: string | null;
  purchase_rate: string | null;
  reorder_level: string | null;
  income_account_id: number;
  expense_account_id: number;
  inventory_account_id: number | null;
  cogs_account_id: number | null;
  tax_code_id: number | null;
  is_active: boolean | number;
  row_version: number;
  created_at: Date | string;
  updated_at: Date | string | null;
};

/** Map shared item columns used by `/accounting/items` and `/inventory/items`. */
export function mapItemDto(row: ItemCoreRow): ItemDto {
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
