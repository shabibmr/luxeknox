import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { PermissionCache } from './permission-cache';
import { PermissionGuard } from './permission.guard';

@Module({
  providers: [
    PermissionCache,
    PermissionGuard,
    {
      provide: APP_GUARD,
      useClass: PermissionGuard,
    },
  ],
  exports: [PermissionCache, PermissionGuard],
})
export class RbacModule {}
