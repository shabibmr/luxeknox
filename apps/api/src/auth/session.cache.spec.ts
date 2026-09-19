import { describe, it, expect, beforeEach, vi } from 'vitest';
import { SessionCache } from './session.cache';
import type { Session } from '../platform/db/schema/sessions';

function createMockSession(overrides: Partial<Session> = {}): Session {
  return {
    id: 1,
    user_id: 10,
    user_type: 'member',
    profile_id: 100,
    family_id: 'fam-uuid-1',
    access_token_hash: 'hash-at-1',
    refresh_token_hash: 'hash-rt-1',
    revoked_at: null,
    expires_at: new Date(Date.now() + 1800000),
    created_at: new Date(),
    updated_at: null,
    ...overrides,
  };
}

describe('SessionCache', () => {
  let cache: SessionCache;

  beforeEach(() => {
    vi.useRealTimers();
    cache = new SessionCache(60); // 60s TTL
  });

  it('stores and retrieves cached session within TTL', () => {
    const session = createMockSession({ id: 1, access_token_hash: 'token1' });
    cache.set('token1', session);

    const cached = cache.get('token1');
    expect(cached).toEqual(session);
  });

  it('returns null for missing keys', () => {
    expect(cache.get('nonexistent')).toBeNull();
  });

  it('expires entries after TTL has elapsed', () => {
    vi.useFakeTimers();
    try {
      const session = createMockSession({ id: 1, access_token_hash: 'token1' });
      cache.set('token1', session);

      expect(cache.get('token1')).toEqual(session);

      // Advance by 60,001 ms (exceeding default 60s TTL)
      vi.advanceTimersByTime(60001);

      expect(cache.get('token1')).toBeNull();
    } finally {
      vi.useRealTimers();
    }
  });

  it('supports custom TTL per entry', () => {
    vi.useFakeTimers();
    try {
      const session = createMockSession({ id: 1 });
      cache.set('short-lived', session, 1000); // 1s TTL

      expect(cache.get('short-lived')).toEqual(session);

      vi.advanceTimersByTime(1001);
      expect(cache.get('short-lived')).toBeNull();
    } finally {
      vi.useRealTimers();
    }
  });

  describe('dropSession', () => {
    it('drops session by token hash', () => {
      const session = createMockSession({ id: 1, access_token_hash: 'token1' });
      cache.set('token1', session);

      expect(cache.get('token1')).toEqual(session);
      cache.dropSession('token1');
      expect(cache.get('token1')).toBeNull();
    });
  });

  describe('dropByFamily', () => {
    it('drops all sessions associated with a family_id', () => {
      const session1 = createMockSession({ id: 1, family_id: 'fam-A', access_token_hash: 'tok1' });
      const session2 = createMockSession({ id: 2, family_id: 'fam-A', access_token_hash: 'tok2' });
      const session3 = createMockSession({ id: 3, family_id: 'fam-B', access_token_hash: 'tok3' });

      cache.set('tok1', session1);
      cache.set('tok2', session2);
      cache.set('tok3', session3);

      expect(cache.size).toBe(3);

      cache.dropByFamily('fam-A');

      expect(cache.get('tok1')).toBeNull();
      expect(cache.get('tok2')).toBeNull();
      expect(cache.get('tok3')).toEqual(session3);
    });
  });

  describe('dropByUser', () => {
    it('drops all sessions associated with a user_id', () => {
      const session1 = createMockSession({ id: 1, user_id: 99, access_token_hash: 'tok1' });
      const session2 = createMockSession({ id: 2, user_id: 99, access_token_hash: 'tok2' });
      const session3 = createMockSession({ id: 3, user_id: 100, access_token_hash: 'tok3' });

      cache.set('tok1', session1);
      cache.set('tok2', session2);
      cache.set('tok3', session3);

      expect(cache.size).toBe(3);

      cache.dropByUser(99);

      expect(cache.get('tok1')).toBeNull();
      expect(cache.get('tok2')).toBeNull();
      expect(cache.get('tok3')).toEqual(session3);
    });
  });

  describe('clear', () => {
    it('clears all cached entries', () => {
      cache.set('tok1', createMockSession({ id: 1 }));
      cache.set('tok2', createMockSession({ id: 2 }));
      expect(cache.size).toBe(2);

      cache.clear();
      expect(cache.size).toBe(0);
      expect(cache.get('tok1')).toBeNull();
    });
  });
});
