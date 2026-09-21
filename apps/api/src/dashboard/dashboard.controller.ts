import { Controller, Get } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { DashboardService } from './dashboard.service';
import type { DashboardResponseDto } from './dashboard.dto';

@ApiTags('DASH')
@ApiBearerAuth('bearer')
@Controller('dashboard')
export class DashboardController {
  constructor(private readonly service: DashboardService) {}

  @Get()
  @ApiOperation({
    operationId: 'getDashboard',
    summary: 'Role-specific home snapshot; unauthorized widgets omitted',
    description:
      'No single route-level permission gate — every authenticated user may call this. ' +
      'Each section (member/trainer/admin) is included only when the caller both holds ' +
      'the matching dashboard.{member,trainer,admin} permission and has a profile of that kind.',
  })
  @ApiResponse({ status: 200, description: 'OK' })
  async getDashboard(@CurrentUser() currentUser: AuthenticatedUser): Promise<DashboardResponseDto> {
    return this.service.getDashboard(currentUser);
  }
}
