import {
  CanActivate,
  ExecutionContext,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { Request } from 'express';
import { isPublicRequest } from './public-paths';
import { hashToken } from './token';
import { SessionCache } from './session.cache';
import { SessionRepository } from './session.repository';
import { UserRepository } from './user.repository';
import { ACCESS_TOKEN_EXPIRY_SECONDS } from './auth.service';
import { UnauthorizedError } from '../platform/errors/app-error';
import type { UserType } from '../platform/db/schema/users';
import type { Session } from '../platform/db/schema/sessions';

export interface AuthenticatedUser {
  id: number;
  email: string | null;
  phoneNumber: string | null;
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

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly sessionCache: SessionCache,
    private readonly sessionRepository: SessionRepository,
    private readonly userRepository: UserRepository,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    if (isPublicRequest(this.reflector, context)) {
      return true;
    }

    const request = context.switchToHttp().getRequest<Request>();

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
    const user = await this.userRepository.findById(session.user_id);
    if (!user || user.status !== 'active') {
      this.sessionCache.dropSession(tokenHash);
      throw new UnauthorizedError('User account is not active');
    }

    // 3. Attach authenticated user and session to request
    request.user = {
      id: user.id,
      email: user.email,
      phoneNumber: user.phone_number,
      userType: user.user_type,
      roleId: user.role_id,
      profileId: session.profile_id,
      sessionId: session.id,
    };
    request.session = session;

    return true;
  }
}
