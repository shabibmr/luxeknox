import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Post,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiHeader,
  ApiOperation,
  ApiSecurity,
  ApiTags,
} from '@nestjs/swagger';
import type { Request } from 'express';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { Public } from '../auth/public.decorator';
import { UseIdempotency } from '../platform/idempotency/idempotency.interceptor';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import type { PaginatedResponse } from '../platform/http/pagination';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  attendanceSummaryQuerySchema,
  checkInRequestSchema,
  listAttendancesQuerySchema,
  manualOverrideRequestSchema,
  type AttendanceResponseDto,
  type AttendanceSummaryDto,
  type AttendanceSummaryQueryDto,
  type CheckInRequestDto,
  type ListAttendancesQueryDto,
  type ManualOverrideRequestDto,
  type OccupancyDto,
} from './attendance.dto';
import { AttendanceService } from './attendance.service';
import { CheckInAuthGuard } from './check-in-auth.guard';

@ApiTags('ATTN')
@Controller('attendances')
export class AttendanceController {
  constructor(private readonly service: AttendanceService) {}

  @Post('check-in')
  @Public()
  @UseGuards(CheckInAuthGuard)
  @UseIdempotency()
  @HttpCode(201)
  @ApiOperation({ operationId: 'checkIn', summary: 'Gate check-in (user session or device key)' })
  @ApiBearerAuth('bearer')
  @ApiSecurity('deviceKey')
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Optional idempotency key for safe hardware/client retries',
  })
  async checkIn(
    @Req() req: Request,
    @Body(new ZodValidationPipe(checkInRequestSchema)) dto: CheckInRequestDto,
  ): Promise<AttendanceResponseDto> {
    return this.service.checkIn(dto, {
      actor: req.user ?? null,
      device: req.device ?? null,
    });
  }

  @Post('override')
  @RequirePermission('attendance.override')
  @HttpCode(201)
  @ApiBearerAuth('bearer')
  @ApiOperation({
    operationId: 'manualOverrideCheckIn',
    summary: 'Manual gate check-in override (bypasses eligibility/caps)',
  })
  async override(
    @CurrentUser() currentUser: AuthenticatedUser,
    @Body(new ZodValidationPipe(manualOverrideRequestSchema)) dto: ManualOverrideRequestDto,
  ): Promise<AttendanceResponseDto> {
    return this.service.manualOverride(dto, currentUser);
  }

  @Get('summary')
  @RequirePermission('attendance.read')
  @ApiBearerAuth('bearer')
  @ApiOperation({ operationId: 'getAttendanceSummary', summary: 'Scoped attendance summary' })
  async summary(
    @CurrentUser() currentUser: AuthenticatedUser,
    @Query(new ZodValidationPipe(attendanceSummaryQuerySchema)) query: AttendanceSummaryQueryDto,
  ): Promise<AttendanceSummaryDto> {
    return this.service.summary(query, currentUser);
  }

  @Get('occupancy')
  @RequirePermission('attendance.read')
  @ApiBearerAuth('bearer')
  @ApiOperation({
    operationId: 'getAttendanceOccupancy',
    summary: 'Live gate occupancy (open check-ins)',
  })
  async occupancy(): Promise<OccupancyDto> {
    return this.service.getOccupancy();
  }

  @Get()
  @RequirePermission('attendance.read')
  @ApiBearerAuth('bearer')
  @ApiOperation({ operationId: 'listAttendances', summary: 'Gate attendance log' })
  async list(
    @CurrentUser() currentUser: AuthenticatedUser,
    @Query(new ZodValidationPipe(listAttendancesQuerySchema)) query: ListAttendancesQueryDto,
  ): Promise<PaginatedResponse<AttendanceResponseDto>> {
    return this.service.list(query, currentUser);
  }

  @Post(':id/check-out')
  @RequirePermission('attendance.update')
  @ApiBearerAuth('bearer')
  @ApiOperation({ operationId: 'checkOut', summary: 'Gate check-out' })
  async checkOut(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<AttendanceResponseDto> {
    return this.service.checkOut(id, currentUser);
  }
}
