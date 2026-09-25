import { Module, forwardRef } from '@nestjs/common';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { SysModule } from '../sys/sys.module';
import { PeopleModule } from '../people/people.module';
import { SchedModule } from '../sched/sched.module';
import { MembModule } from '../memb/memb.module';
import { JobModule } from '../job/job.module';
import { NotificationRepository } from './notification.repository';
import { NotificationService } from './notification.service';
import {
  NotificationController,
  DeviceController,
} from './notification.controller';
import {
  LoggingPushDispatcherAdapter,
  PushDispatcherAdapter,
} from './push-dispatcher.adapter';
import { NotificationEventConsumer } from './notification-event.consumer';
import { NotificationJobsService } from './notification-jobs.service';

@Module({
  imports: [
    PlatformModule,
    RbacModule,
    SysModule,
    forwardRef(() => PeopleModule),
    forwardRef(() => SchedModule),
    forwardRef(() => MembModule),
    forwardRef(() => JobModule),
  ],
  controllers: [NotificationController, DeviceController],
  providers: [
    NotificationRepository,
    NotificationService,
    NotificationEventConsumer,
    NotificationJobsService,
    {
      provide: PushDispatcherAdapter,
      useClass: LoggingPushDispatcherAdapter,
    },
  ],
  exports: [
    NotificationRepository,
    NotificationService,
    PushDispatcherAdapter,
  ],
})
export class NotifModule {}
