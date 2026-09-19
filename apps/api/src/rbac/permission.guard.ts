import {
  CanActivate,
  ExecutionContext,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { Request } from 'express';
import { IS_PUBLIC_KEY } from '../auth/public.decorator';
import { PUBLIC_PATH_PATTERNS } from '../auth/auth.guard';
import { REQUIRE_PERMISSIONS_KEY } from './require-permission.decorator';
import { PermissionCache } from './permission-cache';
import { ForbiddenError, UnauthorizedError } from '../platform/errors/app-error';

@Injectable()
export class PermissionGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly permissionCache: PermissionCache,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    // 1. If marked with @Public(), bypass permission checks
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) {
      return true;
    }

    // 2. If path is in public allowlist, bypass
    const request = context.switchToHttp().getRequest<Request>();
    const path = request.path || request.url?.split('?')[0] || '';
    if (PUBLIC_PATH_PATTERNS.some((pattern) => pattern.test(path))) {
      return true;
    }

    // 3. Read required permissions
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

    // 4. Resolve permissions for user's roleId from PermissionCache
    const userPermissions = await this.permissionCache.getPermissionsForRole(user.roleId);

    // Check if role has wildcard '*' or 'all'
    if (userPermissions.has('*') || userPermissions.has('all')) {
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
