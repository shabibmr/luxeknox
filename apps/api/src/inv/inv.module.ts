import { Module } from '@nestjs/common';
import { PlatformModule } from '../platform/platform.module';
import { InventoryItemsController } from './items.controller';
import { InventoryItemsRepository } from './items.repository';
import { InventoryItemsService } from './items.service';

@Module({
  imports: [PlatformModule],
  controllers: [InventoryItemsController],
  providers: [InventoryItemsRepository, InventoryItemsService],
  exports: [InventoryItemsRepository, InventoryItemsService],
})
export class InvModule {}
