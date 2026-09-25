import { describe, expect, it } from 'vitest';
import {
  addMoney,
  cmpMoney,
  fromCents,
  mulMoneyPercent,
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
