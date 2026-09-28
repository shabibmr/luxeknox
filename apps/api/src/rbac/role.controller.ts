import { Body, Controller, Get, HttpCode, Param, ParseIntPipe, Patch, Post, Put, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { RequirePermission } from './require-permission.decorator';
import {
  rolePermissionsWriteSchema,
  roleWriteSchema,
  type RolePermissionsWriteDto,
  type RoleWriteDto,
} from './role.dto';
import { RoleService } from './role.service';

@ApiTags('RBAC')
@ApiBearerAuth('bearer')
@Controller('roles')
export class RoleController {
  constructor(private readonly service: RoleService) {}

  @Get()
  @RequirePermission('roles.read')
  @ApiOperation({ operationId: 'listRoles', summary: 'List roles' })
  async list(@Query() rawQuery: Record<string, unknown>) {
    return this.service.list(rawQuery);
  }

  @Post()
  @HttpCode(201)
  @RequirePermission('roles.create')
  @ApiOperation({ operationId: 'createRole', summary: 'Create a custom role' })
  async create(
    @Body(new ZodValidationPipe(roleWriteSchema)) dto: RoleWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('roles.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getRole', summary: 'Get a role and its permissions' })
  async getById(@Param('id', ParseIntPipe) id: number) {
    return this.service.getById(id);
  }

  @Patch(':id')
  @RequirePermission('roles.update')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'updateRole', summary: 'Update a non-system role' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(roleWriteSchema)) dto: RoleWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.update(id, dto, currentUser);
  }

  @Put(':id/permissions')
  @RequirePermission('roles.update')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({
    operationId: 'replaceRolePermissions',
    summary: 'Replace permission set on a non-system role',
  })
  async replacePermissions(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(rolePermissionsWriteSchema)) dto: RolePermissionsWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.replacePermissions(id, dto, currentUser);
  }
}
