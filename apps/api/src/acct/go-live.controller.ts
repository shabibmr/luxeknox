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
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  enablePostingSchema,
  mapPaymentMethodSchema,
  type EnablePostingDto,
  type EnablePostingResponseDto,
  type GoLiveChecklistResponseDto,
  type GoLivePaymentMethodDto,
  type MapPaymentMethodDto,
  type UnearnedPreviewResponseDto,
} from './go-live.dto';
import { GoLiveService } from './go-live.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting/go-live')
export class GoLiveController {
  constructor(private readonly goLiveService: GoLiveService) {}

  @Get('checklist')
  @RequirePermission('accounting.read')
  @ApiOperation({
    operationId: 'getGoLiveChecklist',
    summary: 'Get accounting go-live checklist and prerequisite checks',
  })
  async getGoLiveChecklist(
    @Query('go_live_date') goLiveDate?: string,
  ): Promise<GoLiveChecklistResponseDto> {
    return this.goLiveService.getGoLiveChecklist(goLiveDate);
  }

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

  @Patch('payment-methods/:id')
  @RequirePermission('accounting.accounts_write')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({
    operationId: 'mapPaymentMethodAccount',
    summary: 'Map payment method to accounting account',
  })
  async mapPaymentMethodAccount(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(mapPaymentMethodSchema)) dto: MapPaymentMethodDto,
  ): Promise<GoLivePaymentMethodDto> {
    return this.goLiveService.mapPaymentMethodAccount(id, dto.account_id);
  }

  @Post('enable-posting')
  @HttpCode(200)
  @RequirePermission('accounting.posting_toggle')
  @ApiOperation({
    operationId: 'enablePosting',
    summary: 'Enable accounting journal posting',
  })
  async enablePosting(
    @Body(new ZodValidationPipe(enablePostingSchema.optional().default({})))
    dto?: EnablePostingDto,
  ): Promise<EnablePostingResponseDto> {
    return this.goLiveService.enablePosting(dto?.go_live_date);
  }
}
