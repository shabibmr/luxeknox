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
import { ApiBearerAuth, ApiOperation, ApiParam, ApiProperty, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  memberDocumentWriteSchema,
  type MemberDocumentWriteDto,
} from './member-document.dto';
import { MemberDocumentService } from './member-document.service';
import type { MemberDocument } from '../platform/db/schema/member-documents';

export class MemberDocumentResponseDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: Number }) member_id!: number;
  @ApiProperty({ type: String }) document_type!: string;
  @ApiProperty({ type: String, nullable: true }) title!: string | null;
  @ApiProperty({ type: String }) file_url!: string;
  @ApiProperty({ type: Number, nullable: true }) file_size!: number | null;
  @ApiProperty({ type: Number, nullable: true }) verified_by_user_id!: number | null;
}

@ApiTags('HEALTH')
@ApiBearerAuth('bearer')
@Controller('members/:id/documents')
export class MemberDocumentController {
  constructor(private readonly memberDocumentService: MemberDocumentService) {}

  @Get()
  @RequirePermission('health.read')
  @ApiOperation({ operationId: 'listMemberDocuments', summary: 'Member documents' })
  @ApiParam({ name: 'id', type: Number })
  async list(
    @Param('id', ParseIntPipe) memberId: number,
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.memberDocumentService.list(memberId, query, currentUser);
  }

  @Post()
  @RequirePermission('health.update')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createMemberDocument', summary: 'Attach a document metadata row' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 201, type: MemberDocumentResponseDto })
  async create(
    @Param('id', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(memberDocumentWriteSchema)) dto: MemberDocumentWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MemberDocument> {
    return this.memberDocumentService.create(memberId, dto, currentUser);
  }

  @Post(':documentId/verify')
  @RequirePermission('health.approve')
  @ApiOperation({ operationId: 'verifyMemberDocument', summary: 'Verify a document' })
  @ApiParam({ name: 'id', type: Number })
  @ApiParam({ name: 'documentId', type: Number })
  @ApiResponse({ status: 200, type: MemberDocumentResponseDto })
  async verify(
    @Param('id', ParseIntPipe) memberId: number,
    @Param('documentId', ParseIntPipe) documentId: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MemberDocument> {
    return this.memberDocumentService.verify(memberId, documentId, currentUser);
  }

  @Delete(':documentId')
  @RequirePermission('health.update')
  @HttpCode(204)
  @ApiOperation({ operationId: 'deleteMemberDocument', summary: 'Delete a document row' })
  @ApiParam({ name: 'id', type: Number })
  @ApiParam({ name: 'documentId', type: Number })
  async remove(
    @Param('id', ParseIntPipe) memberId: number,
    @Param('documentId', ParseIntPipe) documentId: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<void> {
    await this.memberDocumentService.remove(memberId, documentId, currentUser);
  }
}
