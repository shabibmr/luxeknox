import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import type { GoalMetric, NewGoalMetric } from '../platform/db/schema/goals';
import { NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import type {
  GoalMetricFilterQueryDto,
  GoalMetricUpdateDto,
  GoalMetricWriteDto,
} from './goal.dto';
import { GoalMetricRepository } from './goal-metric.repository';

@Injectable()
export class GoalMetricService {
  constructor(
    private readonly repository: GoalMetricRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
  ) {}

  async list(
    rawQuery: Record<string, unknown>,
    filter: GoalMetricFilterQueryDto,
  ): Promise<PaginatedResponse<GoalMetric>> {
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findManyFiltered({
      category: filter.category,
      isActive: filter.is_active,
      q: filter.q,
      limit: pagination.limit,
      offset,
    });

    return createPaginatedResponse({
      items: rows,
      total,
      limit: pagination.limit,
      offset,
    });
  }

  async getById(id: number): Promise<GoalMetric> {
    const metric = await this.repository.findById(id);
    if (!metric) {
      throw new NotFoundError(`Goal metric with id ${id} not found`);
    }
    return metric;
  }

  async create(dto: GoalMetricWriteDto, actor: AuthenticatedUser): Promise<GoalMetric> {
    const now = new Date();
    const newMetric: NewGoalMetric = {
      name: dto.name,
      unit_of_measure: dto.unit_of_measure,
      category: dto.category,
      is_active: dto.is_active ?? true,
      created_at: now,
      updated_at: now,
    };

    const created = await this.repository.create(newMetric);

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'create',
      entityName: 'goal_metrics',
      entityId: created.id,
      afterState: created,
    });

    return created;
  }

  async update(
    id: number,
    dto: GoalMetricUpdateDto,
    actor: AuthenticatedUser,
  ): Promise<GoalMetric> {
    const existing = await this.getById(id);

    const updateData: Partial<NewGoalMetric> = {
      ...dto,
      updated_at: new Date(),
    };

    const updated = await this.repository.updateById(id, updateData);
    if (!updated) {
      throw new NotFoundError(`Goal metric with id ${id} not found`);
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'update',
      entityName: 'goal_metrics',
      entityId: id,
      beforeState: existing,
      afterState: updated,
    });

    return updated;
  }
}
