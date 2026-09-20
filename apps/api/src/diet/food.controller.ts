import { Body, Controller, Get, Param, ParseIntPipe, Patch, Post, Query } from '@nestjs/common';
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
  foodUpdateSchema,
  foodWriteSchema,
  type FoodUpdateDto,
  type FoodWriteDto,
} from './food.dto';
import { FoodService } from './food.service';

export class FoodResponseDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: String }) name!: string;
  @ApiProperty({ type: String }) serving_unit!: string;
  @ApiProperty({ type: Number, nullable: true }) serving_size!: number | null;
  @ApiProperty({ type: Number, nullable: true }) calories!: number | null;
  @ApiProperty({ type: Number, nullable: true }) protein_grams!: number | null;
  @ApiProperty({ type: Number, nullable: true }) carbs_grams!: number | null;
  @ApiProperty({ type: Number, nullable: true }) fat_grams!: number | null;
  @ApiProperty({ type: Number, nullable: true }) fiber_grams!: number | null;
  @ApiProperty({ type: Boolean }) is_verified!: boolean;
  @ApiProperty({ type: Boolean }) is_active!: boolean;
}

export class FoodPageMetaDto {
  @ApiProperty({ type: Number }) limit!: number;
  @ApiProperty({ type: Number, nullable: true }) offset!: number | null;
  @ApiProperty({ type: String, nullable: true }) cursor!: string | null;
  @ApiProperty({ type: String, nullable: true }) next_cursor!: string | null;
  @ApiProperty({ type: Boolean }) has_more!: boolean;
  @ApiProperty({ type: Number, required: false }) total?: number;
}

export class FoodPageResponseDto {
  @ApiProperty({ type: [FoodResponseDto] }) data!: FoodResponseDto[];
  @ApiProperty({ type: FoodPageMetaDto }) meta!: FoodPageMetaDto;
}

@ApiTags('DIET')
@ApiBearerAuth('bearer')
@Controller('foods')
export class FoodController {
  constructor(private readonly foodService: FoodService) {}

  @Get()
  @RequirePermission('diet.read')
  @ApiOperation({
    operationId: 'listFoods',
    summary: 'Food library',
    description: 'Browse/search foods. Non-updaters only see verified+active (FR-DIET-001).',
  })
  @ApiQuery({
    name: 'limit',
    required: false,
    type: Number,
    description: 'Default from gym_settings pagination.default_page_size.',
  })
  @ApiQuery({ name: 'offset', required: false, type: Number })
  @ApiQuery({ name: 'q', required: false, type: String, description: 'Case-insensitive search (FR-API-014).' })
  @ApiQuery({ name: 'is_verified', required: false, type: Boolean })
  @ApiQuery({ name: 'is_active', required: false, type: Boolean })
  @ApiResponse({ status: 200, description: 'OK', type: FoodPageResponseDto })
  @ApiResponse({ status: 401, description: 'Missing or expired session' })
  @ApiResponse({ status: 403, description: 'Forbidden: missing diet.read permission' })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<FoodPageResponseDto> {
    return this.foodService.list(query, currentUser);
  }

  @Post()
  @RequirePermission('diet.create')
  @ApiOperation({
    operationId: 'createFood',
    summary: 'Create a food',
    description: 'Admin CRUD (FR-DIET-001).',
  })
  @ApiResponse({ status: 201, description: 'OK', type: FoodResponseDto })
  @ApiResponse({ status: 400, description: 'Validation failed' })
  @ApiResponse({ status: 401, description: 'Missing or expired session' })
  @ApiResponse({ status: 403, description: 'Forbidden: missing diet.create permission' })
  async create(
    @Body(new ZodValidationPipe(foodWriteSchema)) dto: FoodWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<FoodResponseDto> {
    return this.foodService.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('diet.read')
  @ApiOperation({
    operationId: 'getFood',
    summary: 'Food detail',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: FoodResponseDto })
  @ApiResponse({ status: 404, description: 'Food not found' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<FoodResponseDto> {
    return this.foodService.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('diet.update')
  @ApiOperation({
    operationId: 'updateFood',
    summary: 'Update a food',
    description: 'Partial update. `is_active: false` deactivates — no separate delete endpoint.',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: FoodResponseDto })
  @ApiResponse({ status: 400, description: 'Validation failed' })
  @ApiResponse({ status: 404, description: 'Food not found' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(foodUpdateSchema)) dto: FoodUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<FoodResponseDto> {
    return this.foodService.update(id, dto, currentUser);
  }
}
