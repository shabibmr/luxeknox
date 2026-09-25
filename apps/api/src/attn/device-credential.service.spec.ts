import { describe, expect, it, vi } from 'vitest';
import { DeviceCredentialService } from './device-credential.service';
import type { DeviceCredential } from '../platform/db/schema/attendance';

function buildDb(initialRows: DeviceCredential[] = []) {
  const rows: DeviceCredential[] = [...initialRows];
  let nextId = rows.length + 1;

  const db = {
    insert: vi.fn(() => ({
      values: vi.fn(async (values: any) => {
        const row: DeviceCredential = {
          id: nextId++,
          device_name: values.device_name,
          key_hash: values.key_hash,
          is_active: values.is_active ?? true,
          location_details: values.location_details ?? null,
          last_used_at: null,
          created_at: values.created_at,
          updated_at: null,
        } as DeviceCredential;
        rows.push(row);
        return [{ insertId: row.id }];
      }),
    })),
    select: vi.fn(() => ({
      from: vi.fn(() => ({
        where: vi.fn(async () => rows.filter((r) => r.is_active)),
      })),
    })),
    update: vi.fn(() => ({
      set: vi.fn((values: any) => ({
        where: vi.fn(async () => {
          // naive: apply to all rows (fine for these single-row tests)
          rows.forEach((r) => Object.assign(r, values));
        }),
      })),
    })),
  };

  return { db, rows };
}

describe('DeviceCredentialService', () => {
  it('creates a device credential and returns the raw key exactly once', async () => {
    const { db } = buildDb();
    const service = new DeviceCredentialService(db as any);

    const created = await service.create('Front Gate Turnstile');

    expect(created.id).toBeDefined();
    expect(created.device_name).toBe('Front Gate Turnstile');
    expect(typeof created.key).toBe('string');
    expect(created.key.length).toBeGreaterThan(20);
  });

  it('verifies a correct key against the stored hash', async () => {
    const { db } = buildDb();
    const service = new DeviceCredentialService(db as any);
    const created = await service.create('Side Gate Reader');

    const verified = await service.verify(created.key);

    expect(verified).not.toBeNull();
    expect(verified?.device_name).toBe('Side Gate Reader');
  });

  it('rejects an incorrect key', async () => {
    const { db } = buildDb();
    const service = new DeviceCredentialService(db as any);
    await service.create('Back Gate Reader');

    const verified = await service.verify('totally-wrong-key');

    expect(verified).toBeNull();
  });

  it('rejects the correct key for an inactive device', async () => {
    const { db, rows } = buildDb();
    const service = new DeviceCredentialService(db as any);
    const created = await service.create('Deactivated Reader');
    rows[0].is_active = false;

    const verified = await service.verify(created.key);

    expect(verified).toBeNull();
  });
});
