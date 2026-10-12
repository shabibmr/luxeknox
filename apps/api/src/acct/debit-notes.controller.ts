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
import { ApiBearerAuth, ApiHeader, ApiOperation, ApiParam, ApiQuery, ApiTags } from '@nestjs/swagger';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import type { PaginatedResponse } from '../platform/http/pagination';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { UseIdempotency } from '../platform/idempotency/idempotency.interceptor';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  debitNoteCreateSchema,
  type DebitNoteCreateDto,
  type DebitNoteDto,
} from './debit-notes.dto';
import { DebitNotesService } from './debit-notes.service';

@ApiTags('ACCT')
@ApiBearerAuth('bearer')
@Controller('accounting/debit-notes')
export class DebitNotesController {
  constructor(private readonly service: DebitNotesService) {}

  @Get()
  @RequirePermission('accounting.read')
  @ApiOperation({ operationId: 'listDebitNotes', summary: 'List debit notes' })
  @ApiQuery({ name: 'status', required: false, enum: ['draft', 'posted', 'void'] })
  @ApiQuery({ name: 'purchase_bill_id', required: false, type: Number })
  @ApiQuery({ name: 'from', required: false, type: String })
  @ApiQuery({ name: 'to', required: false, type: String })
  @ApiQuery({ name: 'search', required: false, type: String })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<PaginatedResponse<DebitNoteDto>> {
    return this.service.list(query, currentUser);
  }

  @Post()
  @RequirePermission('accounting.purchases_write')
  @UseIdempotency()
  @HttpCode(201)
  @ApiOperation({ operationId: 'createDebitNote', summary: 'Create a draft debit note' })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Replay-safe key for debit note creation',
  })
  async create(
    @Body(new ZodValidationPipe(debitNoteCreateSchema)) dto: DebitNoteCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<DebitNoteDto> {
    return this.service.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('accounting.read')
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'getDebitNote', summary: 'Get debit note by ID' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<DebitNoteDto> {
    return this.service.getById(id, currentUser);
  }

  @Post(':id/post')
  @RequirePermission('accounting.purchases_write')
  @HttpCode(200)
  @ApiParam({ name: 'id', type: Number })
  @ApiOperation({ operationId: 'postDebitNote', summary: 'Post a debit note to the general ledger' })
  async post(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<DebitNoteDto> {
    return this.service.post(id, currentUser);
  }
}
