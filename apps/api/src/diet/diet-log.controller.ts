import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Put,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { DietLogService } from './diet-log.service';
import {
  dietLogFilterQuerySchema,
  dietLogWriteSchema,
  type DietLogFilterQueryDto,
  type DietLogWriteDto,
} from './diet-log.dto';

@ApiTags('DIET')
@ApiBearerAuth('bearer')
@Controller('members/:id/diet-logs')
export class DietLogController {
  constructor(private readonly service: DietLogService) {}

  @Put(':date')
  @RequirePermission('diets.write')
  @HttpCode(200)
  @ApiOperation({ operationId: 'putDietLog', summary: "Upsert a day's intake log" })
  @ApiParam({ name: 'id', type: Number, description: 'Member ID' })
  @ApiParam({ name: 'date', type: String, description: 'Date in YYYY-MM-DD format' })
  async putLog(
    @Param('id', ParseIntPipe) memberId: number,
    @Param('date') dateStr: string,
    @Body(new ZodValidationPipe(dietLogWriteSchema)) dto: DietLogWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.putLog(memberId, dateStr, dto, currentUser);
  }

  @Get()
  @RequirePermission('diets.read')
  @ApiOperation({ operationId: 'listDietLogs', summary: 'Diet adherence history' })
  @ApiParam({ name: 'id', type: Number, description: 'Member ID' })
  async listLogs(
    @Param('id', ParseIntPipe) memberId: number,
    @Query() rawQuery: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    const filter = dietLogFilterQuerySchema.parse(rawQuery);
    return this.service.listLogs(memberId, rawQuery, filter, currentUser);
  }
}
