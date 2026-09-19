import { Injectable, Optional } from '@nestjs/common';
import type { Session } from '../platform/db/schema/sessions';

interface CacheEntry {
  session: Session;
  expiresAtMs: number;
}

/**
 * In-memory cache mapping token hash -> session data.
 * Default TTL: 60 seconds (per ADR-0003).
 *
 * Supports invalidation by token hash, family ID, or user ID on logout or revocation.
 */
@Injectable()
export class SessionCache {
  private readonly defaultTtlMs: number;
  private readonly cache = new Map<string, CacheEntry>();

  constructor(@Optional() ttlSeconds: number = 60) {
    this.defaultTtlMs = (ttlSeconds ?? 60) * 1000;
  }

  /**
   * Sets session data in cache associated with a token hash.
   *
   * @param tokenHash Access or refresh token SHA-256 hash
   * @param session The Session database record
   * @param ttlMs Optional TTL in milliseconds (defaults to 60,000 ms)
   */
  set(tokenHash: string, session: Session, ttlMs?: number): void {
    const expiresAtMs = Date.now() + (ttlMs ?? this.defaultTtlMs);
    this.cache.set(tokenHash, { session, expiresAtMs });
  }

  /**
   * Gets session data from cache by token hash if not expired.
   * Returns null if missing or expired (and purges expired entry).
   *
   * @param tokenHash Access or refresh token SHA-256 hash
   */
  get(tokenHash: string): Session | null {
    const entry = this.cache.get(tokenHash);
    if (!entry) {
      return null;
    }

    if (Date.now() > entry.expiresAtMs) {
      this.cache.delete(tokenHash);
      return null;
    }

    return entry.session;
  }

  /**
   * Drops a session from cache by token hash.
   *
   * @param tokenHash Token SHA-256 hash
   */
  dropSession(tokenHash: string): void {
    this.cache.delete(tokenHash);
  }

  /**
   * Drops all cached sessions belonging to a family_id.
   * Used when a token family is revoked upon reuse detection.
   *
   * @param familyId The session family identifier
   */
  dropByFamily(familyId: string): void {
    for (const [key, entry] of this.cache.entries()) {
      if (entry.session.family_id === familyId) {
        this.cache.delete(key);
      }
    }
  }

  /**
   * Drops all cached sessions for a user ID.
   * Used on user suspension, password change, or global logout.
   *
   * @param userId The user's primary key ID
   */
  dropByUser(userId: number): void {
    for (const [key, entry] of this.cache.entries()) {
      if (entry.session.user_id === userId) {
        this.cache.delete(key);
      }
    }
  }

  /**
   * Clears the entire cache.
   */
  clear(): void {
    this.cache.clear();
  }

  /**
   * Returns the current number of cached entries (including uncollected expired entries).
   */
  get size(): number {
    return this.cache.size;
  }
}
