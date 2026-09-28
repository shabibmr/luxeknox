import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import type { Request } from 'express';
import { ACCESS_TOKEN_EXPIRY_SECONDS } from '../auth/auth.service';
import { hashToken } from '../auth/token';
import { SessionCache } from '../auth/session.cache';
import { SessionRepository } from '../auth/session.repository';
import { UserRepository } from '../auth/user.repository';
import { PermissionCache, WILDCARD_SLUG } from '../rbac/permission-cache';
import { ForbiddenError, UnauthorizedError } from '../platform/errors/app-error';
import type { DeviceCredential } from '../platform/db/schema/attendance';
import { DeviceCredentialService } from './device-credential.service';

declare global {
  namespace Express {
    interface Request {
      device?: Pick<DeviceCredential, 'id' | 'device_name'>;
    }
  }
}

/**
 * ATT-005: dual auth for gate check-in — Bearer session **or** X-Device-Key.
 * Route must be `@Public()` so the global AuthGuard/PermissionGuard skip;
 * this guard performs the real authentication (and permission check for Bearer).
 */
@Injectable()
export class CheckInAuthGuard implements CanActivate {
  constructor(
    private readonly deviceCredentials: DeviceCredentialService,
    private readonly sessionCache: SessionCache,
    private readonly sessionRepository: SessionRepository,
    private readonly userRepository: UserRepository,
    private readonly permissionCache: PermissionCache,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<Request>();

    const deviceKeyHeader = request.headers['x-device-key'];
    const deviceKey = typeof deviceKeyHeader === 'string' ? deviceKeyHeader.trim() : '';
    if (deviceKey) {
      const device = await this.deviceCredentials.verify(deviceKey);
      if (!device) {
        throw new UnauthorizedError('Invalid or inactive device key');
      }
      request.device = { id: device.id, device_name: device.device_name };
      return true;
    }

    const authHeader = request.headers['authorization'];
    if (!authHeader || typeof authHeader !== 'string' || !authHeader.startsWith('Bearer ')) {
      throw new UnauthorizedError('Missing Authorization bearer token or X-Device-Key');
    }

    const token = authHeader.substring('Bearer '.length).trim();
    if (!token || !token.startsWith('gk_at_')) {
      throw new UnauthorizedError('Invalid access token');
    }

    const tokenHash = hashToken(token);
    const now = new Date();
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

    const user = await this.userRepository.findById(session.user_id);
    if (!user || user.status !== 'active') {
      this.sessionCache.dropSession(tokenHash);
      throw new UnauthorizedError('User account is not active');
    }

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

    const permissions = await this.permissionCache.getPermissionsForRole(user.role_id);
    if (
      !permissions.has(WILDCARD_SLUG) &&
      !permissions.has('attendance.create') &&
      !permissions.has('attendance.checkin')
    ) {
      throw new ForbiddenError("Forbidden: missing required permission 'attendance.create'");
    }

    return true;
  }
}
