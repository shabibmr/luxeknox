import { Module, forwardRef } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { AuthModule } from '../auth/auth.module';
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
import { FcmPushDispatcherAdapter } from './fcm-push-dispatcher.adapter';
import { NotificationEventConsumer } from './notification-event.consumer';
import { NotificationJobsService } from './notification-jobs.service';

@Module({
  imports: [
    ConfigModule,
    PlatformModule,
    RbacModule,
    forwardRef(() => AuthModule),
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
      useFactory: (config: ConfigService) => {
        const email = config.get<string>('FIREBASE_CLIENT_EMAIL');
        const key = config.get<string>('FIREBASE_PRIVATE_KEY');
        if (!email || !key) {
          return new LoggingPushDispatcherAdapter();
        }
        return new FcmPushDispatcherAdapter({
          projectId:
            config.get<string>('FIREBASE_PROJECT_ID') ?? 'luxe-knox-app',
          clientEmail: email,
          privateKey: key.replace(/\\n/g, '\n'),
        });
      },
      inject: [ConfigService],
    },
  ],
  exports: [
    NotificationRepository,
    NotificationService,
    PushDispatcherAdapter,
  ],
})
export class NotifModule {}
