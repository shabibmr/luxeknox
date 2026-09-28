import { Controller, Get, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import type { PaginatedResponse } from '../platform/http/pagination';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  listAttendanceHistoriesQuerySchema,
  type AttendanceHistoryDto,
  type ListAttendanceHistoriesQueryDto,
} from './attendance.dto';
import { AttendanceService } from './attendance.service';

@ApiTags('ATTN')
@ApiBearerAuth('bearer')
@Controller('attendance-histories')
export class AttendanceHistoryController {
  constructor(private readonly service: AttendanceService) {}

  @Get()
  @RequirePermission('attendance.read')
  @ApiOperation({ operationId: 'listAttendanceHistories', summary: 'Daily footfall aggregates' })
  async list(
    @Query(new ZodValidationPipe(listAttendanceHistoriesQuerySchema))
    query: ListAttendanceHistoriesQueryDto,
  ): Promise<PaginatedResponse<AttendanceHistoryDto>> {
    return this.service.listHistories(query);
  }
}
