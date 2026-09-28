import { Body, Controller, Get, Param, ParseIntPipe, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiProperty, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  membershipActionRequestSchema,
  membershipCreateSchema,
  membershipExtensionWriteSchema,
  membershipFreezeWriteSchema,
  membershipUpgradeRequestSchema,
  type MembershipActionRequestDto,
  type MembershipCreateDto,
  type MembershipExtensionWriteDto,
  type MembershipFreezeWriteDto,
  type MembershipUpgradeRequestDto,
} from './membership.dto';
import { MembershipService } from './membership.service';

export class MembershipResponseDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: Number }) member_id!: number;
  @ApiProperty({ type: Number }) product_id!: number;
  @ApiProperty({ type: String }) start_date!: string;
  @ApiProperty({ type: String }) end_date!: string;
  @ApiProperty({ type: Number }) remaining_pt_sessions!: number;
  @ApiProperty({ type: String }) status!: string;
  @ApiProperty({ type: String, nullable: true }) locker_number!: string | null;
  @ApiProperty({ type: Boolean }) auto_renew!: boolean;
  @ApiProperty({ type: Number }) row_version!: number;
}

@ApiTags('MEMB')
@ApiBearerAuth('bearer')
@Controller()
export class MembershipController {
  constructor(private readonly service: MembershipService) {}

  @Get('memberships')
  @RequirePermission('memberships.read')
  @ApiOperation({ operationId: 'listMemberships', summary: 'Membership contracts' })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'offset', required: false, type: Number })
  @ApiQuery({ name: 'member_id', required: false, type: Number })
  @ApiQuery({ name: 'status', required: false, type: String })
  @ApiResponse({ status: 200, description: 'OK' })
  async list(@Query() query: Record<string, unknown>, @CurrentUser() currentUser: AuthenticatedUser) {
    return this.service.list(query, currentUser);
  }

  @Post('memberships')
  @RequirePermission('memberships.create')
  @ApiOperation({ operationId: 'createMembership', summary: 'Assign a membership' })
  @ApiResponse({ status: 201, description: 'OK', type: MembershipResponseDto })
  async create(
    @Body(new ZodValidationPipe(membershipCreateSchema)) dto: MembershipCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.create(dto, currentUser);
  }

  @Get('memberships/:id')
  @RequirePermission('memberships.read')
  @ApiOperation({ operationId: 'getMembership', summary: 'Membership detail' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: MembershipResponseDto })
  @ApiResponse({ status: 404, description: 'Membership not found' })
  async getById(@Param('id', ParseIntPipe) id: number, @CurrentUser() currentUser: AuthenticatedUser) {
    return this.service.getById(id, currentUser);
  }

  @Get('memberships/:id/history')
  @RequirePermission('memberships.read')
  @ApiOperation({ operationId: 'listMembershipHistory', summary: 'Append-only membership history' })
  @ApiParam({ name: 'id', type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'cursor', required: false, type: String })
  @ApiResponse({ status: 200, description: 'OK' })
  async listHistory(
    @Param('id', ParseIntPipe) id: number,
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.listHistory(id, query, currentUser);
  }

  @Post('memberships/:id/renew')
  @RequirePermission('memberships.approve')
  @ApiOperation({ operationId: 'renewMembership', summary: 'Renew a membership' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: MembershipResponseDto })
  @ApiResponse({ status: 409, description: 'row_version mismatch' })
  async renew(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(membershipActionRequestSchema)) dto: MembershipActionRequestDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.renew(id, dto, currentUser);
  }

  @Post('memberships/:id/upgrade')
  @RequirePermission('memberships.approve')
  @ApiOperation({ operationId: 'upgradeMembership', summary: 'Upgrade a membership' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: MembershipResponseDto })
  @ApiResponse({ status: 409, description: 'row_version mismatch' })
  async upgrade(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(membershipUpgradeRequestSchema)) dto: MembershipUpgradeRequestDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.upgrade(id, dto, currentUser);
  }

  @Post('memberships/:id/cancel')
  @RequirePermission('memberships.approve')
  @ApiOperation({ operationId: 'cancelMembership', summary: 'Cancel a membership' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: MembershipResponseDto })
  @ApiResponse({ status: 409, description: 'row_version mismatch' })
  async cancel(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(membershipActionRequestSchema)) dto: MembershipActionRequestDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.cancel(id, dto, currentUser);
  }

  @Get('memberships/:id/freezes')
  @RequirePermission('memberships.read')
  @ApiOperation({ operationId: 'listMembershipFreezes', summary: 'Freeze requests' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK' })
  async listFreezes(@Param('id', ParseIntPipe) id: number, @CurrentUser() currentUser: AuthenticatedUser) {
    return this.service.listFreezes(id, currentUser);
  }

  @Post('memberships/:id/freezes')
  @RequirePermission('memberships.update')
  @ApiOperation({ operationId: 'requestMembershipFreeze', summary: 'Request or create a freeze' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 201, description: 'OK' })
  async requestFreeze(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(membershipFreezeWriteSchema)) dto: MembershipFreezeWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.requestFreeze(id, dto, currentUser);
  }

  @Post('memberships/:id/extensions')
  @RequirePermission('memberships.approve')
  @ApiOperation({ operationId: 'extendMembership', summary: 'Grant a compensatory extension' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 201, description: 'OK' })
  async extend(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(membershipExtensionWriteSchema)) dto: MembershipExtensionWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.extend(id, dto, currentUser);
  }
}
