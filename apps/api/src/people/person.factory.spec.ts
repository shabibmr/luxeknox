import { describe, it, expect, vi, beforeEach } from 'vitest';
import { BadRequestError } from '../platform/errors/app-error';
import {
  PersonFactory,
  type CreatePersonInput,
  type PersonCredentials,
} from './person.factory';
import type { DrizzleDb } from '../platform/db/client';

vi.mock('../auth/password', () => ({
  hashPassword: vi.fn(async (password: string) => `hashed:${password}`),
}));

type TableName =
  | 'users'
  | 'members'
  | 'trainers'
  | 'employees'
  | 'roles'
  | 'membership_number_counters';

const DRIZZLE_NAME = Symbol.for('drizzle:Name');

function tableName(table: object): TableName {
  const name =
    (table as { [key: symbol]: unknown })[DRIZZLE_NAME] ??
    (table as { _: { name?: string } })._?.name;
  if (
    name === 'users' ||
    name === 'members' ||
    name === 'trainers' ||
    name === 'employees' ||
    name === 'roles' ||
    name === 'membership_number_counters'
  ) {
    return name;
  }
  throw new Error(`Unknown table in mock: ${String(name)}`);
}

describe('PersonFactory', () => {
  let factory: PersonFactory;
  let mockTx: any;
  let mockDb: DrizzleDb<any>;
  let nextIds: Record<TableName, number>;
  let stores: Record<TableName, any[]>;
  let failProfileInsert: boolean;

  beforeEach(() => {
    failProfileInsert = false;
    nextIds = {
      users: 1,
      members: 1,
      trainers: 1,
      employees: 1,
      roles: 10,
      membership_number_counters: 1,
    };
    stores = {
      users: [],
      members: [],
      trainers: [],
      employees: [],
      roles: [
        { id: 3, slug: 'member', name: 'Member' },
        { id: 2, slug: 'trainer', name: 'Trainer' },
        { id: 4, slug: 'employee', name: 'Employee' },
      ],
      membership_number_counters: [{ id: 1, next_value: 1 }],
    };

    const makeSelectBuilder = (fromTable: TableName) => {
      const state: { where?: (row: any) => boolean; limitN?: number } = {};
      const builder: any = {
        from: vi.fn((table: any) => {
          fromTable = tableName(table);
          return builder;
        }),
        where: vi.fn((condition: any) => {
          // Best-effort: drizzle eq objects expose queryChunks; for tests we
          // filter in thenables using stored predicates set by helpers below.
          state.where = condition?.__mockPredicate;
          return builder;
        }),
        limit: vi.fn((n: number) => {
          state.limitN = n;
          return builder;
        }),
        then: (resolve: (value: unknown) => unknown, reject?: (reason: unknown) => unknown) => {
          try {
            let rows = [...stores[fromTable]];
            if (state.where) {
              rows = rows.filter(state.where);
            }
            if (state.limitN != null) {
              rows = rows.slice(0, state.limitN);
            }
            // Project id-only selects used by resolveRoleId / resolveProfileId
            return Promise.resolve(rows).then(resolve, reject);
          } catch (err) {
            return Promise.reject(err).then(resolve, reject);
          }
        },
      };
      return builder;
    };

    mockTx = {
      select: vi.fn((projection?: Record<string, unknown>) => {
        // Default from-less builder; `.from` sets table.
        const builder = makeSelectBuilder('users');
        if (projection) {
          const originalThen = builder.then.bind(builder);
          builder.then = (resolve: any, reject?: any) =>
            originalThen((rows: any[]) => {
              const mapped = rows.map((row) => {
                const out: Record<string, unknown> = {};
                for (const key of Object.keys(projection)) {
                  out[key] = row[key];
                }
                return out;
              });
              return resolve(mapped);
            }, reject);
        }
        return builder;
      }),
      insert: vi.fn((table: any) => {
        const name = tableName(table);
        return {
          values: vi.fn(async (values: any) => {
            if (name !== 'users' && failProfileInsert) {
              throw new Error('simulated profile insert failure');
            }
            const id = nextIds[name]++;
            const row = { id, ...values };
            stores[name].push(row);
            return [{ insertId: id }];
          }),
        };
      }),
      update: vi.fn((table: any) => {
        const name = tableName(table);
        return {
          set: vi.fn((values: any) => ({
            where: vi.fn(async () => {
              if (name === 'membership_number_counters') {
                stores.membership_number_counters[0] = {
                  ...stores.membership_number_counters[0],
                  ...values,
                };
              }
            }),
          })),
        };
      }),
      execute: vi.fn(async () => [[{ next_value: stores.membership_number_counters[0].next_value }]]),
    };

    // Patch eq-style filtering: our factory uses eq(col, value). We intercept
    // by wrapping select().from().where with a predicate derived from stores.
    const originalSelect = mockTx.select;
    mockTx.select = (projection?: Record<string, unknown>) => {
      const builder = originalSelect(projection);
      const originalFrom = builder.from;
      builder.from = (table: any) => {
        const name = tableName(table);
        const fromBuilder = originalFrom(table);
        const originalWhere = fromBuilder.where;
        fromBuilder.where = (condition: any) => {
          // eq leaves queryChunks; we approximate by matching common columns
          // via a custom symbol set on test doubles when needed.
          const predicate = (row: any) => {
            if (condition?.__mockPredicate) {
              return condition.__mockPredicate(row);
            }
            // Fallback: if selecting by primary patterns used in factory
            if (name === 'roles' && stores.roles.some((r) => r.id === row.id || r.slug === row.slug)) {
              return true;
            }
            return true;
          };
          return originalWhere({ __mockPredicate: predicate });
        };
        return fromBuilder;
      };
      return builder;
    };

    mockDb = {
      transaction: vi.fn(async (callback: (tx: any) => Promise<any>) => callback(mockTx)),
      select: mockTx.select,
      insert: mockTx.insert,
      update: mockTx.update,
      execute: mockTx.execute,
    } as unknown as DrizzleDb<any>;

    factory = new PersonFactory(mockDb);
  });

  function memberInput(
    overrides: Partial<{
      credentials: PersonCredentials;
      profile: { first_name: string; last_name: string };
    }> = {},
  ): CreatePersonInput {
    return {
      userType: 'member',
      credentials: {
        email: 'new.member@example.com',
        password: 'Secret123!',
        ...overrides.credentials,
      },
      profile: {
        first_name: 'Ada',
        last_name: 'Lovelace',
        ...overrides.profile,
      },
    };
  }

  it('rejects employee create without role_id', async () => {
    await expect(
      factory.createPerson({
        userType: 'employee',
        credentials: { email: 'desk@example.com', password: 'Secret123!' },
        profile: { first_name: 'Front', last_name: 'Desk', job_title: 'Reception' },
      } as CreatePersonInput),
    ).rejects.toThrow(BadRequestError);
  });

  it('rejects credentials with neither email nor phone', async () => {
    await expect(
      factory.createPerson({
        userType: 'member',
        credentials: { password: 'Secret123!' },
        profile: { first_name: 'Ada', last_name: 'Lovelace' },
      }),
    ).rejects.toThrow(BadRequestError);
  });

  it('creates member + user atomically and never returns password_hash', async () => {
    // Tighten role filter: slug member
    const originalSelect = mockTx.select;
    mockTx.select = (projection?: Record<string, unknown>) => {
      const builder = originalSelect(projection);
      const originalFrom = builder.from;
      builder.from = (table: any) => {
        const name = tableName(table);
        const fromBuilder = originalFrom(table);
        const originalWhere = fromBuilder.where;
        fromBuilder.where = (_condition: any) => {
          const predicate = (row: any) => {
            if (name === 'roles') return row.slug === 'member' || row.id === 3;
            if (name === 'users') return true;
            if (name === 'members') return true;
            if (name === 'membership_number_counters') return row.id === 1;
            return true;
          };
          return originalWhere({ __mockPredicate: predicate });
        };
        return fromBuilder;
      };
      return builder;
    };

    const result = await factory.createPerson(memberInput());

    expect(result.userType).toBe('member');
    expect(result.user).not.toHaveProperty('password_hash');
    expect(result.user.email).toBe('new.member@example.com');
    expect(result.user.user_type).toBe('member');
    if (result.userType === 'member') {
      expect(result.profile.membership_number).toBe('M00000001');
      expect(result.profile.first_name).toBe('Ada');
    }
    expect(stores.users).toHaveLength(1);
    expect(stores.members).toHaveLength(1);
    expect(stores.membership_number_counters[0].next_value).toBe(2);
    expect(mockDb.transaction).toHaveBeenCalledTimes(1);
  });

  it('rolls back when profile insert fails (transaction throws)', async () => {
    failProfileInsert = true;
    const originalSelect = mockTx.select;
    mockTx.select = (projection?: Record<string, unknown>) => {
      const builder = originalSelect(projection);
      const originalFrom = builder.from;
      builder.from = (table: any) => {
        const name = tableName(table);
        const fromBuilder = originalFrom(table);
        const originalWhere = fromBuilder.where;
        fromBuilder.where = (_condition: any) => {
          const predicate = (row: any) => {
            if (name === 'roles') return row.slug === 'member';
            return true;
          };
          return originalWhere({ __mockPredicate: predicate });
        };
        return fromBuilder;
      };
      return builder;
    };

    // Simulate drizzle transaction rollback by rethrowing from callback
    mockDb.transaction = vi.fn(async (callback: (tx: any) => Promise<any>) => {
      const snapshotUsers = stores.users.length;
      try {
        return await callback(mockTx);
      } catch (err) {
        stores.users.length = snapshotUsers;
        stores.members.length = 0;
        throw err;
      }
    }) as any;

    await expect(factory.createPerson(memberInput())).rejects.toThrow(/profile insert failure/);
    expect(stores.members).toHaveLength(0);
  });

  it('resolveProfileId returns member id and null for admin', async () => {
    stores.members.push({ id: 42, user_id: 7 });
    const originalSelect = mockTx.select;
    mockTx.select = (projection?: Record<string, unknown>) => {
      const builder = originalSelect(projection);
      const originalFrom = builder.from;
      builder.from = (table: any) => {
        const name = tableName(table);
        const fromBuilder = originalFrom(table);
        const originalWhere = fromBuilder.where;
        fromBuilder.where = (_condition: any) => {
          const predicate = (row: any) => {
            if (name === 'members') return row.user_id === 7;
            return true;
          };
          return originalWhere({ __mockPredicate: predicate });
        };
        return fromBuilder;
      };
      return builder;
    };

    // resolveProfileId uses root db.select, not transaction
    (mockDb as any).select = mockTx.select;

    await expect(factory.resolveProfileId(7, 'member')).resolves.toBe(42);
    await expect(factory.resolveProfileId(7, 'admin')).resolves.toBeNull();
  });
});
