import { Module, forwardRef } from '@nestjs/common';
import { AcctModule } from '../acct/acct.module';
import { PlatformModule } from '../platform/platform.module';
import { InventoryCatalogController } from './catalog.controller';
import { InventoryCatalogRepository } from './catalog.repository';
import { InventoryCatalogService } from './catalog.service';
import { CounterSalesController } from './counter-sales.controller';
import { CounterSalesRepository } from './counter-sales.repository';
import { CounterSalesService } from './counter-sales.service';
import { InventoryItemsController } from './items.controller';
import { InventoryItemsRepository } from './items.repository';
import { InventoryItemsService } from './items.service';
import { StockRepository } from './stock.repository';
import { StockService } from './stock.service';

@Module({
  imports: [PlatformModule, forwardRef(() => AcctModule)],
  controllers: [InventoryItemsController, InventoryCatalogController, CounterSalesController],
  providers: [
    InventoryCatalogRepository,
    InventoryCatalogService,
    InventoryItemsRepository,
    InventoryItemsService,
    CounterSalesRepository,
    CounterSalesService,
    StockRepository,
    StockService,
  ],
  exports: [
    InventoryItemsRepository,
    InventoryItemsService,
    CounterSalesRepository,
    CounterSalesService,
    StockRepository,
    StockService,
  ],
})
export class InvModule {}
