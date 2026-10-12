import { Module } from '@nestjs/common';
import { PlatformModule } from '../platform/platform.module';
import { AccountingPostingService } from './accounting-posting.service';
import { AccountingRepository } from './accounting.repository';
import { JournalController } from './journal.controller';
import { JournalService } from './journal.service';

@Module({
  imports: [PlatformModule],
  controllers: [JournalController],
  providers: [AccountingRepository, AccountingPostingService, JournalService],
  exports: [AccountingPostingService, AccountingRepository],
})
export class AcctModule {}
