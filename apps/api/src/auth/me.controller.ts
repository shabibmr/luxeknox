import { Controller, Get } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from './current-user.decorator';
import type { AuthenticatedUser } from './auth.guard';
import { PermissionCache } from '../rbac/permission-cache';
import { RoleRepository } from '../rbac/role.repository';

export interface MeUserDto {
  id: number;
  email: string | null;
  userType: string;
  roleId: number;
  user_type?: string;
  role_id?: number;
  status?: string;
  phone_number?: string | null;
}

export interface MeRoleDto {
  id: number;
  name: string;
  slug: string;
}

export interface MePrincipalDto {
  user_id: number;
  user_type: string;
  role: string;
  role_id: number;
  profile_id: number | null;
  permissions: string[];
}

export interface MeResponseDto {
  user: MeUserDto;
  principal?: MePrincipalDto;
  role: MeRoleDto | null;
  slugs: string[];
  profile: null;
}

@ApiTags('Auth')
@ApiBearerAuth('bearer')
@Controller('me')
export class MeController {
  constructor(
    private readonly roleRepository: RoleRepository,
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
    const role = await this.roleRepository.findById(currentUser.roleId);

    const slugs = await this.permissionCache.getResolvedSlugs(currentUser.roleId);

    return {
      user: {
        id: currentUser.id,
        email: currentUser.email,
        userType: currentUser.userType,
        roleId: currentUser.roleId,
        user_type: currentUser.userType,
        role_id: currentUser.roleId,
        status: 'active',
        phone_number: currentUser.phoneNumber,
      },
      principal: {
        user_id: currentUser.id,
        user_type: currentUser.userType,
        role: role ? role.slug : currentUser.userType,
        role_id: currentUser.roleId,
        profile_id: currentUser.profileId ?? null,
        permissions: slugs,
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
