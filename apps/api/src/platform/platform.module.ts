import { Module } from '@nestjs/common';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { EventEmitterModule } from '@nestjs/event-emitter';
import { GlobalExceptionFilter } from './errors/exception.filter';
import { RequestIdInterceptor } from './http/request-id.interceptor';
import { AuditService } from './audit/audit.service';
import { AuditLogController } from './audit/audit-log.controller';
import { AuditLogRepository } from './audit/audit-log.repository';
import { AuditLogService } from './audit/audit-log.service';
import { DomainEventBus } from './events/domain-events';

import { PaginationHelper } from './http/pagination';
import { SysModule } from '../sys/sys.module';
import { IdempotencyRepository } from './idempotency/idempotency.repository';
import { IdempotencyInterceptor } from './idempotency/idempotency.interceptor';

@Module({
  imports: [EventEmitterModule.forRoot(), SysModule],
  controllers: [AuditLogController],
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
    {
      provide: APP_INTERCEPTOR,
      useClass: IdempotencyInterceptor,
    },
    IdempotencyInterceptor,
    IdempotencyRepository,
    AuditService,
    AuditLogRepository,
    AuditLogService,
    DomainEventBus,
    PaginationHelper,
  ],
  exports: [
    GlobalExceptionFilter,
    RequestIdInterceptor,
    IdempotencyInterceptor,
    IdempotencyRepository,
    AuditService,
    AuditLogRepository,
    AuditLogService,
    DomainEventBus,
    PaginationHelper,
  ],
})
export class PlatformModule {}


