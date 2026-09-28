import { Injectable, Logger } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { PermissionCache } from '../rbac/permission-cache';
import { PersonFactory } from '../people/person.factory';
import { SettingsService } from '../sys/settings.service';
import { JobRunnerService } from '../job/job-runner.service';
import { ForbiddenError } from '../platform/errors/app-error';
import { ReportsRepository } from './reports.repository';
import { resolveReportDateRange } from './reports.timezone';
import { formatToCsv } from './reports.csv';
import type { ReportQueryDto, ReportResponseDto, ReportType } from './reports.dto';

@Injectable()
export class ReportsService {
  private readonly logger = new Logger(ReportsService.name);

  constructor(
    private readonly reportsRepository: ReportsRepository,
    private readonly settingsService: SettingsService,
    private readonly permissionCache: PermissionCache,
    private readonly personFactory: PersonFactory,
    private readonly jobRunner: JobRunnerService,
  ) {}

  /**
   * Generates a report with date boundary timezone conversion and role/scope authorization.
   */
  async generateReport(
    currentUser: AuthenticatedUser,
    type: ReportType,
    query: ReportQueryDto,
  ): Promise<ReportResponseDto> {
    const [canRead, canReadOwn, canExport] = await Promise.all([
      this.permissionCache.hasPermission(currentUser.roleId, 'reports.read'),
      this.permissionCache.hasPermission(currentUser.roleId, 'reports.read_own'),
      this.permissionCache.hasPermission(currentUser.roleId, 'reports.export'),
    ]);

    if (!canRead && !canReadOwn) {
      throw new ForbiddenError('Permission reports.read or reports.read_own required');
    }

    if (query.format === 'csv' && !canExport) {
      throw new ForbiddenError('Permission reports.export required to export reports');
    }

    // RPT-010: If caller does not have gym-wide reports.read, they are restricted to trainer own slice
    if (!canRead) {
      if (type !== 'trainer_own' && type !== 'trainers') {
        throw new ForbiddenError('reports.read required for gym-wide reports');
      }
    }

    // Resolve trainer profile ID for trainer_own or restricted trainers
    let effectiveTrainerId = query.trainer_id;
    if (type === 'trainer_own' || (!canRead && type === 'trainers')) {
      const profileId =
        currentUser.profileId ??
        (await this.personFactory.resolveProfileId(currentUser.id, currentUser.userType));

      if (currentUser.userType === 'trainer') {
        if (!profileId) {
          throw new ForbiddenError('Trainer profile not found for user');
        }
        effectiveTrainerId = profileId;
      }
    }

    // RPT-011: Apply gym timezone date boundaries
    const tz = await this.settingsService.getTimezone();
    const { from, to, startUtc, endUtc } = resolveReportDateRange(query.from, query.to, tz);

    let rows: Array<Record<string, any>> = [];

    switch (type) {
      case 'members':
        rows = await this.reportsRepository.getMembersReport(startUtc, endUtc);
        break;
      case 'memberships':
        rows = await this.reportsRepository.getMembershipsReport(
          startUtc,
          endUtc,
          query.product_id,
        );
        break;
      case 'attendance':
        rows = await this.reportsRepository.getAttendanceReport(startUtc, endUtc);
        break;
      case 'payments':
        rows = await this.reportsRepository.getPaymentsReport(startUtc, endUtc);
        break;
      case 'trainers':
        rows = await this.reportsRepository.getTrainersReport(
          startUtc,
          endUtc,
          effectiveTrainerId,
        );
        break;
      case 'trainer_own': {
        const rawRows = await this.reportsRepository.getTrainersReport(
          startUtc,
          endUtc,
          effectiveTrainerId,
        );
        // FR-RPT-009 / RPT-010: strip revenue from trainer own slice if not permitted
        rows = rawRows.map((r) => {
          const { revenue, ...rest } = r;
          return canRead ? r : rest;
        });
        break;
      }
      case 'workouts':
        rows = await this.reportsRepository.getWorkoutsReport(startUtc, endUtc);
        break;
      case 'diets':
        rows = await this.reportsRepository.getDietsReport(startUtc, endUtc);
        break;
      case 'progress':
        rows = await this.reportsRepository.getProgressReport(startUtc, endUtc);
        break;
      default:
        rows = [];
    }

    return {
      type,
      from,
      to,
      rows,
    };
  }

  /**
   * RPT-012: Export report as formatted CSV with '|' separator.
   */
  async exportReportCsv(
    currentUser: AuthenticatedUser,
    type: ReportType,
    query: ReportQueryDto,
  ): Promise<string> {
    const report = await this.generateReport(currentUser, type, { ...query, format: 'csv' });
    return formatToCsv(report.rows);
  }

  /**
   * RPT-013: Queue an asynchronous background export job via JobRunnerService (FND-017 / FND-018).
   */
  async queueAsyncReportExport(
    currentUser: AuthenticatedUser,
    type: ReportType,
    query: ReportQueryDto,
  ): Promise<{ status: string; jobName: string }> {
    const jobName = `report_export_${type}_${Date.now()}`;
    await this.jobRunner.run(jobName, async () => {
      this.logger.log(`Running background report export for ${type} (requested by user ${currentUser.id})`);
      const csv = await this.exportReportCsv(currentUser, type, query);
      this.logger.log(`Background report export for ${type} generated ${csv.length} bytes`);
    });

    return {
      status: 'completed',
      jobName,
    };
  }
}
