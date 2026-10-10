import { z } from 'zod';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export const memberHealthWriteSchema = z.object({
  blood_group: z.string().trim().max(16).optional().nullable(),
  height_cm: z.number().positive().optional().nullable(),
  baseline_weight_kg: z.number().positive().optional().nullable(),
  allergies: z.string().trim().max(5000).optional().nullable(),
  dietary_preferences: z.string().trim().max(5000).optional().nullable(),
  physician_name: z.string().trim().max(150).optional().nullable(),
  physician_phone: z.string().trim().max(32).optional().nullable(),
});

export type MemberHealthWriteDto = z.infer<typeof memberHealthWriteSchema>;

export class MemberHealthRecordDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: Number }) member_id!: number;
  @ApiPropertyOptional({ type: String, nullable: true }) blood_group!: string | null;
  @ApiPropertyOptional({ type: Number, nullable: true }) height_cm!: number | null;
  @ApiPropertyOptional({ type: Number, nullable: true }) baseline_weight_kg!: number | null;
  @ApiPropertyOptional({ type: String, nullable: true }) allergies!: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) dietary_preferences!: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) physician_name!: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) physician_phone!: string | null;
  @ApiProperty({ type: String }) recorded_at!: string;
}
