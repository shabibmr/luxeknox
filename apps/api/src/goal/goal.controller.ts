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
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  goalCheckInWriteSchema,
  goalFilterQuerySchema,
  goalUpdateSchema,
  goalWriteSchema,
  type GoalCheckInWriteDto,
  type GoalFilterQueryDto,
  type GoalUpdateDto,
  type GoalWriteDto,
} from './goal.dto';
import { GoalService } from './goal.service';

@ApiTags('GOAL')
@ApiBearerAuth('bearer')
@Controller()
export class GoalController {
  constructor(private readonly service: GoalService) {}

  @Get('members/:id/goals')
  @RequirePermission('goals.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'listMemberGoals', summary: 'Member goals' })
  async listMemberGoals(
    @Param('id', ParseIntPipe) memberId: number,
    @Query() rawQuery: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    const filter = goalFilterQuerySchema.parse(rawQuery);
    return this.service.listMemberGoals(memberId, rawQuery, filter, currentUser);
  }

  @Post('members/:id/goals')
  @RequirePermission('goals.write')
  @HttpCode(201)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'createMemberGoal', summary: 'Create a goal' })
  async createMemberGoal(
    @Param('id', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(goalWriteSchema)) dto: GoalWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.createGoal(memberId, dto, currentUser);
  }

  @Get('goals/:id')
  @RequirePermission('goals.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getGoal', summary: 'Goal detail' })
  async getGoal(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.getGoalById(id, currentUser);
  }

  @Patch('goals/:id')
  @RequirePermission('goals.write')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'updateGoal', summary: 'Update a goal' })
  async updateGoal(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(goalUpdateSchema)) dto: GoalUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.updateGoal(id, dto, currentUser);
  }

  @Post('goals/:id/check-ins')
  @RequirePermission('goals.write')
  @HttpCode(201)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'checkInGoal', summary: 'Record a goal check-in' })
  async checkInGoal(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(goalCheckInWriteSchema)) dto: GoalCheckInWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.checkIn(id, dto, currentUser);
  }
}
