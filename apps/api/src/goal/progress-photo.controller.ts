import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  progressPhotoComparisonQuerySchema,
  progressPhotoFilterQuerySchema,
  progressPhotoWriteSchema,
  type ProgressPhotoComparisonQueryDto,
  type ProgressPhotoFilterQueryDto,
  type ProgressPhotoWriteDto,
} from './goal.dto';
import { ProgressPhotoService } from './progress-photo.service';

@ApiTags('GOAL')
@ApiBearerAuth('bearer')
@Controller()
export class ProgressPhotoController {
  constructor(private readonly service: ProgressPhotoService) {}

  @Get('members/:id/progress-photos/comparison')
  @RequirePermission('goals.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({
    operationId: 'compareProgressPhotos',
    summary: 'Compare progress photos across two dates and poses',
  })
  async comparePhotos(
    @Param('id', ParseIntPipe) memberId: number,
    @Query() rawQuery: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    const query = progressPhotoComparisonQuerySchema.parse(rawQuery);
    return this.service.getComparison(memberId, query, currentUser);
  }

  @Get('members/:id/progress-photos')
  @RequirePermission('goals.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'listProgressPhotos', summary: 'Progress photos gallery' })
  async listPhotos(
    @Param('id', ParseIntPipe) memberId: number,
    @Query() rawQuery: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    const filter = progressPhotoFilterQuerySchema.parse(rawQuery);
    return this.service.listPhotos(memberId, rawQuery, filter, currentUser);
  }

  @Post('members/:id/progress-photos')
  @RequirePermission('goals.write')
  @HttpCode(201)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'createProgressPhoto', summary: 'Add a progress photo' })
  async createPhoto(
    @Param('id', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(progressPhotoWriteSchema)) dto: ProgressPhotoWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.createPhoto(memberId, dto, currentUser);
  }

  @Delete('progress-photos/:id')
  @RequirePermission('goals.write')
  @HttpCode(204)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'deleteProgressPhoto', summary: 'Delete a progress photo' })
  async deletePhoto(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    await this.service.deletePhoto(id, currentUser);
  }
}
