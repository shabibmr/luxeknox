import { describe, expect, it } from 'vitest';
import type { SQL } from 'drizzle-orm';
import { CasingCache } from 'drizzle-orm/casing';
import { itemListWhere } from './items.repository';

function sqlText(condition: SQL): { sql: string; params: unknown[] } {
  return condition.toQuery({
    casing: new CasingCache(),
    escapeName: (name) => `\`${name}\``,
    escapeParam: () => '?',
    escapeString: (value) => `'${value}'`,
  });
}

describe('itemListWhere', () => {
  it('matches name or SKU', () => {
    const where = itemListWhere({ search: 'WHEY-1' });
    expect(where).toBeDefined();
    const query = sqlText(where!);
    expect(query.sql).toContain('`name`');
    expect(query.sql).toContain('`sku`');
    expect(query.params).toEqual(['%WHEY-1%', '%WHEY-1%']);
  });

  it('ignores a blank search', () => {
    expect(itemListWhere({ search: '   ' })).toBeUndefined();
  });

  it('filters kind, category, active, and tracked', () => {
    const where = itemListWhere({
      itemKind: 'goods',
      categoryId: 4,
      isActive: true,
      inventoryTracked: false,
    });
    const query = sqlText(where!);
    expect(query.sql).toContain('`item_kind`');
    expect(query.sql).toContain('`category_id`');
    expect(query.sql).toContain('`is_active`');
    expect(query.sql).toContain('`inventory_tracked`');
    expect(query.params).toEqual(['goods', 4, true, false]);
  });
});
