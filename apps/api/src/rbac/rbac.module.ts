import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { PlatformModule } from '../platform/platform.module';
import { PermissionCache } from './permission-cache';
import { PermissionController } from './permission.controller';
import { PermissionGuard } from './permission.guard';
import { PermissionRepository } from './permission.repository';
import { PermissionService } from './permission.service';
import { RoleController } from './role.controller';
import { RoleRepository } from './role.repository';
import { RoleService } from './role.service';

@Module({
  imports: [PlatformModule],
  controllers: [RoleController, PermissionController],
  providers: [
    RoleRepository,
    PermissionRepository,
    PermissionCache,
    PermissionGuard,
    RoleService,
    PermissionService,
    {
      provide: APP_GUARD,
      useClass: PermissionGuard,
    },
  ],
  exports: [PermissionCache, PermissionGuard, RoleRepository, PermissionRepository],
})
export class RbacModule {}
