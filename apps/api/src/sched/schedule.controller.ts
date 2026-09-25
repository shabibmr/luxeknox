import { Body, Controller, Get, HttpCode, Param, ParseIntPipe, Patch, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  cancelRequestSchema,
  scheduleTransitionSchema,
  scheduleWriteSchema,
  type CancelRequestDto,
  type ScheduleTransitionDto,
  type ScheduleWriteDto,
} from './schedule.dto';
import { ScheduleService } from './schedule.service';

@ApiTags('SCHED')
@ApiBearerAuth('bearer')
@Controller('schedules')
export class ScheduleController {
  constructor(private readonly service: ScheduleService) {}

  @Get()
  @RequirePermission('schedules.read')
  @ApiOperation({ operationId: 'listSchedules', summary: 'Calendar list' })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.list(query, currentUser);
  }

  @Post()
  @RequirePermission('schedules.write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createSchedule', summary: 'Create a booking or class occurrence' })
  async create(
    @Body(new ZodValidationPipe(scheduleWriteSchema)) dto: ScheduleWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('schedules.read')
  @ApiOperation({ operationId: 'getSchedule', summary: 'Schedule detail' })
  @ApiParam({ name: 'id', type: Number })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('schedules.write')
  @ApiOperation({ operationId: 'updateSchedule', summary: 'Update a schedule (requires row_version)' })
  @ApiParam({ name: 'id', type: Number })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(scheduleWriteSchema)) dto: ScheduleWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.update(id, dto, currentUser);
  }

  @Post(':id/cancel')
  @RequirePermission('schedules.cancel')
  @ApiOperation({ operationId: 'cancelSchedule', summary: 'Cancel a schedule' })
  @ApiParam({ name: 'id', type: Number })
  async cancel(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(cancelRequestSchema)) dto: CancelRequestDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.cancel(id, dto, currentUser);
  }

  @Post(':id/start')
  @RequirePermission('schedules.write')
  @ApiOperation({ operationId: 'startSchedule', summary: 'Transition a schedule to ongoing' })
  @ApiParam({ name: 'id', type: Number })
  async start(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(scheduleTransitionSchema)) dto: ScheduleTransitionDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.start(id, dto, currentUser);
  }

  @Post(':id/complete')
  @RequirePermission('schedules.write')
  @ApiOperation({ operationId: 'completeSchedule', summary: 'Transition an ongoing schedule to completed' })
  @ApiParam({ name: 'id', type: Number })
  async complete(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(scheduleTransitionSchema)) dto: ScheduleTransitionDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.complete(id, dto, currentUser);
  }

  @Get(':id/history')
  @RequirePermission('schedules.read')
  @ApiOperation({ operationId: 'listScheduleHistory', summary: 'Append-only schedule history' })
  @ApiParam({ name: 'id', type: Number })
  async listHistory(
    @Param('id', ParseIntPipe) id: number,
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.listHistory(id, query, currentUser);
  }
}
