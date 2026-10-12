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
import { ApiBearerAuth, ApiHeader, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { UseIdempotency } from '../platform/idempotency/idempotency.interceptor';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import type { PaginatedResponse } from '../platform/http/pagination';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  journalCreateSchema,
  journalReverseSchema,
  type JournalCreateDto,
  type JournalDto,
  type JournalReverseDto,
} from './journal.dto';
import { JournalService } from './journal.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting/journals')
export class JournalController {
  constructor(private readonly service: JournalService) {}

  @Get()
  @RequirePermission('accounting.read')
  @ApiOperation({ operationId: 'listJournals', summary: 'List journal entries' })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<JournalDto>> {
    return this.service.list(query, currentUser);
  }

  @Post()
  @RequirePermission('accounting.journals_write')
  @UseIdempotency()
  @HttpCode(201)
  @ApiOperation({
    operationId: 'createJournal',
    summary: 'Create a manual or opening-balance journal',
  })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Replay-safe key for manual journal creates',
  })
  async create(
    @Body(new ZodValidationPipe(journalCreateSchema)) dto: JournalCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<JournalDto> {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('accounting.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getJournal', summary: 'Journal entry detail' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<JournalDto> {
    return this.service.getById(id, currentUser);
  }

  @Post(':id/reverse')
  @RequirePermission('accounting.journals_write')
  @UseIdempotency()
  @HttpCode(201)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'reverseJournal', summary: 'Reverse a posted journal' })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Replay-safe key for journal reversals',
  })
  async reverse(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(journalReverseSchema)) dto: JournalReverseDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<JournalDto> {
    return this.service.reverse(id, dto, currentUser);
  }
}
