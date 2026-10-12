import { Controller, Get, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { RequirePermission } from '../rbac/require-permission.decorator';
import type { UnearnedPreviewResponseDto } from './go-live.dto';
import { GoLiveService } from './go-live.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting/go-live')
export class GoLiveController {
  constructor(private readonly goLiveService: GoLiveService) {}

  @Get('unearned-preview')
  @RequirePermission('accounting.read')
  @ApiOperation({
    operationId: 'getUnearnedPreview',
    summary: 'Preview unearned membership and PT revenue for go-live',
  })
  async getUnearnedPreview(
    @Query('go_live_date') goLiveDate?: string,
  ): Promise<UnearnedPreviewResponseDto> {
    return this.goLiveService.getUnearnedPreview(goLiveDate);
  }
}
