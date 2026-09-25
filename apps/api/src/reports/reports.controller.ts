import { Controller, Get, Param, Query, Res } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import type { Response } from 'express';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { ReportsService } from './reports.service';
import {
  reportQuerySchema,
  reportTypeParamSchema,
  type ReportQueryDto,
  type ReportResponseDto,
  type ReportTypeParamDto,
} from './reports.dto';
import { formatToCsv } from './reports.csv';

@ApiTags('RPT')
@ApiBearerAuth('bearer')
@Controller('reports')
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  @Get(':type')
  @ApiOperation({
    operationId: 'getReport',
    summary: 'Analytics report',
    description:
      'Generates operational and business analytics reports. Supports json and csv format. ' +
      'Requires reports.read (gym-wide) or reports.read_own (own trainer slice), and reports.export for CSV format.',
  })
  @ApiResponse({ status: 200, description: 'OK' })
  async getReport(
    @Param(new ZodValidationPipe(reportTypeParamSchema)) { type }: ReportTypeParamDto,
    @Query(new ZodValidationPipe(reportQuerySchema)) query: ReportQueryDto,
    @CurrentUser() currentUser: AuthenticatedUser,
    @Res({ passthrough: true }) res: Response,
  ): Promise<ReportResponseDto | string> {
    const report = await this.reportsService.generateReport(currentUser, type, query);

    if (query.format === 'csv') {
      res.setHeader('Content-Type', 'text/csv; charset=utf-8');
      res.setHeader(
        'Content-Disposition',
        `attachment; filename="report-${type}-${report.from}-${report.to}.csv"`,
      );
      return formatToCsv(report.rows);
    }

    return report;
  }
}
