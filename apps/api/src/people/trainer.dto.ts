import { z } from 'zod';

const moneyString = z
  .string()
  .trim()
  .regex(/^-?\d+\.\d{2}$/, 'hourly_rate must be a Money string (e.g. "50.00")');

export const trainerCreateSchema = z.object({
  email: z.string().trim().email().max(255),
  phone_number: z.string().trim().min(1).max(32).optional().nullable(),
  password: z.string().min(1, 'password is required').max(255),
  first_name: z.string().trim().min(1).max(100),
  last_name: z.string().trim().min(1).max(100),
  bio: z.string().trim().max(5000).optional().nullable(),
  specializations: z.array(z.string().trim().min(1)).optional().nullable(),
  hourly_rate: moneyString.optional().nullable(),
  max_clients_capacity: z.number().int().positive().optional().nullable(),
});

export type TrainerCreateDto = z.infer<typeof trainerCreateSchema>;

export const trainerUpdateSchema = z
  .object({
    phone_number: z.string().trim().min(1).max(32).optional().nullable(),
    first_name: z.string().trim().min(1).max(100).optional(),
    last_name: z.string().trim().min(1).max(100).optional(),
    bio: z.string().trim().max(5000).optional().nullable(),
    specializations: z.array(z.string().trim().min(1)).optional().nullable(),
    hourly_rate: moneyString.optional().nullable(),
    max_clients_capacity: z.number().int().positive().optional().nullable(),
    is_active: z.boolean().optional(),
  })
  .strict();

export type TrainerUpdateDto = z.infer<typeof trainerUpdateSchema>;

export const trainerFilterQuerySchema = z.object({
  q: z.string().trim().min(1).optional(),
});

export type TrainerFilterQueryDto = z.infer<typeof trainerFilterQuerySchema>;
