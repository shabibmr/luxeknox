import { describe, expect, it } from 'vitest';
import {
  addMoney,
  allocate,
  parseRatePercent,
  prorate,
  cmpMoney,
  fromCents,
  mulMoneyPercent,
  mulQtyRate,
  mulQtyUnitCost,
  divValueByQty,
  cmpQty,
  addQty,
  subQty,
  roundMoney,
  roundQty3,
  subMoney,
  toCents,
} from './money';

describe('money helpers', () => {
  it('rounds half-up to cents', () => {
    expect(roundMoney('1.225')).toBe('1.23');
    expect(roundMoney('1.224')).toBe('1.22');
  });

  it('rounds quantities half-up to 3 decimals', () => {
    expect(roundQty3('1.250')).toBe('1.250');
    expect(roundQty3('1.2505')).toBe('1.251');
    expect(roundQty3('1.2504')).toBe('1.250');
    expect(roundQty3(2)).toBe('2.000');
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

describe('divValueByQty', () => {
  it('computes the weighted-average unit cost to 4 decimals', () => {
    expect(divValueByQty('1650.00', '15.000')).toBe('110.0000');
    expect(divValueByQty('1000.00', '10.000')).toBe('100.0000');
  });

  it('rounds half-up at the 5th decimal', () => {
    // 10 / 3 = 3.3333… → 3.3333
    expect(divValueByQty('10.00', '3.000')).toBe('3.3333');
    // 1.00 / 6 = 0.16666… → 0.1667
    expect(divValueByQty('1.00', '6.000')).toBe('0.1667');
  });

  it('rejects zero quantity', () => {
    expect(() => divValueByQty('10.00', '0')).toThrow();
  });
});

describe('mulQtyUnitCost', () => {
  it('multiplies quantity by a 4-decimal unit cost', () => {
    expect(mulQtyUnitCost('2.000', '110.0000')).toBe('220.00');
    expect(mulQtyUnitCost('1.500', '10.0000')).toBe('15.00');
  });

  it('rounds half-up to cents', () => {
    expect(mulQtyUnitCost('1.000', '1.0050')).toBe('1.01');
    expect(mulQtyUnitCost('1.000', '1.0049')).toBe('1.00');
  });
});

describe('qty helpers', () => {
  it('adds, subtracts and compares at 3 decimals', () => {
    expect(addQty('10.000', '5.000')).toBe('15.000');
    expect(subQty('15.000', '2.000')).toBe('13.000');
    expect(cmpQty('14.000', '15.000')).toBe(-1);
    expect(cmpQty('15.000', '15')).toBe(0);
  });
});

describe('prorate', () => {
  it('rounds half-up on odd cents', () => {
    expect(prorate('100.00', 1, 3)).toBe('33.33');
    expect(prorate('100.00', 2, 3)).toBe('66.67');
    expect(prorate('0.05', 1, 2)).toBe('0.03');
  });

  it('returns the full amount when numerator equals denominator', () => {
    expect(prorate('1234.56', 30, 30)).toBe('1234.56');
  });

  it('handles negatives away from zero and rejects bad denominators', () => {
    expect(prorate('-0.05', 1, 2)).toBe('-0.03');
    expect(() => prorate('1.00', 1, 0)).toThrow();
    expect(() => prorate('1.00', 1.5, 3)).toThrow();
  });
});

describe('allocate', () => {
  it('splits 1/3 without drift', () => {
    expect(allocate('100.00', [1, 1, 1])).toEqual(['33.34', '33.33', '33.33']);
  });

  it('always sums to the total', () => {
    const parts = allocate('0.07', [3, 3, 3, 1]);
    expect(parts.reduce((s, p) => addMoney(s, p), '0.00')).toBe('0.07');
    const neg = allocate('-100.01', [2, 1, 1]);
    expect(neg.reduce((s, p) => addMoney(s, p), '0.00')).toBe('-100.01');
  });

  it('gives zero-weight entries nothing and rejects invalid weights', () => {
    expect(allocate('10.00', [1, 0, 1])).toEqual(['5.00', '0.00', '5.00']);
    expect(() => allocate('1.00', [])).toThrow();
    expect(() => allocate('1.00', [0, 0])).toThrow();
    expect(() => allocate('1.00', [-1, 2])).toThrow();
  });
});

describe('parseRatePercent', () => {
  it('normalises to 2dp and rejects invalid or negative input', () => {
    expect(parseRatePercent('18')).toBe('18.00');
    expect(parseRatePercent('12.5')).toBe('12.50');
    expect(parseRatePercent('-1')).toBeNull();
    expect(parseRatePercent('abc')).toBeNull();
  });
});
