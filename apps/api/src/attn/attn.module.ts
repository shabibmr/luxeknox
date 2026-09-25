import { Module, forwardRef } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { JobModule } from '../job/job.module';
import { MembModule } from '../memb/memb.module';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { SchedModule } from '../sched/sched.module';
import { SysModule } from '../sys/sys.module';
import { AttendanceController } from './attendance.controller';
import { AttendanceHistoryController } from './attendance-history.controller';
import { AttendanceJobsService } from './attendance-jobs.service';
import { AttendancePassController } from './attendance-pass.controller';
import { AttendancePassService } from './attendance-pass.service';
import { AttendanceRepository } from './attendance.repository';
import { AttendanceService } from './attendance.service';
import { CheckInAuthGuard } from './check-in-auth.guard';
import { DeviceCredentialService } from './device-credential.service';
import { HardwareIngestAdapter } from './hardware-ingest.adapter';
import { SessionAttendanceController } from './session-attendance.controller';
import { SessionAttendanceService } from './session-attendance.service';

@Module({
  imports: [
    PlatformModule,
    RbacModule,
    SysModule,
    MembModule,
    JobModule,
    SchedModule,
    forwardRef(() => AuthModule),
  ],
  controllers: [
    AttendancePassController,
    AttendanceController,
    AttendanceHistoryController,
    SessionAttendanceController,
  ],
  providers: [
    AttendancePassService,
    DeviceCredentialService,
    HardwareIngestAdapter,
    AttendanceRepository,
    AttendanceService,
    CheckInAuthGuard,
    AttendanceJobsService,
    SessionAttendanceService,
  ],
  exports: [
    AttendancePassService,
    DeviceCredentialService,
    AttendanceService,
    SessionAttendanceService,
  ],
})
export class AttnModule {}
