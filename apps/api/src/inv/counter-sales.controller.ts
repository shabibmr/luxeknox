import { Body, Controller, HttpCode, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiHeader, ApiOperation, ApiTags } from '@nestjs/swagger';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { UseIdempotency } from '../platform/idempotency/idempotency.interceptor';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { saleWriteSchema, type CounterSaleDto, type SaleWrite } from './counter-sales.dto';
import { CounterSalesService } from './counter-sales.service';

@ApiTags('INV')
@ApiBearerAuth('bearer')
@Controller('inventory/sales')
export class CounterSalesController {
  constructor(private readonly service: CounterSalesService) {}

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
