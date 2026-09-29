import { ApiProperty } from '@nestjs/swagger';
import { z } from 'zod';
import { MEDIA_PURPOSES, type MediaPurpose } from './storage.service';

export const mediaUploadRequestSchema = z.object({
  purpose: z.enum(MEDIA_PURPOSES, {
    errorMap: () => ({
      message: `Invalid purpose. Allowed purposes are: ${MEDIA_PURPOSES.join(', ')}`,
    }),
  }),
  content_type: z.string().trim().min(1, 'content_type is required').max(255),
  size_bytes: z.number().int().positive('size_bytes must be a positive integer'),
});

export class MediaUploadRequestDto {
  @ApiProperty({
    enum: MEDIA_PURPOSES,
    description: `Purpose of upload. Allowed values: ${MEDIA_PURPOSES.join(', ')}`,
    example: 'avatar',
  })
  purpose!: MediaPurpose;

  @ApiProperty({
    type: String,
    description: 'MIME type of the media file',
    example: 'image/jpeg',
  })
  content_type!: string;

  @ApiProperty({
    type: Number,
    description: 'File size in bytes',
    example: 1024,
  })
  size_bytes!: number;
}
