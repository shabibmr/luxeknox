import { Module, forwardRef } from '@nestjs/common';
import { PeopleModule } from '../people/people.module';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { SysModule } from '../sys/sys.module';
import { DietLogController } from './diet-log.controller';
import { DietLogRepository } from './diet-log.repository';
import { DietLogService } from './diet-log.service';
import { DietPlanController } from './diet-plan.controller';
import { DietPlanRepository } from './diet-plan.repository';
import { DietPlanService } from './diet-plan.service';
import { FoodController } from './food.controller';
import { FoodRepository } from './food.repository';
import { FoodService } from './food.service';

@Module({
  imports: [PlatformModule, RbacModule, forwardRef(() => PeopleModule), SysModule],
  controllers: [FoodController, DietPlanController, DietLogController],
  providers: [
    FoodRepository,
    FoodService,
    DietPlanRepository,
    DietPlanService,
    DietLogRepository,
    DietLogService,
  ],
  exports: [
    FoodRepository,
    FoodService,
    DietPlanRepository,
    DietPlanService,
    DietLogRepository,
    DietLogService,
  ],
})
export class DietModule {}
