import { z } from 'zod';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

const QUESTIONS = [
  ['q1_heart_condition', 'q1_details'],
  ['q2_chest_pain_activity', 'q2_details'],
  ['q3_chest_pain_rest', 'q3_details'],
  ['q4_dizziness_consciousness', 'q4_details'],
  ['q5_bone_joint_problem', 'q5_details'],
  ['q6_medication_condition', 'q6_details'],
  ['q7_other_reason', 'q7_details'],
] as const;

const optionalText = z.string().optional().nullable();

export const parQSubmitSchema = z
  .object({
    q1_heart_condition: z.boolean(),
    q1_details: optionalText,
    q2_chest_pain_activity: z.boolean(),
    q2_details: optionalText,
    q3_chest_pain_rest: z.boolean(),
    q3_details: optionalText,
    q4_dizziness_consciousness: z.boolean(),
    q4_details: optionalText,
    q5_bone_joint_problem: z.boolean(),
    q5_details: optionalText,
    q6_medication_condition: z.boolean(),
    q6_details: optionalText,
    q7_other_reason: z.boolean(),
    q7_details: optionalText,
    declaration_accepted: z.literal(true, {
      errorMap: () => ({ message: 'The PAR-Q+ declaration must be accepted' }),
    }),
  })
  .superRefine((value, ctx) => {
    for (const [key, detailsKey] of QUESTIONS) {
      if (value[key] && !value[detailsKey]?.trim()) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: [detailsKey],
          message: `${detailsKey} is required when ${key} is YES`,
        });
      }
    }
  });

export type ParQSubmitDto = z.infer<typeof parQSubmitSchema>;

export const parQTrainerReviewSchema = z
  .object({
    trainer_screening_notes: z.string().trim().min(1),
    referral_required: z.boolean(),
    referral_reason: optionalText,
  })
  .superRefine((value, ctx) => {
    if (value.referral_required && !value.referral_reason?.trim()) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ['referral_reason'],
        message: 'referral_reason is required when referral_required is true',
      });
    }
  });

export type ParQTrainerReviewDto = z.infer<typeof parQTrainerReviewSchema>;

export const parQClearanceSchema = z.object({
  decision: z.enum(['cleared', 'rejected']),
});

export type ParQClearanceDto = z.infer<typeof parQClearanceSchema>;

export class ParQScreeningDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: Number }) member_id!: number;
  @ApiProperty({ type: String }) version!: string;
  @ApiProperty({ type: Boolean }) q1_heart_condition!: boolean;
  @ApiPropertyOptional({ type: String, nullable: true }) q1_details!: string | null;
  @ApiProperty({ type: Boolean }) q2_chest_pain_activity!: boolean;
  @ApiPropertyOptional({ type: String, nullable: true }) q2_details!: string | null;
  @ApiProperty({ type: Boolean }) q3_chest_pain_rest!: boolean;
  @ApiPropertyOptional({ type: String, nullable: true }) q3_details!: string | null;
  @ApiProperty({ type: Boolean }) q4_dizziness_consciousness!: boolean;
  @ApiPropertyOptional({ type: String, nullable: true }) q4_details!: string | null;
  @ApiProperty({ type: Boolean }) q5_bone_joint_problem!: boolean;
  @ApiPropertyOptional({ type: String, nullable: true }) q5_details!: string | null;
  @ApiProperty({ type: Boolean }) q6_medication_condition!: boolean;
  @ApiPropertyOptional({ type: String, nullable: true }) q6_details!: string | null;
  @ApiProperty({ type: Boolean }) q7_other_reason!: boolean;
  @ApiPropertyOptional({ type: String, nullable: true }) q7_details!: string | null;
  @ApiProperty({ type: Boolean }) has_positive_answer!: boolean;
  @ApiPropertyOptional({ type: String, nullable: true }) trainer_screening_notes!: string | null;
  @ApiProperty({ type: Boolean }) referral_required!: boolean;
  @ApiPropertyOptional({ type: String, nullable: true }) referral_reason!: string | null;
  @ApiProperty({ type: Boolean }) declaration_accepted!: boolean;
  @ApiPropertyOptional({ type: String, nullable: true }) client_signed_at!: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) trainer_signed_at!: string | null;
  @ApiProperty({
    type: String,
    enum: ['passed', 'pending_clearance', 'cleared', 'rejected'],
  })
  clearance_status!: 'passed' | 'pending_clearance' | 'cleared' | 'rejected';
  @ApiPropertyOptional({ type: String, nullable: true }) cleared_at!: string | null;
  @ApiPropertyOptional({ type: Number, nullable: true }) cleared_by_user_id!: number | null;
  @ApiProperty({ type: String }) created_at!: string;
  @ApiPropertyOptional({ type: String, nullable: true }) updated_at!: string | null;
}
