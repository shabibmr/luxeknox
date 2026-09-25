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
import { WorkoutPlanService } from './workout-plan.service';
import {
  assignPlanSchema,
  workoutPlanCreateSchema,
  workoutPlanExercisesWriteSchema,
  workoutPlanFilterQuerySchema,
  workoutPlanUpdateSchema,
  type AssignPlanDto,
  type WorkoutPlanCreateDto,
  type WorkoutPlanExercisesWriteDto,
  type WorkoutPlanFilterQueryDto,
  type WorkoutPlanUpdateDto,
} from './workout-plan.dto';

@ApiTags('WORK')
@ApiBearerAuth('bearer')
@Controller('workout-plans')
export class WorkoutPlanController {
  constructor(private readonly service: WorkoutPlanService) {}

  @Get()
  @RequirePermission('workouts.read')
  @ApiOperation({ operationId: 'listWorkoutPlans', summary: 'Workout plans and templates' })
  async list(
    @Query() rawQuery: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    const filter = workoutPlanFilterQuerySchema.parse(rawQuery);
    return this.service.list(rawQuery, filter, currentUser);
  }

  @Post()
  @RequirePermission('workouts.write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createWorkoutPlan', summary: 'Create a plan (also creates version 1)' })
  async create(
    @Body(new ZodValidationPipe(workoutPlanCreateSchema)) dto: WorkoutPlanCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('workouts.read')
  @ApiOperation({ operationId: 'getWorkoutPlan', summary: 'Plan with current version line items' })
  @ApiParam({ name: 'id', type: Number })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('workouts.write')
  @ApiOperation({ operationId: 'updateWorkoutPlan', summary: 'Update plan metadata (requires row_version)' })
  @ApiParam({ name: 'id', type: Number })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(workoutPlanUpdateSchema)) dto: WorkoutPlanUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.update(id, dto, currentUser);
  }

  @Post(':id/publish')
  @RequirePermission('workouts.write')
  @HttpCode(200)
  @ApiOperation({ operationId: 'publishWorkoutPlan', summary: 'Publish a draft plan' })
  @ApiParam({ name: 'id', type: Number })
  async publish(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.publish(id, currentUser);
  }

  @Post(':id/archive')
  @RequirePermission('workouts.write')
  @HttpCode(200)
  @ApiOperation({ operationId: 'archiveWorkoutPlan', summary: 'Archive a workout plan' })
  @ApiParam({ name: 'id', type: Number })
  async archive(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.archive(id, currentUser);
  }

  @Post(':id/assign')
  @RequirePermission('workouts.write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'assignWorkoutPlan', summary: 'Copy a template onto a member (new plan + version 1)' })
  @ApiParam({ name: 'id', type: Number })
  async assign(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(assignPlanSchema)) dto: AssignPlanDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.assign(id, dto, currentUser);
  }

  @Get(':id/versions')
  @RequirePermission('workouts.read')
  @ApiOperation({ operationId: 'listWorkoutPlanVersions', summary: 'Plan version snapshots' })
  @ApiParam({ name: 'id', type: Number })
  async listVersions(
    @Param('id', ParseIntPipe) id: number,
    @Query() rawQuery: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.listVersions(id, rawQuery, currentUser);
  }

  @Put(':id/exercises')
  @RequirePermission('workouts.write')
  @ApiOperation({ operationId: 'replaceWorkoutPlanExercises', summary: 'Replace current-version line items (inserts a new version)' })
  @ApiParam({ name: 'id', type: Number })
  async replaceExercises(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(workoutPlanExercisesWriteSchema)) dto: WorkoutPlanExercisesWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.replaceExercises(id, dto, currentUser);
  }
}
