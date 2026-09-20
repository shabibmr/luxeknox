import { Controller, Get } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from './current-user.decorator';
import type { AuthenticatedUser } from './auth.guard';
import { PermissionCache } from '../rbac/permission-cache';
import { RoleRepository } from '../rbac/role.repository';
import { UserRepository } from './user.repository';
import { PersonFactory } from '../people/person.factory';
import { MemberRepository } from '../people/member.repository';
import { TrainerRepository } from '../people/trainer.repository';
import { EmployeeRepository } from '../people/employee.repository';
import { normalizeSpecializations } from '../people/normalize-specializations';
import { roundMoney } from '../platform/money/money';

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
  /** Null for Super Admin without an employee row (FR-AUTH-009). */
  profile: unknown | null;
}

@ApiTags('Auth')
@ApiBearerAuth('bearer')
@Controller('me')
export class MeController {
  constructor(
    private readonly roleRepository: RoleRepository,
    private readonly permissionCache: PermissionCache,
    private readonly userRepository: UserRepository,
    private readonly personFactory: PersonFactory,
    private readonly memberRepository: MemberRepository,
    private readonly trainerRepository: TrainerRepository,
    private readonly employeeRepository: EmployeeRepository,
  ) {}

  @Get()
  @ApiOperation({
    summary: 'Get current authenticated user profile and permissions',
    description:
      'Returns the authenticated user details, assigned role, resolved permission slug list, and PEOPLE profile when present.',
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
    const userRow = await this.userRepository.findById(currentUser.id);

    const profileId =
      currentUser.profileId ??
      (await this.personFactory.resolveProfileId(currentUser.id, currentUser.userType));

    const profile = await this.loadProfile(currentUser.userType, profileId);

    return {
      user: {
        id: currentUser.id,
        email: currentUser.email,
        userType: currentUser.userType,
        roleId: currentUser.roleId,
        user_type: currentUser.userType,
        role_id: currentUser.roleId,
        status: userRow?.status ?? 'active',
        phone_number: currentUser.phoneNumber,
      },
      principal: {
        user_id: currentUser.id,
        user_type: currentUser.userType,
        role: role ? role.slug : currentUser.userType,
        role_id: currentUser.roleId,
        profile_id: profileId,
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
      profile,
    };
  }

  private async loadProfile(
    userType: AuthenticatedUser['userType'],
    profileId: number | null,
  ): Promise<unknown | null> {
    if (profileId == null) {
      return null;
    }

    if (userType === 'member') {
      return this.memberRepository.findById(profileId);
    }
    if (userType === 'trainer') {
      const trainer = await this.trainerRepository.findById(profileId);
      if (!trainer) return null;
      return {
        ...trainer,
        specializations: normalizeSpecializations(trainer.specializations),
        hourly_rate:
          trainer.hourly_rate == null || trainer.hourly_rate === ''
            ? null
            : roundMoney(String(trainer.hourly_rate)),
      };
    }
    if (userType === 'employee') {
      return this.employeeRepository.findByIdWithRole(profileId);
    }
    return null;
  }
}
