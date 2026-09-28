import { Body, Controller, Get, HttpCode, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import type { PaginatedResponse } from '../platform/http/pagination';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  paymentMethodWriteSchema,
  type PaymentMethodDto,
  type PaymentMethodWriteDto,
} from './payment.dto';
import { PaymentMethodService } from './payment-method.service';

@ApiTags('PAY')
@ApiBearerAuth('bearer')
@Controller('payment-methods')
export class PaymentMethodController {
  constructor(private readonly service: PaymentMethodService) {}

  @Get()
  @RequirePermission('payments.read')
  @ApiOperation({ operationId: 'listPaymentMethods', summary: 'Payment methods' })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<PaymentMethodDto>> {
    return this.service.list(query, currentUser);
  }

  @Post()
  @RequirePermission('payments.create')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createPaymentMethod', summary: 'Create a payment method' })
  async create(
    @Body(new ZodValidationPipe(paymentMethodWriteSchema)) dto: PaymentMethodWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaymentMethodDto> {
    return this.service.create(dto, currentUser);
  }
}
