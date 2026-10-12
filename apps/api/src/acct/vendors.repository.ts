import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, like, or, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import type { DrizzleDb } from '../platform/db/client';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import {
  vendors,
  type NewVendor,
  type Vendor,
} from '../platform/db/schema/accounting';
import { BusinessRuleError, NotFoundError } from '../platform/errors/app-error';

export interface VendorFilterParams {
  search?: string;
  isActive?: boolean;
  limit: number;
  offset: number;
}

@Injectable()
export class VendorsRepository extends BaseRepository<
  typeof vendors,
  Vendor,
  NewVendor
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, vendors);
  }

  async findMany(params: VendorFilterParams): Promise<{ rows: Vendor[]; total: number }> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [];

    if (params.isActive !== undefined) {
      conditions.push(eq(vendors.is_active, params.isActive));
    }
    if (params.search && params.search.trim().length > 0) {
      const term = `%${params.search.trim()}%`;
      conditions.push(
        or(
          like(vendors.name, term),
          like(vendors.phone, term),
          like(vendors.email, term),
          like(vendors.gstin, term),
        ) as SQL,
      );
    }

    const where = conditions.length > 0 ? and(...conditions) : undefined;

    let listQ = db.select().from(vendors);
    let countQ = db.select({ value: count() }).from(vendors);
    if (where) {
      listQ = listQ.where(where);
      countQ = countQ.where(where);
    }

    const rows = await listQ
      .orderBy(desc(vendors.id))
      .limit(params.limit)
      .offset(params.offset);
    const totalRows = await countQ;

    return { rows, total: Number(totalRows[0]?.value ?? 0) };
  }

  async insertVendor(data: NewVendor): Promise<Vendor> {
    const db = this.getDb() as any;
    const result = await db.insert(vendors).values(data);
    const id = Number(result?.[0]?.insertId ?? result?.insertId ?? 0);
    const created = await this.findById(id);
    if (!created) throw new Error(`Failed to load vendor ${id}`);
    return created;
  }

  async updateVendor(id: number, data: Partial<NewVendor>): Promise<Vendor> {
    const db = this.getDb() as any;
    await db.update(vendors).set(data).where(eq(vendors.id, id));
    const updated = await this.findById(id);
    if (!updated) throw new NotFoundError(`Vendor ${id} was not found`);
    return updated;
  }

  /**
   * Asserts vendor exists and is active.
   * Throws NotFoundError if not found, or BusinessRuleError if inactive.
   */
  async assertActiveVendor(vendorId: number): Promise<Vendor> {
    const vendor = await this.findById(vendorId);
    if (!vendor) {
      throw new NotFoundError(`Vendor ${vendorId} was not found`);
    }
    if (!vendor.is_active) {
      throw new BusinessRuleError('Vendor is inactive');
    }
    return vendor;
  }
}
