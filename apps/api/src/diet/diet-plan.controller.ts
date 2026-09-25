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
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { DietPlanService } from './diet-plan.service';
import {
  assignDietPlanSchema,
  dietPlanCreateSchema,
  dietPlanFilterQuerySchema,
  dietPlanMealsWriteSchema,
  dietPlanUpdateSchema,
  type AssignDietPlanDto,
  type DietPlanCreateDto,
  type DietPlanFilterQueryDto,
  type DietPlanMealsWriteDto,
  type DietPlanUpdateDto,
} from './diet-plan.dto';

@ApiTags('DIET')
@ApiBearerAuth('bearer')
@Controller('diet-plans')
export class DietPlanController {
  constructor(private readonly service: DietPlanService) {}

  @Get()
  @RequirePermission('diets.read')
  @ApiOperation({ operationId: 'listDietPlans', summary: 'Diet plans and templates' })
  async list(
    @Query() rawQuery: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    const filter = dietPlanFilterQuerySchema.parse(rawQuery);
    return this.service.list(rawQuery, filter, currentUser);
  }

  @Post()
  @RequirePermission('diets.write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createDietPlan', summary: 'Create a diet plan (also creates version 1)' })
  async create(
    @Body(new ZodValidationPipe(dietPlanCreateSchema)) dto: DietPlanCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('diets.read')
  @ApiOperation({ operationId: 'getDietPlan', summary: 'Plan with current version meals' })
  @ApiParam({ name: 'id', type: Number })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('diets.write')
  @ApiOperation({ operationId: 'updateDietPlan', summary: 'Update diet plan metadata (requires row_version)' })
  @ApiParam({ name: 'id', type: Number })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(dietPlanUpdateSchema)) dto: DietPlanUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.update(id, dto, currentUser);
  }

  @Post(':id/publish')
  @RequirePermission('diets.write')
  @HttpCode(200)
  @ApiOperation({ operationId: 'publishDietPlan', summary: 'Publish a draft diet plan' })
  @ApiParam({ name: 'id', type: Number })
  async publish(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.publish(id, currentUser);
  }

  @Post(':id/assign')
  @RequirePermission('diets.write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'assignDietPlan', summary: 'Copy a template onto a member' })
  @ApiParam({ name: 'id', type: Number })
  async assign(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(assignDietPlanSchema)) dto: AssignDietPlanDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.assign(id, dto, currentUser);
  }

  @Get(':id/versions')
  @RequirePermission('diets.read')
  @ApiOperation({ operationId: 'listDietPlanVersions', summary: 'Diet plan versions' })
  @ApiParam({ name: 'id', type: Number })
  async listVersions(
    @Param('id', ParseIntPipe) id: number,
    @Query() rawQuery: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.listVersions(id, rawQuery, currentUser);
  }

  @Put(':id/meals')
  @RequirePermission('diets.write')
  @ApiOperation({ operationId: 'replaceDietPlanMeals', summary: 'Replace current-version meals (inserts a new version)' })
  @ApiParam({ name: 'id', type: Number })
  async replaceMeals(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(dietPlanMealsWriteSchema)) dto: DietPlanMealsWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.replaceMeals(id, dto, currentUser);
  }
}
