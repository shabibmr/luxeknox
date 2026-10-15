import { z } from 'zod';
import { itemKindSchema, type ItemKind } from '../acct/items.dto';

export type { ItemKind };

function queryBoolean(val: unknown): unknown {
  if (typeof val === 'string') {
    const lower = val.trim().toLowerCase();
    if (lower === 'true' || lower === '1') return true;
    if (lower === 'false' || lower === '0') return false;
  }
  return val;
}

export const inventoryItemFilterQuerySchema = z.object({
  search: z
    .string()
    .trim()
    .optional()
    .transform((value) => (value && value.length > 0 ? value : undefined)),
  item_kind: itemKindSchema.optional(),
  category_id: z.preprocess(
    (val) => (val === '' || val == null ? undefined : val),
    z.coerce.number().int().positive().optional(),
  ),
  is_active: z.preprocess(queryBoolean, z.boolean().optional()).optional(),
  inventory_tracked: z.preprocess(queryBoolean, z.boolean().optional()).optional(),
});

export type InventoryItemFilterQuery = z.infer<typeof inventoryItemFilterQuerySchema>;

/** Item read shape from the inventory contract. `stock` is omitted until the ledger exists. */
export interface InventoryItemDto {
  id: number;
  name: string;
  sku: string | null;
  hsn_sac: string | null;
  item_kind: ItemKind;
  category_id: number | null;
  category_name: string | null;
  uom_id: number;
  uom_code: string;
  uom_decimal_places: number;
  sale_rate: string | null;
  purchase_rate: string | null;
  tax_code_id: number | null;
  income_account_id: number;
  expense_account_id: number;
  inventory_account_id: number | null;
  cogs_account_id: number | null;
  inventory_tracked: boolean;
  reorder_level: string | null;
  has_movements: boolean;
  is_active: boolean;
  row_version: number;
  created_at: Date | string;
  updated_at: Date | string | null;
}
