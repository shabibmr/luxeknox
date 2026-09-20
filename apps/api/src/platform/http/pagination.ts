import { Injectable } from '@nestjs/common';
import { SettingsService } from '../../sys/settings.service';
import { BadRequestError } from '../errors/app-error';
import {
  CursorPayload,
  NormalizedPaginationParams,
  PaginatedResponse,
  PaginationQueryDto,
  ParsedPaginationQuery,
} from './pagination.dto';

export const MAX_PAGE_SIZE = 100;

/**
 * Encodes a cursor payload ({ createdAt, id }) into a URL-safe Base64 string.
 */
export function encodeCursor(payload: CursorPayload): string {
  const json = JSON.stringify({
    createdAt: payload.createdAt,
    id: payload.id,
  });
  return Buffer.from(json, 'utf8').toString('base64url');
}

/**
 * Decodes an opaque Base64 / Base64URL string back into a CursorPayload.
 * Throws BadRequestError if the cursor is malformed or invalid.
 */
export function decodeCursor(cursor: string): CursorPayload {
  try {
    const raw = Buffer.from(cursor, 'base64url').toString('utf8');
    const parsed = JSON.parse(raw);

    if (
      !parsed ||
      typeof parsed !== 'object' ||
      typeof parsed.createdAt !== 'string' ||
      typeof parsed.id !== 'number' ||
      !Number.isFinite(parsed.id)
    ) {
      throw new Error('Invalid cursor structure');
    }

    // Verify createdAt is a valid date string
    const date = new Date(parsed.createdAt);
    if (isNaN(date.getTime())) {
      throw new Error('Invalid cursor timestamp');
    }

    return {
      createdAt: parsed.createdAt,
      id: parsed.id,
    };
  } catch {
    throw new BadRequestError('Invalid pagination cursor');
  }
}

/**
 * Builds a standardized PaginatedResponse envelope matching the committed OpenAPI `PageMeta`
 * schema (`docs/openapi/v1.yaml`): snake_case, `limit`/`offset`/`cursor` always present.
 *
 * If cursorExtractor is provided and items.length > limit, the list is trimmed to limit,
 * hasMore is set to true, and `next_cursor` is generated using cursorExtractor on the last item.
 * In offset mode, when `total` is known, `has_more` is derived from `offset + data.length < total`
 * instead — callers do not need to over-fetch by one row just to detect the last page.
 */
export function createPaginatedResponse<T>(params: {
  items: T[];
  limit: number;
  offset?: number | null;
  requestCursor?: string | null;
  total?: number;
  cursorExtractor?: (item: T) => CursorPayload;
}): PaginatedResponse<T> {
  const { items, limit, offset = null, requestCursor = null, total, cursorExtractor } = params;
  const overFetched = items.length > limit;
  const data = overFetched ? items.slice(0, limit) : items;

  let nextCursor: string | null = null;
  if (overFetched && cursorExtractor && data.length > 0) {
    const lastItem = data[data.length - 1];
    nextCursor = encodeCursor(cursorExtractor(lastItem));
  }

  const hasMore =
    total !== undefined && offset !== null ? offset + data.length < total : overFetched;

  return {
    data,
    meta: {
      limit,
      offset,
      cursor: requestCursor,
      next_cursor: nextCursor,
      has_more: hasMore,
      ...(total !== undefined ? { total } : {}),
    },
  };
}

/**
 * Helper service for pagination handling, integrating with SettingsService for defaults.
 */
@Injectable()
export class PaginationHelper {
  constructor(private readonly settingsService: SettingsService) {}

  /**
   * Resolves the effective limit for a query, defaulting to SettingsService.getDefaultPageSize()
   * capped at MAX_PAGE_SIZE (100).
   */
  async resolveLimit(requestedLimit?: number): Promise<number> {
    if (requestedLimit !== undefined && requestedLimit !== null) {
      if (requestedLimit <= 0) {
        throw new BadRequestError('Limit must be greater than 0');
      }
      return Math.min(requestedLimit, MAX_PAGE_SIZE);
    }
    const defaultLimit = await this.settingsService.getDefaultPageSize();
    return Math.min(defaultLimit, MAX_PAGE_SIZE);
  }

  /**
   * Normalizes pagination query parameters into resolved limit, offset, and optional decoded cursor.
   */
  async normalizeParams(
    query: ParsedPaginationQuery | Record<string, unknown>,
  ): Promise<NormalizedPaginationParams> {
    const parsed =
      query instanceof Object && 'limit' in query && 'cursor' in query && 'page' in query
        ? (query as ParsedPaginationQuery)
        : PaginationQueryDto.parse(query);

    const limit = await this.resolveLimit(parsed.limit);

    if (parsed.cursor) {
      const cursorPayload = decodeCursor(parsed.cursor);
      return {
        mode: 'cursor',
        limit,
        cursor: cursorPayload,
      };
    }

    if (parsed.offset !== undefined) {
      return {
        mode: 'offset',
        limit,
        offset: parsed.offset,
      };
    }

    if (parsed.page !== undefined) {
      const page = Math.max(1, parsed.page);
      const offset = (page - 1) * limit;
      return {
        mode: 'offset',
        limit,
        page,
        offset,
      };
    }

    return {
      mode: 'offset',
      limit,
      page: 1,
      offset: 0,
    };
  }
}
