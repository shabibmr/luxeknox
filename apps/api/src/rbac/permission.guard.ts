import {
  CanActivate,
  ExecutionContext,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { Request } from 'express';
import { isPublicRequest } from '../auth/public-paths';
import { REQUIRE_PERMISSIONS_KEY } from './require-permission.decorator';
import { PermissionCache, WILDCARD_SLUG } from './permission-cache';
import { ForbiddenError, UnauthorizedError } from '../platform/errors/app-error';

@Injectable()
export class PermissionGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly permissionCache: PermissionCache,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    if (isPublicRequest(this.reflector, context)) {
      return true;
    }

    const request = context.switchToHttp().getRequest<Request>();

    // Read required permissions
    const requiredPermissions = this.reflector.getAllAndOverride<string[]>(
      REQUIRE_PERMISSIONS_KEY,
      [context.getHandler(), context.getClass()],
    );

    // If route has no required permissions specified, allow access (authenticated user)
    if (!requiredPermissions || requiredPermissions.length === 0) {
      return true;
    }

    // User must be authenticated to check permissions
    const user = request.user;
    if (!user) {
      throw new UnauthorizedError('Authentication required');
    }

    // Resolve permissions for user's roleId from PermissionCache
    const userPermissions = await this.permissionCache.getPermissionsForRole(user.roleId);

    if (userPermissions.has(WILDCARD_SLUG)) {
      return true;
    }

    // 5. Verify all required permissions are granted
    for (const required of requiredPermissions) {
      if (!userPermissions.has(required)) {
        throw new ForbiddenError(
          `Forbidden: missing required permission '${required}'`,
          [{ requiredPermission: required }],
        );
      }
    }

    return true;
  }
}
