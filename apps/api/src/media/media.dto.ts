import { z } from 'zod';
import { MEDIA_PURPOSES } from './storage.service';

export const mediaUploadRequestSchema = z.object({
  purpose: z.enum(MEDIA_PURPOSES),
  content_type: z.string().trim().min(1).max(255),
  size_bytes: z.number().int().positive(),
});

export type MediaUploadRequestDto = z.infer<typeof mediaUploadRequestSchema>;
