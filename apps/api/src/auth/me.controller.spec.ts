import { describe, it, expect, beforeEach, vi } from 'vitest';
import { MeController } from './me.controller';
import type { AuthenticatedUser } from './auth.guard';
import type { PermissionCache } from '../rbac/permission-cache';
import type { Role } from '../platform/db/schema/roles';

describe('MeController', () => {
  let controller: MeController;
  let mockDb: any;
  let mockPermissionCache: Partial<PermissionCache>;

  const mockUser: AuthenticatedUser = {
    id: 1,
    email: 'admin@luxeknox.com',
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
    mockDb = {
      select: vi.fn(),
    };

    mockPermissionCache = {
      getPermissionsForRole: vi.fn().mockResolvedValue(new Set(['*', 'settings.read', 'settings.write'])),
    };

    controller = new MeController(mockDb, mockPermissionCache as PermissionCache);
  });

  function mockDbSelect(result: any[]) {
    mockDb.select.mockReturnValueOnce({
      from: vi.fn().mockReturnValue({
        where: vi.fn().mockReturnValue({
          limit: vi.fn().mockResolvedValue(result),
        }),
      }),
    });
  }

  it('returns user summary, role details, slugs array, and profile: null', async () => {
    mockDbSelect([mockRole]);

    const result = await controller.getMe(mockUser);

    expect(result).toEqual({
      user: {
        id: 1,
        email: 'admin@luxeknox.com',
        userType: 'admin',
        roleId: 1,
      },
      role: {
        id: 1,
        name: 'Super Admin',
        slug: 'super_admin',
      },
      slugs: expect.arrayContaining(['*', 'settings.read', 'settings.write']),
      profile: null,
    });

    expect(mockPermissionCache.getPermissionsForRole).toHaveBeenCalledWith(1);
  });

  it('handles user with no matching role row in DB', async () => {
    mockDbSelect([]); // No role returned
    (mockPermissionCache.getPermissionsForRole as any).mockResolvedValueOnce(new Set(['members.read']));

    const memberUser: AuthenticatedUser = {
      id: 5,
      email: 'member@luxeknox.com',
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
