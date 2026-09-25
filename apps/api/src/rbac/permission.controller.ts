import { Controller, Get, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { PermissionService } from './permission.service';
import { RequirePermission } from './require-permission.decorator';

@ApiTags('RBAC')
@ApiBearerAuth('bearer')
@Controller('permissions')
export class PermissionController {
  constructor(private readonly service: PermissionService) {}

  @Get()
  @RequirePermission('roles.read')
  @ApiOperation({ operationId: 'listPermissions', summary: 'List permission catalog' })
  async list(@Query() rawQuery: Record<string, unknown>) {
    return this.service.list(rawQuery);
  }
}
