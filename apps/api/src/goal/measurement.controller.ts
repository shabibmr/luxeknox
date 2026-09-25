import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  measurementFilterQuerySchema,
  measurementWriteSchema,
  type MeasurementFilterQueryDto,
  type MeasurementWriteDto,
} from './goal.dto';
import { MeasurementService } from './measurement.service';

@ApiTags('GOAL')
@ApiBearerAuth('bearer')
@Controller()
export class MeasurementController {
  constructor(private readonly service: MeasurementService) {}

  @Get('members/:id/measurements/chart')
  @RequirePermission('goals.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getMeasurementChart', summary: 'Longitudinal metric chart series' })
  async getMeasurementChart(
    @Param('id', ParseIntPipe) memberId: number,
    @Query('metric_id', ParseIntPipe) metricId: number,
    @Query('from') from: string | undefined,
    @Query('to') to: string | undefined,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.getLongitudinalChart(memberId, metricId, from, to, currentUser);
  }

  @Get('members/:id/measurements')
  @RequirePermission('goals.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'listMeasurements', summary: 'Measurement sessions' })
  async listMeasurements(
    @Param('id', ParseIntPipe) memberId: number,
    @Query() rawQuery: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    const filter = measurementFilterQuerySchema.parse(rawQuery);
    return this.service.listMeasurements(memberId, rawQuery, filter, currentUser);
  }

  @Post('members/:id/measurements')
  @RequirePermission('goals.write')
  @HttpCode(201)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'createMeasurement', summary: 'Record a measurement session' })
  async createMeasurement(
    @Param('id', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(measurementWriteSchema)) dto: MeasurementWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.createMeasurement(memberId, dto, currentUser);
  }

  @Get('measurements/:id')
  @RequirePermission('goals.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getMeasurement', summary: 'Measurement session with values' })
  async getMeasurement(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.getMeasurementById(id, currentUser);
  }
}
