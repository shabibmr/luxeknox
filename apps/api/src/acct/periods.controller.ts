import {
  Controller,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiParam,
  ApiQuery,
  ApiTags,
} from '@nestjs/swagger';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  periodFilterQuerySchema,
  type AccountingPeriodDto,
  type FiscalYearDto,
  type PeriodFilterQueryDto,
} from './periods.dto';
import { PeriodsService } from './periods.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting')
export class PeriodsController {
  constructor(private readonly service: PeriodsService) {}

  @Get('fiscal-years')
  @RequirePermission('accounting.read')
  @ApiOperation({
    operationId: 'listFiscalYears',
    summary: 'List all fiscal years',
  })
  async listFiscalYears(
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<FiscalYearDto[]> {
    return this.service.listFiscalYears(currentUser);
  }

  @Get('periods')
  @RequirePermission('accounting.read')
  @ApiOperation({
    operationId: 'listAccountingPeriods',
    summary: 'List accounting periods',
  })
  @ApiQuery({ name: 'fiscal_year_id', required: false, type: Number })
  @ApiQuery({ name: 'status', required: false, enum: ['open', 'locked'] })
  async listPeriods(
    @Query(new ZodValidationPipe(periodFilterQuerySchema)) query: PeriodFilterQueryDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<AccountingPeriodDto[]> {
    return this.service.listPeriods(query, currentUser);
  }

  @Post('periods/:id/lock')
  @RequirePermission('accounting.periods_close')
  @HttpCode(200)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({
    operationId: 'lockAccountingPeriod',
    summary: 'Lock an accounting period',
  })
  async lock(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<AccountingPeriodDto> {
    return this.service.lock(id, currentUser);
  }

  @Post('periods/:id/unlock')
  @RequirePermission('accounting.periods_close')
  @HttpCode(200)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({
    operationId: 'unlockAccountingPeriod',
    summary: 'Unlock an accounting period',
  })
  async unlock(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<AccountingPeriodDto> {
    return this.service.unlock(id, currentUser);
  }
}
