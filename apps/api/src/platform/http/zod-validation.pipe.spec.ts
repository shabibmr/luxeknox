import { describe, it, expect } from 'vitest';
import { z } from 'zod';
import { ZodValidationPipe } from './zod-validation.pipe';
import { BadRequestError } from '../errors/app-error';

const schema = z.object({
  identifier: z.string().min(1),
  password: z.string().min(1),
});

describe('ZodValidationPipe', () => {
  const pipe = new ZodValidationPipe(schema);

  it('returns parsed data for a valid body', () => {
    const input = { identifier: 'a@b.com', password: 'secret' };
    expect(pipe.transform(input, {} as any)).toEqual(input);
  });

  it('throws BadRequestError when a required field is missing', () => {
    expect(() => pipe.transform({}, {} as any)).toThrow(BadRequestError);
  });

  it('thrown error carries validation_error code and non-empty details', () => {
    try {
      pipe.transform({}, {} as any);
      expect.unreachable('expected BadRequestError');
    } catch (err) {
      expect(err).toBeInstanceOf(BadRequestError);
      const error = err as BadRequestError;
      expect(error.code).toBe('validation_error');
      expect(error.details.length).toBeGreaterThan(0);
    }
  });
});
