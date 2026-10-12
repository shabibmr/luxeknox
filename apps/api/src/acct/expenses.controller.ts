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
import { ApiBearerAuth, ApiHeader, ApiOperation, ApiParam, ApiQuery, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { UseIdempotency } from '../platform/idempotency/idempotency.interceptor';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import type { PaginatedResponse } from '../platform/http/pagination';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  expenseCreateSchema,
  expenseUpdateSchema,
  type ExpenseCreateDto,
  type ExpenseUpdateDto,
  type ExpenseVoucherDto,
} from './expenses.dto';
import { ExpensesService } from './expenses.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting/expenses')
export class ExpensesController {
  constructor(private readonly service: ExpensesService) {}

  @Get()
  @RequirePermission('accounting.read')
  @ApiOperation({ operationId: 'listExpenses', summary: 'List expense vouchers' })
  @ApiQuery({ name: 'status', required: false, enum: ['draft', 'posted'] })
  @ApiQuery({ name: 'vendor_id', required: false, type: Number })
  @ApiQuery({ name: 'from', required: false, type: String })
  @ApiQuery({ name: 'to', required: false, type: String })
  @ApiQuery({ name: 'search', required: false, type: String })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<ExpenseVoucherDto>> {
    return this.service.list(query, currentUser);
  }

  @Post()
  @RequirePermission('accounting.expenses_write')
  @UseIdempotency()
  @HttpCode(201)
  @ApiOperation({ operationId: 'createExpense', summary: 'Create an expense voucher' })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Replay-safe key for expense voucher creation',
  })
  async create(
    @Body(new ZodValidationPipe(expenseCreateSchema)) dto: ExpenseCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ExpenseVoucherDto> {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('accounting.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getExpense', summary: 'Get expense voucher by ID' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ExpenseVoucherDto> {
    return this.service.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('accounting.expenses_write')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'updateExpense', summary: 'Update a draft expense voucher' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(expenseUpdateSchema)) dto: ExpenseUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ExpenseVoucherDto> {
    return this.service.update(id, dto, currentUser);
  }

  @Post(':id/post')
  @RequirePermission('accounting.expenses_write')
  @HttpCode(200)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'postExpense', summary: 'Post an expense voucher to general ledger' })
  async post(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ExpenseVoucherDto> {
    return this.service.post(id, currentUser);
  }
}
