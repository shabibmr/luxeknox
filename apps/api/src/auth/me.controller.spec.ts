import { describe, it, expect, beforeEach, vi } from 'vitest';
import { MeController } from './me.controller';
import type { AuthenticatedUser } from './auth.guard';
import type { PermissionCache } from '../rbac/permission-cache';
import type { RoleRepository } from '../rbac/role.repository';
import type { Role } from '../platform/db/schema/roles';
import type { UserRepository } from './user.repository';
import type { PersonFactory } from '../people/person.factory';
import type { MemberRepository } from '../people/member.repository';
import type { TrainerRepository } from '../people/trainer.repository';
import type { EmployeeRepository } from '../people/employee.repository';

describe('MeController', () => {
  let controller: MeController;
  let roleRepository: RoleRepository;
  let mockPermissionCache: Partial<PermissionCache>;
  let userRepository: UserRepository;
  let personFactory: PersonFactory;
  let memberRepository: MemberRepository;

  const mockUser: AuthenticatedUser = {
    id: 1,
    email: 'admin@luxeknox.com',
    phoneNumber: '+15551234567',
    userType: 'admin',
    roleId: 1,
    profileId: null,
    sessionId: 10,
  };

  const mockRole: Role = {
    id: 1,
    name: 'Super Admin',
    slug: 'super_admin',
    description: 'Full system access',
    is_system: true,
    created_at: new Date(),
    updated_at: null,
  };

  beforeEach(() => {
    roleRepository = {
      findById: vi.fn().mockResolvedValue(mockRole),
    } as unknown as RoleRepository;

    mockPermissionCache = {
      getResolvedSlugs: vi
        .fn()
        .mockResolvedValue(['audit.read', 'settings.read', 'settings.write']),
    };

    userRepository = {
      findById: vi.fn().mockResolvedValue({ status: 'active' }),
    } as unknown as UserRepository;

    personFactory = {
      resolveProfileId: vi.fn().mockResolvedValue(null),
    } as unknown as PersonFactory;

    memberRepository = {
      findById: vi.fn(),
    } as unknown as MemberRepository;

    controller = new MeController(
      roleRepository,
      mockPermissionCache as PermissionCache,
      userRepository,
      personFactory,
      memberRepository,
      { findById: vi.fn() } as unknown as TrainerRepository,
      { findByIdWithRole: vi.fn() } as unknown as EmployeeRepository,
    );
  });

  it('returns user summary, role details, expanded slugs, and profile: null for admin', async () => {
    const result = await controller.getMe(mockUser);

    expect(result).toEqual({
      user: {
        id: 1,
        email: 'admin@luxeknox.com',
        userType: 'admin',
        roleId: 1,
        user_type: 'admin',
        role_id: 1,
        status: 'active',
        phone_number: '+15551234567',
      },
      principal: {
        user_id: 1,
        user_type: 'admin',
        role: 'super_admin',
        role_id: 1,
        profile_id: null,
        permissions: ['audit.read', 'settings.read', 'settings.write'],
      },
      role: {
        id: 1,
        name: 'Super Admin',
        slug: 'super_admin',
      },
      slugs: ['audit.read', 'settings.read', 'settings.write'],
      profile: null,
    });

    expect(result.slugs).toContain('settings.read');
    expect(result.slugs).not.toContain('*');
    expect(mockPermissionCache.getResolvedSlugs).toHaveBeenCalledWith(1);
  });

  it('returns member profile when profileId is present', async () => {
    const memberProfile = {
      id: 42,
      user_id: 5,
      membership_number: 'M00000001',
      first_name: 'Demo',
      last_name: 'Member',
    };
    vi.mocked(personFactory.resolveProfileId).mockResolvedValueOnce(42);
    vi.mocked(memberRepository.findById).mockResolvedValueOnce(memberProfile as any);
    vi.mocked(roleRepository.findById).mockResolvedValueOnce(null);
    (mockPermissionCache.getResolvedSlugs as any).mockResolvedValueOnce(['members.read']);

    const memberUser: AuthenticatedUser = {
      id: 5,
      email: 'member@luxeknox.com',
      phoneNumber: null,
      userType: 'member',
      roleId: 99,
      profileId: 42,
      sessionId: 12,
    };

    const result = await controller.getMe(memberUser);

    expect(result.role).toBeNull();
    expect(result.slugs).toEqual(['members.read']);
    expect(result.principal?.profile_id).toBe(42);
    expect(result.profile).toEqual(memberProfile);
  });
});
