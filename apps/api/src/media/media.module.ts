import { Module } from '@nestjs/common';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { MediaController } from './media.controller';
import { StorageService } from './storage.service';

@Module({
  imports: [PlatformModule, RbacModule],
  controllers: [MediaController],
  providers: [StorageService],
  exports: [StorageService],
})
export class MediaModule {}
