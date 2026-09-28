import { Module } from '@nestjs/common';
import { SysModule } from '../sys/sys.module';
import { RbacModule } from '../rbac/rbac.module';
import { PeopleModule } from '../people/people.module';
import { JobModule } from '../job/job.module';
import { ReportsRepository } from './reports.repository';
import { ReportsService } from './reports.service';
import { ReportsController } from './reports.controller';

@Module({
  imports: [SysModule, RbacModule, PeopleModule, JobModule],
  controllers: [ReportsController],
  providers: [ReportsRepository, ReportsService],
  exports: [ReportsService, ReportsRepository],
})
export class ReportsModule {}
