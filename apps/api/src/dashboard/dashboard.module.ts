import { Module } from '@nestjs/common';
import { RbacModule } from '../rbac/rbac.module';
import { PeopleModule } from '../people/people.module';
import { MembModule } from '../memb/memb.module';
import { AttnModule } from '../attn/attn.module';
import { PayModule } from '../pay/pay.module';
import { DashboardController } from './dashboard.controller';
import { DashboardService } from './dashboard.service';
import { DashboardCache } from './dashboard-cache';

@Module({
  imports: [RbacModule, PeopleModule, MembModule, AttnModule, PayModule],
  controllers: [DashboardController],
  providers: [DashboardService, DashboardCache],
})
export class DashboardModule {}
