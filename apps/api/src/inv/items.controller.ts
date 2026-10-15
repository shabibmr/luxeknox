import { Controller, Get, Param, ParseIntPipe, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiQuery, ApiTags } from '@nestjs/swagger';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import type { PaginatedResponse } from '../platform/http/pagination';
import { RequirePermission } from '../rbac/require-permission.decorator';
import type { InventoryItemDto } from './items.dto';
import { InventoryItemsService } from './items.service';

@ApiTags('INV')
@ApiBearerAuth('bearer')
@Controller('inventory/items')
export class InventoryItemsController {
  constructor(private readonly service: InventoryItemsService) {}

  @Get()
  @RequirePermission('inventory.read')
  @ApiOperation({ operationId: 'listInventoryItems', summary: 'List inventory items' })
  @ApiQuery({ name: 'search', required: false, type: String, description: 'Name or SKU' })
  @ApiQuery({ name: 'item_kind', required: false, enum: ['service', 'goods'] })
  @ApiQuery({ name: 'category_id', required: false, type: Number })
  @ApiQuery({ name: 'is_active', required: false, type: Boolean })
  @ApiQuery({ name: 'inventory_tracked', required: false, type: Boolean })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<InventoryItemDto>> {
    return this.service.list(query, currentUser);
  }

  @Get(':id')
  @RequirePermission('inventory.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getInventoryItem', summary: 'Get inventory item by ID' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<InventoryItemDto> {
    return this.service.getById(id, currentUser);
  }
}
