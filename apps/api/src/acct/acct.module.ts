import { Module } from '@nestjs/common';
import { PlatformModule } from '../platform/platform.module';
import { AccountingPostingService } from './accounting-posting.service';
import { AccountingRepository } from './accounting.repository';
import { AccountsController } from './accounts.controller';
import { AccountsRepository } from './accounts.repository';
import { AccountsService } from './accounts.service';
import { ItemsController } from './items.controller';
import { ItemsRepository } from './items.repository';
import { ItemsService } from './items.service';
import { JournalController } from './journal.controller';
import { JournalService } from './journal.service';
import { PeriodsController } from './periods.controller';
import { PeriodsRepository } from './periods.repository';
import { PeriodsService } from './periods.service';
import { TaxCodesController } from './tax-codes.controller';
import { TaxCodesRepository } from './tax-codes.repository';
import { TaxCodesService } from './tax-codes.service';
import { VendorsController } from './vendors.controller';
import { VendorsRepository } from './vendors.repository';
import { VendorsService } from './vendors.service';

@Module({
  imports: [PlatformModule],
  controllers: [
    JournalController,
    AccountsController,
    TaxCodesController,
    VendorsController,
    ItemsController,
    PeriodsController,
  ],
  providers: [
    AccountingRepository,
    AccountingPostingService,
    JournalService,
    AccountsRepository,
    AccountsService,
    TaxCodesRepository,
    TaxCodesService,
    VendorsRepository,
    VendorsService,
    ItemsRepository,
    ItemsService,
    PeriodsRepository,
    PeriodsService,
  ],
  exports: [
    AccountingPostingService,
    AccountingRepository,
    AccountsRepository,
    AccountsService,
    TaxCodesRepository,
    TaxCodesService,
    VendorsRepository,
    VendorsService,
    ItemsRepository,
    ItemsService,
    PeriodsRepository,
    PeriodsService,
  ],
})
export class AcctModule {}
