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
  accountCreateSchema,
  accountUpdateSchema,
  type AccountCreateDto,
  type AccountDto,
  type AccountUpdateDto,
} from './accounts.dto';
import { AccountsService } from './accounts.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting/accounts')
export class AccountsController {
  constructor(private readonly service: AccountsService) {}

  @Get()
  @RequirePermission('accounting.read')
  @ApiOperation({ operationId: 'listAccounts', summary: 'List accounts' })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<AccountDto>> {
    return this.service.list(query, currentUser);
  }

  @Post()
  @RequirePermission('accounting.accounts_write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createAccount', summary: 'Create an account' })
  async create(
    @Body(new ZodValidationPipe(accountCreateSchema)) dto: AccountCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<AccountDto> {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('accounting.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getAccount', summary: 'Account detail' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<AccountDto> {
    return this.service.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('accounting.accounts_write')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'updateAccount', summary: 'Update an account' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(accountUpdateSchema)) dto: AccountUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<AccountDto> {
    return this.service.update(id, dto, currentUser);
  }
}
