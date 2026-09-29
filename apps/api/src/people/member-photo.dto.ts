import { ApiProperty } from '@nestjs/swagger';
import { z } from 'zod';

export const ALLOWED_MEMBER_PHOTO_PURPOSES = ['avatar', 'progress_photo'] as const;
export type AllowedMemberPhotoPurpose = (typeof ALLOWED_MEMBER_PHOTO_PURPOSES)[number];

export const memberPhotoWriteSchema = z.object({
  /** MEDIA object_key from POST /media/uploads (avatar or progress_photo). */
  photo_url: z.string().trim().min(1, 'photo_url is required').max(1024),
});

export class MemberPhotoWriteDto {
  @ApiProperty({
    type: String,
    description: 'MEDIA object_key from POST /media/uploads (avatar or progress_photo)',
    example: 'avatar/2026/09/550e8400-e29b-41d4-a716-446655440000.jpg',
  })
  photo_url!: string;
}
