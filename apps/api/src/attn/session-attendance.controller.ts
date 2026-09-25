import { Body, Controller, Param, ParseIntPipe, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { z } from 'zod';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { SessionAttendanceService } from './session-attendance.service';

const markAttendanceSchema = z
  .object({
    attended: z.boolean(),
  })
  .strict();

type MarkAttendanceBody = z.infer<typeof markAttendanceSchema>;

@ApiTags('ATTN')
@ApiBearerAuth('bearer')
@Controller('schedules')
export class SessionAttendanceController {
  constructor(private readonly service: SessionAttendanceService) {}

  @Post(':id/participants/:participantId/mark')
  @RequirePermission('attendance.update')
  @ApiOperation({
    operationId: 'markSessionAttendance',
    summary: 'Mark session attended / no-show',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiParam({ name: 'participantId', type: Number })
  async mark(
    @Param('id', ParseIntPipe) id: number,
    @Param('participantId', ParseIntPipe) participantId: number,
    @Body(new ZodValidationPipe(markAttendanceSchema)) dto: MarkAttendanceBody,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.mark(id, participantId, dto, currentUser);
  }
}
