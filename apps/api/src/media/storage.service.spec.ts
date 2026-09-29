import { describe, it, expect, beforeEach, vi } from 'vitest';
import { BadRequestError, BusinessRuleError, NotFoundError } from '../platform/errors/app-error';
import { MEDIA_PURPOSES, PURPOSE_LIMITS, StorageService } from './storage.service';
import type { AuditService } from '../platform/audit/audit.service';
import type { AuthenticatedUser } from '../auth/auth.guard';

function actor(userType: AuthenticatedUser['userType']): AuthenticatedUser {
  return {
    id: 1,
    email: 'u@example.com',
    phoneNumber: null,
    userType,
    roleId: 1,
    profileId: 1,
    sessionId: 1,
  };
}

describe('StorageService', () => {
  let service: StorageService;
  let audit: { recordAudit: ReturnType<typeof vi.fn> };

  beforeEach(() => {
    process.env.MEDIA_DRIVER = 'local';
    process.env.MEDIA_SIGNING_SECRET = 'test-secret';
    process.env.MEDIA_PUBLIC_BASE_URL = 'http://127.0.0.1:3000';
    audit = { recordAudit: vi.fn().mockResolvedValue(undefined) };
    service = new StorageService(audit as unknown as AuditService);
  });

  describe('Contract Exhaustiveness (HARDEN-04)', () => {
    it('every MEDIA_PURPOSES entry has a valid limits definition in PURPOSE_LIMITS', () => {
      for (const purpose of MEDIA_PURPOSES) {
        const limits = PURPOSE_LIMITS[purpose];
        expect(limits).toBeDefined();
        expect(limits.maxBytes).toBeGreaterThan(0);
        expect(limits.mimeTypes.length).toBeGreaterThan(0);
      }
      expect(Object.keys(PURPOSE_LIMITS).sort()).toEqual([...MEDIA_PURPOSES].sort());
    });

    it.each(MEDIA_PURPOSES)('creates an upload slot for purpose: %s', async (purpose) => {
      const limits = PURPOSE_LIMITS[purpose];
      const validMime = limits.mimeTypes[0];
      const slot = await service.createUploadSlot(
        { purpose, content_type: validMime, size_bytes: 1024 },
        actor('admin'),
      );
      expect(slot.object_key.startsWith(`${purpose}/`)).toBe(true);
      expect(slot.url).toContain('/v1/media/objects?key=');
      expect(slot.expires_at).toBeTruthy();
      expect(audit.recordAudit).toHaveBeenCalled();
    });
  });

  describe('Validation & Error Messages', () => {
    it('rejects unknown media purpose with clear error message', async () => {
      await expect(
        service.createUploadSlot(
          { purpose: 'unknown_purpose' as any, content_type: 'image/jpeg', size_bytes: 1024 },
          actor('admin'),
        ),
      ).rejects.toThrow(BadRequestError);

      await expect(
        service.createUploadSlot(
          { purpose: 'unknown_purpose' as any, content_type: 'image/jpeg', size_bytes: 1024 },
          actor('admin'),
        ),
      ).rejects.toThrow(/Allowed purposes are:/);
    });

    it('rejects payload exceeding purpose maxBytes with BusinessRuleError', async () => {
      const avatarLimits = PURPOSE_LIMITS.avatar;
      await expect(
        service.createUploadSlot(
          {
            purpose: 'avatar',
            content_type: 'image/jpeg',
            size_bytes: avatarLimits.maxBytes + 1,
          },
          actor('admin'),
        ),
      ).rejects.toThrow(BusinessRuleError);

      await expect(
        service.createUploadSlot(
          {
            purpose: 'avatar',
            content_type: 'image/jpeg',
            size_bytes: avatarLimits.maxBytes + 1,
          },
          actor('admin'),
        ),
      ).rejects.toThrow(/size_bytes must be between 1 and/);
    });

    it('rejects disallowed content_type for purpose with BusinessRuleError', async () => {
      await expect(
        service.createUploadSlot(
          { purpose: 'avatar', content_type: 'application/pdf', size_bytes: 1024 },
          actor('admin'),
        ),
      ).rejects.toThrow(BusinessRuleError);

      await expect(
        service.createUploadSlot(
          { purpose: 'avatar', content_type: 'application/pdf', size_bytes: 1024 },
          actor('admin'),
        ),
      ).rejects.toThrow(/is not allowed for purpose avatar/);
    });
  });

  describe('Signed GET & Access Control', () => {
    it('denies trainer signed GET for id_proof keys (BR-HEALTH-001)', async () => {
      await expect(
        service.createSignedGet('id_proof/2026/09/abc.jpg', actor('trainer')),
      ).rejects.toThrow(NotFoundError);
    });

    it('allows admin signed GET for id_proof keys', async () => {
      const result = await service.createSignedGet('id_proof/2026/09/abc.jpg', actor('admin'));
      expect(result.url).toContain('sig=');
    });
  });
});
