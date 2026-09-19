import { Inject, Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';
import { eq, or } from 'drizzle-orm';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { users, type User } from '../platform/db/schema/users';
import { sessions, type Session, type NewSession } from '../platform/db/schema/sessions';
import { SessionRepository } from './session.repository';
import { SessionCache } from './session.cache';
import { LoginThrottle } from './login-throttle';
import { issueAccessToken, issueRefreshToken, hashToken } from './token';
import { verifyPassword } from './password';
import { UnauthorizedError } from '../platform/errors/app-error';
import type { AuthResponse } from './auth.dto';

/** Access token lifespan in seconds (30 minutes) per ADR-0003 */
export const ACCESS_TOKEN_EXPIRY_SECONDS = 1800;

/** Refresh token / session lifespan in days (30 days) per ADR-0003 */
export const REFRESH_TOKEN_EXPIRY_DAYS = 30;

@Injectable()
export class AuthService {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
    private readonly sessionRepository: SessionRepository,
    private readonly sessionCache: SessionCache,
    private readonly loginThrottle: LoginThrottle,
  ) {}

  /**
   * Authenticates a user with email/phone and password, returning opaque token pair.
   *
   * @param identifier User email or phone number
   * @param password Plaintext password
   * @param ipAddress Client IP address
   */
  async login(identifier: string, password: string, ipAddress: string): Promise<AuthResponse> {
    // 1. Rate-limit check per identifier and IP
    this.loginThrottle.check(identifier, ipAddress);

    // 2. Uniform lookup by email or phone
    const normalizedId = identifier.trim();
    const userResult = await this.findUserByIdentifier(normalizedId);

    // 3. Uniform rejection: same generic message for unknown user or invalid password
    if (!userResult) {
      this.loginThrottle.recordFailure(identifier, ipAddress);
      throw new UnauthorizedError('Invalid credentials');
    }

    const isPasswordValid = await verifyPassword(userResult.password_hash, password);
    if (!isPasswordValid) {
      this.loginThrottle.recordFailure(identifier, ipAddress);
      throw new UnauthorizedError('Invalid credentials');
    }

    // 4. Reject non-active accounts
    if (userResult.status !== 'active') {
      throw new UnauthorizedError('Account is not active');
    }

    // 5. Successful authentication: reset throttle counters
    this.loginThrottle.recordSuccess(identifier, ipAddress);

    // 6. Issue tokens and persist new session
    const familyId = randomUUID();
    return this.createSessionAndIssueTokens(userResult, familyId);
  }

  /**
   * Refreshes access token using refresh token rotation with family reuse detection.
   *
   * @param refreshToken Raw opaque refresh token (`gk_rt_...`)
   */
  async refresh(refreshToken: string): Promise<AuthResponse> {
    const refreshTokenHash = hashToken(refreshToken);
    const now = new Date();

    // 1. Check active session via cache or repository
    let activeSession = this.sessionCache.get(refreshTokenHash);
    if (!activeSession) {
      activeSession = await this.sessionRepository.findActiveByRefreshTokenHash(refreshTokenHash, now);
    }

    if (activeSession) {
      // Valid active session -> Rotate refresh token
      // Invalidate the current session
      await this.sessionRepository.revokeSession(activeSession.id, now);
      this.sessionCache.dropSession(refreshTokenHash);
      this.sessionCache.dropSession(activeSession.access_token_hash);

      // Fetch user to ensure user is still active
      const user = await this.findUserById(activeSession.user_id);
      if (!user || user.status !== 'active') {
        throw new UnauthorizedError('Account is not active');
      }

      // Re-issue new token pair keeping the exact same family_id
      return this.createSessionAndIssueTokens(user, activeSession.family_id, activeSession.profile_id);
    }

    // 2. Not active -> Check if session existed with this refresh token hash (Reuse Detection)
    const existingSession = await this.findSessionByRefreshTokenHash(refreshTokenHash);

    if (existingSession && existingSession.revoked_at !== null) {
      // Reuse of revoked refresh token detected! Revoke entire token family
      await this.sessionRepository.revokeFamily(existingSession.family_id, now);
      this.sessionCache.dropByFamily(existingSession.family_id);

      throw new UnauthorizedError('Invalid or reused refresh token');
    }

    // Session not found or expired
    throw new UnauthorizedError('Invalid or expired refresh token');
  }

  /**
   * Logs out a session by revoking the access token.
   *
   * @param accessToken Raw opaque access token (`gk_at_...`)
   */
  async logout(accessToken: string): Promise<void> {
    const accessTokenHash = hashToken(accessToken);
    const now = new Date();

    // Check cache or db for active session
    let session = this.sessionCache.get(accessTokenHash);
    if (!session) {
      session = await this.sessionRepository.findActiveByAccessTokenHash(accessTokenHash, now);
    }

    if (session) {
      await this.sessionRepository.revokeSession(session.id, now);
      this.sessionCache.dropSession(accessTokenHash);
      this.sessionCache.dropSession(session.refresh_token_hash);
    }
  }

  /**
   * Helper to create a new session record in DB and cache, returning AuthResponse.
   */
  private async createSessionAndIssueTokens(
    user: User,
    familyId: string,
    profileId?: number | null,
  ): Promise<AuthResponse> {
    const accessToken = issueAccessToken();
    const refreshToken = issueRefreshToken();

    const accessTokenHash = hashToken(accessToken);
    const refreshTokenHash = hashToken(refreshToken);

    const now = new Date();
    const expiresAt = new Date(now.getTime() + REFRESH_TOKEN_EXPIRY_DAYS * 24 * 60 * 60 * 1000);

    const sessionData: NewSession = {
      user_id: user.id,
      user_type: user.user_type,
      profile_id: profileId ?? null,
      family_id: familyId,
      access_token_hash: accessTokenHash,
      refresh_token_hash: refreshTokenHash,
      revoked_at: null,
      expires_at: expiresAt,
      created_at: now,
      updated_at: null,
    };

    const sessionId = await this.sessionRepository.createSession(sessionData);

    // Cache the session under access and refresh hashes
    const sessionRecord: Session = {
      id: sessionId || 0,
      user_id: sessionData.user_id,
      user_type: sessionData.user_type,
      profile_id: sessionData.profile_id ?? null,
      family_id: sessionData.family_id,
      access_token_hash: sessionData.access_token_hash,
      refresh_token_hash: sessionData.refresh_token_hash,
      revoked_at: null,
      expires_at: sessionData.expires_at,
      created_at: sessionData.created_at,
      updated_at: null,
    };
    this.sessionCache.set(accessTokenHash, sessionRecord);
    this.sessionCache.set(refreshTokenHash, sessionRecord);

    return {
      accessToken,
      refreshToken,
      tokenType: 'Bearer',
      expiresIn: ACCESS_TOKEN_EXPIRY_SECONDS,
    };
  }

  /**
   * Look up user by email or phone.
   */
  private async findUserByIdentifier(identifier: string): Promise<User | null> {
    const trimmed = identifier.trim();
    const normalizedEmail = trimmed.toLowerCase();
    const rows = await (this.db as any)
      .select()
      .from(users)
      .where(or(eq(users.email, normalizedEmail), eq(users.phone_number, trimmed)))
      .limit(1);

    return (rows[0] as User) ?? null;
  }

  /**
   * Look up user by primary key ID.
   */
  private async findUserById(id: number): Promise<User | null> {
    const rows = await (this.db as any)
      .select()
      .from(users)
      .where(eq(users.id, id))
      .limit(1);

    return (rows[0] as User) ?? null;
  }

  /**
   * Look up any session by refresh token hash (even if revoked/expired) for reuse detection.
   */
  private async findSessionByRefreshTokenHash(refreshTokenHash: string): Promise<Session | null> {
    const rows = await (this.db as any)
      .select()
      .from(sessions)
      .where(eq(sessions.refresh_token_hash, refreshTokenHash))
      .limit(1);

    return (rows[0] as Session) ?? null;
  }
}
