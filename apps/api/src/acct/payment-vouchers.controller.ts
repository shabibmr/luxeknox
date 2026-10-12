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
  paymentVoucherCreateSchema,
  paymentVoucherUpdateSchema,
  type PaymentVoucherCreateDto,
  type PaymentVoucherDto,
  type PaymentVoucherUpdateDto,
} from './payment-vouchers.dto';
import { PaymentVouchersService } from './payment-vouchers.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting/payment-vouchers')
export class PaymentVouchersController {
  constructor(private readonly service: PaymentVouchersService) {}

  @Get()
  @RequirePermission('accounting.read')
  @ApiOperation({ operationId: 'listPaymentVouchers', summary: 'List payment vouchers' })
  @ApiQuery({ name: 'status', required: false, enum: ['draft', 'posted'] })
  @ApiQuery({ name: 'from', required: false, type: String })
  @ApiQuery({ name: 'to', required: false, type: String })
  @ApiQuery({ name: 'bank_account_id', required: false, type: Number })
  @ApiQuery({ name: 'search', required: false, type: String })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<PaymentVoucherDto>> {
    return this.service.list(query, currentUser);
  }

  @Post()
  @RequirePermission('accounting.payments_write')
  @UseIdempotency()
  @HttpCode(201)
  @ApiOperation({ operationId: 'createPaymentVoucher', summary: 'Create a draft payment voucher' })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Replay-safe key for payment voucher creates',
  })
  async create(
    @Body(new ZodValidationPipe(paymentVoucherCreateSchema)) dto: PaymentVoucherCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaymentVoucherDto> {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('accounting.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getPaymentVoucher', summary: 'Get payment voucher by ID' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaymentVoucherDto> {
    return this.service.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('accounting.payments_write')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'updatePaymentVoucher', summary: 'Update a draft payment voucher' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(paymentVoucherUpdateSchema)) dto: PaymentVoucherUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaymentVoucherDto> {
    return this.service.update(id, dto, currentUser);
  }

  @Post(':id/post')
  @RequirePermission('accounting.payments_write')
  @HttpCode(200)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'postPaymentVoucher', summary: 'Post a payment voucher to GL' })
  async post(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaymentVoucherDto> {
    return this.service.post(id, currentUser);
  }
}
