import { Module } from '@nestjs/common';
import { RbacModule } from '../rbac/rbac.module';
import { PeopleModule } from '../people/people.module';
import { MembModule } from '../memb/memb.module';
import { DashboardController } from './dashboard.controller';
import { DashboardService } from './dashboard.service';
import { DashboardCache } from './dashboard-cache';

@Module({
  imports: [RbacModule, PeopleModule, MembModule],
  controllers: [DashboardController],
  providers: [DashboardService, DashboardCache],
})
export class DashboardModule {}
