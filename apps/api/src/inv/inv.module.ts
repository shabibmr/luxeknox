import { Module } from '@nestjs/common';
import { AcctModule } from '../acct/acct.module';
import { PlatformModule } from '../platform/platform.module';
import { CounterSalesController } from './counter-sales.controller';
import { CounterSalesRepository } from './counter-sales.repository';
import { CounterSalesService } from './counter-sales.service';
import { InventoryItemsController } from './items.controller';
import { InventoryItemsRepository } from './items.repository';
import { InventoryItemsService } from './items.service';

@Module({
  imports: [PlatformModule, AcctModule],
  controllers: [InventoryItemsController, CounterSalesController],
  providers: [
    InventoryItemsRepository,
    InventoryItemsService,
    CounterSalesRepository,
    CounterSalesService,
  ],
  exports: [
    InventoryItemsRepository,
    InventoryItemsService,
    CounterSalesRepository,
    CounterSalesService,
  ],
})
export class InvModule {}
