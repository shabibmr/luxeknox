import { describe, expect, it } from 'vitest';
import {
  addMoney,
  cmpMoney,
  fromCents,
  mulMoneyPercent,
  mulQtyRate,
  roundMoney,
  subMoney,
  toCents,
} from './money';

describe('money helpers', () => {
  it('rounds half-up to cents', () => {
    expect(roundMoney('1.225')).toBe('1.23');
    expect(roundMoney('1.224')).toBe('1.22');
  });

  it('adds and subtracts without float drift', () => {
    expect(addMoney('10.10', '0.20')).toBe('10.30');
    expect(subMoney('100.00', '0.01')).toBe('99.99');
  });

  it('computes percent tax half-up', () => {
    expect(mulMoneyPercent('100.00', '18.00')).toBe('18.00');
    expect(mulMoneyPercent('99.99', '18.00')).toBe('18.00');
    expect(mulMoneyPercent('10.00', '18.00')).toBe('1.80');
  });

  it('compares amounts', () => {
    expect(cmpMoney('1.00', '1.00')).toBe(0);
    expect(cmpMoney('0.99', '1.00')).toBe(-1);
    expect(cmpMoney('1.01', '1.00')).toBe(1);
  });

  it('round-trips cents', () => {
    expect(fromCents(toCents('12.34'))).toBe('12.34');
    expect(fromCents(toCents('-0.01'))).toBe('-0.01');
  });
});

describe('mulQtyRate', () => {
  it('multiplies whole quantities exactly', () => {
    expect(mulQtyRate('2', '99.50')).toBe('199.00');
    expect(mulQtyRate(3, 10)).toBe('30.00');
  });

  it('handles 3-decimal quantities', () => {
    expect(mulQtyRate('0.333', '10.00')).toBe('3.33');
    expect(mulQtyRate('1.250', '80.00')).toBe('100.00');
    expect(mulQtyRate('12345678901.234', '1.00')).toBe('12345678901.23');
  });

  it('rounds half-up at the .005 boundary', () => {
    // 0.5 * 0.01 = 0.005 -> 0.01
    expect(mulQtyRate('0.500', '0.01')).toBe('0.01');
    // 1.005 * 1.00 = 1.005 -> 1.01 (a float gives 1.00)
    expect(mulQtyRate('1.005', '1.00')).toBe('1.01');
    expect(mulQtyRate('1.004', '1.00')).toBe('1.00');
    // 2.675 * 1.00 -> 2.68
    expect(mulQtyRate('2.675', '1.00')).toBe('2.68');
  });

  it('rounds negatives away from zero on ties', () => {
    expect(mulQtyRate('-1.005', '1.00')).toBe('-1.01');
    expect(mulQtyRate('1.005', '-1.00')).toBe('-1.01');
    expect(mulQtyRate('-0.001', '1.00')).toBe('0.00');
  });

  it('returns zero for zero inputs', () => {
    expect(mulQtyRate('0.000', '5.00')).toBe('0.00');
  });

  it('rejects precision beyond 3 / 2 decimals and bad input', () => {
    expect(() => mulQtyRate('1.0001', '1.00')).toThrow();
    expect(() => mulQtyRate('1', '1.001')).toThrow();
    expect(() => mulQtyRate('abc', '1')).toThrow();
  });
});
