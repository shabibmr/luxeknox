import { Inject, Injectable } from '@nestjs/common';
import { and, asc, count, eq, inArray, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  taxCodeComponents,
  taxCodes,
  type NewTaxCode,
  type NewTaxCodeComponent,
  type TaxCode,
  type TaxCodeComponent,
} from '../platform/db/schema/accounting';

export type TaxCodeWithComponents = TaxCode & {
  components: TaxCodeComponent[];
};

@Injectable()
export class TaxCodesRepository extends BaseRepository<
  typeof taxCodes,
  TaxCode,
  NewTaxCode
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, taxCodes);
  }

  async findByCode(code: string): Promise<TaxCode | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(taxCodes)
      .where(eq(taxCodes.code, code))
      .limit(1);
    return rows[0] ?? null;
  }

  async insertTaxCode(row: NewTaxCode): Promise<TaxCode> {
    const db = this.getDb() as any;
    const result = await db.insert(taxCodes).values(row);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const created = await this.findById(id);
    if (!created) {
      throw new Error(`Failed to load tax code ${id}`);
    }
    return created;
  }

  async updateTaxCode(id: number, values: Partial<NewTaxCode>): Promise<TaxCode> {
    const db = this.getDb() as any;
    await db.update(taxCodes).set(values).where(eq(taxCodes.id, id));
    const updated = await this.findById(id);
    if (!updated) {
      throw new Error(`Failed to load tax code ${id}`);
    }
    return updated;
  }

  async insertComponents(rows: NewTaxCodeComponent[]): Promise<TaxCodeComponent[]> {
    if (rows.length === 0) return [];
    const db = this.getDb() as any;
    await db.insert(taxCodeComponents).values(rows);
    return this.listComponents(rows[0]!.tax_code_id);
  }

  async deleteComponentsByTaxCodeId(taxCodeId: number): Promise<void> {
    const db = this.getDb() as any;
    await db
      .delete(taxCodeComponents)
      .where(eq(taxCodeComponents.tax_code_id, taxCodeId));
  }

  async listComponents(taxCodeId: number): Promise<TaxCodeComponent[]> {
    const db = this.getDb() as any;
    return db
      .select()
      .from(taxCodeComponents)
      .where(eq(taxCodeComponents.tax_code_id, taxCodeId))
      .orderBy(asc(taxCodeComponents.id));
  }

  async findComponentsByTaxCodeIds(taxCodeIds: number[]): Promise<TaxCodeComponent[]> {
    if (taxCodeIds.length === 0) return [];
    const db = this.getDb() as any;
    return db
      .select()
      .from(taxCodeComponents)
      .where(inArray(taxCodeComponents.tax_code_id, taxCodeIds))
      .orderBy(asc(taxCodeComponents.tax_code_id), asc(taxCodeComponents.id));
  }

  /** Total `rate_percent` for each tax code id. Missing ids are omitted. */
  async findRatePercentsByIds(ids: number[]): Promise<Map<number, string>> {
    if (ids.length === 0) return new Map();
    const db = this.getDb() as any;
    const rows = await db
      .select({
        id: taxCodes.id,
        rate_percent: taxCodes.rate_percent,
      })
      .from(taxCodes)
      .where(inArray(taxCodes.id, ids));
    return new Map(
      (rows as Array<{ id: number; rate_percent: string | number }>).map((row) => [
        Number(row.id),
        String(row.rate_percent),
      ]),
    );
  }

  async findByIdWithComponents(id: number): Promise<TaxCodeWithComponents | null> {
    const taxCode = await this.findById(id);
    if (!taxCode) return null;
    const components = await this.listComponents(id);
    return { ...taxCode, components };
  }

  async findMany(params: {
    isActive?: boolean;
    limit: number;
    offset: number;
  }): Promise<{ rows: TaxCodeWithComponents[]; total: number }> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [];

    if (params.isActive !== undefined) {
      conditions.push(eq(taxCodes.is_active, params.isActive));
    }

    const where = conditions.length ? and(...conditions) : undefined;

    let listQ = db.select().from(taxCodes);
    let countQ = db.select({ value: count() }).from(taxCodes);
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }

    const rows: TaxCode[] = await listQ
      .orderBy(asc(taxCodes.code), asc(taxCodes.id))
      .limit(params.limit)
      .offset(params.offset);
    const totalRows = await countQ;

    if (rows.length === 0) {
      return { rows: [], total: Number(totalRows[0]?.value ?? 0) };
    }

    const ids = rows.map((r) => r.id);
    const allComponents = await this.findComponentsByTaxCodeIds(ids);
    const componentsByTaxCodeId = new Map<number, TaxCodeComponent[]>();
    for (const comp of allComponents) {
      const list = componentsByTaxCodeId.get(comp.tax_code_id) ?? [];
      list.push(comp);
      componentsByTaxCodeId.set(comp.tax_code_id, list);
    }

    const rowsWithComponents: TaxCodeWithComponents[] = rows.map((r) => ({
      ...r,
      components: componentsByTaxCodeId.get(r.id) ?? [],
    }));

    return {
      rows: rowsWithComponents,
      total: Number(totalRows[0]?.value ?? 0),
    };
  }
}
