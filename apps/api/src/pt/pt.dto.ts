import { z } from 'zod';

const moneyString = z
  .string()
  .regex(/^\d+\.\d{2}$/, 'must be a two-decimal string, e.g. "1299.00"');

const isoDate = z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Expected YYYY-MM-DD');

const hourSlot = z
  .string()
  .regex(/^([01]\d|2[0-3]):00(:00)?$/, 'slot_start must be on the hour, e.g. "17:00"');

const weekdays = z
  .array(z.number().int().min(0).max(6))
  .min(1)
  .max(7)
  .refine((v) => new Set(v).size === v.length, 'weekdays must be unique');

const tenderLine = z
  .object({
    payment_method_id: z.number().int().positive(),
    amount: z.string().regex(/^\d+(\.\d{1,2})?$/),
    transaction_reference: z.string().max(150).optional(),
  })
  .strict();

/** Payment fields shared by purchase and renew — same shape as POST /payments. */
const paymentFields = {
  discount_amount: z.string().regex(/^\d+(\.\d{1,2})?$/).optional(),
  payment_method_id: z.number().int().positive().optional(),
  tenders: z.array(tenderLine).min(1).optional(),
  transaction_reference: z.string().max(150).optional(),
};

export const ptProductWriteSchema = z.object({
  name: z.string().trim().min(1, 'name is required'),
  code: z.string().trim().min(1, 'code is required').max(32),
  description: z.string().optional(),
  duration_days: z.number().int().positive(),
  sessions_per_week: z.number().int().min(1).max(7),
  base_price: moneyString,
  tax_percentage: moneyString.optional(),
  is_active: z.boolean().optional(),
});
export type PtProductWriteDto = z.infer<typeof ptProductWriteSchema>;

export const ptProductUpdateSchema = ptProductWriteSchema.partial();
export type PtProductUpdateDto = z.infer<typeof ptProductUpdateSchema>;

export const ptProductFilterQuerySchema = z.object({
  q: z.string().trim().min(1).optional(),
});

const csvWeekdays = z
  .string()
  .transform((s) => s.split(',').filter(Boolean).map((x) => Number(x.trim())))
  .pipe(weekdays);

export const ptScheduleGridQuerySchema = z.object({
  member_id: z.coerce.number().int().positive(),
  pt_product_id: z.coerce.number().int().positive(),
  start_date: isoDate,
  weekdays: csvWeekdays,
  /** When re-planning an existing subscription, its own sessions are not conflicts. */
  exclude_subscription_id: z.coerce.number().int().positive().optional(),
});
export type PtScheduleGridQueryDto = z.infer<typeof ptScheduleGridQuerySchema>;

export const ptPurchaseSchema = z
  .object({
    member_id: z.number().int().positive(),
    pt_product_id: z.number().int().positive(),
    trainer_id: z.number().int().positive(),
    start_date: isoDate,
    weekdays,
    slot_start: hourSlot,
    ...paymentFields,
  })
  .strict()
  .refine((v) => !(v.tenders?.length && v.payment_method_id != null), {
    message: 'Use either payment_method_id or tenders, not both',
    path: ['tenders'],
  });
export type PtPurchaseDto = z.infer<typeof ptPurchaseSchema>;

export const ptRenewSchema = z
  .object({
    /** Defaults to the current subscription's package. */
    pt_product_id: z.number().int().positive().optional(),
    ...paymentFields,
  })
  .strict()
  .refine((v) => !(v.tenders?.length && v.payment_method_id != null), {
    message: 'Use either payment_method_id or tenders, not both',
    path: ['tenders'],
  });
export type PtRenewDto = z.infer<typeof ptRenewSchema>;

export const ptReassignTrainerSchema = z
  .object({
    trainer_id: z.number().int().positive(),
    effective_date: isoDate,
    reason: z.string().trim().max(500).optional(),
  })
  .strict();
export type PtReassignTrainerDto = z.infer<typeof ptReassignTrainerSchema>;

export const ptChangeSlotSchema = z
  .object({
    weekdays,
    slot_start: hourSlot,
    /** Optionally move to another active trainer in the same re-plan. */
    trainer_id: z.number().int().positive().optional(),
    effective_date: isoDate,
    reason: z.string().trim().max(500).optional(),
  })
  .strict();
export type PtChangeSlotDto = z.infer<typeof ptChangeSlotSchema>;
