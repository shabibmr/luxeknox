import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Patch,
  Post,
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
  trainerCreateSchema,
  trainerUpdateSchema,
  type TrainerCreateDto,
  type TrainerUpdateDto,
} from './trainer.dto';
import { TrainerService, type TrainerResponse } from './trainer.service';
import type { Member } from '../platform/db/schema/members';

export class TrainerResponseDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: Number }) user_id!: number;
  @ApiProperty({ type: String }) first_name!: string;
  @ApiProperty({ type: String }) last_name!: string;
  @ApiProperty({ type: String, nullable: true }) bio!: string | null;
  @ApiProperty({ type: [String], nullable: true }) specializations!: string[] | null;
  @ApiProperty({ type: String, nullable: true }) hourly_rate!: string | null;
  @ApiProperty({ type: Number, nullable: true }) rating!: number | null;
  @ApiProperty({ type: Number, nullable: true }) max_clients_capacity!: number | null;
  @ApiProperty({ type: Boolean }) is_active!: boolean;
  @ApiProperty({ type: Number }) assigned_active_count!: number;
}

export class TrainerPageMetaDto {
  @ApiProperty({ type: Number }) limit!: number;
  @ApiProperty({ type: Number, nullable: true }) offset!: number | null;
  @ApiProperty({ type: String, nullable: true }) cursor!: string | null;
  @ApiProperty({ type: String, nullable: true }) next_cursor!: string | null;
  @ApiProperty({ type: Boolean }) has_more!: boolean;
  @ApiProperty({ type: Number, required: false }) total?: number;
}

export class TrainerPageResponseDto {
  @ApiProperty({ type: [TrainerResponseDto] }) data!: TrainerResponseDto[];
  @ApiProperty({ type: TrainerPageMetaDto }) meta!: TrainerPageMetaDto;
}

@ApiTags('PEOPLE')
@ApiBearerAuth('bearer')
@Controller('trainers')
export class TrainerController {
  constructor(private readonly trainerService: TrainerService) {}

  @Get()
  @RequirePermission('trainers.read')
  @ApiOperation({ operationId: 'listTrainers', summary: 'Trainer directory' })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'offset', required: false, type: Number })
  @ApiQuery({ name: 'q', required: false, type: String })
  @ApiResponse({ status: 200, type: TrainerPageResponseDto })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<TrainerPageResponseDto> {
    return this.trainerService.list(query, currentUser);
  }

  @Post()
  @RequirePermission('trainers.create')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createTrainer', summary: 'Create a trainer' })
  @ApiResponse({ status: 201, type: TrainerResponseDto })
  async create(
    @Body(new ZodValidationPipe(trainerCreateSchema)) dto: TrainerCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<TrainerResponse> {
    return this.trainerService.create(dto, currentUser);
  }

  @Get(':id/members')
  @RequirePermission('members.read')
  @ApiOperation({
    operationId: 'listTrainerMembers',
    summary: 'Members assigned to a trainer',
  })
  @ApiParam({ name: 'id', type: Number })
  async listMembers(
    @Param('id', ParseIntPipe) id: number,
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<{ data: Member[]; meta: unknown }> {
    return this.trainerService.listMembers(id, query, currentUser);
  }

  @Get(':id')
  @RequirePermission('trainers.read')
  @ApiOperation({
    operationId: 'getTrainer',
    summary: 'Trainer profile (rate hidden from members)',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: TrainerResponseDto })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<TrainerResponse> {
    return this.trainerService.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('trainers.update')
  @ApiOperation({ operationId: 'updateTrainer', summary: 'Update trainer' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: TrainerResponseDto })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(trainerUpdateSchema)) dto: TrainerUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<TrainerResponse> {
    return this.trainerService.update(id, dto, currentUser);
  }
}
