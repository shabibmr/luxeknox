import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gt, isNull } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { sessions, type Session, type NewSession } from '../platform/db/schema/sessions';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';

@Injectable()
export class SessionRepository extends BaseRepository<typeof sessions, Session, NewSession> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, sessions);
  }

  /**
   * Finds an active session by access token SHA-256 hash.
   * A session is active when revoked_at IS NULL and expires_at > now (evaluated in UTC).
   *
   * @param accessTokenHash SHA-256 hex string of the access token
   * @param now Optional date representing current time (defaults to new Date())
   */
  async findActiveByAccessTokenHash(accessTokenHash: string, now: Date = new Date()): Promise<Session | null> {
    const minCreatedAt = new Date(now.getTime() - 1800 * 1000);
    return this.findOne(
      and(
        eq(sessions.access_token_hash, accessTokenHash),
        isNull(sessions.revoked_at),
        gt(sessions.expires_at, now),
        gt(sessions.created_at, minCreatedAt),
      )!,
    );
  }

  /**
   * Finds an active session by refresh token SHA-256 hash.
   * A session is active when revoked_at IS NULL and expires_at > now (evaluated in UTC).
   *
   * @param refreshTokenHash SHA-256 hex string of the refresh token
   * @param now Optional date representing current time (defaults to new Date())
   */
  async findActiveByRefreshTokenHash(refreshTokenHash: string, now: Date = new Date()): Promise<Session | null> {
    return this.findOne(
      and(
        eq(sessions.refresh_token_hash, refreshTokenHash),
        isNull(sessions.revoked_at),
        gt(sessions.expires_at, now),
      )!,
    );
  }

  /** Finds a session by refresh token hash regardless of revoked/expired state (reuse detection). */
  async findByRefreshTokenHash(refreshTokenHash: string): Promise<Session | null> {
    return this.findOne(eq(sessions.refresh_token_hash, refreshTokenHash));
  }

  /**
   * Creates a new session record.
   *
   * @param session Data for the new session
   */
  async createSession(session: NewSession): Promise<number> {
    const result = await this.create(session);
    return Number(result?.[0]?.insertId ?? 0);
  }

  /**
   * Revokes a session by setting revoked_at to the specified revocation time (UTC).
   *
   * @param id Session ID
   * @param revokedAt Optional date representing revocation time (defaults to new Date())
   */
  async revokeSession(id: number, revokedAt: Date = new Date()): Promise<void> {
    await this.update(eq(sessions.id, id), {
      revoked_at: revokedAt,
      updated_at: revokedAt,
    });
  }

  /**
   * Revokes all active sessions belonging to a session family (`family_id`).
   * Used for reuse-detection in refresh token rotation (FR-AUTH-004).
   *
   * @param familyId The session family identifier
   * @param revokedAt Optional date representing revocation time (defaults to new Date())
   */
  async revokeFamily(familyId: string, revokedAt: Date = new Date()): Promise<void> {
    await this.update(
      and(
        eq(sessions.family_id, familyId),
        isNull(sessions.revoked_at),
      )!,
      {
        revoked_at: revokedAt,
        updated_at: revokedAt,
      },
    );
  }
}
