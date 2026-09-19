import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import type { Request } from 'express';
import type { AuthenticatedUser } from './auth.guard';
import { UnauthorizedError } from '../platform/errors/app-error';

/**
 * Parameter decorator that extracts the authenticated user from the request.
 * Can optionally extract a specific property: `@CurrentUser('id') userId: number`.
 */
export const CurrentUser = createParamDecorator(
  (data: keyof AuthenticatedUser | undefined, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest<Request>();
    const user = (request as any).user as AuthenticatedUser | undefined;

    if (!user) {
      throw new UnauthorizedError('Authentication required');
    }

    return data ? user[data] : user;
  },
);
