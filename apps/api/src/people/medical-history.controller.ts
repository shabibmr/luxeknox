import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import type { PaginatedResponse } from '../platform/http/pagination';
import {
  MedicalHistoryDto,
  medicalHistoryUpdateSchema,
  medicalHistoryWriteSchema,
  type MedicalHistoryUpdateDto,
  type MedicalHistoryWriteDto,
} from './medical-history.dto';
import { MedicalHistoryService } from './medical-history.service';

@ApiTags('HEALTH')
@ApiBearerAuth('bearer')
@Controller('members/:id/medical-histories')
export class MedicalHistoryController {
  constructor(private readonly service: MedicalHistoryService) {}

  @Get()
  @RequirePermission('health.read')
  @ApiOperation({ operationId: 'listMedicalHistories', summary: 'Medical history list' })
  @ApiParam({ name: 'id', type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'offset', required: false, type: Number })
  @ApiResponse({ status: 200, type: [MedicalHistoryDto] })
  async list(
    @Param('id', ParseIntPipe) memberId: number,
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<MedicalHistoryDto>> {
    return this.service.list(memberId, query, currentUser);
  }

  @Post()
  @RequirePermission('health.update')
  @ApiOperation({ operationId: 'createMedicalHistory', summary: 'Add a medical history row' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 201, type: MedicalHistoryDto })
  async create(
    @Param('id', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(medicalHistoryWriteSchema)) dto: MedicalHistoryWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MedicalHistoryDto> {
    return this.service.create(memberId, dto, currentUser);
  }

  @Patch(':historyId')
  @RequirePermission('health.update')
  @ApiOperation({ operationId: 'updateMedicalHistory', summary: 'Update a medical history row' })
  @ApiParam({ name: 'id', type: Number })
  @ApiParam({ name: 'historyId', type: Number })
  @ApiResponse({ status: 200, type: MedicalHistoryDto })
  async update(
    @Param('id', ParseIntPipe) memberId: number,
    @Param('historyId', ParseIntPipe) historyId: number,
    @Body(new ZodValidationPipe(medicalHistoryUpdateSchema)) dto: MedicalHistoryUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MedicalHistoryDto> {
    return this.service.update(memberId, historyId, dto, currentUser);
  }

  @Delete(':historyId')
  @RequirePermission('health.update')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ operationId: 'deleteMedicalHistory', summary: 'Soft-remove a medical history row' })
  @ApiParam({ name: 'id', type: Number })
  @ApiParam({ name: 'historyId', type: Number })
  @ApiResponse({ status: 204, description: 'No content' })
  async delete(
    @Param('id', ParseIntPipe) memberId: number,
    @Param('historyId', ParseIntPipe) historyId: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<void> {
    await this.service.delete(memberId, historyId, currentUser);
  }
}
