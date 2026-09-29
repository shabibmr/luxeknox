import { Body, Controller, Get, Param, ParseIntPipe, Patch, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  ptProductUpdateSchema,
  ptProductWriteSchema,
  type PtProductUpdateDto,
  type PtProductWriteDto,
} from './pt.dto';
import { PtProductService } from './pt-product.service';

@ApiTags('PT')
@ApiBearerAuth('bearer')
@Controller('pt-products')
export class PtProductController {
  constructor(private readonly service: PtProductService) {}

  @Get()
  @RequirePermission('pt_products.read')
  @ApiOperation({ operationId: 'listPtProducts', summary: 'Personal Training package catalog' })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'offset', required: false, type: Number })
  @ApiQuery({ name: 'q', required: false, type: String })
  @ApiResponse({ status: 200, description: 'OK' })
  list(@Query() query: Record<string, unknown>, @CurrentUser() actor: AuthenticatedUser) {
    return this.service.list(query, actor);
  }

  @Post()
  @RequirePermission('pt_products.write')
  @ApiOperation({ operationId: 'createPtProduct', summary: 'Create a PT package' })
  @ApiResponse({ status: 201, description: 'Created' })
  create(
    @Body(new ZodValidationPipe(ptProductWriteSchema)) dto: PtProductWriteDto,
    @CurrentUser() actor: AuthenticatedUser,
  ) {
    return this.service.create(dto, actor);
  }

  @Get(':id')
  @RequirePermission('pt_products.read')
  @ApiOperation({ operationId: 'getPtProduct', summary: 'PT package detail' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK' })
  getById(@Param('id', ParseIntPipe) id: number, @CurrentUser() actor: AuthenticatedUser) {
    return this.service.getById(id, actor);
  }

  @Patch(':id')
  @RequirePermission('pt_products.write')
  @ApiOperation({ operationId: 'updatePtProduct', summary: 'Update / archive a PT package' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK' })
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(ptProductUpdateSchema)) dto: PtProductUpdateDto,
    @CurrentUser() actor: AuthenticatedUser,
  ) {
    return this.service.update(id, dto, actor);
  }
}
