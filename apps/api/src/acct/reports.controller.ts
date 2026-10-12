import { Controller, Get, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiQuery, ApiTags } from '@nestjs/swagger';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  balanceSheetQuerySchema,
  dayBookQuerySchema,
  gstSummaryQuerySchema,
  openItemsQuerySchema,
  profitAndLossQuerySchema,
  trialBalanceQuerySchema,
  type BalanceSheetQueryDto,
  type BalanceSheetReportDto,
  type DayBookQueryDto,
  type DayBookReportDto,
  type GstSummaryQueryDto,
  type GstSummaryReportDto,
  type OpenItemsQueryDto,
  type OpenItemsReportDto,
  type ProfitAndLossQueryDto,
  type ProfitAndLossReportDto,
  type TrialBalanceQueryDto,
  type TrialBalanceReportDto,
} from './reports.dto';
import { ReportsService } from './reports.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting/reports')
export class ReportsController {
  constructor(private readonly service: ReportsService) {}

  @Get('trial-balance')
  @RequirePermission('accounting.read')
  @ApiOperation({
    operationId: 'getTrialBalance',
    summary: 'Trial balance for a date range',
  })
  @ApiQuery({ name: 'from', required: false, type: String })
  @ApiQuery({ name: 'to', required: true, type: String })
  async getTrialBalance(
    @Query(new ZodValidationPipe(trialBalanceQuerySchema)) query: TrialBalanceQueryDto,
    @CurrentUser() _currentUser: AuthenticatedUser,
  ): Promise<TrialBalanceReportDto> {
    return this.service.getTrialBalance(query);
  }

  @Get('profit-and-loss')
  @RequirePermission('accounting.read')
  @ApiOperation({
    operationId: 'getProfitAndLoss',
    summary: 'Profit and loss for a date range',
  })
  @ApiQuery({ name: 'from', required: true, type: String })
  @ApiQuery({ name: 'to', required: true, type: String })
  async getProfitAndLoss(
    @Query(new ZodValidationPipe(profitAndLossQuerySchema)) query: ProfitAndLossQueryDto,
    @CurrentUser() _currentUser: AuthenticatedUser,
  ): Promise<ProfitAndLossReportDto> {
    return this.service.getProfitAndLoss(query);
  }

  @Get('balance-sheet')
  @RequirePermission('accounting.read')
  @ApiOperation({
    operationId: 'getBalanceSheet',
    summary: 'Balance sheet as of a date',
  })
  @ApiQuery({ name: 'as_of', required: true, type: String })
  async getBalanceSheet(
    @Query(new ZodValidationPipe(balanceSheetQuerySchema)) query: BalanceSheetQueryDto,
    @CurrentUser() _currentUser: AuthenticatedUser,
  ): Promise<BalanceSheetReportDto> {
    return this.service.getBalanceSheet(query);
  }

  @Get('day-book')
  @RequirePermission('accounting.read')
  @ApiOperation({
    operationId: 'getDayBook',
    summary: 'Day book for one date',
  })
  @ApiQuery({ name: 'date', required: true, type: String })
  async getDayBook(
    @Query(new ZodValidationPipe(dayBookQuerySchema)) query: DayBookQueryDto,
    @CurrentUser() _currentUser: AuthenticatedUser,
  ): Promise<DayBookReportDto> {
    return this.service.getDayBook(query);
  }

  @Get('open-items')
  @RequirePermission('accounting.read')
  @ApiOperation({
    operationId: 'getOpenItems',
    summary: 'Open AR or AP items',
  })
  @ApiQuery({ name: 'kind', required: true, enum: ['ar', 'ap'] })
  async getOpenItems(
    @Query(new ZodValidationPipe(openItemsQuerySchema)) query: OpenItemsQueryDto,
    @CurrentUser() _currentUser: AuthenticatedUser,
  ): Promise<OpenItemsReportDto> {
    return this.service.getOpenItems(query);
  }

  @Get('gst-summary')
  @RequirePermission('accounting.read')
  @ApiOperation({
    operationId: 'getGstSummary',
    summary: 'GST summary for a date range',
  })
  @ApiQuery({ name: 'from', required: true, type: String })
  @ApiQuery({ name: 'to', required: true, type: String })
  async getGstSummary(
    @Query(new ZodValidationPipe(gstSummaryQuerySchema)) query: GstSummaryQueryDto,
    @CurrentUser() _currentUser: AuthenticatedUser,
  ): Promise<GstSummaryReportDto> {
    return this.service.getGstSummary(query);
  }
}
