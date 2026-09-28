import { Controller, Get } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { AttendancePassService, type AttendancePassDto } from './attendance-pass.service';

@ApiTags('ATTN')
@ApiBearerAuth('bearer')
@Controller('attendance')
export class AttendancePassController {
  constructor(private readonly service: AttendancePassService) {}

  @Get('pass')
  @RequirePermission('attendance.read')
  @ApiOperation({ operationId: 'getAttendancePass', summary: 'Member digital pass (QR payload)' })
  async getPass(@CurrentUser() currentUser: AuthenticatedUser): Promise<AttendancePassDto> {
    return this.service.getPass(currentUser);
  }
}
