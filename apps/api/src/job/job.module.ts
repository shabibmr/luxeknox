import { Module } from '@nestjs/common';
import { ScheduleModule } from '@nestjs/schedule';
import { JobRunRepository } from './job-run.repository';
import { JobRunnerService } from './job-runner.service';

@Module({
  imports: [ScheduleModule.forRoot()],
  providers: [JobRunRepository, JobRunnerService],
  exports: [JobRunnerService, JobRunRepository],
})
export class JobModule {}
