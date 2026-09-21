import { Module } from '@nestjs/common';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { PeopleModule } from '../people/people.module';
import { FreezeController } from './freeze.controller';
import { MembershipController } from './membership.controller';
import { MembershipProductController } from './membership-product.controller';
import { MembershipProductRepository } from './membership-product.repository';
import { MembershipProductService } from './membership-product.service';
import { MembershipRepository } from './membership.repository';
import { MembershipService } from './membership.service';

@Module({
  imports: [PlatformModule, RbacModule, PeopleModule],
  controllers: [MembershipProductController, MembershipController, FreezeController],
  providers: [
    MembershipProductRepository,
    MembershipProductService,
    MembershipRepository,
    MembershipService,
  ],
  exports: [MembershipRepository],
})
export class MembModule {}
