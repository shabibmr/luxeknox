import { z } from 'zod';

const optionalEmail = z
  .string()
  .trim()
  .email('email must be a valid email')
  .max(255)
  .optional()
  .nullable();

const optionalPhone = z.string().trim().min(1).max(32).optional().nullable();

/**
 * Mirrors OpenAPI `MemberCreate` (V3-05a): password required; at least one of
 * email / phone_number.
 */
export const memberCreateSchema = z
  .object({
    email: optionalEmail,
    phone_number: optionalPhone,
    password: z.string().min(1, 'password is required').max(255),
    first_name: z.string().trim().min(1, 'first_name is required').max(100),
    last_name: z.string().trim().min(1, 'last_name is required').max(100),
    gender: z.string().trim().max(32).optional().nullable(),
    date_of_birth: z.string().trim().min(1).optional().nullable(),
    address: z.string().trim().max(2000).optional().nullable(),
    assigned_trainer_id: z.number().int().positive().optional().nullable(),
    notes: z.string().trim().max(5000).optional().nullable(),
  })
  .superRefine((data, ctx) => {
    const hasEmail = data.email != null && String(data.email).trim().length > 0;
    const hasPhone = data.phone_number != null && String(data.phone_number).trim().length > 0;
    if (!hasEmail && !hasPhone) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: 'At least one of email or phone_number is required',
        path: ['email'],
      });
    }
  });

export type MemberCreateDto = z.infer<typeof memberCreateSchema>;

/**
 * Partial profile update. `membership_number` is immutable — rejected via strict().
 */
export const memberUpdateSchema = z
  .object({
    email: optionalEmail,
    phone_number: optionalPhone,
    first_name: z.string().trim().min(1).max(100).optional(),
    last_name: z.string().trim().min(1).max(100).optional(),
    gender: z.string().trim().max(32).optional().nullable(),
    date_of_birth: z.string().trim().min(1).optional().nullable(),
    address: z.string().trim().max(2000).optional().nullable(),
    assigned_trainer_id: z.number().int().positive().optional().nullable(),
    notes: z.string().trim().max(5000).optional().nullable(),
  })
  .strict();

export type MemberUpdateDto = z.infer<typeof memberUpdateSchema>;

export const assignTrainerSchema = z.object({
  trainer_id: z.number().int().positive(),
  override_capacity: z.boolean().optional().default(false),
  reason: z.string().trim().max(2000).optional().nullable(),
});

export type AssignTrainerDto = z.infer<typeof assignTrainerSchema>;

const positiveIntQuery = z
  .union([z.number(), z.string()])
  .optional()
  .transform((value) => {
    if (value === undefined || value === null || value === '') return undefined;
    const n = typeof value === 'number' ? value : Number(value);
    return Number.isFinite(n) && n > 0 ? Math.trunc(n) : undefined;
  });

export const memberFilterQuerySchema = z.object({
  q: z.string().trim().min(1).optional(),
  status: z.enum(['active', 'inactive', 'suspended']).optional(),
  // Ignored in V3 until MEMB — accepted so clients do not 400.
  membership_status: z.string().trim().min(1).optional(),
  assigned_trainer_id: positiveIntQuery,
});

export type MemberFilterQueryDto = z.infer<typeof memberFilterQuerySchema>;
