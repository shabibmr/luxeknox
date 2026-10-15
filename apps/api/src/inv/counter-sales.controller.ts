import { Body, Controller, Get, HttpCode, Param, ParseIntPipe, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiHeader, ApiOperation, ApiParam, ApiQuery, ApiTags } from '@nestjs/swagger';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import type { PaginatedResponse } from '../platform/http/pagination';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { UseIdempotency } from '../platform/idempotency/idempotency.interceptor';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  saleWriteSchema,
  type CounterSaleDto,
  type CounterSaleListItemDto,
  type SaleWrite,
} from './counter-sales.dto';
import { CounterSalesService } from './counter-sales.service';

@ApiTags('INV')
@ApiBearerAuth('bearer')
@Controller('inventory/sales')
export class CounterSalesController {
  constructor(private readonly service: CounterSalesService) {}

  @Get()
  @RequirePermission('inventory.read')
  @ApiOperation({ operationId: 'listCounterSales', summary: 'List counter sales' })
  @ApiQuery({ name: 'from', required: false, type: String, description: 'Sale date from (YYYY-MM-DD)' })
  @ApiQuery({ name: 'to', required: false, type: String, description: 'Sale date to (YYYY-MM-DD)' })
  @ApiQuery({ name: 'member_id', required: false, type: Number })
  @ApiQuery({ name: 'item_id', required: false, type: Number })
  @ApiQuery({ name: 'search', required: false, type: String, description: 'Sale number' })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<CounterSaleListItemDto>> {
    return this.service.list(query, currentUser);
  }

  @Get(':id')
  @RequirePermission('inventory.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getCounterSale', summary: 'Get a counter sale' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<CounterSaleDto> {
    return this.service.getById(id, currentUser);
  }

  @Post()
  @RequirePermission('inventory.sales_write')
  @UseIdempotency()
  @HttpCode(201)
  @ApiOperation({ operationId: 'createCounterSale', summary: 'Create and post a counter sale' })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Replay-safe key (8–128 chars). The same key returns the original sale.',
  })
  async create(
    @Body(new ZodValidationPipe(saleWriteSchema)) dto: SaleWrite,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<CounterSaleDto> {
    return this.service.create(dto, currentUser);
  }
}
