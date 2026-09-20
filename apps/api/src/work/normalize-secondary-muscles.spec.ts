import { describe, expect, it } from 'vitest';
import { normalizeSecondaryMuscles } from './normalize-secondary-muscles';

describe('normalizeSecondaryMuscles', () => {
  it('passes through nullish and arrays', () => {
    expect(normalizeSecondaryMuscles(null)).toBeNull();
    expect(normalizeSecondaryMuscles(undefined)).toBeNull();
    expect(normalizeSecondaryMuscles(['a', 'b'])).toEqual(['a', 'b']);
  });

  it('parses double-encoded JSON array strings', () => {
    expect(normalizeSecondaryMuscles('["triceps","shoulders"]')).toEqual([
      'triceps',
      'shoulders',
    ]);
  });

  it('wraps a plain string as a single-element array', () => {
    expect(normalizeSecondaryMuscles('core')).toEqual(['core']);
  });

  it('treats blank strings as null', () => {
    expect(normalizeSecondaryMuscles('')).toBeNull();
    expect(normalizeSecondaryMuscles('   ')).toBeNull();
  });
});
