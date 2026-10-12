import { Module } from '@nestjs/common';
import { PlatformModule } from '../platform/platform.module';
import { SysModule } from '../sys/sys.module';
import { AccountingPostingService } from './accounting-posting.service';
import { AccountingRepository } from './accounting.repository';
import { AccountsController } from './accounts.controller';
import { AccountsRepository } from './accounts.repository';
import { AccountsService } from './accounts.service';
import { CreditNotesRepository } from './credit-notes.repository';
import { DebitNotesController } from './debit-notes.controller';
import { DebitNotesRepository } from './debit-notes.repository';
import { DebitNotesService } from './debit-notes.service';
import { ExpensesController } from './expenses.controller';
import { ExpensesRepository } from './expenses.repository';
import { ExpensesService } from './expenses.service';
import { ItemsController } from './items.controller';
import { ItemsRepository } from './items.repository';
import { ItemsService } from './items.service';
import { JournalController } from './journal.controller';
import { JournalService } from './journal.service';
import { PaymentVouchersController } from './payment-vouchers.controller';
import { PaymentVouchersRepository } from './payment-vouchers.repository';
import { PaymentVouchersService } from './payment-vouchers.service';
import { PeriodsController } from './periods.controller';
import { PeriodsRepository } from './periods.repository';
import { PeriodsService } from './periods.service';
import { PurchaseBillsController } from './purchase-bills.controller';
import { PurchaseBillsRepository } from './purchase-bills.repository';
import { PurchaseBillsService } from './purchase-bills.service';
import { RevenueRecognitionPortService } from './revenue-recognition-port.service';
import { RevenueRecognitionRepository } from './revenue-recognition.repository';
import { SalesBridgeService } from './sales-bridge.service';
import { TaxCodesController } from './tax-codes.controller';
import { TaxCodesRepository } from './tax-codes.repository';
import { TaxCodesService } from './tax-codes.service';
import { VendorsController } from './vendors.controller';
import { VendorsRepository } from './vendors.repository';
import { VendorsService } from './vendors.service';

@Module({
  imports: [PlatformModule, SysModule],
  controllers: [
    JournalController,
    AccountsController,
    TaxCodesController,
    VendorsController,
    ItemsController,
    PeriodsController,
    PurchaseBillsController,
    ExpensesController,
    PaymentVouchersController,
    DebitNotesController,
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
    PurchaseBillsRepository,
    PurchaseBillsService,
    ExpensesRepository,
    ExpensesService,
    PaymentVouchersRepository,
    PaymentVouchersService,
    DebitNotesRepository,
    DebitNotesService,
    CreditNotesRepository,
    RevenueRecognitionRepository,
    SalesBridgeService,
    RevenueRecognitionPortService,
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
    PurchaseBillsRepository,
    PurchaseBillsService,
    ExpensesRepository,
    ExpensesService,
    PaymentVouchersRepository,
    PaymentVouchersService,
    DebitNotesRepository,
    DebitNotesService,
    CreditNotesRepository,
    RevenueRecognitionRepository,
    SalesBridgeService,
    RevenueRecognitionPortService,
  ],
})
export class AcctModule {}
