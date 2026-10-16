import { Controller, Get, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiQuery, ApiTags } from '@nestjs/swagger';
import type { PaginatedResponse } from '../platform/http/pagination';
import { RequirePermission } from '../rbac/require-permission.decorator';
import type { ItemCategoryDto, UomDto } from './catalog.dto';
import { InventoryCatalogService } from './catalog.service';

@ApiTags('INV')
@ApiBearerAuth('bearer')
@Controller('inventory')
export class InventoryCatalogController {
  constructor(private readonly service: InventoryCatalogService) {}

  @Get('uoms')
  @RequirePermission('inventory.read')
  @ApiOperation({ operationId: 'listUoms', summary: 'List units of measure' })
  @ApiQuery({ name: 'is_active', required: false, type: Boolean })
  async listUoms(@Query() query: Record<string, unknown>): Promise<PaginatedResponse<UomDto>> {
    return this.service.listUoms(query);
  }

  @Get('item-categories')
  @RequirePermission('inventory.read')
  @ApiOperation({ operationId: 'listItemCategories', summary: 'List item categories' })
  @ApiQuery({ name: 'is_active', required: false, type: Boolean })
  async listCategories(
    @Query() query: Record<string, unknown>,
  ): Promise<PaginatedResponse<ItemCategoryDto>> {
    return this.service.listCategories(query);
  }
}
