import { describe, it, expect, vi } from 'vitest';
import {
  decodeCursor,
  encodeCursor,
  createPaginatedResponse,
  PaginationHelper,
  DEFAULT_PAGE_SIZE,
  MAX_PAGE_SIZE,
} from './pagination';
import { PaginationQueryDto } from './pagination.dto';
import { BadRequestError } from '../errors/app-error';
import { SettingsService } from '../../sys/settings.service';

describe('Pagination', () => {
  describe('encodeCursor & decodeCursor', () => {
    it('correctly encodes and decodes a valid cursor payload', () => {
      const payload = {
        createdAt: '2026-09-16T12:00:00.000Z',
        id: 12345,
      };

      const encoded = encodeCursor(payload);
      expect(typeof encoded).toBe('string');
      expect(encoded.length).toBeGreaterThan(0);

      const decoded = decodeCursor(encoded);
      expect(decoded).toEqual(payload);
    });

    it('throws BadRequestError for malformed base64', () => {
      expect(() => decodeCursor('not-valid-base64!!@@')).toThrow(BadRequestError);
    });

    it('throws BadRequestError for JSON missing required fields', () => {
      const invalidJson = Buffer.from(JSON.stringify({ id: 123 }), 'utf8').toString('base64url');
      expect(() => decodeCursor(invalidJson)).toThrow(BadRequestError);
    });

    it('throws BadRequestError for invalid timestamp', () => {
      const invalidTime = Buffer.from(
        JSON.stringify({ createdAt: 'invalid-date', id: 123 }),
        'utf8',
      ).toString('base64url');
      expect(() => decodeCursor(invalidTime)).toThrow(BadRequestError);
    });

    it('throws BadRequestError for non-numeric id', () => {
      const invalidId = Buffer.from(
        JSON.stringify({ createdAt: '2026-09-16T12:00:00.000Z', id: '123' }),
        'utf8',
      ).toString('base64url');
      expect(() => decodeCursor(invalidId)).toThrow(BadRequestError);
    });
  });

  describe('PaginationQueryDto', () => {
    it('parses valid query parameters', () => {
      const parsed = PaginationQueryDto.parse({
        limit: '25',
        page: '2',
        offset: '50',
        cursor: 'abc',
      });

      expect(parsed).toEqual({
        limit: 25,
        page: 2,
        offset: 50,
        cursor: 'abc',
      });
    });

    it('allows undefined parameters', () => {
      const parsed = PaginationQueryDto.parse({});
      expect(parsed).toEqual({
        limit: undefined,
        page: undefined,
        offset: undefined,
        cursor: undefined,
      });
    });

    it('throws BadRequestError for negative limit', () => {
      expect(() => PaginationQueryDto.parse({ limit: '-5' })).toThrow(BadRequestError);
    });

    it('throws BadRequestError for 0 limit', () => {
      expect(() => PaginationQueryDto.parse({ limit: '0' })).toThrow(BadRequestError);
    });

    it('throws BadRequestError for negative offset', () => {
      expect(() => PaginationQueryDto.parse({ offset: '-1' })).toThrow(BadRequestError);
    });

    it('throws BadRequestError for invalid number strings', () => {
      expect(() => PaginationQueryDto.parse({ limit: 'abc' })).toThrow(BadRequestError);
    });
  });

  describe('createPaginatedResponse', () => {
    it('creates envelope with has_more = false when items <= limit', () => {
      const items = [{ id: 1, createdAt: '2026-09-16T12:00:00.000Z' }];
      const response = createPaginatedResponse({
        items,
        limit: 10,
        offset: 0,
        total: 1,
      });

      expect(response).toEqual({
        data: items,
        meta: {
          limit: 10,
          offset: 0,
          cursor: null,
          next_cursor: null,
          has_more: false,
          total: 1,
        },
      });
    });

    it('creates envelope with has_more = true, slices data to limit, and extracts next_cursor', () => {
      const items = [
        { id: 1, createdAt: '2026-09-16T10:00:00.000Z' },
        { id: 2, createdAt: '2026-09-16T11:00:00.000Z' },
        { id: 3, createdAt: '2026-09-16T12:00:00.000Z' },
      ];

      const response = createPaginatedResponse({
        items,
        limit: 2,
        cursorExtractor: (item) => ({ id: item.id, createdAt: item.createdAt }),
      });

      expect(response.data).toHaveLength(2);
      expect(response.data).toEqual([items[0], items[1]]);
      expect(response.meta.has_more).toBe(true);
      expect(response.meta.next_cursor).toBeTruthy();
      expect(response.meta.limit).toBe(2);
      expect(response.meta.offset).toBeNull();
      expect(response.meta.cursor).toBeNull();

      const decoded = decodeCursor(response.meta.next_cursor!);
      expect(decoded).toEqual({
        id: 2,
        createdAt: '2026-09-16T11:00:00.000Z',
      });
    });

    it('echoes the request cursor and derives has_more from total in offset mode', () => {
      const items = [{ id: 5 }, { id: 6 }];
      const response = createPaginatedResponse({
        items,
        limit: 2,
        offset: 4,
        requestCursor: 'opaque-request-cursor',
        total: 10,
      });

      expect(response.meta).toEqual({
        limit: 2,
        offset: 4,
        cursor: 'opaque-request-cursor',
        next_cursor: null,
        has_more: true,
        total: 10,
      });
    });

    it('has_more is false in offset mode once offset + data length reaches total', () => {
      const items = [{ id: 9 }, { id: 10 }];
      const response = createPaginatedResponse({
        items,
        limit: 2,
        offset: 8,
        total: 10,
      });

      expect(response.meta.has_more).toBe(false);
    });
  });

  describe('PaginationHelper', () => {
    it('uses DEFAULT_PAGE_SIZE (20) when no settings service or limit is provided', async () => {
      const helper = new PaginationHelper();
      const limit = await helper.resolveLimit();
      expect(limit).toBe(DEFAULT_PAGE_SIZE);
    });

    it('fetches default limit from SettingsService when available', async () => {
      const mockSettingsService = {
        getDefaultPageSize: vi.fn().mockResolvedValue(50),
      } as unknown as SettingsService;

      const helper = new PaginationHelper(mockSettingsService);
      const limit = await helper.resolveLimit();

      expect(mockSettingsService.getDefaultPageSize).toHaveBeenCalledTimes(1);
      expect(limit).toBe(50);
    });

    it('caps requested limit at MAX_PAGE_SIZE (100)', async () => {
      const helper = new PaginationHelper();
      const limit = await helper.resolveLimit(150);
      expect(limit).toBe(MAX_PAGE_SIZE);
    });

    it('caps SettingsService default at MAX_PAGE_SIZE (100) if setting exceeds max', async () => {
      const mockSettingsService = {
        getDefaultPageSize: vi.fn().mockResolvedValue(200),
      } as unknown as SettingsService;

      const helper = new PaginationHelper(mockSettingsService);
      const limit = await helper.resolveLimit();
      expect(limit).toBe(MAX_PAGE_SIZE);
    });

    it('normalizes cursor-based pagination query', async () => {
      const helper = new PaginationHelper();
      const cursor = encodeCursor({
        id: 42,
        createdAt: '2026-09-16T12:00:00.000Z',
      });

      const normalized = await helper.normalizeParams({
        cursor,
        limit: 15,
      });

      expect(normalized.mode).toBe('cursor');
      expect(normalized.limit).toBe(15);
      expect(normalized.cursor).toEqual({
        id: 42,
        createdAt: '2026-09-16T12:00:00.000Z',
      });
    });

    it('normalizes page-based pagination query into offset', async () => {
      const helper = new PaginationHelper();
      const normalized = await helper.normalizeParams({
        page: 3,
        limit: 10,
      });

      expect(normalized.mode).toBe('offset');
      expect(normalized.limit).toBe(10);
      expect(normalized.page).toBe(3);
      expect(normalized.offset).toBe(20);
    });

    it('normalizes offset-based pagination query', async () => {
      const helper = new PaginationHelper();
      const normalized = await helper.normalizeParams({
        offset: 35,
        limit: 10,
      });

      expect(normalized.mode).toBe('offset');
      expect(normalized.limit).toBe(10);
      expect(normalized.offset).toBe(35);
    });
  });
});
