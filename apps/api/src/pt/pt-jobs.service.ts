import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { JobRunnerService } from '../job/job-runner.service';
import { PtSubscriptionService } from './pt-subscription.service';

export const PT_STATUS_TRANSITIONS_JOB = 'pt.status_transitions';

@Injectable()
export class PtJobsService implements OnModuleInit {
  private readonly logger = new Logger(PtJobsService.name);

  constructor(
    private readonly jobRunner: JobRunnerService,
    private readonly subscriptions: PtSubscriptionService,
  ) {}

  onModuleInit(): void {
    this.jobRunner.register(PT_STATUS_TRANSITIONS_JOB, () => this.subscriptions.runStatusTransitions());
  }

  /**
   * Hourly (not daily) because "today" is evaluated in the gym timezone, whose midnight
   * is not 00:00 UTC. The transitions are idempotent.
   */
  @Cron('15 * * * *')
  async cronStatusTransitions(): Promise<void> {
    await this.jobRunner.run(PT_STATUS_TRANSITIONS_JOB, async () => {
      const result = await this.subscriptions.runStatusTransitions();
      if (result.activated || result.completed) {
        this.logger.log(`PT transitions: ${result.activated} activated, ${result.completed} completed`);
      }
    });
  }
}
