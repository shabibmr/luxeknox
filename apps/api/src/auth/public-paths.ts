import type { ExecutionContext } from '@nestjs/common';
import type { Reflector } from '@nestjs/core';
import type { Request } from 'express';
import { IS_PUBLIC_KEY } from './public.decorator';

/**
 * Routes reachable without a Bearer token (M0-22).
 * Paths carry the `v1` global prefix because `setGlobalPrefix('v1')` always runs.
 */
export const PUBLIC_PATH_PATTERNS: readonly RegExp[] = [
  /^\/v1\/health\/?$/,
  /^\/v1\/ready\/?$/,
  /^\/v1\/auth\/login\/?$/,
  /^\/v1\/auth\/refresh\/?$/,
  /^\/v1\/settings\/public\/?$/,
];

export function isPublicRequest(reflector: Reflector, context: ExecutionContext): boolean {
  const decorated = reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
    context.getHandler(),
    context.getClass(),
  ]);
  if (decorated) {
    return true;
  }

  const request = context.switchToHttp().getRequest<Request>();
  const path = request.path || request.url?.split('?')[0] || '';
  return PUBLIC_PATH_PATTERNS.some((pattern) => pattern.test(path));
}
