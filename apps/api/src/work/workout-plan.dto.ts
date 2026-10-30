import { z } from 'zod';

export const PROGRESSION_METHOD_VALUES = [
  'load',
  'reps',
  'volume',
  'density',
  'technique',
] as const;

const progressionMethodsSchema = z
  .array(z.enum(PROGRESSION_METHOD_VALUES))
  .superRefine((items, ctx) => {
    if (new Set(items).size !== items.length) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: 'progression_methods must not contain duplicates',
      });
    }
  });

const workoutPlanBlueprintFields = {
  primary_objective_12w: z.string().optional().nullable(),
  milestone_4w: z.string().optional().nullable(),
  sessions_per_week: z.number().int().min(1).max(14).optional().nullable(),
  target_session_duration_minutes: z.number().int().min(15).max(180).optional().nullable(),
  split_type: z.string().trim().min(1, 'split_type cannot be blank').max(64, 'split_type cannot exceed 64 characters').optional().nullable(),
  cardio_protocol: z.string().optional().nullable(),
  mobility_protocol: z.string().optional().nullable(),
  progression_methods: progressionMethodsSchema.optional().nullable(),
  main_success_measure: z.string().trim().min(1, 'main_success_measure cannot be blank').max(255, 'main_success_measure cannot exceed 255 characters').optional().nullable(),
  trainer_programming_notes: z.string().optional().nullable(),
};

export const workoutPlanCreateSchema = z.object({
  title: z.string().trim().min(1, 'title is required'),
  description: z.string().optional(),
  member_id: z.number().int().positive().optional(),
  trainer_id: z.number().int().positive().optional(),
  target_goal: z.string().trim().optional(),
  difficulty: z.string().trim().optional(),
  duration_weeks: z.number().int().positive().optional(),
  is_template: z.boolean().optional(),
  ...workoutPlanBlueprintFields,
});

export type WorkoutPlanCreateDto = z.infer<typeof workoutPlanCreateSchema>;

export const workoutPlanUpdateSchema = z.object({
  title: z.string().trim().min(1).optional(),
  description: z.string().optional(),
  member_id: z.number().int().positive().optional(),
  trainer_id: z.number().int().positive().optional(),
  target_goal: z.string().trim().optional(),
  difficulty: z.string().trim().optional(),
  duration_weeks: z.number().int().positive().optional(),
  is_template: z.boolean().optional(),
  row_version: z.number().int().positive().optional(),
  ...workoutPlanBlueprintFields,
});

export type WorkoutPlanUpdateDto = z.infer<typeof workoutPlanUpdateSchema>;

export const workoutPlanFilterQuerySchema = z.object({
  member_id: z.coerce.number().int().positive().optional(),
  is_template: z
    .union([z.boolean(), z.string()])
    .optional()
    .transform((val) => {
      if (val === undefined) return undefined;
      if (typeof val === 'boolean') return val;
      return val === 'true' || val === '1';
    }),
  trainer_id: z.coerce.number().int().positive().optional(),
  status: z.enum(['draft', 'active', 'archived']).optional(),
  q: z.string().trim().optional(),
});

export type WorkoutPlanFilterQueryDto = z.infer<typeof workoutPlanFilterQuerySchema>;

export const assignPlanSchema = z.object({
  member_id: z.number().int().positive('member_id is required'),
});

export type AssignPlanDto = z.infer<typeof assignPlanSchema>;

function hasOneDecimalPlaceOrLess(n: number): boolean {
  return Number.isInteger(Math.round(n * 10)) && Math.abs(n * 10 - Math.round(n * 10)) < 1e-8;
}

function blankToNull(value: unknown): unknown {
  if (typeof value === 'string' && value.trim() === '') return null;
  return value;
}

const targetRirSchema = z.preprocess(
  blankToNull,
  z
    .number()
    .min(0)
    .max(10)
    .refine(hasOneDecimalPlaceOrLess, 'target_rir allows at most one decimal place')
    .nullable(),
);

const targetDurationSecondsSchema = z.preprocess(
  blankToNull,
  z.number().int().min(0).nullable(),
);

export const workoutPlanExerciseItemSchema = z.object({
  exercise_id: z.number().int().positive('exercise_id is required'),
  day_number: z.number().int().min(1, 'day_number must be at least 1'),
  order_index: z.number().int().min(0, 'order_index must be non-negative'),
  target_sets: z.number().int().positive().optional().default(3),
  target_reps: z.string().trim().optional().default('10'),
  target_weight_kg: z.number().positive().optional(),
  target_rir: targetRirSchema.optional(),
  target_duration_seconds: targetDurationSecondsSchema.optional(),
  rest_seconds: z.number().int().nonnegative().optional().default(60),
  rest_between_exercises_seconds: z.number().int().nonnegative().optional(),
  notes: z.string().nullable().optional(),
});

export type WorkoutPlanExerciseItemDto = z.infer<typeof workoutPlanExerciseItemSchema>;

export const workoutPlanExercisesWriteSchema = z.object({
  changelog: z.string().optional(),
  row_version: z.number().int().positive().optional(),
  exercises: z.array(workoutPlanExerciseItemSchema),
});

export type WorkoutPlanExercisesWriteDto = z.infer<typeof workoutPlanExercisesWriteSchema>;

export * from './workout-session.dto';

