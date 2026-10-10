import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { WorkoutSessionService } from './workout-session.service';
import {
  workoutSessionCompleteSchema,
  workoutSessionCreateSchema,
  workoutSessionFilterQuerySchema,
  workoutSetUpdateSchema,
  workoutSetWriteSchema,
  type WorkoutSessionCompleteDto,
  type WorkoutSessionCreateDto,
  type WorkoutSetUpdateDto,
  type WorkoutSetWriteDto,
} from './workout-plan.dto';

@ApiTags('WORK')
@ApiBearerAuth('bearer')
@Controller('workout-sessions')
export class WorkoutSessionController {
  constructor(private readonly service: WorkoutSessionService) {}

  @Get()
  @RequirePermission('workouts.read')
  @ApiOperation({ operationId: 'listWorkoutSessions', summary: 'Workout history' })
  async list(
    @Query() rawQuery: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    const filter = workoutSessionFilterQuerySchema.parse(rawQuery);
    return this.service.listSessions(rawQuery, filter, currentUser);
  }

  @Post()
  @RequirePermission('workouts.write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'startWorkoutSession', summary: 'Start a live session' })
  async start(
    @Body(new ZodValidationPipe(workoutSessionCreateSchema)) dto: WorkoutSessionCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.start(dto, currentUser);
  }

  @Get('active')
  @RequirePermission('workouts.read')
  @ApiOperation({ operationId: 'getActiveWorkoutSession', summary: 'Get the member\'s active (in-progress) workout session' })
  async getActive(
    @Query('member_id') memberIdStr: string | undefined,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    const memberId = memberIdStr ? parseInt(memberIdStr, 10) : undefined;
    return this.service.getActive(memberId, currentUser);
  }

  @Get('personal-records')
  @RequirePermission('workouts.read')
  @ApiOperation({ operationId: 'getPersonalRecords', summary: 'Member personal records across completed sessions' })
  async getPersonalRecords(
    @Query('member_id') memberIdStr: string | undefined,
    @Query('exercise_id') exerciseIdStr: string | undefined,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    const memberId = memberIdStr ? parseInt(memberIdStr, 10) : undefined;
    const exerciseId = exerciseIdStr ? parseInt(exerciseIdStr, 10) : undefined;
    return this.service.getPersonalRecords(memberId, exerciseId, currentUser);
  }

  @Get(':id')
  @RequirePermission('workouts.read')
  @ApiOperation({ operationId: 'getWorkoutSession', summary: 'Get workout session details' })
  @ApiParam({ name: 'id', type: Number })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.getById(id, currentUser);
  }

  @Post(':id/sets')
  @RequirePermission('workouts.write')
  @HttpCode(201)
  @ApiOperation({ operationId: 'logWorkoutSet', summary: 'Log a set' })
  @ApiParam({ name: 'id', type: Number })
  async logSet(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(workoutSetWriteSchema)) dto: WorkoutSetWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.logSet(id, dto, currentUser);
  }

  @Patch(':id/sets/:setId')
  @RequirePermission('workouts.write')
  @ApiOperation({ operationId: 'updateWorkoutSet', summary: 'Edit a logged set' })
  @ApiParam({ name: 'id', type: Number })
  @ApiParam({ name: 'setId', type: Number })
  async updateSet(
    @Param('id', ParseIntPipe) id: number,
    @Param('setId', ParseIntPipe) setId: number,
    @Body(new ZodValidationPipe(workoutSetUpdateSchema)) dto: WorkoutSetUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.updateSet(id, setId, dto, currentUser);
  }

  @Delete(':id/sets/:setId')
  @HttpCode(204)
  @RequirePermission('workouts.write')
  @ApiOperation({ operationId: 'deleteWorkoutSet', summary: 'Delete a logged set' })
  @ApiParam({ name: 'id', type: Number })
  @ApiParam({ name: 'setId', type: Number })
  async deleteSet(
    @Param('id', ParseIntPipe) id: number,
    @Param('setId', ParseIntPipe) setId: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    await this.service.deleteSet(id, setId, currentUser);
  }

  @Post(':id/complete')
  @RequirePermission('workouts.write')
  @HttpCode(200)
  @ApiOperation({ operationId: 'completeWorkoutSession', summary: 'Complete a session' })
  @ApiParam({ name: 'id', type: Number })
  async complete(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(workoutSessionCompleteSchema)) dto: WorkoutSessionCompleteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.complete(id, dto, currentUser);
  }
}
