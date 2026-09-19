import { describe, it, expect, beforeEach, vi } from 'vitest';
import { AuthService } from './auth.service';
import { SessionRepository } from './session.repository';
import { SessionCache } from './session.cache';
import { LoginThrottle } from './login-throttle';
import { hashPassword } from './password';
import { hashToken } from './token';
import { RateLimitedError } from '../platform/errors/app-error';
import type { User } from '../platform/db/schema/users';
import type { Session } from '../platform/db/schema/sessions';

describe('AuthService', () => {
  let authService: AuthService;
  let mockDb: any;
  let sessionRepository: SessionRepository;
  let sessionCache: SessionCache;
  let loginThrottle: LoginThrottle;

  const validPassword = 'CorrectPassword123!';
  let validPasswordHash: string;

  const mockUser: User = {
    id: 42,
    email: 'test@example.com',
    phone_number: '+1234567890',
    password_hash: '', // will set in beforeEach
    user_type: 'member',
    role_id: 1,
    avatar_url: null,
    status: 'active',
    created_at: new Date(),
    updated_at: null,
  };

  beforeEach(async () => {
    validPasswordHash = await hashPassword(validPassword);
    mockUser.password_hash = validPasswordHash;

    mockDb = {
      select: vi.fn(),
    };

    sessionRepository = {
      findActiveByAccessTokenHash: vi.fn().mockResolvedValue(null),
      findActiveByRefreshTokenHash: vi.fn().mockResolvedValue(null),
      createSession: vi.fn().mockResolvedValue(101),
      revokeSession: vi.fn().mockResolvedValue(undefined),
      revokeFamily: vi.fn().mockResolvedValue(undefined),
    } as unknown as SessionRepository;

    sessionCache = new SessionCache(60);
    loginThrottle = new LoginThrottle({ maxAttempts: 5, windowMs: 15 * 60 * 1000 });

    authService = new AuthService(
      mockDb,
      sessionRepository,
      sessionCache,
      loginThrottle,
    );
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

  describe('login', () => {
    it('successfully logs in with valid email credentials and returns token pair', async () => {
      mockDbSelect([mockUser]);

      const result = await authService.login('test@example.com', validPassword, '127.0.0.1');

      expect(result.accessToken).toMatch(/^gk_at_/);
      expect(result.refreshToken).toMatch(/^gk_rt_/);
      expect(result.tokenType).toBe('Bearer');
      expect(result.expiresIn).toBe(1800);

      expect(sessionRepository.createSession).toHaveBeenCalledTimes(1);
      const sessionArg = (sessionRepository.createSession as any).mock.calls[0][0];
      expect(sessionArg.user_id).toBe(mockUser.id);
      expect(sessionArg.user_type).toBe(mockUser.user_type);
      expect(sessionArg.family_id).toBeDefined();
    });

    it('successfully logs in with valid phone credentials', async () => {
      mockDbSelect([mockUser]);

      const result = await authService.login('+1234567890', validPassword, '127.0.0.1');

      expect(result.accessToken).toMatch(/^gk_at_/);
      expect(result.refreshToken).toMatch(/^gk_rt_/);
    });

    it('fails with generic "Invalid credentials" error when user is not found', async () => {
      mockDbSelect([]); // No user found

      await expect(
        authService.login('unknown@example.com', validPassword, '127.0.0.1'),
      ).rejects.toThrow('Invalid credentials');
    });

    it('fails with uniform "Invalid credentials" error when password is wrong', async () => {
      mockDbSelect([mockUser]);

      await expect(
        authService.login('test@example.com', 'WrongPassword!', '127.0.0.1'),
      ).rejects.toThrow('Invalid credentials');
    });

    it('fails when user status is inactive', async () => {
      const inactiveUser: User = { ...mockUser, status: 'inactive' };
      mockDbSelect([inactiveUser]);

      await expect(
        authService.login('test@example.com', validPassword, '127.0.0.1'),
      ).rejects.toThrow('Account is not active');
    });

    it('fails when user status is suspended', async () => {
      const suspendedUser: User = { ...mockUser, status: 'suspended' };
      mockDbSelect([suspendedUser]);

      await expect(
        authService.login('test@example.com', validPassword, '127.0.0.1'),
      ).rejects.toThrow('Account is not active');
    });

    it('throttles after 5 failed login attempts and throws RateLimitedError', async () => {
      const wrongPass = 'BadPass';

      for (let i = 0; i < 5; i++) {
        mockDbSelect([mockUser]);
        await expect(
          authService.login('test@example.com', wrongPass, '192.168.1.1'),
        ).rejects.toThrow('Invalid credentials');
      }

      // 6th attempt should be rejected by throttle before DB lookup
      await expect(
        authService.login('test@example.com', validPassword, '192.168.1.1'),
      ).rejects.toThrow(RateLimitedError);
    });

    it('resets throttle counters on successful login', async () => {
      // 4 failed attempts
      for (let i = 0; i < 4; i++) {
        mockDbSelect([mockUser]);
        await expect(
          authService.login('test@example.com', 'wrong', '10.0.0.1'),
        ).rejects.toThrow('Invalid credentials');
      }

      // Successful login
      mockDbSelect([mockUser]);
      await authService.login('test@example.com', validPassword, '10.0.0.1');

      // Subsequent 4 failed attempts should now still be allowed
      for (let i = 0; i < 4; i++) {
        mockDbSelect([mockUser]);
        await expect(
          authService.login('test@example.com', 'wrong', '10.0.0.1'),
        ).rejects.toThrow('Invalid credentials');
      }
    });
  });

  describe('refresh', () => {
    const rawRefreshToken = 'gk_rt_existing_refresh_token_string_123';
    const rawRefreshTokenHash = hashToken(rawRefreshToken);

    const activeMockSession: Session = {
      id: 99,
      user_id: 42,
      user_type: 'member',
      profile_id: 100,
      family_id: 'fam-uuid-test',
      access_token_hash: 'at_hash_1',
      refresh_token_hash: rawRefreshTokenHash,
      revoked_at: null,
      expires_at: new Date(Date.now() + 86400000),
      created_at: new Date(),
      updated_at: null,
    };

    it('rotates refresh token, preserving family_id and revoking old session', async () => {
      (sessionRepository.findActiveByRefreshTokenHash as any).mockResolvedValueOnce(activeMockSession);
      mockDbSelect([mockUser]); // findUserById

      const result = await authService.refresh(rawRefreshToken);

      expect(result.accessToken).toMatch(/^gk_at_/);
      expect(result.refreshToken).toMatch(/^gk_rt_/);
      expect(result.refreshToken).not.toBe(rawRefreshToken);

      // Old session was revoked
      expect(sessionRepository.revokeSession).toHaveBeenCalledWith(activeMockSession.id, expect.any(Date));

      // New session created with same family_id
      expect(sessionRepository.createSession).toHaveBeenCalledTimes(1);
      const newSessionArg = (sessionRepository.createSession as any).mock.calls[0][0];
      expect(newSessionArg.family_id).toBe('fam-uuid-test');
      expect(newSessionArg.user_id).toBe(42);
    });

    it('stores real session id in cache upon login and revokes it on cached refresh', async () => {
      mockDbSelect([mockUser]);
      const loginResult = await authService.login(mockUser.email!, validPassword, '127.0.0.1');

      // The cached session must have id: 101, not 0
      const cachedSession = sessionCache.get(hashToken(loginResult.refreshToken));
      expect(cachedSession).toBeDefined();
      expect(cachedSession!.id).toBe(101);

      // Now refresh using the cached token
      mockDbSelect([mockUser]);
      await authService.refresh(loginResult.refreshToken);

      // Verify revokeSession was called with 101, not 0
      expect(sessionRepository.revokeSession).toHaveBeenCalledWith(101, expect.any(Date));
    });

    it('detects refresh token reuse and revokes entire family', async () => {
      // Active lookup returns null (either not in cache or already revoked)
      (sessionRepository.findActiveByRefreshTokenHash as any).mockResolvedValueOnce(null);

      // findSessionByRefreshTokenHash returns a revoked session
      const revokedSession: Session = {
        ...activeMockSession,
        revoked_at: new Date(),
      };
      mockDbSelect([revokedSession]);

      await expect(authService.refresh(rawRefreshToken)).rejects.toThrow(
        'Invalid or reused refresh token',
      );

      // Family was revoked
      expect(sessionRepository.revokeFamily).toHaveBeenCalledWith(
        activeMockSession.family_id,
        expect.any(Date),
      );
    });

    it('rejects if refresh token does not exist anywhere', async () => {
      (sessionRepository.findActiveByRefreshTokenHash as any).mockResolvedValueOnce(null);
      mockDbSelect([]); // No session found at all

      await expect(authService.refresh(rawRefreshToken)).rejects.toThrow(
        'Invalid or expired refresh token',
      );
    });
  });

  describe('logout', () => {
    it('revokes session in repository and drops from cache', async () => {
      const rawAccessToken = 'gk_at_test_access_token_123';
      const atHash = hashToken(rawAccessToken);

      const session: Session = {
        id: 77,
        user_id: 42,
        user_type: 'member',
        profile_id: null,
        family_id: 'fam-uuid-1',
        access_token_hash: atHash,
        refresh_token_hash: 'rt_hash_1',
        revoked_at: null,
        expires_at: new Date(Date.now() + 1800000),
        created_at: new Date(),
        updated_at: null,
      };

      (sessionRepository.findActiveByAccessTokenHash as any).mockResolvedValueOnce(session);
      sessionCache.set(atHash, session);

      await authService.logout(rawAccessToken);

      expect(sessionRepository.revokeSession).toHaveBeenCalledWith(session.id, expect.any(Date));
      expect(sessionCache.get(atHash)).toBeNull();
    });
  });
});
