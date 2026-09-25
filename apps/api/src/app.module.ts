import { Module } from '@nestjs/common';
import { PlatformModule } from './platform/platform.module';
import { HealthModule } from './platform/health/health.module';
import { DrizzleModule } from './platform/db/drizzle.module';
import { SysModule } from './sys/sys.module';
import { AuthModule } from './auth/auth.module';
import { RbacModule } from './rbac/rbac.module';
import { WorkModule } from './work/work.module';
import { DietModule } from './diet/diet.module';
import { PeopleModule } from './people/people.module';
import { MediaModule } from './media/media.module';
import { MembModule } from './memb/memb.module';
import { DashboardModule } from './dashboard/dashboard.module';
import { SchedModule } from './sched/sched.module';
import { AttnModule } from './attn/attn.module';
import { ReportsModule } from './reports/reports.module';
import { GoalModule } from './goal/goal.module';
import { NotifModule } from './notif/notif.module';

@Module({
  imports: [
    DrizzleModule.forRoot(),
    PlatformModule,
    HealthModule,
    SysModule,
    AuthModule,
    RbacModule,
    WorkModule,
    DietModule,
    PeopleModule,
    MediaModule,
    MembModule,
    SchedModule,
    AttnModule,
    GoalModule,
    NotifModule,
    DashboardModule,
    ReportsModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}


