import { Module } from '@nestjs/common';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { ExerciseController } from './exercise.controller';
import { ExerciseRepository } from './exercise.repository';
import { ExerciseService } from './exercise.service';

@Module({
  imports: [PlatformModule, RbacModule],
  controllers: [ExerciseController],
  providers: [ExerciseRepository, ExerciseService],
  exports: [],
})
export class WorkModule {}
