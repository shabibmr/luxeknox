import { Body, Controller, Get, Param, ParseIntPipe, Put } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  LifestyleIntakeDto,
  lifestyleIntakePutSchema,
  type LifestyleIntakePutDto,
} from './lifestyle-intake.dto';
import { LifestyleIntakeService } from './lifestyle-intake.service';

@ApiTags('HEALTH')
@ApiBearerAuth('bearer')
@Controller('members/:id/lifestyle-intake')
export class LifestyleIntakeController {
  constructor(private readonly service: LifestyleIntakeService) {}

  @Get()
  @RequirePermission('health.read')
  @ApiOperation({ operationId: 'getLifestyleIntake', summary: 'Get member lifestyle intake' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: LifestyleIntakeDto })
  async get(
    @Param('id', ParseIntPipe) memberId: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<LifestyleIntakeDto> {
    return this.service.get(memberId, currentUser);
  }

  @Put()
  @RequirePermission('health.lifestyle')
  @ApiOperation({
    operationId: 'putLifestyleIntake',
    summary: 'Create or replace member lifestyle intake',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: LifestyleIntakeDto })
  async put(
    @Param('id', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(lifestyleIntakePutSchema)) dto: LifestyleIntakePutDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<LifestyleIntakeDto> {
    return this.service.put(memberId, dto, currentUser);
  }
}
