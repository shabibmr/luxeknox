import { describe, it, expect, beforeEach, vi } from 'vitest';
import { MeController } from './me.controller';
import type { AuthenticatedUser } from './auth.guard';
import type { PermissionCache } from '../rbac/permission-cache';
import type { RoleRepository } from '../rbac/role.repository';
import type { Role } from '../platform/db/schema/roles';

describe('MeController', () => {
  let controller: MeController;
  let roleRepository: RoleRepository;
  let mockPermissionCache: Partial<PermissionCache>;

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

    controller = new MeController(roleRepository, mockPermissionCache as PermissionCache);
  });

  it('returns user summary, role details, expanded slugs without wildcard, and profile: null', async () => {
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

  it('handles user with no matching role row in DB', async () => {
    vi.mocked(roleRepository.findById).mockResolvedValueOnce(null);
    (mockPermissionCache.getResolvedSlugs as any).mockResolvedValueOnce(['members.read']);

    const memberUser: AuthenticatedUser = {
      id: 5,
      email: 'member@luxeknox.com',
      phoneNumber: null,
      userType: 'member',
      roleId: 99,
      profileId: null,
      sessionId: 12,
    };

    const result = await controller.getMe(memberUser);

    expect(result.role).toBeNull();
    expect(result.slugs).toEqual(['members.read']);
    expect(result.profile).toBeNull();
  });
});
