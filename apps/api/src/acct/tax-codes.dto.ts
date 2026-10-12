import { z } from 'zod';
import { roundMoney } from '../platform/money/money';

export const ratePercentSchema = z
  .union([z.string(), z.number()])
  .transform((v) => roundMoney(v))
  .refine(
    (v) => {
      const num = Number(v);
      return Number.isFinite(num) && num >= 0 && num <= 100;
    },
    { message: 'Rate percent must be between 0.00 and 100.00' },
  );

export const taxCodeComponentWriteSchema = z
  .object({
    name: z.string().trim().min(1).max(64),
    rate_percent: ratePercentSchema,
    output_account_id: z.number().int().positive(),
    input_account_id: z.number().int().positive(),
  })
  .strict();

export type TaxCodeComponentWriteDto = z.infer<typeof taxCodeComponentWriteSchema>;

export const taxCodeCreateSchema = z
  .object({
    name: z.string().trim().min(1).max(100),
    code: z.string().trim().min(1).max(32),
    rate_percent: ratePercentSchema,
    is_active: z.boolean().optional().default(true),
    components: z.array(taxCodeComponentWriteSchema).optional().default([]),
  })
  .strict();

export type TaxCodeCreateDto = z.infer<typeof taxCodeCreateSchema>;

export const taxCodeUpdateSchema = z
  .object({
    name: z.string().trim().min(1).max(100).optional(),
    rate_percent: ratePercentSchema.optional(),
    is_active: z.boolean().optional(),
    components: z.array(taxCodeComponentWriteSchema).optional(),
  })
  .strict();

export type TaxCodeUpdateDto = z.infer<typeof taxCodeUpdateSchema>;

export const taxCodeFilterQuerySchema = z.object({
  is_active: z
    .union([z.boolean(), z.enum(['true', 'false', '1', '0'])])
    .transform((v) => (typeof v === 'boolean' ? v : v === 'true' || v === '1'))
    .optional(),
});

export type TaxCodeFilterQueryDto = z.infer<typeof taxCodeFilterQuerySchema>;

export interface TaxCodeComponentDto {
  id: number;
  tax_code_id: number;
  name: string;
  rate_percent: string;
  output_account_id: number;
  input_account_id: number;
}

export interface TaxCodeDto {
  id: number;
  name: string;
  code: string;
  rate_percent: string;
  is_active: boolean;
  components: TaxCodeComponentDto[];
}
