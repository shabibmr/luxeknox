import { z } from 'zod';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ACTIVITY_LEVELS } from '../platform/db/schema/lifestyle-intake';

const PRIORITY_DOMAINS = ['sleep', 'nutrition', 'activity', 'recovery'] as const;

const lifestylePriorityItemSchema = z.object({
  priority: z.enum(PRIORITY_DOMAINS),
  current_status: z.string().trim().min(1),
  first_action: z.string().trim().min(1),
});

function hasOneDecimalPlaceOrLess(n: number): boolean {
  return Number.isInteger(Math.round(n * 10)) && Math.abs(n * 10 - Math.round(n * 10)) < 1e-8;
}

export const lifestyleIntakePutSchema = z.object({
  activity_level: z.enum(ACTIVITY_LEVELS).optional().nullable(),
  training_history: z.string().optional().nullable(),
  current_pain_discomfort: z.string().optional().nullable(),
  sleep_hours_typical: z
    .number()
    .min(0)
    .max(24)
    .refine(hasOneDecimalPlaceOrLess, 'sleep_hours_typical allows at most one decimal place')
    .optional()
    .nullable(),
  stress_level: z.number().int().min(1).max(10),
  work_activity_demands: z.string().optional().nullable(),
  typical_daily_steps: z.number().int().min(0).max(200_000).optional().nullable(),
  nutrition_approach: z.string().optional().nullable(),
  hydration_habits: z.string().optional().nullable(),
  recovery_habits: z.string().optional().nullable(),
  other_notes: z.string().optional().nullable(),
  lifestyle_priorities: z
    .array(lifestylePriorityItemSchema)
    .length(4)
    .superRefine((items, ctx) => {
      const domains = new Set(items.map((item) => item.priority));
      if (domains.size !== 4) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: 'lifestyle_priorities must include each of sleep, nutrition, activity, recovery once',
        });
      }
    }),
  conducted_by_trainer_id: z.number().int().positive().optional().nullable(),
});

export type LifestyleIntakePutDto = z.infer<typeof lifestyleIntakePutSchema>;

export class LifestyleIntakeDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: Number }) member_id!: number;
  @ApiPropertyOptional({ type: String, nullable: true }) activity_level!: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) training_history!: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) current_pain_discomfort!: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) sleep_hours_typical!: string | null;
  @ApiProperty({ type: Number }) stress_level!: number | null;
  @ApiPropertyOptional({ type: String, nullable: true }) work_activity_demands!: string | null;
  @ApiPropertyOptional({ type: Number, nullable: true }) typical_daily_steps!: number | null;
  @ApiPropertyOptional({ type: String, nullable: true }) nutrition_approach!: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) hydration_habits!: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) recovery_habits!: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) other_notes!: string | null;
  @ApiPropertyOptional({ type: Array, nullable: true }) lifestyle_priorities!:
    | Array<{
        priority: 'sleep' | 'nutrition' | 'activity' | 'recovery';
        current_status: string;
        first_action: string;
      }>
    | null;
  @ApiPropertyOptional({ type: Number, nullable: true }) conducted_by_trainer_id!: number | null;
  @ApiProperty({ type: String }) created_at!: string;
  @ApiPropertyOptional({ type: String, nullable: true }) updated_at!: string | null;
}
