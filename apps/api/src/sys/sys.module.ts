import { Module } from '@nestjs/common';
import { SettingsRepository } from './settings.repository';
import { SettingsService } from './settings.service';
import { SettingsController } from './settings.controller';
import { AuditService } from '../platform/audit/audit.service';

@Module({
  imports: [],
  controllers: [SettingsController],
  providers: [SettingsRepository, SettingsService, AuditService],
  exports: [SettingsRepository, SettingsService],
})
export class SysModule {}
