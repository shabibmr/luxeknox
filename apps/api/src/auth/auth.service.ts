import { Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';
import { eq } from 'drizzle-orm';
import { type Session, type NewSession } from '../platform/db/schema/sessions';
import { users, type User } from '../platform/db/schema/users';
import { SessionRepository } from './session.repository';
import { SessionCache } from './session.cache';
import { LoginThrottle } from './login-throttle';
import { UserRepository } from './user.repository';
import { PasswordResetTokenRepository } from './password-reset-token.repository';
import { issueAccessToken, issueRefreshToken, issuePasswordResetToken, hashToken } from './token';
import { hashPassword, verifyPassword } from './password';
import { BadRequestError, UnauthorizedError } from '../platform/errors/app-error';
import type { AuthenticatedUser } from './auth.guard';
import type { AuthResponse, ChangePasswordDto, ForgotPasswordDto, ResetPasswordDto } from './auth.dto';
import { PermissionCache } from '../rbac/permission-cache';
import { RoleRepository } from '../rbac/role.repository';
import { PersonFactory } from '../people/person.factory';
import { AuditService } from '../platform/audit/audit.service';

/** Access token lifespan in seconds (30 minutes) per ADR-0003 */
export const ACCESS_TOKEN_EXPIRY_SECONDS = 1800;

/** Refresh token / session lifespan in days (30 days) per ADR-0003 */
export const REFRESH_TOKEN_EXPIRY_DAYS = 30;

/** Password-reset token lifespan in minutes. */
export const PASSWORD_RESET_TOKEN_EXPIRY_MINUTES = 60;

@Injectable()
export class AuthService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly sessionRepository: SessionRepository,
    private readonly sessionCache: SessionCache,
    private readonly loginThrottle: LoginThrottle,
    private readonly roleRepository: RoleRepository,
    private readonly permissionCache: PermissionCache,
    private readonly personFactory: PersonFactory,
    private readonly passwordResetTokenRepository: PasswordResetTokenRepository,
    private readonly auditService: AuditService,
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
    const userResult = await this.userRepository.findByIdentifier(normalizedId);

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

    // 4. Reject non-active accounts with the same message as bad credentials
    if (userResult.status !== 'active') {
      this.loginThrottle.recordFailure(identifier, ipAddress);
      throw new UnauthorizedError('Invalid credentials');
    }

    // 5. Successful authentication: reset identifier throttle only
    this.loginThrottle.recordSuccess(identifier);

    // 6. Resolve PEOPLE profile id (null for Super Admin without employee row)
    const profileId = await this.personFactory.resolveProfileId(
      userResult.id,
      userResult.user_type,
    );

    // 7. Issue tokens and persist new session (stamp sessions.profile_id)
    const familyId = randomUUID();
    return this.createSessionAndIssueTokens(userResult, familyId, profileId);
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
      const user = await this.userRepository.findById(activeSession.user_id);
      if (!user || user.status !== 'active') {
        throw new UnauthorizedError('Account is not active');
      }

      // Re-issue new token pair keeping the exact same family_id
      return this.createSessionAndIssueTokens(user, activeSession.family_id, activeSession.profile_id);
    }

    // 2. Not active -> Check if session existed with this refresh token hash (Reuse Detection)
    const existingSession = await this.sessionRepository.findByRefreshTokenHash(refreshTokenHash);

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
   * Changes the current user's password and invalidates every other active session
   * (keeping the caller's own session alive) per FR-AUTH password-change contract.
   */
  async changePassword(actor: AuthenticatedUser, dto: ChangePasswordDto): Promise<void> {
    const user = await this.userRepository.findById(actor.id);
    if (!user) {
      throw new UnauthorizedError('Account is not active');
    }

    const isValid = await verifyPassword(user.password_hash, dto.current_password);
    if (!isValid) {
      throw new BadRequestError('Current password is incorrect');
    }

    const newHash = await hashPassword(dto.new_password);
    const now = new Date();
    await this.userRepository.update(eq(users.id, user.id), {
      password_hash: newHash,
      updated_at: now,
    });

    await this.sessionRepository.revokeAllForUserExcept(user.id, actor.sessionId, now);
    this.sessionCache.dropByUser(user.id);

    await this.auditService.recordAudit({
      actorUserId: user.id,
      action: 'password_change',
      entityName: 'users',
      entityId: user.id,
    });
  }

  /**
   * Issues a single-use password-reset token for the user matching the given
   * identifier. Always resolves without revealing whether the identifier exists.
   */
  async forgotPassword(dto: ForgotPasswordDto): Promise<void> {
    const identifier = (dto.email || dto.phone_number || '').trim();
    if (!identifier) {
      return;
    }

    const user = await this.userRepository.findByIdentifier(identifier);
    if (!user || user.status !== 'active') {
      return;
    }

    const rawToken = issuePasswordResetToken();
    const tokenHash = hashToken(rawToken);
    const now = new Date();
    const expiresAt = new Date(now.getTime() + PASSWORD_RESET_TOKEN_EXPIRY_MINUTES * 60 * 1000);

    await this.passwordResetTokenRepository.create({
      user_id: user.id,
      token_hash: tokenHash,
      expires_at: expiresAt,
      used_at: null,
      created_at: now,
    });

    // NOTE: delivery (email/SMS) is intentionally out of scope here — no outbound
    // mail/SMS provider is wired into this service yet. The raw token is only ever
    // held in memory for this request; only its hash is persisted.
  }

  /**
   * Consumes a one-time password-reset token, sets a new password, and revokes
   * every active session for the account (the caller holds no session to preserve).
   */
  async resetPassword(dto: ResetPasswordDto): Promise<void> {
    const tokenHash = hashToken(dto.token);
    const now = new Date();

    const resetToken = await this.passwordResetTokenRepository.findActiveByTokenHash(tokenHash, now);
    if (!resetToken) {
      throw new BadRequestError('Reset token is invalid or has expired');
    }

    const user = await this.userRepository.findById(resetToken.user_id);
    if (!user) {
      throw new BadRequestError('Reset token is invalid or has expired');
    }

    const newHash = await hashPassword(dto.new_password);
    await this.userRepository.update(eq(users.id, user.id), {
      password_hash: newHash,
      updated_at: now,
    });

    await this.passwordResetTokenRepository.markUsed(resetToken.id, now);
    await this.sessionRepository.revokeAllForUser(user.id, now);
    this.sessionCache.dropByUser(user.id);

    await this.auditService.recordAudit({
      actorUserId: user.id,
      action: 'password_reset',
      entityName: 'users',
      entityId: user.id,
    });
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

    const role = await this.roleRepository.findById(user.role_id);
    const permissions = await this.permissionCache.getResolvedSlugs(user.role_id);

    const principal = {
      user_id: user.id,
      user_type: user.user_type,
      role: role ? role.slug : user.user_type,
      role_id: user.role_id,
      profile_id: profileId ?? null,
      permissions,
    };

    return {
      accessToken,
      access_token: accessToken,
      refreshToken,
      refresh_token: refreshToken,
      tokenType: 'Bearer',
      token_type: 'Bearer',
      expiresIn: ACCESS_TOKEN_EXPIRY_SECONDS,
      expires_in: ACCESS_TOKEN_EXPIRY_SECONDS,
      principal,
    };
  }
}
