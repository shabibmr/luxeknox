import { Module, forwardRef } from '@nestjs/common';
import { PeopleModule } from '../people/people.module';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { ExerciseController } from './exercise.controller';
import { ExerciseRepository } from './exercise.repository';
import { ExerciseService } from './exercise.service';
import { WorkoutPlanController } from './workout-plan.controller';
import { WorkoutPlanRepository } from './workout-plan.repository';
import { WorkoutPlanService } from './workout-plan.service';
import { WorkoutSessionController } from './workout-session.controller';
import { WorkoutSessionRepository } from './workout-session.repository';
import { WorkoutSessionService } from './workout-session.service';

@Module({
  imports: [PlatformModule, RbacModule, forwardRef(() => PeopleModule)],
  controllers: [
    ExerciseController,
    WorkoutPlanController,
    WorkoutSessionController,
  ],
  providers: [
    ExerciseRepository,
    ExerciseService,
    WorkoutPlanRepository,
    WorkoutPlanService,
    WorkoutSessionRepository,
    WorkoutSessionService,
  ],
  exports: [
    ExerciseRepository,
    ExerciseService,
    WorkoutPlanRepository,
    WorkoutPlanService,
    WorkoutSessionRepository,
    WorkoutSessionService,
  ],
})
export class WorkModule {}
