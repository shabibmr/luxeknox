import { Module, forwardRef } from '@nestjs/common';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { PeopleModule } from '../people/people.module';
import { SysModule } from '../sys/sys.module';
import { BookingController } from './booking.controller';
import { BookingService } from './booking.service';
import { FacilityController } from './facility.controller';
import { FacilityRepository } from './facility.repository';
import { FacilityService } from './facility.service';
import { ScheduleController } from './schedule.controller';
import { ScheduleRepository } from './schedule.repository';
import { ScheduleService } from './schedule.service';
import { ScheduleTypeController } from './schedule-type.controller';
import { ScheduleTypeRepository } from './schedule-type.repository';
import { ScheduleTypeService } from './schedule-type.service';
import { SlotCalculationService } from './slot-calculation.service';
import { TrainerAvailabilityController } from './trainer-availability.controller';
import { TrainerAvailabilityRepository } from './trainer-availability.repository';
import { TrainerAvailabilityService } from './trainer-availability.service';

@Module({
  imports: [PlatformModule, RbacModule, SysModule, forwardRef(() => PeopleModule)],
  controllers: [
    ScheduleTypeController,
    FacilityController,
    TrainerAvailabilityController,
    ScheduleController,
    BookingController,
  ],
  providers: [
    ScheduleTypeRepository,
    ScheduleTypeService,
    FacilityRepository,
    FacilityService,
    TrainerAvailabilityRepository,
    TrainerAvailabilityService,
    ScheduleRepository,
    ScheduleService,
    SlotCalculationService,
    BookingService,
  ],
  exports: [ScheduleRepository, ScheduleService, SlotCalculationService, BookingService],
})
export class SchedModule {}
