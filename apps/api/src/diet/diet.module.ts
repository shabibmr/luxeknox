import { Module } from '@nestjs/common';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { FoodController } from './food.controller';
import { FoodRepository } from './food.repository';
import { FoodService } from './food.service';

@Module({
  imports: [PlatformModule, RbacModule],
  controllers: [FoodController],
  providers: [FoodRepository, FoodService],
  exports: [],
})
export class DietModule {}
