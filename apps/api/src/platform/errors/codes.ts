export const ErrorCode = {
  VALIDATION_ERROR: 'validation_error',
  UNAUTHENTICATED: 'unauthenticated',
  FORBIDDEN: 'forbidden',
  NOT_FOUND: 'not_found',
  CONFLICT: 'conflict',
  BUSINESS_RULE: 'business_rule',
  RATE_LIMITED: 'rate_limited',
  INTERNAL_ERROR: 'internal_error',
} as const;

export type ErrorCode = (typeof ErrorCode)[keyof typeof ErrorCode];

export interface ErrorResponseBody {
  code: string;
  message: string;
  details?: unknown[];
  request_id: string;
}
