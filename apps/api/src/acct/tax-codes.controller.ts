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
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import type { PaginatedResponse } from '../platform/http/pagination';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  taxCodeCreateSchema,
  taxCodeUpdateSchema,
  type TaxCodeCreateDto,
  type TaxCodeDto,
  type TaxCodeUpdateDto,
} from './tax-codes.dto';
import { TaxCodesService } from './tax-codes.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting/tax-codes')
export class TaxCodesController {
  constructor(private readonly service: TaxCodesService) {}

  @Get()
  @RequirePermission('accounting.read')
  @ApiOperation({ operationId: 'listTaxCodes', summary: 'List tax codes' })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<TaxCodeDto>> {
    return this.service.list(query, currentUser);
  }

  @Post()
  @RequirePermission('accounting.accounts_write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createTaxCode', summary: 'Create a tax code' })
  async create(
    @Body(new ZodValidationPipe(taxCodeCreateSchema)) dto: TaxCodeCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<TaxCodeDto> {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('accounting.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getTaxCode', summary: 'Tax code detail' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<TaxCodeDto> {
    return this.service.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('accounting.accounts_write')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'updateTaxCode', summary: 'Update a tax code' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(taxCodeUpdateSchema)) dto: TaxCodeUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<TaxCodeDto> {
    return this.service.update(id, dto, currentUser);
  }
}
