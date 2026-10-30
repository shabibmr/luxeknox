import { describe, expect, it, vi } from 'vitest';
import { members } from '../schema/members';
import { trainers } from '../schema/trainers';
import { users } from '../schema/users';
import { parQScreenings } from '../schema/par-q';
import { memberLifestyleIntakes } from '../schema/lifestyle-intake';
import { ptProgressReviews } from '../schema/personal-training';
import { seedPtClientFile } from './pt-client-file';

type SeedState = {
  users: Array<Record<string, unknown>>;
  members: Array<Record<string, unknown>>;
  trainers: Array<Record<string, unknown>>;
  parQ: Array<Record<string, unknown>>;
  lifestyle: Array<Record<string, unknown>>;
  reviews: Array<Record<string, unknown>>;
};

function rowsFor(state: SeedState, table: unknown): Array<Record<string, unknown>> {
  if (table === users) return state.users;
  if (table === members) return state.members;
  if (table === trainers) return state.trainers;
  if (table === parQScreenings) return state.parQ;
  if (table === memberLifestyleIntakes) return state.lifestyle;
  if (table === ptProgressReviews) return state.reviews;
  return [];
}

function fakeDb(state: SeedState) {
  return {
    select() {
      let rows: Array<Record<string, unknown>> = [];
      const query = {
        from(table: unknown) {
          rows = rowsFor(state, table).map((row) => ({ ...row }));
          return query;
        },
        where() {
          return query;
        },
        limit(n: number) {
          rows = rows.slice(0, n);
          return query;
        },
        then(resolve: (value: unknown) => unknown, reject: (reason: unknown) => unknown) {
          return Promise.resolve(rows).then(resolve, reject);
        },
      };
      return query;
    },
    insert(table: unknown) {
      return {
        values(row: Record<string, unknown>) {
          const bucket = rowsFor(state, table);
          bucket.push({ id: bucket.length + 1, ...row });
          return Promise.resolve();
        },
      };
    },
  };
}

function memberAndTrainerState(): SeedState {
  return {
    users: [
      { id: 2, email: 'trainer', user_type: 'trainer' },
      { id: 3, email: 'member', user_type: 'member' },
    ],
    members: [{ id: 10, user_id: 3 }],
    trainers: [{ id: 8, user_id: 2 }],
    parQ: [],
    lifestyle: [],
    reviews: [],
  };
}

describe('seedPtClientFile', () => {
  it('skips and finishes when no member exists', async () => {
    const warn = vi.spyOn(console, 'warn').mockImplementation(() => undefined);
    const state = memberAndTrainerState();
    state.users = [];
    state.members = [];

    const result = await seedPtClientFile(fakeDb(state) as any);

    expect(result).toEqual({
      parQSeeded: false,
      lifestyleSeeded: false,
      reviewSeeded: false,
      skipped: 'no_member',
    });
    expect(warn).toHaveBeenCalledWith(
      expect.stringContaining('No member found'),
    );
    warn.mockRestore();
  });

  it('reports a review skip when a member exists without a trainer', async () => {
    const warn = vi.spyOn(console, 'warn').mockImplementation(() => undefined);
    const state = memberAndTrainerState();
    state.users = [{ id: 3, email: 'member', user_type: 'member' }];
    state.trainers = [];

    const result = await seedPtClientFile(fakeDb(state) as any);

    expect(result.parQSeeded).toBe(true);
    expect(result.lifestyleSeeded).toBe(true);
    expect(result.reviewSeeded).toBe(false);
    expect(result.skipped).toBe('no_trainer');
    expect(state.reviews).toHaveLength(0);
    expect(warn).toHaveBeenCalledWith(
      expect.stringContaining('skipping progress review'),
    );
    warn.mockRestore();
  });

  it('inserts one of each sample row and does not duplicate on a second run', async () => {
    const state = memberAndTrainerState();
    const db = fakeDb(state) as any;

    const first = await seedPtClientFile(db);
    const second = await seedPtClientFile(db);

    expect(first).toEqual({
      parQSeeded: true,
      lifestyleSeeded: true,
      reviewSeeded: true,
      skipped: null,
    });
    expect(second).toEqual({
      parQSeeded: false,
      lifestyleSeeded: false,
      reviewSeeded: false,
      skipped: null,
    });
    expect(state.parQ).toHaveLength(1);
    expect(state.lifestyle).toHaveLength(1);
    expect(state.reviews).toHaveLength(1);
    expect(state.parQ[0]?.clearance_status).toBe('passed');
    expect(state.parQ[0]?.q1_heart_condition).toBe(false);
  });
});
