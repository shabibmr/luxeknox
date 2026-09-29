import { Module } from '@nestjs/common';
import { PtAccessService } from './pt-access.service';
import { PtSubscriptionRepository } from './pt-subscription.repository';

/**
 * Leaf module (DB only) so goal/work/diet modules can check trainer write access
 * without importing the full PT module and its payment/scheduling dependencies.
 */
@Module({
  providers: [PtSubscriptionRepository, PtAccessService],
  exports: [PtSubscriptionRepository, PtAccessService],
})
export class PtAccessModule {}
