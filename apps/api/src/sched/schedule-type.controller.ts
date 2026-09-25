import { Body, Controller, Get, HttpCode, Param, ParseIntPipe, Patch, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  scheduleTypeUpdateSchema,
  scheduleTypeWriteSchema,
  type ScheduleTypeUpdateDto,
  type ScheduleTypeWriteDto,
} from './schedule-type.dto';
import { ScheduleTypeService } from './schedule-type.service';

@ApiTags('SCHED')
@ApiBearerAuth('bearer')
@Controller('schedule-types')
export class ScheduleTypeController {
  constructor(private readonly service: ScheduleTypeService) {}

  @Get()
  @RequirePermission('schedules.read')
  @ApiOperation({ operationId: 'listScheduleTypes', summary: 'Schedule types' })
  async list(@Query() query: Record<string, unknown>) {
    return this.service.list(query);
  }

  @Post()
  @RequirePermission('schedules.write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createScheduleType', summary: 'Create a schedule type' })
  async create(
    @Body(new ZodValidationPipe(scheduleTypeWriteSchema)) dto: ScheduleTypeWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.create(dto, currentUser);
  }

  @Patch(':id')
  @RequirePermission('schedules.write')
  @ApiOperation({ operationId: 'updateScheduleType', summary: 'Update a schedule type' })
  @ApiParam({ name: 'id', type: Number })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(scheduleTypeUpdateSchema)) dto: ScheduleTypeUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.update(id, dto, currentUser);
  }
}
