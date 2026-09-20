import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { PermissionCache } from './permission-cache';
import { PermissionGuard } from './permission.guard';
import { RoleRepository } from './role.repository';
import { PermissionRepository } from './permission.repository';

@Module({
  providers: [
    RoleRepository,
    PermissionRepository,
    PermissionCache,
    PermissionGuard,
    {
      provide: APP_GUARD,
      useClass: PermissionGuard,
    },
  ],
  exports: [PermissionCache, PermissionGuard, RoleRepository, PermissionRepository],
})
export class RbacModule {}
