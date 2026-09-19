import { z } from 'zod';
import { BadRequestError } from '../errors/app-error';

export interface CursorPayload {
  createdAt: string; // ISO 8601 string e.g. "2026-09-16T12:00:00.000Z"
  id: number;
}

export interface PaginationMeta {
  limit: number;
  offset: number | null;
  cursor: string | null;
  next_cursor: string | null;
  has_more: boolean;
  total?: number;
}

export interface PaginatedResponse<T> {
  data: T[];
  meta: PaginationMeta;
}

export interface NormalizedPaginationParams {
  mode: 'cursor' | 'offset';
  limit: number;
  cursor?: CursorPayload;
  page?: number;
  offset?: number;
}

/**
 * Zod schema for validating raw query parameters.
 */
export const PaginationQuerySchema = z.object({
  cursor: z.string().optional(),
  limit: z
    .union([z.string(), z.number()])
    .optional()
    .transform((val) => {
      if (val === undefined || val === null || val === '') return undefined;
      const num = typeof val === 'number' ? val : parseInt(val, 10);
      if (isNaN(num) || num <= 0) {
        throw new BadRequestError('Invalid limit parameter: must be a positive integer');
      }
      return num;
    }),
  page: z
    .union([z.string(), z.number()])
    .optional()
    .transform((val) => {
      if (val === undefined || val === null || val === '') return undefined;
      const num = typeof val === 'number' ? val : parseInt(val, 10);
      if (isNaN(num) || num <= 0) {
        throw new BadRequestError('Invalid page parameter: must be a positive integer');
      }
      return num;
    }),
  offset: z
    .union([z.string(), z.number()])
    .optional()
    .transform((val) => {
      if (val === undefined || val === null || val === '') return undefined;
      const num = typeof val === 'number' ? val : parseInt(val, 10);
      if (isNaN(num) || num < 0) {
        throw new BadRequestError('Invalid offset parameter: must be a non-negative integer');
      }
      return num;
    }),
});

export type RawPaginationQuery = z.input<typeof PaginationQuerySchema>;
export type ParsedPaginationQuery = z.output<typeof PaginationQuerySchema>;

/**
 * PaginationQueryDto class for Nest request binding and manual validation.
 */
export class PaginationQueryDto {
  cursor?: string;
  limit?: number;
  page?: number;
  offset?: number;

  static parse(raw: Record<string, unknown>): ParsedPaginationQuery {
    const result = PaginationQuerySchema.safeParse(raw);
    if (!result.success) {
      const issue = result.error.issues[0];
      throw new BadRequestError(issue?.message || 'Invalid pagination parameters');
    }
    return result.data;
  }
}
