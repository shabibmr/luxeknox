import { z } from 'zod';
import { ACCOUNT_TYPES, type AccountType } from '../platform/db/schema/accounting';

export const accountCreateSchema = z
  .object({
    name: z.string().trim().min(1).max(150),
    account_type: z.enum(ACCOUNT_TYPES),
    parent_id: z.number().int().positive().nullable().optional(),
    is_active: z.boolean().optional().default(true),
    is_bank: z.boolean().optional().default(false),
    is_control: z.boolean().optional().default(false),
    control_role: z.string().trim().min(1).max(32).nullable().optional(),
  })
  .strict();

export type AccountCreateDto = z.infer<typeof accountCreateSchema>;

export const accountUpdateSchema = z
  .object({
    name: z.string().trim().min(1).max(150).optional(),
    parent_id: z.number().int().positive().nullable().optional(),
    is_active: z.boolean().optional(),
    is_bank: z.boolean().optional(),
  })
  .strict();

export type AccountUpdateDto = z.infer<typeof accountUpdateSchema>;

export const accountFilterQuerySchema = z.object({
  account_type: z.enum(ACCOUNT_TYPES).optional(),
  is_active: z
    .union([z.boolean(), z.enum(['true', 'false', '1', '0'])])
    .transform((v) => (typeof v === 'boolean' ? v : v === 'true' || v === '1'))
    .optional(),
  search: z.string().trim().min(1).max(150).optional(),
});

export type AccountFilterQueryDto = z.infer<typeof accountFilterQuerySchema>;

export interface AccountDto {
  id: number;
  name: string;
  account_type: AccountType;
  parent_id: number | null;
  is_active: boolean;
  is_bank: boolean;
  is_control: boolean;
  control_role: string | null;
  created_at: Date | string;
  updated_at: Date | string | null;
}
