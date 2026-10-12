import { z } from 'zod';

const optionalEmail = z
  .string()
  .trim()
  .email('email must be a valid email address')
  .max(255, 'email must be at most 255 characters')
  .optional()
  .nullable();

const optionalPhone = z
  .string()
  .trim()
  .max(32, 'phone must be at most 32 characters')
  .optional()
  .nullable();

const optionalGstin = z
  .string()
  .trim()
  .max(20, 'gstin must be at most 20 characters')
  .optional()
  .nullable();

export const vendorWriteSchema = z
  .object({
    name: z.string().trim().min(1, 'name is required').max(150, 'name must be at most 150 characters'),
    phone: optionalPhone,
    email: optionalEmail,
    gstin: optionalGstin,
    is_active: z.boolean().optional().default(true),
  })
  .strict();

export type VendorWriteDto = z.infer<typeof vendorWriteSchema>;

export const vendorUpdateSchema = z
  .object({
    name: z.string().trim().min(1, 'name cannot be empty').max(150, 'name must be at most 150 characters').optional(),
    phone: optionalPhone,
    email: optionalEmail,
    gstin: optionalGstin,
    is_active: z.boolean().optional(),
  })
  .strict();

export type VendorUpdateDto = z.infer<typeof vendorUpdateSchema>;

export const vendorFilterQuerySchema = z.object({
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

export type VendorFilterQueryDto = z.infer<typeof vendorFilterQuerySchema>;

export interface VendorDto {
  id: number;
  name: string;
  phone: string | null;
  email: string | null;
  gstin: string | null;
  is_active: boolean;
  created_at: Date | string;
  updated_at: Date | string | null;
}
