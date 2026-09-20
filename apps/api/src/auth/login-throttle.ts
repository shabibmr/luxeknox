import { Injectable, Optional } from '@nestjs/common';
import { RateLimitedError } from '../platform/errors/app-error';

export interface ThrottleConfig {
  /** Maximum number of failed attempts allowed within the window. Default: 5 */
  maxAttempts?: number;
  /** Window duration in milliseconds. Default: 15 minutes (900,000 ms) */
  windowMs?: number;
}

/**
 * In-memory sliding window rate limiter for login attempts (BR-AUTH-003).
 * Tracks attempts separately per identifier (email or phone) and per IP address.
 */
@Injectable()
export class LoginThrottle {
  private readonly maxAttempts: number;
  private readonly windowMs: number;

  // Key -> array of attempt timestamps in ms
  private readonly attempts = new Map<string, number[]>();

  constructor(@Optional() config?: ThrottleConfig) {
    this.maxAttempts = config?.maxAttempts ?? 5;
    this.windowMs = config?.windowMs ?? 15 * 60 * 1000; // 15 minutes
  }

  /**
   * Checks if an identifier or IP is throttled, throwing RateLimitedError (HTTP 429) if exceeded.
   *
   * @param identifier Email or phone number
   * @param ipAddress Client IP address
   */
  check(identifier: string, ipAddress: string): void {
    const now = Date.now();
    const idKey = `id:${identifier.toLowerCase().trim()}`;
    const ipKey = `ip:${ipAddress.trim()}`;

    this.checkKey(idKey, now);
    this.checkKey(ipKey, now);
  }

  /**
   * Records a failed login attempt for the identifier and IP.
   *
   * @param identifier Email or phone number
   * @param ipAddress Client IP address
   */
  recordFailure(identifier: string, ipAddress: string): void {
    const now = Date.now();
    const idKey = `id:${identifier.toLowerCase().trim()}`;
    const ipKey = `ip:${ipAddress.trim()}`;

    this.recordKey(idKey, now);
    this.recordKey(ipKey, now);
  }

  /**
   * Resets recorded attempts on successful login for the identifier only.
   * IP buckets are intentionally left intact so a shared egress cannot wipe an attacker's counter.
   */
  recordSuccess(identifier: string): void {
    this.attempts.delete(`id:${identifier.toLowerCase().trim()}`);
  }

  /**
   * Clears all recorded attempts. Useful for testing.
   */
  clear(): void {
    this.attempts.clear();
  }

  private checkKey(key: string, now: number): void {
    const timestamps = this.getValidTimestamps(key, now);
    if (timestamps.length >= this.maxAttempts) {
      throw new RateLimitedError('Too many failed login attempts. Please try again later.');
    }
  }

  private recordKey(key: string, now: number): void {
    const timestamps = this.getValidTimestamps(key, now);
    timestamps.push(now);
    this.attempts.set(key, timestamps);
  }

  private getValidTimestamps(key: string, now: number): number[] {
    const existing = this.attempts.get(key);
    if (!existing) {
      return [];
    }
    const cutoff = now - this.windowMs;
    const valid = existing.filter((ts) => ts > cutoff);
    if (valid.length === 0) {
      this.attempts.delete(key);
    } else if (valid.length !== existing.length) {
      this.attempts.set(key, valid);
    }
    return valid;
  }
}
