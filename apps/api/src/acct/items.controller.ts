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
  itemCreateSchema,
  itemUpdateSchema,
  type ItemCreateDto,
  type ItemDto,
  type ItemUpdateDto,
} from './items.dto';
import { ItemsService } from './items.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting/items')
export class ItemsController {
  constructor(private readonly service: ItemsService) {}

  @Get()
  @RequirePermission('accounting.read')
  @ApiOperation({ operationId: 'listItems', summary: 'List items' })
  @ApiQuery({ name: 'item_kind', required: false, enum: ['service', 'goods'] })
  @ApiQuery({ name: 'is_active', required: false, type: Boolean })
  @ApiQuery({ name: 'search', required: false, type: String })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<ItemDto>> {
    return this.service.list(query, currentUser);
  }

  @Post()
  @RequirePermission('accounting.accounts_write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createItem', summary: 'Create item' })
  async create(
    @Body(new ZodValidationPipe(itemCreateSchema)) dto: ItemCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ItemDto> {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('accounting.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getItem', summary: 'Get item by ID' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ItemDto> {
    return this.service.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('accounting.accounts_write')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'updateItem', summary: 'Update item' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(itemUpdateSchema)) dto: ItemUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ItemDto> {
    return this.service.update(id, dto, currentUser);
  }
}
