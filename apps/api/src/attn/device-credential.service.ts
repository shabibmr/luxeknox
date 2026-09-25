import { randomBytes } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import { deviceCredentials, type DeviceCredential } from '../platform/db/schema/attendance';
import { hashPassword, verifyPassword } from '../auth/password';

export interface CreatedDeviceCredential {
  id: number;
  device_name: string;
  /** Raw device key — returned exactly once, at creation. Never persisted or retrievable again. */
  key: string;
}

/**
 * ATT-004: hardware turnstile/reader credential model.
 *
 * Devices authenticate ingest requests via the `X-Device-Key` header (OpenAPI
 * `deviceKey` securityScheme). Raw keys are generated once at issuance and
 * never stored — only an Argon2id hash, verified in constant time via
 * argon2's own `verify()` (same primitive as user password auth in
 * `src/auth/password.ts`). Not wired into the check-in flow yet (ATT-005/006).
 */
@Injectable()
export class DeviceCredentialService {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  /**
   * Issues a new device credential. The raw key is generated here and
   * returned to the caller exactly once; only its Argon2id hash is persisted.
   */
  async create(deviceName: string, locationDetails?: string | null): Promise<CreatedDeviceCredential> {
    const rawKey = randomBytes(32).toString('base64url');
    const keyHash = await hashPassword(rawKey);
    const now = new Date();

    const result = await (this.db as any).insert(deviceCredentials).values({
      device_name: deviceName,
      key_hash: keyHash,
      is_active: true,
      location_details: locationDetails ?? null,
      created_at: now,
    });
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);

    return { id, device_name: deviceName, key: rawKey };
  }

  /**
   * Verifies a presented raw device key against all active stored credential
   * hashes. Returns the matching (and now touched `last_used_at`) credential,
   * or `null` if no active credential matches.
   *
   * Inactive devices never match, even with the correct key.
   */
  async verify(rawKey: string): Promise<DeviceCredential | null> {
    const db = this.db as any;
    const candidates: DeviceCredential[] = await db
      .select()
      .from(deviceCredentials)
      .where(eq(deviceCredentials.is_active, true));

    for (const candidate of candidates) {
      const matches = await verifyPassword(candidate.key_hash, rawKey);
      if (matches) {
        await db
          .update(deviceCredentials)
          .set({ last_used_at: new Date() })
          .where(eq(deviceCredentials.id, candidate.id));
        return candidate;
      }
    }
    return null;
  }
}
