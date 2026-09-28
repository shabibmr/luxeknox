import { Module } from '@nestjs/common';
import { MembModule } from '../memb/memb.module';
import { PeopleModule } from '../people/people.module';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { SysModule } from '../sys/sys.module';
import { PaymentController } from './payment.controller';
import { PaymentMethodController } from './payment-method.controller';
import { PaymentMethodRepository } from './payment-method.repository';
import { PaymentMethodService } from './payment-method.service';
import { PaymentRepository } from './payment.repository';
import { PaymentService } from './payment.service';

@Module({
  imports: [PlatformModule, RbacModule, SysModule, PeopleModule, MembModule],
  controllers: [PaymentMethodController, PaymentController],
  providers: [
    PaymentMethodRepository,
    PaymentMethodService,
    PaymentRepository,
    PaymentService,
  ],
  exports: [PaymentService, PaymentMethodService, PaymentRepository],
})
export class PayModule {}
