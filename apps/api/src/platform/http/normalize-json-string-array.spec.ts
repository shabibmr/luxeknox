import { describe, expect, it } from 'vitest';
import { normalizeJsonStringArray } from './normalize-json-string-array';

describe('normalizeJsonStringArray', () => {
  it('returns null for nullish and blank', () => {
    expect(normalizeJsonStringArray(null)).toBeNull();
    expect(normalizeJsonStringArray(undefined)).toBeNull();
    expect(normalizeJsonStringArray('')).toBeNull();
    expect(normalizeJsonStringArray('   ')).toBeNull();
  });

  it('passes through arrays', () => {
    expect(normalizeJsonStringArray(['a', 1])).toEqual(['a', '1']);
  });

  it('parses JSON array strings', () => {
    expect(normalizeJsonStringArray('["core","glutes"]')).toEqual(['core', 'glutes']);
  });

  it('treats plain strings as a single label', () => {
    expect(normalizeJsonStringArray('yoga')).toEqual(['yoga']);
  });
});
