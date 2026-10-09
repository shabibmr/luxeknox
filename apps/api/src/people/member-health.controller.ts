import { Body, Controller, Get, Param, ParseIntPipe, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import type { PaginatedResponse } from '../platform/http/pagination';
import { MemberHealthRecordDto, memberHealthWriteSchema, type MemberHealthWriteDto } from './member-health.dto';
import { MemberHealthService } from './member-health.service';

@ApiTags('HEALTH')
@ApiBearerAuth('bearer')
@Controller('members/:id/health/history')
export class MemberHealthController {
  constructor(private readonly memberHealthService: MemberHealthService) {}

  @Get()
  @RequirePermission('health.read')
  @ApiOperation({ operationId: 'listMemberHealthHistory', summary: 'Member health history list' })
  @ApiParam({ name: 'id', type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'offset', required: false, type: Number })
  @ApiResponse({ status: 200, type: [MemberHealthRecordDto] })
  async list(
    @Param('id', ParseIntPipe) memberId: number,
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<MemberHealthRecordDto>> {
    return this.memberHealthService.list(memberId, query, currentUser);
  }

  @Post()
  @RequirePermission('health.update')
  @ApiOperation({ operationId: 'createMemberHealthRecord', summary: 'Record a new member health row' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 201, type: MemberHealthRecordDto })
  async create(
    @Param('id', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(memberHealthWriteSchema)) dto: MemberHealthWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MemberHealthRecordDto> {
    return this.memberHealthService.create(memberId, dto, currentUser);
  }
}
