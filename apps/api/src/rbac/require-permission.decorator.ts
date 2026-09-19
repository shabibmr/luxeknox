import { SetMetadata } from '@nestjs/common';

export const REQUIRE_PERMISSIONS_KEY = 'requirePermissions';

/**
 * Decorator to require a single permission slug on a route handler or controller.
 * e.g. `@RequirePermission('settings.read')`
 */
export const RequirePermission = (permission: string) =>
  SetMetadata(REQUIRE_PERMISSIONS_KEY, [permission]);

/**
 * Decorator to require one or more permission slugs on a route handler or controller.
 * e.g. `@RequirePermissions(['members.read', 'members.write'])`
 */
export const RequirePermissions = (permissions: string[]) =>
  SetMetadata(REQUIRE_PERMISSIONS_KEY, permissions);
