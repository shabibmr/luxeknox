import { describe, it, expect } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { NotFoundError } from '../platform/errors/app-error';
import { assertPeopleRowScope } from './row-scope';

function principal(partial: Partial<AuthenticatedUser> & Pick<AuthenticatedUser, 'userType'>): AuthenticatedUser {
  return {
    id: partial.id ?? 1,
    email: partial.email ?? 'user@example.com',
    phoneNumber: partial.phoneNumber ?? null,
    userType: partial.userType,
    roleId: partial.roleId ?? 1,
    profileId: partial.profileId ?? null,
    sessionId: partial.sessionId ?? 1,
  };
}

describe('assertPeopleRowScope', () => {
  const memberTarget = {
    kind: 'member' as const,
    profileId: 10,
    userId: 100,
    assignedTrainerId: 5,
  };

  it('allows admin without row filter', () => {
    expect(() =>
      assertPeopleRowScope(principal({ userType: 'admin', id: 9 }), memberTarget),
    ).not.toThrow();
  });

  it('allows employee without row filter', () => {
    expect(() =>
      assertPeopleRowScope(principal({ userType: 'employee', id: 8 }), memberTarget),
    ).not.toThrow();
  });

  it('allows member accessing self by userId', () => {
    expect(() =>
      assertPeopleRowScope(
        principal({ userType: 'member', id: 100, profileId: 10 }),
        memberTarget,
      ),
    ).not.toThrow();
  });

  it('allows member accessing self by profileId', () => {
    expect(() =>
      assertPeopleRowScope(
        principal({ userType: 'member', id: 999, profileId: 10 }),
        { kind: 'member', profileId: 10 },
      ),
    ).not.toThrow();
  });

  it('404 when member accesses another member', () => {
    expect(() =>
      assertPeopleRowScope(
        principal({ userType: 'member', id: 2, profileId: 2 }),
        memberTarget,
      ),
    ).toThrow(NotFoundError);
  });

  it('allows trainer accessing assigned member', () => {
    expect(() =>
      assertPeopleRowScope(
        principal({ userType: 'trainer', id: 50, profileId: 5 }),
        memberTarget,
      ),
    ).not.toThrow();
  });

  it('404 when trainer accesses unassigned member', () => {
    expect(() =>
      assertPeopleRowScope(
        principal({ userType: 'trainer', id: 50, profileId: 99 }),
        memberTarget,
      ),
    ).toThrow(NotFoundError);
  });

  it('allows trainer reading own trainer profile', () => {
    expect(() =>
      assertPeopleRowScope(
        principal({ userType: 'trainer', id: 50, profileId: 5 }),
        { kind: 'trainer', profileId: 5, userId: 50 },
      ),
    ).not.toThrow();
  });

  it('404 when trainer reads another trainer profile', () => {
    expect(() =>
      assertPeopleRowScope(
        principal({ userType: 'trainer', id: 50, profileId: 5 }),
        { kind: 'trainer', profileId: 6, userId: 51 },
      ),
    ).toThrow(NotFoundError);
  });
});
