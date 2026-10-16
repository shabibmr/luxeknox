import { describe, expect, it } from 'vitest';
import { ReportsRepository } from './reports.repository';

/**
 * R4: the balance sheet must carry prior-year P&L as retained earnings.
 * Fake db: each select() chain resolves to the next queued result set.
 */
function fakeDb(results: unknown[][]) {
  let i = 0;
  const chain: any = new Proxy(
    {},
    {
      get: (_t, prop) => {
        if (prop === 'then') {
          const rows = results[i++] ?? [];
          return (resolve: (v: unknown) => void) => resolve(rows);
        }
        return () => chain;
      },
    },
  );
  return { select: () => chain };
}

const line = (id: number, code: string, type: string, debit: string, credit: string) => ({
  accountId: id,
  accountCode: code,
  accountName: code,
  accountType: type,
  debit,
  credit,
});

describe('ReportsRepository.getBalanceSheet (R4)', () => {
  it('balances in year two by showing prior-year profit as retained earnings', async () => {
    // Year 1: income 1000 (cash). Year 2 (starts 2027-01-01): income 500 (cash), expense 200 (cash).
    const fy = [{ starts_on: '2027-01-01', ends_on: '2027-12-31' }];
    const cumulative = [
      line(1, '1000', 'asset', '1300.00', '0.00'), // 1000 + 500 - 200
      line(2, '4000', 'income', '0.00', '1500.00'),
      line(3, '5000', 'expense', '200.00', '0.00'),
    ];
    const currentYear = [line(2, '4000', 'income', '0.00', '500.00'), line(3, '5000', 'expense', '200.00', '0.00')];
    const prior = [line(2, '4000', 'income', '0.00', '1000.00')];
    const repo = new ReportsRepository(fakeDb([fy, cumulative, currentYear, prior]) as any, {} as any);

    const bs = await repo.getBalanceSheet('2027-06-30');

    expect(bs.currentYearEarnings).toBe('300.00');
    expect(bs.retainedEarnings).toBe('1000.00');
    expect(bs.totalAssets).toBe('1300.00');
    expect(bs.totalLiabilitiesAndEquity).toBe('1300.00');
  });
});
