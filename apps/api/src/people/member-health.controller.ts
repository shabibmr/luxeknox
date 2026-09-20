import { Body, Controller, Get, Param, ParseIntPipe, Put } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiProperty, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { memberHealthWriteSchema, type MemberHealthWriteDto } from './member-health.dto';
import { MemberHealthService } from './member-health.service';
import type { MemberHealth } from '../platform/db/schema/member-health';

export class MemberHealthResponseDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: Number }) member_id!: number;
  @ApiProperty({ type: String, nullable: true }) blood_group!: string | null;
  @ApiProperty({ type: Number, nullable: true }) height_cm!: number | null;
  @ApiProperty({ type: Number, nullable: true }) baseline_weight_kg!: number | null;
  @ApiProperty({ type: String, nullable: true }) allergies!: string | null;
  @ApiProperty({ type: String, nullable: true }) dietary_preferences!: string | null;
  @ApiProperty({ type: String, nullable: true }) physician_name!: string | null;
  @ApiProperty({ type: String, nullable: true }) physician_phone!: string | null;
}

@ApiTags('HEALTH')
@ApiBearerAuth('bearer')
@Controller('members/:id/health')
export class MemberHealthController {
  constructor(private readonly memberHealthService: MemberHealthService) {}

  @Get()
  @RequirePermission('health.read')
  @ApiOperation({ operationId: 'getMemberHealth', summary: 'Current health row' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: MemberHealthResponseDto })
  async get(
    @Param('id', ParseIntPipe) memberId: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MemberHealth> {
    return this.memberHealthService.get(memberId, currentUser);
  }

  @Put()
  @RequirePermission('health.update')
  @ApiOperation({ operationId: 'putMemberHealth', summary: 'Replace current health row' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: MemberHealthResponseDto })
  async put(
    @Param('id', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(memberHealthWriteSchema)) dto: MemberHealthWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MemberHealth> {
    return this.memberHealthService.put(memberId, dto, currentUser);
  }
}
