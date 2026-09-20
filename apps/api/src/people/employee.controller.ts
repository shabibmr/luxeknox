import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiParam,
  ApiProperty,
  ApiQuery,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  assignRoleSchema,
  employeeCreateSchema,
  employeeStatusSchema,
  employeeUpdateSchema,
  type AssignRoleDto,
  type EmployeeCreateDto,
  type EmployeeStatusDto,
  type EmployeeUpdateDto,
} from './employee.dto';
import { EmployeeService } from './employee.service';
import type { EmployeeWithRole } from './employee.repository';

export class EmployeeResponseDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: Number }) user_id!: number;
  @ApiProperty({ type: String }) first_name!: string;
  @ApiProperty({ type: String }) last_name!: string;
  @ApiProperty({ type: String }) job_title!: string;
  @ApiProperty({ type: String, nullable: true }) department!: string | null;
  @ApiProperty({ type: String, nullable: true }) hire_date!: string | null;
  @ApiProperty({ type: String }) status!: string;
  @ApiProperty({ type: Number }) role_id!: number;
}

export class EmployeePageMetaDto {
  @ApiProperty({ type: Number }) limit!: number;
  @ApiProperty({ type: Number, nullable: true }) offset!: number | null;
  @ApiProperty({ type: String, nullable: true }) cursor!: string | null;
  @ApiProperty({ type: String, nullable: true }) next_cursor!: string | null;
  @ApiProperty({ type: Boolean }) has_more!: boolean;
  @ApiProperty({ type: Number, required: false }) total?: number;
}

export class EmployeePageResponseDto {
  @ApiProperty({ type: [EmployeeResponseDto] }) data!: EmployeeResponseDto[];
  @ApiProperty({ type: EmployeePageMetaDto }) meta!: EmployeePageMetaDto;
}

@ApiTags('PEOPLE')
@ApiBearerAuth('bearer')
@Controller('employees')
export class EmployeeController {
  constructor(private readonly employeeService: EmployeeService) {}

  @Get()
  @RequirePermission('employees.read')
  @ApiOperation({ operationId: 'listEmployees', summary: 'Staff directory' })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'offset', required: false, type: Number })
  @ApiQuery({ name: 'q', required: false, type: String })
  @ApiResponse({ status: 200, type: EmployeePageResponseDto })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<EmployeePageResponseDto> {
    return this.employeeService.list(query, currentUser);
  }

  @Post()
  @RequirePermission('employees.create')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createEmployee', summary: 'Create an employee' })
  @ApiResponse({ status: 201, type: EmployeeResponseDto })
  async create(
    @Body(new ZodValidationPipe(employeeCreateSchema)) dto: EmployeeCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<EmployeeWithRole> {
    return this.employeeService.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('employees.read')
  @ApiOperation({ operationId: 'getEmployee', summary: 'Employee profile' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: EmployeeResponseDto })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<EmployeeWithRole> {
    return this.employeeService.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('employees.update')
  @ApiOperation({ operationId: 'updateEmployee', summary: 'Update employee' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: EmployeeResponseDto })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(employeeUpdateSchema)) dto: EmployeeUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<EmployeeWithRole> {
    return this.employeeService.update(id, dto, currentUser);
  }

  @Put(':id/role')
  @RequirePermission('roles.update')
  @ApiOperation({ operationId: 'assignEmployeeRole', summary: 'Assign exactly one role' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: EmployeeResponseDto })
  async assignRole(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(assignRoleSchema)) dto: AssignRoleDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<EmployeeWithRole> {
    return this.employeeService.assignRole(id, dto, currentUser);
  }

  @Post(':id/status')
  @RequirePermission('employees.update')
  @HttpCode(200)
  @ApiOperation({
    operationId: 'setEmployeeStatus',
    summary: 'Change employment status; suspend revokes sessions',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: EmployeeResponseDto })
  async setStatus(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(employeeStatusSchema)) dto: EmployeeStatusDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<EmployeeWithRole> {
    return this.employeeService.setStatus(id, dto, currentUser);
  }
}
