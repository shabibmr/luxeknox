import { describe, it, expect, beforeEach, vi } from 'vitest';
import { Reflector } from '@nestjs/core';
import type { ExecutionContext } from '@nestjs/common';
import { PermissionGuard } from './permission.guard';
import { PermissionCache } from './permission-cache';
import { AuthGuard, type AuthenticatedUser } from '../auth/auth.guard';
import { SessionCache } from '../auth/session.cache';
import { SessionRepository } from '../auth/session.repository';
import { UserRepository } from '../auth/user.repository';
import { ForbiddenError, UnauthorizedError } from '../platform/errors/app-error';
import { hashToken } from '../auth/token';
import type { Session } from '../platform/db/schema/sessions';
import type { User } from '../platform/db/schema/users';

describe('AuthGuard & PermissionGuard', () => {
  let reflector: Reflector;

  // AuthGuard dependencies
  let authGuard: AuthGuard;
  let sessionCache: SessionCache;
  let sessionRepository: SessionRepository;
  let userRepository: UserRepository;

  // PermissionGuard dependencies
  let permissionGuard: PermissionGuard;
  let permissionCache: PermissionCache;

  const validAccessToken = 'gk_at_test_access_token_1234567890abcdef';
  const validTokenHash = hashToken(validAccessToken);

  const mockSession: Session = {
    id: 10,
    user_id: 100,
    user_type: 'member',
    profile_id: 50,
    family_id: 'fam-uuid-1',
    access_token_hash: validTokenHash,
    refresh_token_hash: 'rt_hash',
    revoked_at: null,
    expires_at: new Date(Date.now() + 1800000),
    created_at: new Date(),
    updated_at: null,
  };

  const mockActiveUser: User = {
    id: 100,
    email: 'member@example.com',
    phone_number: '+1000000000',
    password_hash: 'hashed',
    user_type: 'member',
    role_id: 5, // Member role
    avatar_url: null,
    status: 'active',
    created_at: new Date(),
    updated_at: null,
  };

  function createMockExecutionContext(options: {
    path?: string;
    authHeader?: string;
    user?: AuthenticatedUser;
    session?: Session;
    isPublic?: boolean;
    requiredPermissions?: string[];
  }): ExecutionContext {
    const {
      path = '/v1/members/me',
      authHeader,
      user,
      session,
      isPublic = false,
      requiredPermissions,
    } = options;

    const request: any = {
      path,
      url: path,
      headers: authHeader ? { authorization: authHeader } : {},
      user,
      session,
    };

    const handler = () => {};
    const cls = class TestController {};

    return {
      switchToHttp: () => ({
        getRequest: () => request,
        getResponse: () => ({}),
        getNext: () => ({}),
      }),
      getHandler: () => handler,
      getClass: () => cls,
    } as unknown as ExecutionContext;
  }

  beforeEach(() => {
    reflector = new Reflector();

    sessionCache = new SessionCache(60);
    sessionRepository = {
      findActiveByAccessTokenHash: vi.fn().mockResolvedValue(null),
    } as unknown as SessionRepository;
    userRepository = {
      findById: vi.fn().mockResolvedValue(null),
    } as unknown as UserRepository;

    authGuard = new AuthGuard(reflector, sessionCache, sessionRepository, userRepository);
    permissionCache = {
      getPermissionsForRole: vi.fn(),
    } as unknown as PermissionCache;
    permissionGuard = new PermissionGuard(reflector, permissionCache);
  });

  describe('Public Allowlist', () => {
    it.each([
      '/v1/health',
      '/v1/ready',
      '/v1/auth/login',
      '/v1/auth/refresh',
      '/v1/settings/public',
    ])('allows public path %s without token in AuthGuard', async (path) => {
      const ctx = createMockExecutionContext({ path });
      const canActivate = await authGuard.canActivate(ctx);
      expect(canActivate).toBe(true);
    });

    it('allows routes marked with @Public()', async () => {
      vi.spyOn(reflector, 'getAllAndOverride').mockReturnValueOnce(true);
      const ctx = createMockExecutionContext({ path: '/v1/custom-public' });

      const canActivate = await authGuard.canActivate(ctx);
      expect(canActivate).toBe(true);
    });
  });

  describe('AuthGuard token validation', () => {
    it('throws UnauthorizedError (401) when Authorization header is missing', async () => {
      const ctx = createMockExecutionContext({
        path: '/v1/settings',
        authHeader: undefined,
      });

      await expect(authGuard.canActivate(ctx)).rejects.toThrow(UnauthorizedError);
      await expect(authGuard.canActivate(ctx)).rejects.toThrow('Missing or malformed Authorization header');
    });

    it('throws UnauthorizedError (401) when token does not start with gk_at_', async () => {
      const ctx = createMockExecutionContext({
        path: '/v1/settings',
        authHeader: 'Bearer invalid_token_format',
      });

      await expect(authGuard.canActivate(ctx)).rejects.toThrow(UnauthorizedError);
      await expect(authGuard.canActivate(ctx)).rejects.toThrow('Invalid access token');
    });

    it('throws UnauthorizedError (401) when session is not found in cache or DB', async () => {
      const ctx = createMockExecutionContext({
        path: '/v1/settings',
        authHeader: `Bearer ${validAccessToken}`,
      });
      (sessionRepository.findActiveByAccessTokenHash as any).mockResolvedValueOnce(null);

      await expect(authGuard.canActivate(ctx)).rejects.toThrow(UnauthorizedError);
      await expect(authGuard.canActivate(ctx)).rejects.toThrow('Invalid or expired session');
    });

    it('throws UnauthorizedError (401) when session is expired or revoked', async () => {
      const ctx = createMockExecutionContext({
        path: '/v1/settings',
        authHeader: `Bearer ${validAccessToken}`,
      });

      const expiredSession: Session = {
        ...mockSession,
        expires_at: new Date(Date.now() - 1000), // expired 1 sec ago
      };
      sessionCache.set(validTokenHash, expiredSession);

      const err = await authGuard.canActivate(ctx).catch((e) => e);
      expect(err).toBeInstanceOf(UnauthorizedError);
      expect(err.message).toBe('Session has expired or been revoked');
    });

    it('throws UnauthorizedError (401) when user status is suspended', async () => {
      const ctx = createMockExecutionContext({
        path: '/v1/settings',
        authHeader: `Bearer ${validAccessToken}`,
      });
      sessionCache.set(validTokenHash, mockSession);

      const suspendedUser: User = {
        ...mockActiveUser,
        status: 'suspended',
      };
      vi.mocked(userRepository.findById).mockResolvedValueOnce(suspendedUser);

      const err = await authGuard.canActivate(ctx).catch((e) => e);
      expect(err).toBeInstanceOf(UnauthorizedError);
      expect(err.message).toBe('User account is not active');
    });

    it('successfully attaches user and session to request for valid active session', async () => {
      const ctx = createMockExecutionContext({
        path: '/v1/settings',
        authHeader: `Bearer ${validAccessToken}`,
      });
      sessionCache.set(validTokenHash, mockSession);
      vi.mocked(userRepository.findById).mockResolvedValueOnce(mockActiveUser);

      const canActivate = await authGuard.canActivate(ctx);
      expect(canActivate).toBe(true);

      const req = ctx.switchToHttp().getRequest<any>();
      expect(req.user).toEqual({
        id: mockActiveUser.id,
        email: mockActiveUser.email,
        phoneNumber: mockActiveUser.phone_number,
        userType: mockActiveUser.user_type,
        roleId: mockActiveUser.role_id,
        profileId: mockSession.profile_id,
        sessionId: mockSession.id,
      });
      expect(req.session).toEqual(mockSession);
    });
  });

  describe('PermissionGuard & RBAC verification', () => {
    it('throws UnauthorizedError when request.user is missing on protected route', async () => {
      vi.spyOn(reflector, 'getAllAndOverride')
        .mockReturnValueOnce(false) // isPublic
        .mockReturnValueOnce(['settings.read']); // requiredPermissions

      const ctx = createMockExecutionContext({
        path: '/v1/settings',
        user: undefined,
      });

      await expect(permissionGuard.canActivate(ctx)).rejects.toThrow(UnauthorizedError);
    });

    it('returns 403 ForbiddenError when Member role attempts settings.read', async () => {
      vi.spyOn(reflector, 'getAllAndOverride')
        .mockReturnValueOnce(false) // isPublic
        .mockReturnValueOnce(['settings.read']); // requiredPermissions

      // Mock member permissions without settings.read
      vi.spyOn(permissionCache, 'getPermissionsForRole').mockResolvedValueOnce(
        new Set(['members.read', 'workouts.read', 'auth.login']),
      );

      const ctx = createMockExecutionContext({
        path: '/v1/settings',
        user: {
          id: 100,
          email: 'member@example.com',
          phoneNumber: '+1000000000',
          userType: 'member',
          roleId: 5,
          profileId: 50,
          sessionId: 10,
        },
      });

      const err = await permissionGuard.canActivate(ctx).catch((e) => e);
      expect(err).toBeInstanceOf(ForbiddenError);
      expect(err.message).toBe("Forbidden: missing required permission 'settings.read'");
    });

    it('succeeds when user role has required permission settings.read', async () => {
      vi.spyOn(reflector, 'getAllAndOverride')
        .mockReturnValueOnce(false) // isPublic
        .mockReturnValueOnce(['settings.read']); // requiredPermissions

      // Mock admin permissions including settings.read
      vi.spyOn(permissionCache, 'getPermissionsForRole').mockResolvedValueOnce(
        new Set(['settings.read', 'audit.read']),
      );

      const ctx = createMockExecutionContext({
        path: '/v1/settings',
        user: {
          id: 2,
          email: 'admin@example.com',
          phoneNumber: null,
          userType: 'admin',
          roleId: 2,
          profileId: null,
          sessionId: 11,
        },
      });

      const canActivate = await permissionGuard.canActivate(ctx);
      expect(canActivate).toBe(true);
    });

    it('succeeds when Super Admin has wildcard permission (*)', async () => {
      vi.spyOn(reflector, 'getAllAndOverride')
        .mockReturnValueOnce(false) // isPublic
        .mockReturnValueOnce(['settings.read', 'settings.write']); // requiredPermissions

      // Mock super admin permissions with wildcard '*'
      vi.spyOn(permissionCache, 'getPermissionsForRole').mockResolvedValueOnce(
        new Set(['*']),
      );

      const ctx = createMockExecutionContext({
        path: '/v1/settings',
        user: {
          id: 1,
          email: 'superadmin@example.com',
          phoneNumber: null,
          userType: 'admin',
          roleId: 1,
          profileId: null,
          sessionId: 1,
        },
      });

      const canActivate = await permissionGuard.canActivate(ctx);
      expect(canActivate).toBe(true);
    });

    it('accepts OpenAPI members.create when the role has that slug', async () => {
      vi.spyOn(reflector, 'getAllAndOverride')
        .mockReturnValueOnce(false)
        .mockReturnValueOnce(['members.create']);

      vi.spyOn(permissionCache, 'getPermissionsForRole').mockResolvedValueOnce(
        new Set(['members.read', 'members.create', 'members.write']),
      );

      const ctx = createMockExecutionContext({
        path: '/v1/members',
        user: {
          id: 2,
          email: 'admin@example.com',
          phoneNumber: null,
          userType: 'admin',
          roleId: 2,
          profileId: null,
          sessionId: 11,
        },
      });

      await expect(permissionGuard.canActivate(ctx)).resolves.toBe(true);
    });

    it('rejects legacy members.write alone when route requires members.create', async () => {
      vi.spyOn(reflector, 'getAllAndOverride')
        .mockReturnValueOnce(false)
        .mockReturnValueOnce(['members.create']);

      vi.spyOn(permissionCache, 'getPermissionsForRole').mockResolvedValueOnce(
        new Set(['members.read', 'members.write']),
      );

      const ctx = createMockExecutionContext({
        path: '/v1/members',
        user: {
          id: 4,
          email: 'employee@example.com',
          phoneNumber: null,
          userType: 'employee',
          roleId: 4,
          profileId: 4,
          sessionId: 12,
        },
      });

      const err = await permissionGuard.canActivate(ctx).catch((e) => e);
      expect(err).toBeInstanceOf(ForbiddenError);
      expect(err.message).toContain("missing required permission 'members.create'");
    });
  });
});
