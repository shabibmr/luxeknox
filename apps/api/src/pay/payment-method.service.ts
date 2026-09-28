import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import { ConflictError } from '../platform/errors/app-error';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import type { PaymentMethodDto, PaymentMethodWriteDto } from './payment.dto';
import { PaymentMethodRepository } from './payment-method.repository';

@Injectable()
export class PaymentMethodService {
  constructor(
    private readonly repository: PaymentMethodRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
  ) {}

  toDto(row: {
    id: number;
    method_name: string;
    is_digital: boolean;
    is_active: boolean;
  }): PaymentMethodDto {
    return {
      id: row.id,
      method_name: row.method_name,
      is_digital: row.is_digital,
      is_active: row.is_active,
    };
  }

  async list(
    query: Record<string, unknown>,
    _actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<PaymentMethodDto>> {
    const pagination = await this.paginationHelper.normalizeParams(query);
    const offset = pagination.offset ?? 0;
    const { rows, total } = await this.repository.findMany({
      activeOnly: true,
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

  async create(dto: PaymentMethodWriteDto, actor: AuthenticatedUser): Promise<PaymentMethodDto> {
    const existing = await this.repository.findByName(dto.method_name);
    if (existing) {
      throw new ConflictError(`Payment method '${dto.method_name}' already exists`);
    }
    const now = new Date();
    const created = await this.repository.insertMethod({
      method_name: dto.method_name,
      is_digital: dto.is_digital ?? false,
      is_active: dto.is_active ?? true,
      created_at: now,
      updated_at: now,
    });
    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'payment_method.created',
      entityName: 'payment_methods',
      entityId: created.id,
      afterState: this.toDto(created),
    });
    return this.toDto(created);
  }
}
