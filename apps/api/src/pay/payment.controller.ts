import { Body, Controller, Get, HttpCode, Param, ParseIntPipe, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiHeader, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { UseIdempotency } from '../platform/idempotency/idempotency.interceptor';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import type { PaginatedResponse } from '../platform/http/pagination';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  paymentAdjustSchema,
  paymentCreateSchema,
  type PaymentAdjustDto,
  type PaymentCreateDto,
  type PaymentDto,
  type PaymentReceiptDto,
} from './payment.dto';
import { PaymentService } from './payment.service';

@ApiTags('PAY')
@ApiBearerAuth('bearer')
@Controller('payments')
export class PaymentController {
  constructor(private readonly service: PaymentService) {}

  @Get()
  @RequirePermission('payments.read')
  @ApiOperation({ operationId: 'listPayments', summary: 'Invoice ledger' })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<PaymentDto>> {
    return this.service.list(query, currentUser);
  }

  @Get('outstanding')
  @RequirePermission('payments.read')
  @ApiOperation({
    operationId: 'listOutstandingPayments',
    summary: 'Pending and partial invoices',
  })
  async listOutstanding(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<PaymentDto>> {
    return this.service.listOutstanding(query, currentUser);
  }

  @Post()
  @RequirePermission('payments.create')
  @UseIdempotency()
  @HttpCode(201)
  @ApiOperation({ operationId: 'createPayment', summary: 'Record POS / issue invoice' })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Required in practice for POS retries (FR-API-008)',
  })
  async create(
    @Body(new ZodValidationPipe(paymentCreateSchema)) dto: PaymentCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaymentDto> {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('payments.read')
  @ApiOperation({ operationId: 'getPayment', summary: 'Invoice detail with history' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaymentDto> {
    return this.service.getById(id, currentUser);
  }

  @Post(':id/refund')
  @RequirePermission('payments.approve')
  @UseIdempotency()
  @ApiOperation({ operationId: 'refundPayment', summary: 'Refund against an invoice' })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Required in practice for refund retries (FR-API-008)',
  })
  async refund(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(paymentAdjustSchema)) dto: PaymentAdjustDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaymentDto> {
    return this.service.refund(id, dto, currentUser);
  }

  @Post(':id/adjust')
  @RequirePermission('payments.approve')
  @ApiOperation({ operationId: 'adjustPayment', summary: 'Adjust an invoice' })
  async adjust(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(paymentAdjustSchema)) dto: PaymentAdjustDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaymentDto> {
    return this.service.adjust(id, dto, currentUser);
  }

  @Get(':id/receipt')
  @RequirePermission('payments.read')
  @ApiOperation({
    operationId: 'getPaymentReceipt',
    summary: 'Receipt (re-rendered in MVP; no stored PDF)',
  })
  async getReceipt(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaymentReceiptDto> {
    return this.service.getReceipt(id, currentUser);
  }
}
