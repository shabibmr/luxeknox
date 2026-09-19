import { ArgumentMetadata, Injectable, PipeTransform } from '@nestjs/common';
import { ZodSchema, ZodError } from 'zod';

/**
 * Validates incoming request values against a given Zod schema.
 * Throws ZodError directly so GlobalExceptionFilter formats it as
 * code: 'validation_error' with details and request_id.
 */
@Injectable()
export class ZodValidationPipe implements PipeTransform {
  constructor(private readonly schema?: ZodSchema) {}

  transform(value: unknown, _metadata: ArgumentMetadata) {
    if (!this.schema) {
      return value;
    }

    const result = this.schema.safeParse(value);
    if (!result.success) {
      throw (result as { error: ZodError }).error;
    }

    return result.data;
  }
}
