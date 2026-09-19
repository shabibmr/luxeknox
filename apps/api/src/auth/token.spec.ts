import { describe, it, expect } from 'vitest';
import {
  ACCESS_TOKEN_PREFIX,
  REFRESH_TOKEN_PREFIX,
  issueAccessToken,
  issueRefreshToken,
  hashToken,
} from './token';

describe('token utilities', () => {
  describe('issueAccessToken', () => {
    it('issues token starting with gk_at_ prefix', () => {
      const token = issueAccessToken();
      expect(token.startsWith(ACCESS_TOKEN_PREFIX)).toBe(true);
    });

    it('generates a 256-bit token encoded as base64url', () => {
      const token = issueAccessToken();
      const rawPart = token.slice(ACCESS_TOKEN_PREFIX.length);
      // 32 bytes in base64url is 43 characters
      expect(rawPart.length).toBe(43);
      // Valid base64url characters only: A-Z, a-z, 0-9, -, _
      expect(/^[A-Za-z0-9_-]+$/.test(rawPart)).toBe(true);
    });

    it('generates unique tokens on each invocation', () => {
      const token1 = issueAccessToken();
      const token2 = issueAccessToken();
      expect(token1).not.toBe(token2);
    });
  });

  describe('issueRefreshToken', () => {
    it('issues token starting with gk_rt_ prefix', () => {
      const token = issueRefreshToken();
      expect(token.startsWith(REFRESH_TOKEN_PREFIX)).toBe(true);
    });

    it('generates a 256-bit token encoded as base64url', () => {
      const token = issueRefreshToken();
      const rawPart = token.slice(REFRESH_TOKEN_PREFIX.length);
      expect(rawPart.length).toBe(43);
      expect(/^[A-Za-z0-9_-]+$/.test(rawPart)).toBe(true);
    });

    it('generates unique tokens on each invocation', () => {
      const token1 = issueRefreshToken();
      const token2 = issueRefreshToken();
      expect(token1).not.toBe(token2);
    });
  });

  describe('hashToken', () => {
    it('computes 64-character lowercase hexadecimal SHA-256 hash', () => {
      const token = issueAccessToken();
      const hash = hashToken(token);
      expect(hash).toHaveLength(64);
      expect(/^[0-9a-f]{64}$/.test(hash)).toBe(true);
    });

    it('produces deterministic hashes for the same token', () => {
      const token = 'gk_at_test_token_fixed_input';
      const hash1 = hashToken(token);
      const hash2 = hashToken(token);
      expect(hash1).toBe(hash2);
    });

    it('produces different hashes for different tokens', () => {
      const token1 = issueAccessToken();
      const token2 = issueAccessToken();
      expect(hashToken(token1)).not.toBe(hashToken(token2));
    });
  });
});
