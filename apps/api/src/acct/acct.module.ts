import { Module } from '@nestjs/common';
import { PlatformModule } from '../platform/platform.module';
import { AccountingPostingService } from './accounting-posting.service';
import { AccountingRepository } from './accounting.repository';

@Module({
  imports: [PlatformModule],
  providers: [AccountingRepository, AccountingPostingService],
  exports: [AccountingPostingService, AccountingRepository],
})
export class AcctModule {}
