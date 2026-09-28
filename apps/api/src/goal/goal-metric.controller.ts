import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  goalMetricFilterQuerySchema,
  goalMetricUpdateSchema,
  goalMetricWriteSchema,
  type GoalMetricFilterQueryDto,
  type GoalMetricUpdateDto,
  type GoalMetricWriteDto,
} from './goal.dto';
import { GoalMetricService } from './goal-metric.service';

@ApiTags('GOAL')
@ApiBearerAuth('bearer')
@Controller('goal-metrics')
export class GoalMetricController {
  constructor(private readonly service: GoalMetricService) {}

  @Get()
  @RequirePermission('goals.read')
  @ApiOperation({ operationId: 'listGoalMetrics', summary: 'Measurement type catalog' })
  async list(@Query() rawQuery: Record<string, unknown>) {
    const filter = goalMetricFilterQuerySchema.parse(rawQuery);
    return this.service.list(rawQuery, filter);
  }

  @Post()
  @RequirePermission('goals.write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createGoalMetric', summary: 'Create a metric' })
  async create(
    @Body(new ZodValidationPipe(goalMetricWriteSchema)) dto: GoalMetricWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.create(dto, currentUser);
  }

  @Patch(':id')
  @RequirePermission('goals.write')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'updateGoalMetric', summary: 'Update a metric' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(goalMetricUpdateSchema)) dto: GoalMetricUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.update(id, dto, currentUser);
  }
}
