import { Module } from '@nestjs/common';
import { JobModule } from '../job/job.module';
import { MembModule } from '../memb/memb.module';
import { PayModule } from '../pay/pay.module';
import { PeopleModule } from '../people/people.module';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { SchedModule } from '../sched/sched.module';
import { SysModule } from '../sys/sys.module';
import { PtAccessModule } from './pt-access.module';
import { PtJobsService } from './pt-jobs.service';
import { PtProductController } from './pt-product.controller';
import { PtProductRepository } from './pt-product.repository';
import { PtProductService } from './pt-product.service';
import { PtScheduleService } from './pt-schedule.service';
import { PtSubscriptionController } from './pt-subscription.controller';
import { PtSubscriptionService } from './pt-subscription.service';

/** Personal Training packages, trainer assignment and fixed-slot scheduling. */
@Module({
  imports: [
    PlatformModule,
    RbacModule,
    SysModule,
    JobModule,
    PeopleModule,
    MembModule,
    SchedModule,
    PayModule,
    PtAccessModule,
  ],
  controllers: [PtProductController, PtSubscriptionController],
  providers: [PtProductRepository, PtProductService, PtScheduleService, PtSubscriptionService, PtJobsService],
  exports: [PtSubscriptionService],
})
export class PtModule {}
