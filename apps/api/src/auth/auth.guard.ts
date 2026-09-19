import {
  CanActivate,
  ExecutionContext,
  Inject,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { Request } from 'express';
import { eq } from 'drizzle-orm';
import { IS_PUBLIC_KEY } from './public.decorator';
import { hashToken } from './token';
import { SessionCache } from './session.cache';
import { SessionRepository } from './session.repository';
import { ACCESS_TOKEN_EXPIRY_SECONDS } from './auth.service';
import { UnauthorizedError } from '../platform/errors/app-error';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { users, type User, type UserType } from '../platform/db/schema/users';
import type { Session } from '../platform/db/schema/sessions';

export interface AuthenticatedUser {
  id: number;
  email: string | null;
  userType: UserType;
  roleId: number;
  profileId: number | null;
  sessionId: number;
}

declare global {
  namespace Express {
    interface Request {
      user?: AuthenticatedUser;
      session?: Session;
    }
  }
}

/**
 * Public routes that do not require authentication even without @Public() decorator.
 */
export const PUBLIC_PATH_PATTERNS: readonly RegExp[] = [
  /^\/v1\/health\/?$/,
  /^\/v1\/ready\/?$/,
  /^\/v1\/auth\/login\/?$/,
  /^\/v1\/auth\/refresh\/?$/,
  /^\/v1\/settings\/public\/?$/,
  /^\/v1\/docs(\/.*)?$/,
  /^\/health\/?$/,
  /^\/ready\/?$/,
  /^\/auth\/login\/?$/,
  /^\/auth\/refresh\/?$/,
  /^\/settings\/public\/?$/,
  /^\/docs(\/.*)?$/,
];

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly sessionCache: SessionCache,
    private readonly sessionRepository: SessionRepository,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublicDecorator = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (isPublicDecorator) {
      return true;
    }

    const request = context.switchToHttp().getRequest<Request>();
    const path = request.path || request.url?.split('?')[0] || '';

    if (PUBLIC_PATH_PATTERNS.some((pattern) => pattern.test(path))) {
      return true;
    }

    const authHeader = request.headers['authorization'];
    if (!authHeader || typeof authHeader !== 'string' || !authHeader.startsWith('Bearer ')) {
      throw new UnauthorizedError('Missing or malformed Authorization header');
    }

    const token = authHeader.substring('Bearer '.length).trim();
    if (!token || !token.startsWith('gk_at_')) {
      throw new UnauthorizedError('Invalid access token');
    }

    const tokenHash = hashToken(token);
    const now = new Date();

    // 1. Check SessionCache first, then SessionRepository
    let session = this.sessionCache.get(tokenHash);
    if (!session) {
      session = await this.sessionRepository.findActiveByAccessTokenHash(tokenHash, now);
      if (session) {
        this.sessionCache.set(tokenHash, session);
      }
    }

    if (!session) {
      throw new UnauthorizedError('Invalid or expired session');
    }

    const accessExpiresAt = new Date(
      new Date(session.created_at).getTime() + ACCESS_TOKEN_EXPIRY_SECONDS * 1000,
    );
    if (session.revoked_at !== null || accessExpiresAt <= now || new Date(session.expires_at) <= now) {
      this.sessionCache.dropSession(tokenHash);
      throw new UnauthorizedError('Session has expired or been revoked');
    }

    // 2. Load user and verify status is 'active'
    const userRows = await (this.db as any)
      .select()
      .from(users)
      .where(eq(users.id, session.user_id))
      .limit(1);

    const user: User | undefined = userRows[0];
    if (!user || user.status !== 'active') {
      this.sessionCache.dropSession(tokenHash);
      throw new UnauthorizedError('User account is not active');
    }

    // 3. Attach authenticated user and session to request
    request.user = {
      id: user.id,
      email: user.email,
      userType: user.user_type,
      roleId: user.role_id,
      profileId: session.profile_id,
      sessionId: session.id,
    };
    request.session = session;

    return true;
  }
}
