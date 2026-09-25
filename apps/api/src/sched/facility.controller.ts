import { Body, Controller, Get, HttpCode, Param, ParseIntPipe, Patch, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  facilityUpdateSchema,
  facilityWriteSchema,
  type FacilityUpdateDto,
  type FacilityWriteDto,
} from './facility.dto';
import { FacilityService } from './facility.service';

@ApiTags('SCHED')
@ApiBearerAuth('bearer')
@Controller('facilities')
export class FacilityController {
  constructor(private readonly service: FacilityService) {}

  @Get()
  @RequirePermission('schedules.read')
  @ApiOperation({ operationId: 'listFacilities', summary: 'Rooms and studios' })
  async list(@Query() query: Record<string, unknown>) {
    return this.service.list(query);
  }

  @Post()
  @RequirePermission('schedules.write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createFacility', summary: 'Create a facility' })
  async create(
    @Body(new ZodValidationPipe(facilityWriteSchema)) dto: FacilityWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.create(dto, currentUser);
  }

  @Patch(':id')
  @RequirePermission('schedules.write')
  @ApiOperation({ operationId: 'updateFacility', summary: 'Update a facility' })
  @ApiParam({ name: 'id', type: Number })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(facilityUpdateSchema)) dto: FacilityUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.update(id, dto, currentUser);
  }
}
