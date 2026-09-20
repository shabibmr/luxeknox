import { describe, it, expect } from 'vitest';
import { normalizeSpecializations } from './normalize-specializations';
import { roundMoney } from '../platform/money/money';

describe('normalizeSpecializations', () => {
  it('returns null for nullish / empty', () => {
    expect(normalizeSpecializations(null)).toBeNull();
    expect(normalizeSpecializations(undefined)).toBeNull();
    expect(normalizeSpecializations('')).toBeNull();
    expect(normalizeSpecializations('   ')).toBeNull();
  });

  it('passes through string arrays', () => {
    expect(normalizeSpecializations(['strength', 'mobility'])).toEqual(['strength', 'mobility']);
  });

  it('parses JSON-as-TEXT arrays (MariaDB footgun)', () => {
    expect(normalizeSpecializations('["PT","yoga"]')).toEqual(['PT', 'yoga']);
  });

  it('treats non-JSON strings as a single label', () => {
    expect(normalizeSpecializations('strength')).toEqual(['strength']);
  });
});

describe('trainer Money outbound (roundMoney)', () => {
  it('formats decimal rates as Money strings', () => {
    expect(roundMoney(50)).toBe('50.00');
    expect(roundMoney('50.5')).toBe('50.50');
    expect(roundMoney('12.345')).toBe('12.35');
  });
});
