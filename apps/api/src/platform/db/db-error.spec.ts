import { describe, it, expect, vi } from 'vitest';
import {
  CHECK_VIOLATION,
  DEADLOCK_DETECTED,
  FOREIGN_KEY_VIOLATION,
  INVALID_TEXT_REPRESENTATION,
  PG_ERROR_CODES,
  SERIALIZATION_FAILURE,
  STRING_DATA_RIGHT_TRUNCATION,
  UNIQUE_VIOLATION,
  isCheckViolation,
  isDeadlock,
  isForeignKeyViolation,
  isInvalidTextRepresentation,
  isRetryableTxError,
  isSerializationFailure,
  isStringDataRightTruncation,
  isUniqueViolation,
  sqlState,
} from './pg-errors';
import { translateDbError } from './db-error';
import { AppError, BadRequestError, ConflictError } from '../errors/app-error';
import { ErrorCode } from '../errors/codes';
import { BaseRepository } from './base.repository';
import type { DrizzleDb } from './client';
import { pgTable, serial, text } from 'drizzle-orm/pg-core';
import { eq } from 'drizzle-orm';

function createPgError(code: string, message = 'Database error'): Error & { code: string } {
  return Object.assign(new Error(message), { code });
}

describe('Postgres SQLSTATE Error Classification & Translation (HARDEN-08)', () => {
  describe('pg-errors constants and helper functions', () => {
    it('defines expected SQLSTATE constants', () => {
      expect(UNIQUE_VIOLATION).toBe('23505');
      expect(FOREIGN_KEY_VIOLATION).toBe('23503');
      expect(CHECK_VIOLATION).toBe('23514');
      expect(SERIALIZATION_FAILURE).toBe('40001');
      expect(DEADLOCK_DETECTED).toBe('40P01');
      expect(INVALID_TEXT_REPRESENTATION).toBe('22P02');
      expect(STRING_DATA_RIGHT_TRUNCATION).toBe('22001');

      expect(PG_ERROR_CODES).toEqual({
        UNIQUE_VIOLATION: '23505',
        FOREIGN_KEY_VIOLATION: '23503',
        CHECK_VIOLATION: '23514',
        SERIALIZATION_FAILURE: '40001',
        DEADLOCK_DETECTED: '40P01',
        INVALID_TEXT_REPRESENTATION: '22P02',
        STRING_DATA_RIGHT_TRUNCATION: '22001',
      });
    });

    describe('sqlState extraction', () => {
      it('extracts code from direct property on error', () => {
        const err = createPgError('23505');
        expect(sqlState(err)).toBe('23505');
      });

      it('extracts code from nested cause property', () => {
        const causeErr = createPgError('40001');
        const wrappingErr = new Error('Query failed', { cause: causeErr });
        expect(sqlState(wrappingErr)).toBe('40001');
      });

      it('returns undefined for non-objects or errors without code', () => {
        expect(sqlState(null)).toBeUndefined();
        expect(sqlState(undefined)).toBeUndefined();
        expect(sqlState('string error')).toBeUndefined();
        expect(sqlState(123)).toBeUndefined();
        expect(sqlState(new Error('regular error'))).toBeUndefined();
        expect(sqlState({})).toBeUndefined();
      });
    });

    describe('isCheckViolation', () => {
      it('returns true for 23514 check_violation', () => {
        expect(isCheckViolation(createPgError('23514'))).toBe(true);
        expect(isCheckViolation({ code: '23514' })).toBe(true);
      });

      it('returns false for other error codes', () => {
        expect(isCheckViolation(createPgError('23505'))).toBe(false);
        expect(isCheckViolation(new Error('unrelated'))).toBe(false);
      });
    });

    describe('isSerializationFailure', () => {
      it('returns true for 40001 serialization_failure', () => {
        expect(isSerializationFailure(createPgError('40001'))).toBe(true);
        expect(isSerializationFailure({ code: '40001' })).toBe(true);
      });

      it('returns false for other error codes', () => {
        expect(isSerializationFailure(createPgError('40P01'))).toBe(false);
        expect(isSerializationFailure(createPgError('23505'))).toBe(false);
        expect(isSerializationFailure(new Error())).toBe(false);
      });
    });

    describe('isDeadlock', () => {
      it('returns true for 40P01 deadlock_detected', () => {
        expect(isDeadlock(createPgError('40P01'))).toBe(true);
        expect(isDeadlock({ code: '40P01' })).toBe(true);
      });

      it('returns false for other error codes', () => {
        expect(isDeadlock(createPgError('40001'))).toBe(false);
        expect(isDeadlock(createPgError('23514'))).toBe(false);
        expect(isDeadlock(new Error())).toBe(false);
      });
    });

    describe('isRetryableTxError', () => {
      it('returns true for 40001 serialization_failure', () => {
        expect(isRetryableTxError(createPgError('40001'))).toBe(true);
      });

      it('returns true for 40P01 deadlock_detected', () => {
        expect(isRetryableTxError(createPgError('40P01'))).toBe(true);
      });

      it('returns false for non-retryable error codes', () => {
        expect(isRetryableTxError(createPgError('23505'))).toBe(false);
        expect(isRetryableTxError(createPgError('23503'))).toBe(false);
        expect(isRetryableTxError(createPgError('23514'))).toBe(false);
        expect(isRetryableTxError(createPgError('22P02'))).toBe(false);
        expect(isRetryableTxError(createPgError('22001'))).toBe(false);
        expect(isRetryableTxError(new Error('network timeout'))).toBe(false);
      });
    });

    describe('isInvalidTextRepresentation', () => {
      it('returns true for 22P02 invalid_text_representation', () => {
        expect(isInvalidTextRepresentation(createPgError('22P02'))).toBe(true);
      });

      it('returns false for other error codes', () => {
        expect(isInvalidTextRepresentation(createPgError('23505'))).toBe(false);
      });
    });

    describe('isStringDataRightTruncation', () => {
      it('returns true for 22001 string_data_right_truncation', () => {
        expect(isStringDataRightTruncation(createPgError('22001'))).toBe(true);
      });

      it('returns false for other error codes', () => {
        expect(isStringDataRightTruncation(createPgError('22P02'))).toBe(false);
      });
    });

    describe('isUniqueViolation and isForeignKeyViolation', () => {
      it('identifies unique violation (23505)', () => {
        expect(isUniqueViolation(createPgError('23505'))).toBe(true);
        expect(isUniqueViolation(createPgError('23503'))).toBe(false);
      });

      it('identifies foreign key violation (23503)', () => {
        expect(isForeignKeyViolation(createPgError('23503'))).toBe(true);
        expect(isForeignKeyViolation(createPgError('23505'))).toBe(false);
      });
    });
  });

  describe('translateDbError', () => {
    it('translates 23505 unique_violation to ConflictError with default or custom message', () => {
      const err = createPgError('23505');
      const translated = translateDbError(err);
      expect(translated).toBeInstanceOf(ConflictError);
      expect(translated.message).toBe('Resource already exists; unique constraint violation');

      const customTranslated = translateDbError(err, { duplicateMessage: 'User with email already exists' });
      expect(customTranslated).toBeInstanceOf(ConflictError);
      expect(customTranslated.message).toBe('User with email already exists');
    });

    it('translates 23503 foreign_key_violation to ConflictError with default or custom message', () => {
      const err = createPgError('23503');
      const translated = translateDbError(err);
      expect(translated).toBeInstanceOf(ConflictError);
      expect(translated.message).toBe('Referenced record does not exist or violates foreign key constraint');

      const customTranslated = translateDbError(err, { foreignKeyMessage: 'Gym branch does not exist' });
      expect(customTranslated).toBeInstanceOf(ConflictError);
      expect(customTranslated.message).toBe('Gym branch does not exist');
    });

    it('translates 23514 check_violation to BadRequestError with default or custom message', () => {
      const err = createPgError('23514');
      const translated = translateDbError(err);
      expect(translated).toBeInstanceOf(BadRequestError);
      expect(translated.message).toBe('Check constraint violation');

      const customTranslated = translateDbError(err, { checkViolationMessage: 'Price must be greater than zero' });
      expect(customTranslated).toBeInstanceOf(BadRequestError);
      expect(customTranslated.message).toBe('Price must be greater than zero');

      const alternativeCustom = translateDbError(err, { checkConstraintMessage: 'Invalid duration constraint' });
      expect(alternativeCustom).toBeInstanceOf(BadRequestError);
      expect(alternativeCustom.message).toBe('Invalid duration constraint');
    });

    it('translates 22P02 invalid_text_representation to BadRequestError with default or custom message', () => {
      const err = createPgError('22P02');
      const translated = translateDbError(err);
      expect(translated).toBeInstanceOf(BadRequestError);
      expect(translated.message).toBe('Invalid input data format');

      const customTranslated = translateDbError(err, { invalidInputMessage: 'Malformed UUID or identifier' });
      expect(customTranslated).toBeInstanceOf(BadRequestError);
      expect(customTranslated.message).toBe('Malformed UUID or identifier');

      const customTextTranslated = translateDbError(err, { invalidTextMessage: 'Malformed integer syntax' });
      expect(customTextTranslated).toBeInstanceOf(BadRequestError);
      expect(customTextTranslated.message).toBe('Malformed integer syntax');
    });

    it('translates 22001 string_data_right_truncation to BadRequestError with default or custom message', () => {
      const err = createPgError('22001');
      const translated = translateDbError(err);
      expect(translated).toBeInstanceOf(BadRequestError);
      expect(translated.message).toBe('String data exceeds maximum allowed length');

      const customTranslated = translateDbError(err, { stringTruncationMessage: 'Field exceeds maximum 255 characters' });
      expect(customTranslated).toBeInstanceOf(BadRequestError);
      expect(customTranslated.message).toBe('Field exceeds maximum 255 characters');
    });

    it('preserves unmapped standard Error instances unchanged', () => {
      const originalErr = new Error('Connection reset by peer');
      const translated = translateDbError(originalErr);
      expect(translated).toBe(originalErr);
    });

    it('translates non-Error values to AppError with INTERNAL_ERROR code', () => {
      const translatedNull = translateDbError(null);
      expect(translatedNull).toBeInstanceOf(AppError);
      expect((translatedNull as AppError).code).toBe(ErrorCode.INTERNAL_ERROR);

      const translatedString = translateDbError('Something unexpected');
      expect(translatedString).toBeInstanceOf(AppError);
      expect((translatedString as AppError).code).toBe(ErrorCode.INTERNAL_ERROR);
    });
  });

  describe('BaseRepository error translation integration', () => {
    const testTable = pgTable('test_table', {
      id: serial('id').primaryKey(),
      name: text('name').notNull(),
    });

    type TestItem = typeof testTable.$inferSelect;
    type NewTestItem = typeof testTable.$inferInsert;

    class TestRepository extends BaseRepository<typeof testTable, TestItem, NewTestItem> {
      constructor(db: DrizzleDb<any>) {
        super(db, testTable);
      }
    }

    it('translates check violation (23514) on create to BadRequestError', async () => {
      const mockDb = {
        insert: vi.fn().mockReturnValue({
          values: vi.fn().mockReturnValue({
            returning: vi.fn().mockRejectedValue(createPgError('23514', 'new row violates check constraint')),
          }),
        }),
      } as unknown as DrizzleDb<any>;

      const repo = new TestRepository(mockDb);
      await expect(repo.create({ name: 'Invalid' })).rejects.toThrow(BadRequestError);
    });

    it('translates unique violation (23505) on create to ConflictError', async () => {
      const mockDb = {
        insert: vi.fn().mockReturnValue({
          values: vi.fn().mockReturnValue({
            returning: vi.fn().mockRejectedValue(createPgError('23505', 'duplicate key value violates unique constraint')),
          }),
        }),
      } as unknown as DrizzleDb<any>;

      const repo = new TestRepository(mockDb);
      await expect(repo.create({ name: 'Duplicate' })).rejects.toThrow(ConflictError);
    });

    it('translates check violation (23514) on update to BadRequestError', async () => {
      const mockDb = {
        update: vi.fn().mockReturnValue({
          set: vi.fn().mockReturnValue({
            where: vi.fn().mockRejectedValue(createPgError('23514', 'check constraint')),
          }),
        }),
      } as unknown as DrizzleDb<any>;

      const repo = new TestRepository(mockDb);
      await expect(repo.update(eq(testTable.id, 1), { name: 'Invalid' })).rejects.toThrow(BadRequestError);
    });

    it('translates foreign key violation (23503) on delete to ConflictError', async () => {
      const mockDb = {
        delete: vi.fn().mockReturnValue({
          where: vi.fn().mockRejectedValue(createPgError('23503', 'violates foreign key constraint')),
        }),
      } as unknown as DrizzleDb<any>;

      const repo = new TestRepository(mockDb);
      await expect(repo.delete(eq(testTable.id, 1))).rejects.toThrow(ConflictError);
    });

    it('translates invalid text representation (22P02) on findById to BadRequestError', async () => {
      const mockDb = {
        select: vi.fn().mockReturnValue({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockReturnValue({
              limit: vi.fn().mockRejectedValue(createPgError('22P02', 'invalid input syntax for type integer')),
            }),
          }),
        }),
      } as unknown as DrizzleDb<any>;

      const repo = new TestRepository(mockDb);
      await expect(repo.findById(1)).rejects.toThrow(BadRequestError);
    });

    it('translates invalid text representation (22P02) on findOne to BadRequestError', async () => {
      const mockDb = {
        select: vi.fn().mockReturnValue({
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockReturnValue({
              limit: vi.fn().mockRejectedValue(createPgError('22P02', 'invalid input syntax')),
            }),
          }),
        }),
      } as unknown as DrizzleDb<any>;

      const repo = new TestRepository(mockDb);
      await expect(repo.findOne(eq(testTable.id, 1))).rejects.toThrow(BadRequestError);
    });
  });
});
