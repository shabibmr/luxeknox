import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { NewVendor, Vendor } from '../platform/db/schema/accounting';
import { NotFoundError } from '../platform/errors/app-error';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import {
  vendorFilterQuerySchema,
  type VendorDto,
  type VendorUpdateDto,
  type VendorWriteDto,
} from './vendors.dto';
import { VendorsRepository } from './vendors.repository';

@Injectable()
export class VendorsService {
  constructor(
    private readonly repository: VendorsRepository,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toDto(row: Vendor): VendorDto {
    return {
      id: row.id,
      name: row.name,
      phone: row.phone ?? null,
      email: row.email ?? null,
      gstin: row.gstin ?? null,
      is_active: Boolean(row.is_active),
      created_at: row.created_at,
      updated_at: row.updated_at ?? null,
    };
  }

  async list(
    rawQuery: Record<string, unknown>,
    _actor?: AuthenticatedUser,
  ): Promise<PaginatedResponse<VendorDto>> {
    const filters = vendorFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findMany({
      search: filters.search,
      isActive: filters.is_active,
      limit: pagination.limit,
      offset,
    });

    return createPaginatedResponse({
      items: rows.map((r) => this.toDto(r)),
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async getById(id: number, _actor?: AuthenticatedUser): Promise<VendorDto> {
    const vendor = await this.repository.findById(id);
    if (!vendor) {
      throw new NotFoundError(`Vendor ${id} was not found`);
    }
    return this.toDto(vendor);
  }

  async create(dto: VendorWriteDto, _actor?: AuthenticatedUser): Promise<VendorDto> {
    const now = new Date();
    const created = await this.repository.insertVendor({
      name: dto.name,
      phone: dto.phone ?? null,
      email: dto.email ?? null,
      gstin: dto.gstin ?? null,
      is_active: dto.is_active ?? true,
      created_at: now,
      updated_at: now,
    });
    return this.toDto(created);
  }

  async update(
    id: number,
    dto: VendorUpdateDto,
    _actor?: AuthenticatedUser,
  ): Promise<VendorDto> {
    // Check existence first
    const existing = await this.repository.findById(id);
    if (!existing) {
      throw new NotFoundError(`Vendor ${id} was not found`);
    }

    const now = new Date();
    const patch: Partial<NewVendor> = {
      updated_at: now,
    };
    if (dto.name !== undefined) patch.name = dto.name;
    if (dto.phone !== undefined) patch.phone = dto.phone ?? null;
    if (dto.email !== undefined) patch.email = dto.email ?? null;
    if (dto.gstin !== undefined) patch.gstin = dto.gstin ?? null;
    if (dto.is_active !== undefined) patch.is_active = dto.is_active;

    const updated = await this.repository.updateVendor(id, patch);
    return this.toDto(updated);
  }

  /**
   * Asserts vendor exists and is active.
   * Throws NotFoundError if not found, or BusinessRuleError if inactive.
   */
  async assertActiveVendor(vendorId: number): Promise<VendorDto> {
    const vendor = await this.repository.assertActiveVendor(vendorId);
    return this.toDto(vendor);
  }
}
