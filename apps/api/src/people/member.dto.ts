import { z } from 'zod';
import { blankToNull } from './credentials';

const optionalEmail = z.preprocess(
  blankToNull,
  z.string().trim().email('email must be a valid email').max(255).optional().nullable(),
);

const optionalPhone = z.preprocess(
  blankToNull,
  z.string().trim().min(1).max(32).optional().nullable(),
);

/**
 * Mirrors OpenAPI `MemberCreate` (V3-05a). Email and phone_number are both
 * optional — a member may be created with no login identifier.
 */
export const memberCreateSchema = z.object({
  email: optionalEmail,
  phone_number: optionalPhone,
  password: z.string().min(1).max(255).optional().nullable(),
  first_name: z.string().trim().min(1, 'first_name is required').max(100),
  last_name: z.string().trim().max(100).nullish().transform((v) => v ?? ''),
  gender: z.string().trim().min(1, 'gender is required').max(32),
  date_of_birth: z.string().trim().min(1).optional().nullable(),
  address: z.string().trim().max(2000).optional().nullable(),
  assigned_trainer_id: z.number().int().positive().optional().nullable(),
  notes: z.string().trim().max(5000).optional().nullable(),
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
    last_name: z.string().trim().max(100).optional(),
    gender: z.string().trim().min(1, 'gender cannot be cleared').max(32).optional(),
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
