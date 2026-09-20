import { Injectable, Logger } from '@nestjs/common';
import { createHmac, randomUUID, timingSafeEqual } from 'crypto';
import * as fs from 'fs/promises';
import * as path from 'path';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import { BadRequestError, BusinessRuleError, NotFoundError } from '../platform/errors/app-error';

export const MEDIA_PURPOSES = [
  'exercise_media',
  'avatar',
  'progress_photo',
  'id_proof',
  'waiver',
  'medical_cert',
  'receipt_pdf',
] as const;

export type MediaPurpose = (typeof MEDIA_PURPOSES)[number];

const PURPOSE_LIMITS: Record<MediaPurpose, { maxBytes: number; mimeTypes: readonly string[] }> = {
  avatar: { maxBytes: 5 * 1024 * 1024, mimeTypes: ['image/jpeg', 'image/png', 'image/webp'] },
  id_proof: {
    maxBytes: 10 * 1024 * 1024,
    mimeTypes: ['image/jpeg', 'image/png', 'application/pdf'],
  },
  waiver: {
    maxBytes: 10 * 1024 * 1024,
    mimeTypes: ['application/pdf', 'image/jpeg', 'image/png'],
  },
  medical_cert: {
    maxBytes: 10 * 1024 * 1024,
    mimeTypes: ['application/pdf', 'image/jpeg', 'image/png'],
  },
  progress_photo: {
    maxBytes: 8 * 1024 * 1024,
    mimeTypes: ['image/jpeg', 'image/png', 'image/webp'],
  },
  exercise_media: {
    maxBytes: 50 * 1024 * 1024,
    mimeTypes: ['image/gif', 'image/jpeg', 'image/png', 'video/mp4'],
  },
  receipt_pdf: { maxBytes: 5 * 1024 * 1024, mimeTypes: ['application/pdf'] },
};

const EXT_BY_MIME: Record<string, string> = {
  'image/jpeg': '.jpg',
  'image/png': '.png',
  'image/webp': '.webp',
  'image/gif': '.gif',
  'application/pdf': '.pdf',
  'video/mp4': '.mp4',
};

export function purposeFromObjectKey(objectKey: string): MediaPurpose | null {
  const prefix = objectKey.split('/')[0];
  return (MEDIA_PURPOSES as readonly string[]).includes(prefix) ? (prefix as MediaPurpose) : null;
}

function sign(secret: string, method: 'PUT' | 'GET', objectKey: string, expiresUnix: number): string {
  return createHmac('sha256', secret)
    .update(`${method}\n${objectKey}\n${expiresUnix}`)
    .digest('hex');
}

function verifySig(
  secret: string,
  method: 'PUT' | 'GET',
  objectKey: string,
  expiresUnix: number,
  signature: string,
): boolean {
  if (!Number.isFinite(expiresUnix) || expiresUnix * 1000 < Date.now()) return false;
  const expected = sign(secret, method, objectKey, expiresUnix);
  try {
    const a = Buffer.from(expected, 'hex');
    const b = Buffer.from(signature, 'hex');
    return a.length === b.length && timingSafeEqual(a, b);
  } catch {
    return false;
  }
}

/**
 * Resolve HMAC secret for signed media URLs.
 * Never reuse BOOTSTRAP_ADMIN_PASSWORD — that couples URL forgery resistance to login creds.
 * Non-local NODE_ENV requires MEDIA_SIGNING_SECRET.
 */
function resolveMediaSigningSecret(): string {
  const configured = process.env.MEDIA_SIGNING_SECRET?.trim();
  if (configured) return configured;

  const nodeEnv = (process.env.NODE_ENV || 'development').toLowerCase();
  const isLocal = nodeEnv === 'development' || nodeEnv === 'test' || nodeEnv === '';
  if (!isLocal) {
    throw new Error('MEDIA_SIGNING_SECRET is required when NODE_ENV is not development/test');
  }
  return 'dev-media-signing-secret';
}

/**
 * MEDIA StorageService (ADR-0008): signed PUT slot + signed GET.
 * Local disk adapter is the default; S3 driver fails fast until credentials exist.
 *
 * ACL note (V3): minting a signed GET requires `media.read` at the HTTP layer and
 * additionally denies trainers for `id_proof` keys. Holders of `media.read` may mint
 * a GET for any other object key — intentional global media ACL for staff until a
 * purpose+owner gate lands with a later vertical.
 */
@Injectable()
export class StorageService {
  private readonly logger = new Logger(StorageService.name);
  private readonly driver: 'local' | 's3';
  private readonly localRoot: string;
  private readonly signingSecret: string;
  private readonly publicBaseUrl: string;
  private readonly slotTtlSeconds: number;

  constructor(private readonly auditService: AuditService) {
    this.driver = (process.env.MEDIA_DRIVER || 'local').toLowerCase() === 's3' ? 's3' : 'local';
    this.localRoot = path.resolve(process.env.MEDIA_LOCAL_ROOT || path.join(process.cwd(), '.media'));
    this.signingSecret = resolveMediaSigningSecret();
    this.publicBaseUrl = (
      process.env.MEDIA_PUBLIC_BASE_URL ||
      `http://127.0.0.1:${process.env.PORT || 3000}`
    ).replace(/\/$/, '');
    this.slotTtlSeconds = Number(process.env.MEDIA_SIGNED_URL_TTL_SECONDS || 900);

    if (this.driver === 's3') {
      const required = ['MEDIA_S3_BUCKET', 'MEDIA_S3_ACCESS_KEY', 'MEDIA_S3_SECRET_KEY'];
      const missing = required.filter((k) => !process.env[k]);
      if (missing.length > 0) {
        this.logger.warn(
          `MEDIA_DRIVER=s3 but missing ${missing.join(', ')}; signed S3 URLs are not implemented in this build — use MEDIA_DRIVER=local for Vertical 3.`,
        );
      }
    }
  }

  async createUploadSlot(
    input: { purpose: MediaPurpose; content_type: string; size_bytes: number },
    actor: AuthenticatedUser,
  ): Promise<{ url: string; object_key: string; expires_at: string }> {
    const limits = PURPOSE_LIMITS[input.purpose];
    if (!limits) {
      throw new BadRequestError(`Unknown media purpose: ${input.purpose}`);
    }
    if (input.size_bytes < 1 || input.size_bytes > limits.maxBytes) {
      throw new BusinessRuleError(
        `size_bytes must be between 1 and ${limits.maxBytes} for purpose ${input.purpose}`,
      );
    }
    if (!limits.mimeTypes.includes(input.content_type)) {
      throw new BusinessRuleError(
        `content_type ${input.content_type} is not allowed for purpose ${input.purpose}`,
      );
    }

    const now = new Date();
    const yyyy = String(now.getUTCFullYear());
    const mm = String(now.getUTCMonth() + 1).padStart(2, '0');
    const ext = EXT_BY_MIME[input.content_type] || '';
    const objectKey = `${input.purpose}/${yyyy}/${mm}/${randomUUID()}${ext}`;
    const expiresAt = new Date(now.getTime() + this.slotTtlSeconds * 1000);
    const expiresUnix = Math.floor(expiresAt.getTime() / 1000);

    if (this.driver === 's3' && process.env.MEDIA_S3_BUCKET && process.env.MEDIA_S3_ACCESS_KEY) {
      throw new BusinessRuleError(
        'S3 presign is configured conceptually (ADR-0008) but not wired in this build; set MEDIA_DRIVER=local',
      );
    }

    const signature = sign(this.signingSecret, 'PUT', objectKey, expiresUnix);
    const url = `${this.publicBaseUrl}/v1/media/objects?key=${encodeURIComponent(objectKey)}&expires=${expiresUnix}&sig=${signature}&content_type=${encodeURIComponent(input.content_type)}`;

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'media.upload_slot_created',
      entityName: 'media',
      afterState: { purpose: input.purpose, object_key: objectKey, size_bytes: input.size_bytes },
    });

    return {
      url,
      object_key: objectKey,
      expires_at: expiresAt.toISOString(),
    };
  }

  async createSignedGet(
    objectKey: string,
    actor: AuthenticatedUser,
  ): Promise<{ url: string; expires_at: string }> {
    const purpose = purposeFromObjectKey(objectKey);
    if (actor.userType === 'trainer' && purpose === 'id_proof') {
      throw new NotFoundError('Media not found');
    }

    const expiresAt = new Date(Date.now() + this.slotTtlSeconds * 1000);
    const expiresUnix = Math.floor(expiresAt.getTime() / 1000);
    const signature = sign(this.signingSecret, 'GET', objectKey, expiresUnix);
    const url = `${this.publicBaseUrl}/v1/media/objects?key=${encodeURIComponent(objectKey)}&expires=${expiresUnix}&sig=${signature}`;

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'media.signed_get_issued',
      entityName: 'media',
      afterState: { object_key: objectKey, purpose },
    });

    return { url, expires_at: expiresAt.toISOString() };
  }

  async putLocalObject(
    objectKey: string,
    body: Buffer,
    contentType: string,
    expiresUnix: number,
    signature: string,
  ): Promise<void> {
    if (!verifySig(this.signingSecret, 'PUT', objectKey, expiresUnix, signature)) {
      throw new NotFoundError('Media not found');
    }
    const purpose = purposeFromObjectKey(objectKey);
    if (!purpose) {
      throw new BadRequestError('Invalid object key');
    }
    const limits = PURPOSE_LIMITS[purpose];
    if (body.length > limits.maxBytes) {
      throw new BusinessRuleError('Uploaded body exceeds purpose max size');
    }
    if (!limits.mimeTypes.includes(contentType)) {
      throw new BusinessRuleError('Uploaded content_type not allowed for purpose');
    }

    const abs = this.resolveSafePath(objectKey);
    await fs.mkdir(path.dirname(abs), { recursive: true });
    await fs.writeFile(abs, body);
    await fs.writeFile(`${abs}.meta.json`, JSON.stringify({ contentType }), 'utf8');
  }

  async getLocalObject(
    objectKey: string,
    expiresUnix: number,
    signature: string,
  ): Promise<{ body: Buffer; contentType: string }> {
    if (!verifySig(this.signingSecret, 'GET', objectKey, expiresUnix, signature)) {
      throw new NotFoundError('Media not found');
    }
    const abs = this.resolveSafePath(objectKey);
    try {
      const body = await fs.readFile(abs);
      let contentType = 'application/octet-stream';
      try {
        const meta = JSON.parse(await fs.readFile(`${abs}.meta.json`, 'utf8')) as {
          contentType?: string;
        };
        if (meta.contentType) contentType = meta.contentType;
      } catch {
        // meta optional
      }
      return { body, contentType };
    } catch {
      throw new NotFoundError('Media not found');
    }
  }

  /** Orphan GC hook (FR-MEDIA-004) — not scheduled in V3; available for a later job. */
  async deleteObject(objectKey: string): Promise<void> {
    const abs = this.resolveSafePath(objectKey);
    await fs.rm(abs, { force: true });
    await fs.rm(`${abs}.meta.json`, { force: true });
  }

  private resolveSafePath(objectKey: string): string {
    if (objectKey.includes('..') || objectKey.startsWith('/') || objectKey.includes('\\')) {
      throw new BadRequestError('Invalid object key');
    }
    const abs = path.resolve(this.localRoot, objectKey);
    if (!abs.startsWith(this.localRoot + path.sep) && abs !== this.localRoot) {
      throw new BadRequestError('Invalid object key');
    }
    return abs;
  }
}
