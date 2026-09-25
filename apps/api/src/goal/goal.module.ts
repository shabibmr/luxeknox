import { Module, forwardRef } from '@nestjs/common';
import { PeopleModule } from '../people/people.module';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { SysModule } from '../sys/sys.module';
import { GoalMetricController } from './goal-metric.controller';
import { GoalMetricRepository } from './goal-metric.repository';
import { GoalMetricService } from './goal-metric.service';
import { GoalController } from './goal.controller';
import { GoalRepository } from './goal.repository';
import { GoalService } from './goal.service';
import { MeasurementController } from './measurement.controller';
import { MeasurementRepository } from './measurement.repository';
import { MeasurementService } from './measurement.service';
import { ProgressNoteController } from './progress-note.controller';
import { ProgressNoteRepository } from './progress-note.repository';
import { ProgressNoteService } from './progress-note.service';
import { ProgressPhotoController } from './progress-photo.controller';
import { ProgressPhotoRepository } from './progress-photo.repository';
import { ProgressPhotoService } from './progress-photo.service';

@Module({
  imports: [PlatformModule, RbacModule, forwardRef(() => PeopleModule), SysModule],
  controllers: [
    GoalMetricController,
    GoalController,
    MeasurementController,
    ProgressPhotoController,
    ProgressNoteController,
  ],
  providers: [
    GoalMetricRepository,
    GoalMetricService,
    GoalRepository,
    GoalService,
    MeasurementRepository,
    MeasurementService,
    ProgressPhotoRepository,
    ProgressPhotoService,
    ProgressNoteRepository,
    ProgressNoteService,
  ],
  exports: [
    GoalMetricRepository,
    GoalMetricService,
    GoalRepository,
    GoalService,
    MeasurementRepository,
    MeasurementService,
    ProgressPhotoRepository,
    ProgressPhotoService,
    ProgressNoteRepository,
    ProgressNoteService,
  ],
})
export class GoalModule {}
