/**
 * Shared catalogue browse visibility for library verticals (exercises, foods, …).
 * Services own domain predicates; this helper only centralizes unrestricted checks
 * and leak-safe 404 presentation.
 */

export interface CataloguePermissionCache {
  hasPermission(roleId: number, slug: string): Promise<boolean>;
}

/** True when the role may browse restricted (inactive / unverified) catalogue rows. */
export async function canBrowseUnrestricted(
  permissionCache: CataloguePermissionCache,
  roleId: number,
  unrestrictedPermission: string,
): Promise<boolean> {
  return permissionCache.hasPermission(roleId, unrestrictedPermission);
}

/**
 * Return the row or throw NotFoundError when non-unrestricted callers must not
 * learn that a hidden catalogue item exists.
 */
export function requireVisibleCatalogueRow<T>(
  row: T | null,
  opts: {
    unrestricted: boolean;
    isVisible: (row: T) => boolean;
    notFoundMessage: string;
    NotFoundError: new (message: string) => Error;
  },
): T {
  if (!row) {
    throw new opts.NotFoundError(opts.notFoundMessage);
  }
  if (!opts.unrestricted && !opts.isVisible(row)) {
    throw new opts.NotFoundError(opts.notFoundMessage);
  }
  return row;
}
