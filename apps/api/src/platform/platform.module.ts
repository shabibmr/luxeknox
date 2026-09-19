import { Module } from '@nestjs/common';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { EventEmitterModule } from '@nestjs/event-emitter';
import { GlobalExceptionFilter } from './errors/exception.filter';
import { RequestIdInterceptor } from './http/request-id.interceptor';
import { AuditService } from './audit/audit.service';
import { DomainEventBus } from './events/domain-events';

import { PaginationHelper } from './http/pagination';
import { SysModule } from '../sys/sys.module';

@Module({
  imports: [EventEmitterModule.forRoot(), SysModule],
  controllers: [],
  providers: [
    {
      provide: APP_FILTER,
      useClass: GlobalExceptionFilter,
    },
    GlobalExceptionFilter,
    {
      provide: APP_INTERCEPTOR,
      useClass: RequestIdInterceptor,
    },
    RequestIdInterceptor,
    AuditService,
    DomainEventBus,
    PaginationHelper,
  ],
  exports: [
    GlobalExceptionFilter,
    RequestIdInterceptor,
    AuditService,
    DomainEventBus,
    PaginationHelper,
  ],
})
export class PlatformModule {}


