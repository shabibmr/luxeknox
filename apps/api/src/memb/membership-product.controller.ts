import { Body, Controller, Get, Param, ParseIntPipe, Patch, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiProperty, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  membershipProductUpdateSchema,
  membershipProductWriteSchema,
  type MembershipProductUpdateDto,
  type MembershipProductWriteDto,
} from './membership-product.dto';
import { MembershipProductService } from './membership-product.service';

export class MembershipProductResponseDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: String }) name!: string;
  @ApiProperty({ type: String }) code!: string;
  @ApiProperty({ type: String, nullable: true }) description!: string | null;
  @ApiProperty({ type: Number }) duration_days!: number;
  @ApiProperty({ type: String }) base_price!: string;
  @ApiProperty({ type: String }) tax_percentage!: string;
  @ApiProperty({ type: Number }) max_freeze_days!: number;
  @ApiProperty({ type: Number }) pt_sessions_included!: number;
  @ApiProperty({ type: [String], nullable: true }) access_facilities!: string[] | null;
  @ApiProperty({ type: Boolean }) is_active!: boolean;
}

export class MembershipProductPageMetaDto {
  @ApiProperty({ type: Number }) limit!: number;
  @ApiProperty({ type: Number, nullable: true }) offset!: number | null;
  @ApiProperty({ type: String, nullable: true }) cursor!: string | null;
  @ApiProperty({ type: String, nullable: true }) next_cursor!: string | null;
  @ApiProperty({ type: Boolean }) has_more!: boolean;
  @ApiProperty({ type: Number, required: false }) total?: number;
}

export class MembershipProductPageResponseDto {
  @ApiProperty({ type: [MembershipProductResponseDto] }) data!: MembershipProductResponseDto[];
  @ApiProperty({ type: MembershipProductPageMetaDto }) meta!: MembershipProductPageMetaDto;
}

@ApiTags('MEMB')
@ApiBearerAuth('bearer')
@Controller('membership-products')
export class MembershipProductController {
  constructor(private readonly service: MembershipProductService) {}

  @Get()
  @RequirePermission('memberships.read')
  @ApiOperation({ operationId: 'listMembershipProducts', summary: 'Package catalog' })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'offset', required: false, type: Number })
  @ApiQuery({ name: 'q', required: false, type: String })
  @ApiResponse({ status: 200, description: 'OK', type: MembershipProductPageResponseDto })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MembershipProductPageResponseDto> {
    return this.service.list(query, currentUser);
  }

  @Post()
  @RequirePermission('memberships.create')
  @ApiOperation({ operationId: 'createMembershipProduct', summary: 'Create a package' })
  @ApiResponse({ status: 201, description: 'OK', type: MembershipProductResponseDto })
  async create(
    @Body(new ZodValidationPipe(membershipProductWriteSchema)) dto: MembershipProductWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MembershipProductResponseDto> {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('memberships.read')
  @ApiOperation({ operationId: 'getMembershipProduct', summary: 'Package detail' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: MembershipProductResponseDto })
  @ApiResponse({ status: 404, description: 'Membership product not found' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MembershipProductResponseDto> {
    return this.service.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('memberships.update')
  @ApiOperation({ operationId: 'updateMembershipProduct', summary: 'Update a package' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: MembershipProductResponseDto })
  @ApiResponse({ status: 404, description: 'Membership product not found' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(membershipProductUpdateSchema)) dto: MembershipProductUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MembershipProductResponseDto> {
    return this.service.update(id, dto, currentUser);
  }
}
