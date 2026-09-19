import { Body, Controller, Get, Param, ParseIntPipe, Patch, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiProperty, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { exerciseUpdateSchema, exerciseWriteSchema, type ExerciseUpdateDto, type ExerciseWriteDto } from './exercise.dto';
import { ExerciseService } from './exercise.service';

export class ExerciseResponseDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: String }) name!: string;
  @ApiProperty({ type: String, nullable: true }) primary_muscle_group!: string | null;
  @ApiProperty({ type: [String] }) secondary_muscles!: string[] | null;
  @ApiProperty({ type: String, nullable: true }) equipment_needed!: string | null;
  @ApiProperty({ type: String, nullable: true }) instructions!: string | null;
  @ApiProperty({ type: String, nullable: true }) video_url!: string | null;
  @ApiProperty({ type: String, nullable: true }) gif_url!: string | null;
  @ApiProperty({ type: String, nullable: true }) difficulty_level!: string | null;
  @ApiProperty({ type: Boolean }) is_active!: boolean;
}

export class ExercisePageMetaDto {
  @ApiProperty({ type: Number }) limit!: number;
  @ApiProperty({ type: Number, nullable: true }) offset!: number | null;
  @ApiProperty({ type: String, nullable: true }) cursor!: string | null;
  @ApiProperty({ type: String, nullable: true }) next_cursor!: string | null;
  @ApiProperty({ type: Boolean }) has_more!: boolean;
  @ApiProperty({ type: Number, required: false }) total?: number;
}

export class ExercisePageResponseDto {
  @ApiProperty({ type: [ExerciseResponseDto] }) data!: ExerciseResponseDto[];
  @ApiProperty({ type: ExercisePageMetaDto }) meta!: ExercisePageMetaDto;
}

@ApiTags('WORK')
@ApiBearerAuth('bearer')
@Controller('exercises')
export class ExerciseController {
  constructor(private readonly exerciseService: ExerciseService) {}

  @Get()
  @RequirePermission('exercises.read')
  @ApiOperation({
    operationId: 'listExercises',
    summary: 'Exercise library',
    description: 'Browse/search active exercises by muscle, equipment, difficulty (FR-WORK-002).',
  })
  @ApiQuery({ name: 'limit', required: false, type: Number, description: 'Default from gym_settings pagination.default_page_size.' })
  @ApiQuery({ name: 'offset', required: false, type: Number })
  @ApiQuery({ name: 'q', required: false, type: String, description: 'Case-insensitive search (FR-API-014).' })
  @ApiQuery({ name: 'primary_muscle_group', required: false, type: String })
  @ApiQuery({ name: 'equipment_needed', required: false, type: String })
  @ApiQuery({ name: 'difficulty_level', required: false, type: String })
  @ApiResponse({ status: 200, description: 'OK', type: ExercisePageResponseDto })
  @ApiResponse({ status: 401, description: 'Missing or expired session' })
  @ApiResponse({ status: 403, description: 'Forbidden: missing exercises.read permission' })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ExercisePageResponseDto> {
    return this.exerciseService.list(query, currentUser);
  }

  @Post()
  @RequirePermission('exercises.create')
  @ApiOperation({
    operationId: 'createExercise',
    summary: 'Create an exercise',
    description: 'Admin CRUD (FR-WORK-001).',
  })
  @ApiResponse({ status: 201, description: 'OK', type: ExerciseResponseDto })
  @ApiResponse({ status: 400, description: 'Validation failed' })
  @ApiResponse({ status: 401, description: 'Missing or expired session' })
  @ApiResponse({ status: 403, description: 'Forbidden: missing exercises.create permission' })
  async create(
    @Body(new ZodValidationPipe(exerciseWriteSchema)) dto: ExerciseWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ExerciseResponseDto> {
    return this.exerciseService.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('exercises.read')
  @ApiOperation({
    operationId: 'getExercise',
    summary: 'Exercise detail',
    description: 'Detail includes media URLs (FR-WORK-002).',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: ExerciseResponseDto })
  @ApiResponse({ status: 404, description: 'Exercise not found' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ExerciseResponseDto> {
    return this.exerciseService.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('exercises.update')
  @ApiOperation({
    operationId: 'updateExercise',
    summary: 'Update or deactivate an exercise',
    description: 'Partial update. `is_active: false` deactivates — no separate delete endpoint.',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: ExerciseResponseDto })
  @ApiResponse({ status: 400, description: 'Validation failed' })
  @ApiResponse({ status: 404, description: 'Exercise not found' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(exerciseUpdateSchema)) dto: ExerciseUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ExerciseResponseDto> {
    return this.exerciseService.update(id, dto, currentUser);
  }
}
