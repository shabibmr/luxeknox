import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiQuery, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import type { PaginatedResponse } from '../platform/http/pagination';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  vendorUpdateSchema,
  vendorWriteSchema,
  type VendorDto,
  type VendorUpdateDto,
  type VendorWriteDto,
} from './vendors.dto';
import { VendorsService } from './vendors.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting/vendors')
export class VendorsController {
  constructor(private readonly service: VendorsService) {}

  @Get()
  @RequirePermission('accounting.read')
  @ApiOperation({ operationId: 'listVendors', summary: 'List vendors' })
  @ApiQuery({ name: 'search', required: false, type: String })
  @ApiQuery({ name: 'is_active', required: false, type: Boolean })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<VendorDto>> {
    return this.service.list(query, currentUser);
  }

  @Post()
  @RequirePermission('accounting.vendors_write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createVendor', summary: 'Create vendor' })
  async create(
    @Body(new ZodValidationPipe(vendorWriteSchema)) dto: VendorWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<VendorDto> {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('accounting.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getVendor', summary: 'Get vendor by ID' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<VendorDto> {
    return this.service.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('accounting.vendors_write')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'updateVendor', summary: 'Update vendor' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(vendorUpdateSchema)) dto: VendorUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<VendorDto> {
    return this.service.update(id, dto, currentUser);
  }
}
