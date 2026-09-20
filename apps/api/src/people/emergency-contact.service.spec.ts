import { describe, it, expect, vi, beforeEach } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { AuditService } from '../platform/audit/audit.service';
import type { DrizzleDb } from '../platform/db/client';
import type { PaginationHelper } from '../platform/http/pagination';
import { EmergencyContactService } from './emergency-contact.service';
import type { EmergencyContactRepository } from './emergency-contact.repository';

function actor(): AuthenticatedUser {
  return {
    id: 1,
    email: 'admin@example.com',
    phoneNumber: null,
    userType: 'admin',
    roleId: 1,
    profileId: null,
    sessionId: 1,
  };
}

describe('EmergencyContactService primary uniqueness', () => {
  let service: EmergencyContactService;
  let repository: {
    clearPrimaryForUser: ReturnType<typeof vi.fn>;
    insertContact: ReturnType<typeof vi.fn>;
    findByIdForUser: ReturnType<typeof vi.fn>;
    updateContact: ReturnType<typeof vi.fn>;
  };

  beforeEach(() => {
    repository = {
      clearPrimaryForUser: vi.fn().mockResolvedValue(undefined),
      insertContact: vi.fn().mockResolvedValue(42),
      findByIdForUser: vi.fn().mockResolvedValue({
        id: 42,
        user_id: 10,
        contact_name: 'New Primary',
        relationship: 'spouse',
        phone_primary: '+15550001111',
        phone_secondary: null,
        is_primary: true,
        created_at: new Date(),
        updated_at: null,
      }),
      updateContact: vi.fn().mockResolvedValue(undefined),
    };

    let selectCall = 0;
    const db = {
      select: vi.fn().mockImplementation(() => {
        selectCall += 1;
        // Odd calls: users existence; even calls: member profile for row-scope.
        const rows =
          selectCall % 2 === 1
            ? [{ id: 10 }]
            : [{ id: 99, assigned_trainer_id: null }];
        return {
          from: vi.fn().mockReturnValue({
            where: vi.fn().mockReturnValue({
              limit: vi.fn().mockResolvedValue(rows),
            }),
          }),
        };
      }),
      transaction: vi.fn(async (fn: (tx: unknown) => Promise<unknown>) => fn({})),
    };

    service = new EmergencyContactService(
      repository as unknown as EmergencyContactRepository,
      {} as PaginationHelper,
      { recordAudit: vi.fn().mockResolvedValue(undefined) } as unknown as AuditService,
      db as unknown as DrizzleDb<any>,
    );
  });

  it('clears previous primary when creating a new primary contact', async () => {
    const created = await service.create(
      10,
      {
        contact_name: 'New Primary',
        phone_primary: '+15550001111',
        is_primary: true,
      },
      actor(),
    );

    expect(repository.clearPrimaryForUser).toHaveBeenCalledWith(10);
    expect(repository.insertContact).toHaveBeenCalledWith(
      expect.objectContaining({
        user_id: 10,
        is_primary: true,
        contact_name: 'New Primary',
      }),
    );
    expect(created.is_primary).toBe(true);
  });

  it('does not clear primaries when creating a non-primary contact', async () => {
    repository.findByIdForUser.mockResolvedValueOnce({
      id: 43,
      user_id: 10,
      contact_name: 'Secondary',
      relationship: null,
      phone_primary: '+15550002222',
      phone_secondary: null,
      is_primary: false,
      created_at: new Date(),
      updated_at: null,
    });

    await service.create(
      10,
      {
        contact_name: 'Secondary',
        phone_primary: '+15550002222',
        is_primary: false,
      },
      actor(),
    );

    expect(repository.clearPrimaryForUser).not.toHaveBeenCalled();
  });
});
