import { Body, Controller, Get, Put, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { SettingsService } from './settings.service';
import { Public } from '../auth/public.decorator';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  type SettingsListDto,
  type SettingsWriteDto,
  settingsWriteSchema,
} from './settings.dto';

export interface PublicSettingsDto {
  timezone: string;
  currency: string;
}

@ApiTags('Settings')
@Controller('settings')
export class SettingsController {
  constructor(private readonly settingsService: SettingsService) {}

  @Get('public')
  @Public()
  @ApiOperation({
    summary: 'Get public gym settings',
    description:
      'Returns unauthenticated public gym configuration such as canonical operating timezone and currency.',
  })
  @ApiResponse({
    status: 200,
    description: 'Public gym settings',
  })
  async getPublicSettings(): Promise<PublicSettingsDto> {
    const timezone = await this.settingsService.getTimezone();
    const currency = await this.settingsService.getCurrency();

    return {
      timezone,
      currency,
    };
  }

  @Get()
  @RequirePermission('settings.read')
  @ApiBearerAuth('bearer')
  @ApiOperation({
    summary: 'Get all system settings',
    description:
      'Returns all gym settings list or filtered by category. Requires `settings.read` permission (Super Admin / Admin).',
  })
  @ApiQuery({
    name: 'category',
    required: false,
    enum: ['GENERAL', 'BILLING', 'SCHEDULE', 'ATTENDANCE', 'WORKOUT', 'DIET', 'NOTIFICATION', 'SECURITY'],
    description: 'Filter settings by category',
  })
  @ApiResponse({
    status: 200,
    description: 'All system settings list',
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthenticated or missing Bearer token',
  })
  @ApiResponse({
    status: 403,
    description: 'Forbidden: missing settings.read permission',
  })
  async getAllSettings(@Query('category') category?: string): Promise<SettingsListDto> {
    const data = await this.settingsService.listSettings(category);
    return { data };
  }

  @Put()
  @RequirePermission('settings.update')
  @ApiBearerAuth('bearer')
  @ApiOperation({
    summary: 'Upsert known setting keys',
    description:
      'Upserts one or more gym settings and refreshes the cache. Requires `settings.update` permission.',
  })
  @ApiResponse({
    status: 200,
    description: 'Updated system settings list',
  })
  @ApiResponse({
    status: 400,
    description: 'Validation error in request payload',
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthenticated or missing Bearer token',
  })
  @ApiResponse({
    status: 403,
    description: 'Forbidden: missing settings.update permission',
  })
  async putSettings(
    @Body(new ZodValidationPipe(settingsWriteSchema)) dto: SettingsWriteDto,
  ): Promise<SettingsListDto> {
    const data = await this.settingsService.updateSettings(dto.items);
    return { data };
  }
}
