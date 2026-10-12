import { z } from 'zod';

export const ITEM_KINDS = ['service', 'goods'] as const;
export type ItemKind = (typeof ITEM_KINDS)[number];

export const itemKindSchema = z.enum(ITEM_KINDS);

export const itemCreateSchema = z
  .object({
    name: z.string().trim().min(1, 'name is required').max(150, 'name must be at most 150 characters'),
    item_kind: itemKindSchema,
    income_account_id: z.number().int().positive('income_account_id must be a positive integer'),
    expense_account_id: z.number().int().positive('expense_account_id must be a positive integer'),
    tax_code_id: z.number().int().positive('tax_code_id must be a positive integer').nullable().optional(),
    is_active: z.boolean().optional().default(true),
    inventory_tracked: z.boolean().optional().default(false),
  })
  .strict()
  .refine(
    (data) => data.inventory_tracked !== true,
    {
      message: 'inventory_tracked cannot be true (inventory tracking is not supported)',
      path: ['inventory_tracked'],
    },
  );

export type ItemCreateDto = z.infer<typeof itemCreateSchema>;

export const itemUpdateSchema = z
  .object({
    name: z.string().trim().min(1, 'name cannot be empty').max(150, 'name must be at most 150 characters').optional(),
    income_account_id: z.number().int().positive('income_account_id must be a positive integer').optional(),
    expense_account_id: z.number().int().positive('expense_account_id must be a positive integer').optional(),
    tax_code_id: z.number().int().positive('tax_code_id must be a positive integer').nullable().optional(),
    is_active: z.boolean().optional(),
    inventory_tracked: z.boolean().optional(),
  })
  .strict()
  .refine(
    (data) => data.inventory_tracked !== true,
    {
      message: 'inventory_tracked cannot be true (inventory tracking is not supported)',
      path: ['inventory_tracked'],
    },
  );

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
  item_kind: ItemKind;
  inventory_tracked: boolean;
  income_account_id: number;
  expense_account_id: number;
  tax_code_id: number | null;
  is_active: boolean;
}
