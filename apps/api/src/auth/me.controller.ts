import { Controller, Get, Inject } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { eq } from 'drizzle-orm';
import { CurrentUser } from './current-user.decorator';
import type { AuthenticatedUser } from './auth.guard';
import { PermissionCache } from '../rbac/permission-cache';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { roles, type Role } from '../platform/db/schema/roles';

export interface MeUserDto {
  id: number;
  email: string | null;
  userType: string;
  roleId: number;
}

export interface MeRoleDto {
  id: number;
  name: string;
  slug: string;
}

export interface MeResponseDto {
  user: MeUserDto;
  role: MeRoleDto | null;
  slugs: string[];
  profile: null;
}

@ApiTags('Auth')
@ApiBearerAuth('bearer')
@Controller('me')
export class MeController {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
    private readonly permissionCache: PermissionCache,
  ) {}

  @Get()
  @ApiOperation({
    summary: 'Get current authenticated user profile and permissions',
    description:
      'Returns the authenticated user details, assigned role, resolved permission slug list, and profile stub (null in Module 0).',
  })
  @ApiResponse({
    status: 200,
    description: 'Current user profile summary with resolved permission slugs',
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthenticated or invalid session',
  })
  async getMe(@CurrentUser() currentUser: AuthenticatedUser): Promise<MeResponseDto> {
    // 1. Fetch role row from DB
    const roleRows = await (this.db as any)
      .select()
      .from(roles)
      .where(eq(roles.id, currentUser.roleId))
      .limit(1);

    const role: Role | undefined = roleRows[0];

    // 2. Resolve permission slugs from PermissionCache
    const permissions = await this.permissionCache.getPermissionsForRole(currentUser.roleId);
    const slugs = Array.from(permissions);

    return {
      user: {
        id: currentUser.id,
        email: currentUser.email,
        userType: currentUser.userType,
        roleId: currentUser.roleId,
      },
      role: role
        ? {
            id: role.id,
            name: role.name,
            slug: role.slug,
          }
        : null,
      slugs,
      profile: null,
    };
  }
}
