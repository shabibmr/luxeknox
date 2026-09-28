import {
  Body,
  Controller,
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
  progressNoteFilterQuerySchema,
  progressNoteWriteSchema,
  type ProgressNoteFilterQueryDto,
  type ProgressNoteWriteDto,
} from './goal.dto';
import { ProgressNoteService } from './progress-note.service';

@ApiTags('GOAL')
@ApiBearerAuth('bearer')
@Controller()
export class ProgressNoteController {
  constructor(private readonly service: ProgressNoteService) {}

  @Get('members/:id/progress-notes')
  @RequirePermission('goals.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'listProgressNotes', summary: 'Coach / member notes' })
  async listNotes(
    @Param('id', ParseIntPipe) memberId: number,
    @Query() rawQuery: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    const filter = progressNoteFilterQuerySchema.parse(rawQuery);
    return this.service.listNotes(memberId, rawQuery, filter, currentUser);
  }

  @Post('members/:id/progress-notes')
  @RequirePermission('goals.write')
  @HttpCode(201)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'createProgressNote', summary: 'Add a progress note' })
  async createNote(
    @Param('id', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(progressNoteWriteSchema)) dto: ProgressNoteWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.createNote(memberId, dto, currentUser);
  }
}
