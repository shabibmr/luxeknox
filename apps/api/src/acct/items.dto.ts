import { z } from 'zod';
import { roundMoney } from '../platform/money/money';

export const ITEM_KINDS = ['service', 'goods'] as const;
export type ItemKind = (typeof ITEM_KINDS)[number];

export const itemKindSchema = z.enum(ITEM_KINDS);

const moneySchema = z.union([z.string(), z.number()]).transform((value, ctx) => {
  try {
    return roundMoney(value);
  } catch {
    ctx.addIssue({ code: 'custom', message: 'Invalid money amount' });
    return z.NEVER;
  }
});

const nonNegativeMoneySchema = moneySchema.refine((value) => !value.startsWith('-'), {
  message: 'Amount must be zero or positive',
});

/** Half-up to 3 decimal places. Quantities and reorder levels only. */
function roundQty3(amount: number | string): string {
  const str = String(amount).trim();
  if (!/^\d+(\.\d+)?$/.test(str)) {
    throw new Error(`Invalid quantity: "${amount}"`);
  }
  const [intPart, fracPart = ''] = str.split('.');
  const digits = `${fracPart}0000`;
  let scaled =
    BigInt(intPart) * 1000n +
    BigInt(digits[0]) * 100n +
    BigInt(digits[1]) * 10n +
    BigInt(digits[2]);
  if (digits[3] >= '5') scaled += 1n;
  const scaledStr = scaled.toString().padStart(4, '0');
  return `${scaledStr.slice(0, -3)}.${scaledStr.slice(-3)}`;
}

const qtySchema = z.union([z.string(), z.number()]).transform((value, ctx) => {
  try {
    return roundQty3(value);
  } catch {
    ctx.addIssue({ code: 'custom', message: 'Invalid quantity' });
    return z.NEVER;
  }
});

const optionalSku = z
  .string()
  .trim()
  .max(64, 'sku must be at most 64 characters')
  .nullable()
  .optional();

const optionalHsn = z
  .string()
  .trim()
  .max(16, 'hsn_sac must be at most 16 characters')
  .nullable()
  .optional();

export const itemCreateSchema = z
  .object({
    name: z.string().trim().min(1, 'name is required').max(150, 'name must be at most 150 characters'),
    item_kind: itemKindSchema,
    uom_id: z.number().int().positive('uom_id must be a positive integer'),
    income_account_id: z.number().int().positive('income_account_id must be a positive integer'),
    expense_account_id: z.number().int().positive('expense_account_id must be a positive integer'),
    sku: optionalSku,
    hsn_sac: optionalHsn,
    category_id: z.number().int().positive('category_id must be a positive integer').nullable().optional(),
    sale_rate: nonNegativeMoneySchema.nullable().optional(),
    purchase_rate: nonNegativeMoneySchema.nullable().optional(),
    tax_code_id: z.number().int().positive('tax_code_id must be a positive integer').nullable().optional(),
    is_active: z.boolean().optional().default(true),
    inventory_tracked: z.boolean().optional().default(false),
    inventory_account_id: z
      .number()
      .int()
      .positive('inventory_account_id must be a positive integer')
      .nullable()
      .optional(),
    cogs_account_id: z
      .number()
      .int()
      .positive('cogs_account_id must be a positive integer')
      .nullable()
      .optional(),
    reorder_level: qtySchema.nullable().optional(),
  })
  .strict();

export type ItemCreateDto = z.infer<typeof itemCreateSchema>;

export const itemUpdateSchema = z
  .object({
    name: z.string().trim().min(1, 'name cannot be empty').max(150, 'name must be at most 150 characters').optional(),
    uom_id: z.number().int().positive('uom_id must be a positive integer').optional(),
    income_account_id: z.number().int().positive('income_account_id must be a positive integer').optional(),
    expense_account_id: z.number().int().positive('expense_account_id must be a positive integer').optional(),
    sku: optionalSku,
    hsn_sac: optionalHsn,
    category_id: z.number().int().positive('category_id must be a positive integer').nullable().optional(),
    sale_rate: nonNegativeMoneySchema.nullable().optional(),
    purchase_rate: nonNegativeMoneySchema.nullable().optional(),
    tax_code_id: z.number().int().positive('tax_code_id must be a positive integer').nullable().optional(),
    is_active: z.boolean().optional(),
    inventory_tracked: z.boolean().optional(),
    inventory_account_id: z
      .number()
      .int()
      .positive('inventory_account_id must be a positive integer')
      .nullable()
      .optional(),
    cogs_account_id: z
      .number()
      .int()
      .positive('cogs_account_id must be a positive integer')
      .nullable()
      .optional(),
    reorder_level: qtySchema.nullable().optional(),
  })
  .strict();

export type ItemUpdateDto = z.infer<typeof itemUpdateSchema>;

export const itemFilterQuerySchema = z.object({
  item_kind: itemKindSchema.optional(),
  search: z.string().trim().optional(),
  is_active: z
    .preprocess((val) => {
      if (typeof val === 'string') {
        const lower = val.trim().toLowerCase();
        if (lower === 'true' || lower === '1') return true;
        if (lower === 'false' || lower === '0') return false;
      }
      return val;
    }, z.boolean().optional())
    .optional(),
});

export type ItemFilterQueryDto = z.infer<typeof itemFilterQuerySchema>;

export interface ItemDto {
  id: number;
  name: string;
  sku: string | null;
  hsn_sac: string | null;
  item_kind: ItemKind;
  category_id: number | null;
  uom_id: number;
  inventory_tracked: boolean;
  sale_rate: string | null;
  purchase_rate: string | null;
  reorder_level: string | null;
  income_account_id: number;
  expense_account_id: number;
  inventory_account_id: number | null;
  cogs_account_id: number | null;
  tax_code_id: number | null;
  is_active: boolean;
  row_version: number;
  created_at: Date | string;
  updated_at: Date | string | null;
}
