import { z } from 'zod';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export const medicalHistoryWriteSchema = z.object({
  condition_id: z.number().int().positive().optional().nullable(),
  title: z.string().min(1).max(255),
  description: z.string().optional().nullable(),
  diagnosed_date: z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/, 'diagnosed_date must be YYYY-MM-DD')
    .optional()
    .nullable(),
  clearance_status: z.string().max(64).optional().nullable(),
});

export const medicalHistoryUpdateSchema = medicalHistoryWriteSchema.partial();

export type MedicalHistoryWriteDto = z.infer<typeof medicalHistoryWriteSchema>;
export type MedicalHistoryUpdateDto = z.infer<typeof medicalHistoryUpdateSchema>;

export class MedicalHistoryDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: Number }) member_id!: number;
  @ApiPropertyOptional({ type: Number, nullable: true }) condition_id!: number | null;
  @ApiProperty({ type: String }) title!: string;
  @ApiPropertyOptional({ type: String, nullable: true }) description!: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) diagnosed_date!: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) clearance_status!: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) document_url!: string | null;
}
