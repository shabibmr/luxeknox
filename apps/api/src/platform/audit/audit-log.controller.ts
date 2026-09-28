import { Controller, Get, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { RequirePermission } from '../../rbac/require-permission.decorator';
import { AuditLogService } from './audit-log.service';
import { auditLogFilterQuerySchema } from './audit-log.dto';

@ApiTags('SYS')
@ApiBearerAuth('bearer')
@Controller('audit-logs')
export class AuditLogController {
  constructor(private readonly service: AuditLogService) {}

  @Get()
  @RequirePermission('audit.read')
  @ApiOperation({ operationId: 'listAuditLogs', summary: 'Append-only admin audit (no update/delete)' })
  async list(@Query() rawQuery: Record<string, unknown>) {
    const filter = auditLogFilterQuerySchema.parse(rawQuery);
    return this.service.list(rawQuery, filter);
  }
}
