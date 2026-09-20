import { z } from 'zod';

export const memberPhotoWriteSchema = z.object({
  /** MEDIA object_key from POST /media/uploads (avatar or gallery). */
  photo_url: z.string().trim().min(1).max(1024),
});

export type MemberPhotoWriteDto = z.infer<typeof memberPhotoWriteSchema>;
