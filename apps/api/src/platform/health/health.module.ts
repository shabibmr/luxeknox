import { Module } from '@nestjs/common';
import { JobModule } from '../../job/job.module';
import { HealthController } from './health.controller';

@Module({
  imports: [JobModule],
  controllers: [HealthController],
})
export class HealthModule {}
