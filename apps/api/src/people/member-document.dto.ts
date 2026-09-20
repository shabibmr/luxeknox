import { z } from 'zod';
import { DOCUMENT_TYPES } from '../platform/db/schema/member-documents';

export const memberDocumentWriteSchema = z.object({
  document_type: z.enum(DOCUMENT_TYPES),
  title: z.string().trim().max(255).optional().nullable(),
  /** MEDIA object_key from POST /media/uploads (stored in file_url). */
  file_url: z.string().trim().min(1).max(1024),
  file_size: z.number().int().nonnegative().optional().nullable(),
});

export type MemberDocumentWriteDto = z.infer<typeof memberDocumentWriteSchema>;
