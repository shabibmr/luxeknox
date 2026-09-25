import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { JobRunnerService } from '../job/job-runner.service';
import { AttendanceService } from './attendance.service';

export const ATTENDANCE_ROLLUP_JOB = 'attendance.daily_rollup';
export const ATTENDANCE_AUTO_CHECKOUT_JOB = 'attendance.auto_checkout';

/**
 * ATT-013 / ATT-014 scheduled jobs. Each tick is persisted via JobRunnerService
 * (`job_runs`) so `/ready` metrics and manual rerun stay consistent with FND-018.
 */
@Injectable()
export class AttendanceJobsService implements OnModuleInit {
  private readonly logger = new Logger(AttendanceJobsService.name);

  constructor(
    private readonly attendanceService: AttendanceService,
    private readonly jobRunner: JobRunnerService,
  ) {}

  onModuleInit(): void {
    this.jobRunner.register(ATTENDANCE_ROLLUP_JOB, () => this.runRollup());
    this.jobRunner.register(ATTENDANCE_AUTO_CHECKOUT_JOB, () => this.runAutoCheckout());
  }

  /** 00:15 UTC — roll up yesterday's gate traffic. */
  @Cron('15 0 * * *')
  async cronRollup(): Promise<void> {
    await this.jobRunner.run(ATTENDANCE_ROLLUP_JOB, () => this.runRollup());
  }

  /** Every 15 minutes — close stale open visits. */
  @Cron('*/15 * * * *')
  async cronAutoCheckout(): Promise<void> {
    await this.jobRunner.run(ATTENDANCE_AUTO_CHECKOUT_JOB, () => this.runAutoCheckout());
  }

  private async runRollup(): Promise<void> {
    const history = await this.attendanceService.rollupDay();
    this.logger.log(
      `Rolled up ${history.date}: members=${history.total_member_checkins} trainers=${history.total_trainer_checkins}`,
    );
  }

  private async runAutoCheckout(): Promise<void> {
    const closed = await this.attendanceService.autoCheckoutStale();
    if (closed > 0) {
      this.logger.log(`Auto-checked out ${closed} stale open attendance(s)`);
    }
  }
}
