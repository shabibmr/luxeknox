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
import {
  ApiBearerAuth,
  ApiHeader,
  ApiOperation,
  ApiParam,
  ApiQuery,
  ApiTags,
} from '@nestjs/swagger';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import type { PaginatedResponse } from '../platform/http/pagination';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { UseIdempotency } from '../platform/idempotency/idempotency.interceptor';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  fundTransferCreateSchema,
  fundTransferUpdateSchema,
  type FundTransferCreateDto,
  type FundTransferDto,
  type FundTransferUpdateDto,
} from './fund-transfers.dto';
import { FundTransfersService } from './fund-transfers.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting/fund-transfers')
export class FundTransfersController {
  constructor(private readonly service: FundTransfersService) {}

  @Get()
  @RequirePermission('accounting.read')
  @ApiOperation({ operationId: 'listFundTransfers', summary: 'List fund transfers' })
  @ApiQuery({ name: 'status', required: false, enum: ['draft', 'posted'] })
  @ApiQuery({ name: 'from', required: false, type: String })
  @ApiQuery({ name: 'to', required: false, type: String })
  @ApiQuery({ name: 'account_id', required: false, type: Number })
  @ApiQuery({ name: 'search', required: false, type: String })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<FundTransferDto>> {
    return this.service.list(query, currentUser);
  }

  @Post()
  @RequirePermission('accounting.payments_write')
  @UseIdempotency()
  @HttpCode(201)
  @ApiOperation({ operationId: 'createFundTransfer', summary: 'Create a draft fund transfer' })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Replay-safe key for fund transfer creates',
  })
  async create(
    @Body(new ZodValidationPipe(fundTransferCreateSchema)) dto: FundTransferCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<FundTransferDto> {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('accounting.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getFundTransfer', summary: 'Get fund transfer by ID' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<FundTransferDto> {
    return this.service.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('accounting.payments_write')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'updateFundTransfer', summary: 'Update a draft fund transfer' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(fundTransferUpdateSchema)) dto: FundTransferUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<FundTransferDto> {
    return this.service.update(id, dto, currentUser);
  }

  @Post(':id/post')
  @RequirePermission('accounting.payments_write')
  @HttpCode(200)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'postFundTransfer', summary: 'Post a fund transfer to GL' })
  async post(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<FundTransferDto> {
    return this.service.post(id, currentUser);
  }
}
