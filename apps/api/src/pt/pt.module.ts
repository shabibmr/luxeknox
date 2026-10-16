import { Module } from '@nestjs/common';
import { GoalModule } from '../goal/goal.module';
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
import { PtProgressReviewController } from './pt-progress-review.controller';
import { PtProgressReviewPdfService } from './pt-progress-review-pdf.service';
import { PtProgressReviewRepository } from './pt-progress-review.repository';
import { PtProgressReviewService } from './pt-progress-review.service';
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
    GoalModule,
  ],
  controllers: [PtProductController, PtSubscriptionController, PtProgressReviewController],
  providers: [PtProductRepository, PtProductService, PtScheduleService, PtSubscriptionService,
    PtJobsService,
    PtProgressReviewRepository,
    PtProgressReviewService,
    PtProgressReviewPdfService,
  ],
  exports: [PtSubscriptionService, PtProgressReviewService],
})
export class PtModule {}
