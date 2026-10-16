import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiHeader, ApiOperation, ApiParam, ApiQuery, ApiTags } from '@nestjs/swagger';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import type { PaginatedResponse } from '../platform/http/pagination';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { UseIdempotency } from '../platform/idempotency/idempotency.interceptor';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  purchaseBillCreateSchema,
  type PurchaseBillCreateDto,
  type PurchaseBillDto,
} from './purchase-bills.dto';
import { PurchaseBillsService } from './purchase-bills.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting/purchase-bills')
export class PurchaseBillsController {
  constructor(private readonly service: PurchaseBillsService) {}

  @Get()
  @RequirePermission('accounting.read')
  @ApiOperation({ operationId: 'listPurchaseBills', summary: 'List purchase bills' })
  @ApiQuery({ name: 'status', required: false, enum: ['draft', 'posted', 'void'] })
  @ApiQuery({ name: 'vendor_id', required: false, type: Number })
  @ApiQuery({ name: 'from', required: false, type: String })
  @ApiQuery({ name: 'to', required: false, type: String })
  @ApiQuery({ name: 'search', required: false, type: String })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<PurchaseBillDto>> {
    return this.service.list(query, currentUser);
  }

  @Post()
  @RequirePermission('accounting.purchases_write')
  @UseIdempotency()
  @HttpCode(201)
  @ApiOperation({ operationId: 'createPurchaseBill', summary: 'Create a purchase bill (posted unless draft is true)' })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Replay-safe key for purchase bill creation',
  })
  async create(
    @Body(new ZodValidationPipe(purchaseBillCreateSchema)) dto: PurchaseBillCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PurchaseBillDto> {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('accounting.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getPurchaseBill', summary: 'Get purchase bill by ID' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PurchaseBillDto> {
    return this.service.getById(id, currentUser);
  }

  @Post(':id/post')
  @RequirePermission('accounting.purchases_write')
  @UseIdempotency()
  @HttpCode(200)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'postPurchaseBill', summary: 'Post a draft purchase bill' })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Replay-safe key for posting a purchase bill',
  })
  async post(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PurchaseBillDto> {
    return this.service.post(id, currentUser);
  }
}
