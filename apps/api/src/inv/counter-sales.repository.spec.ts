import { describe, expect, it } from 'vitest';
import type { SQL } from 'drizzle-orm';
import { CasingCache } from 'drizzle-orm/casing';
import { counterSaleListWhere } from './counter-sales.repository';

function sqlText(condition: SQL): { sql: string; params: unknown[] } {
  return condition.toQuery({
    casing: new CasingCache(),
    escapeName: (name) => `\`${name}\``,
    escapeParam: () => '?',
    escapeString: (value) => `'${value}'`,
  });
}

describe('counterSaleListWhere', () => {
  it('filters sale date, member, and sale number', () => {
    const where = counterSaleListWhere({
      from: '2026-10-01',
      to: '2026-10-16',
      memberId: 8,
      search: 'SAL-00000001',
    });
    expect(where).toBeDefined();
    const query = sqlText(where!);
    expect(query.sql).toContain('`sale_date`');
    expect(query.sql).toContain('`member_id`');
    expect(query.sql).toContain('`sale_number`');
    expect(query.params).toEqual(['2026-10-01', '2026-10-16', 8, '%SAL-00000001%']);
  });

  it('keeps sales that contain the item', () => {
    const where = counterSaleListWhere({ itemId: 10 });
    const query = sqlText(where!);
    expect(query.sql.toLowerCase()).toContain('exists');
    expect(query.sql).toContain('counter_sale_lines');
    expect(query.params).toContain(10);
  });

  it('ignores a blank search', () => {
    expect(counterSaleListWhere({ search: '   ' })).toBeUndefined();
  });
});
