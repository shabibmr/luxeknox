import { Controller, Get } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { SettingsService } from './settings.service';
import { Public } from '../auth/public.decorator';
import { RequirePermission } from '../rbac/require-permission.decorator';

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
      'Returns all gym settings key-value pairs. Requires `settings.read` permission (Super Admin / Admin).',
  })
  @ApiResponse({
    status: 200,
    description: 'All system settings dictionary',
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthenticated or missing Bearer token',
  })
  @ApiResponse({
    status: 403,
    description: 'Forbidden: missing settings.read permission',
  })
  async getAllSettings(): Promise<Record<string, string>> {
    return this.settingsService.getAllSettings();
  }
}
