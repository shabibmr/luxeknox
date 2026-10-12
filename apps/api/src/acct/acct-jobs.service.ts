import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { JobRunnerService } from '../job/job-runner.service';
import { REVENUE_RECOGNITION_JOB, RevenueRecognitionService } from './revenue-recognition.service';

@Injectable()
export class AcctJobsService implements OnModuleInit {
  private readonly logger = new Logger(AcctJobsService.name);

  constructor(
    private readonly jobRunner: JobRunnerService,
    private readonly revenueRecognitionService: RevenueRecognitionService,
  ) {}

  onModuleInit(): void {
    this.jobRunner.register(REVENUE_RECOGNITION_JOB, () =>
      this.revenueRecognitionService.runMonthlyRecognition(),
    );
  }

  /**
   * Monthly cron to run revenue recognition on the 1st of every month at midnight UTC.
   */
  @Cron('0 0 1 * *')
  async cronRecognizeRevenue(): Promise<void> {
    await this.jobRunner.run(REVENUE_RECOGNITION_JOB, async () => {
      const result = await this.revenueRecognitionService.runMonthlyRecognition();
      if (result && result.recognizedCount > 0) {
        this.logger.log(
          `Revenue recognition for period ${result.periodId}: ${result.recognizedCount} schedules, total ${result.totalRecognized}`,
        );
      }
    });
  }
}
