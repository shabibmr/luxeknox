import { Body, Controller, Param, ParseIntPipe, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { rejectRequestSchema, type RejectRequestDto } from './membership.dto';
import { MembershipService } from './membership.service';

@ApiTags('MEMB')
@ApiBearerAuth('bearer')
@Controller('freezes')
export class FreezeController {
  constructor(private readonly service: MembershipService) {}

  @Post(':id/approve')
  @RequirePermission('memberships.approve')
  @ApiOperation({ operationId: 'approveFreeze', summary: 'Approve a freeze' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK' })
  async approve(@Param('id', ParseIntPipe) id: number, @CurrentUser() currentUser: AuthenticatedUser) {
    return this.service.approveFreeze(id, currentUser);
  }

  @Post(':id/reject')
  @RequirePermission('memberships.approve')
  @ApiOperation({ operationId: 'rejectFreeze', summary: 'Reject a freeze' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK' })
  async reject(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(rejectRequestSchema)) dto: RejectRequestDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.rejectFreeze(id, dto, currentUser);
  }
}
