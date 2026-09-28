import { Body, Controller, Get, Param, ParseIntPipe, Put } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  trainerAvailabilityWriteSchema,
  type TrainerAvailabilityWriteDto,
} from './trainer-availability.dto';
import { TrainerAvailabilityService } from './trainer-availability.service';

@ApiTags('SCHED')
@ApiBearerAuth('bearer')
@Controller('trainers')
export class TrainerAvailabilityController {
  constructor(private readonly service: TrainerAvailabilityService) {}

  @Get(':id/availability')
  @RequirePermission('schedules.read')
  @ApiOperation({ operationId: 'getTrainerAvailability', summary: 'Trainer hours and block-outs' })
  @ApiParam({ name: 'id', type: Number })
  async list(@Param('id', ParseIntPipe) trainerId: number) {
    return this.service.listForTrainer(trainerId);
  }

  @Put(':id/availability')
  @RequirePermission('schedules.write')
  @ApiOperation({ operationId: 'putTrainerAvailability', summary: 'Replace trainer availability' })
  @ApiParam({ name: 'id', type: Number })
  async replace(
    @Param('id', ParseIntPipe) trainerId: number,
    @Body(new ZodValidationPipe(trainerAvailabilityWriteSchema)) dto: TrainerAvailabilityWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.replaceForTrainer(trainerId, dto, currentUser);
  }
}
