import { SetMetadata } from '@nestjs/common';

export const IS_PUBLIC_KEY = 'isPublic';

/**
 * Decorator to mark routes as public, bypassing authentication and permission checks.
 */
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);
