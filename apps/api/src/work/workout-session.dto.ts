import { z } from 'zod';

export const workoutSessionCreateSchema = z.object({
  member_id: z.number().int().positive().optional(),
  workout_plan_id: z.number().int().positive().optional(),
  workout_plan_version_id: z.number().int().positive().optional(),
});

export type WorkoutSessionCreateDto = z.infer<typeof workoutSessionCreateSchema>;

export const workoutSetWriteSchema = z.object({
  exercise_id: z.number().int().positive('exercise_id is required'),
  set_number: z.number().int().min(1, 'set_number must be at least 1'),
  reps_completed: z.number().int().min(0).optional().default(0),
  weight_lifted_kg: z.number().min(0).optional().default(0),
  rpe_score: z.number().min(1).max(10).nullable().optional(),
  actual_rir: z.number().min(0).max(10).nullable().optional(),
  actual_duration_seconds: z.number().int().min(0).nullable().optional(),
  is_completed: z.boolean().optional().default(true),
  notes: z.string().trim().max(1000).nullable().optional(),
});

export type WorkoutSetWriteDto = z.infer<typeof workoutSetWriteSchema>;

export const workoutSetUpdateSchema = workoutSetWriteSchema
  .omit({ exercise_id: true, set_number: true })
  .partial()
  .refine((data) => Object.keys(data).length > 0, {
    message: 'At least one field is required',
  });

export type WorkoutSetUpdateDto = z.infer<typeof workoutSetUpdateSchema>;

export const workoutSessionCompleteSchema = z.object({
  client_feedback_rating: z.number().int().min(1).max(5).nullable().optional(),
  effort_rating: z.number().int().min(1).max(10).nullable().optional(),
  satisfaction_rating: z.number().int().min(1).max(10).nullable().optional(),
  pain_discomfort_score: z.number().int().min(0).max(10).nullable().optional(),
  pain_notes: z.string().trim().max(1000).nullable().optional(),
  notes: z.string().nullable().optional(),
  trainer_notes: z.string().trim().max(1000).nullable().optional(),
  next_session_plan: z.string().trim().max(1000).nullable().optional(),
  session_focus: z.string().trim().max(120).nullable().optional(),
  warmup_protocol: z.string().trim().nullable().optional(),
  cooldown_protocol: z.string().trim().nullable().optional(),
  client_signed: z.boolean().optional(),
  trainer_signed: z.boolean().optional(),
});

export type WorkoutSessionCompleteDto = z.infer<typeof workoutSessionCompleteSchema>;

export const workoutSessionFilterQuerySchema = z.object({
  member_id: z.coerce.number().int().positive().optional(),
});

export type WorkoutSessionFilterQueryDto = z.infer<typeof workoutSessionFilterQuerySchema>;
