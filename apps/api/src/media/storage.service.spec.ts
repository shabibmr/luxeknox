import { describe, it, expect, beforeEach, vi } from 'vitest';
import { NotFoundError } from '../platform/errors/app-error';
import { StorageService } from './storage.service';
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

  it('creates an upload slot for avatar', async () => {
    const slot = await service.createUploadSlot(
      { purpose: 'avatar', content_type: 'image/png', size_bytes: 1024 },
      actor('admin'),
    );
    expect(slot.object_key.startsWith('avatar/')).toBe(true);
    expect(slot.url).toContain('/v1/media/objects?key=');
    expect(audit.recordAudit).toHaveBeenCalled();
  });

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
