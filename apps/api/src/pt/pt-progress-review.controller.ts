import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Res,
  StreamableFile,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiProduces, ApiTags } from '@nestjs/swagger';
import type { Response } from 'express';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { PtProgressReviewPdfService } from './pt-progress-review-pdf.service';
import {
  PtProgressReviewService,
  ptProgressReviewDraftEditSchema,
  ptProgressReviewDraftSchema,
  type PtProgressReviewDraftDto,
  type PtProgressReviewDraftEditDto,
} from './pt-progress-review.service';

@ApiTags('PT')
@ApiBearerAuth('bearer')
@Controller()
export class PtProgressReviewController {
  constructor(
    private readonly service: PtProgressReviewService,
    private readonly pdfService: PtProgressReviewPdfService,
  ) {}

  @Post('members/:memberId/pt-reviews')
  @RequirePermission('pt_reviews.write')
  @ApiOperation({ operationId: 'createPtProgressReviewDraft', summary: 'Draft a PT progress review' })
  @ApiParam({ name: 'memberId', type: Number })
  createDraft(
    @Param('memberId', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(ptProgressReviewDraftSchema)) dto: PtProgressReviewDraftDto,
    @CurrentUser() actor: AuthenticatedUser,
  ) {
    return this.service.createDraft(memberId, dto, actor);
  }

  @Get('reviews/:id')
  @RequirePermission('pt_reviews.read')
  @ApiOperation({ operationId: 'getPtProgressReview', summary: 'Get a PT progress review' })
  @ApiParam({ name: 'id', type: Number })
  get(@Param('id', ParseIntPipe) id: number, @CurrentUser() actor: AuthenticatedUser) {
    return this.service.get(id, actor);
  }

  @Patch('reviews/:id')
  @RequirePermission('pt_reviews.write')
  @ApiOperation({
    operationId: 'updatePtProgressReviewDraft',
    summary: 'Save the presentation card of a draft review',
  })
  @ApiParam({ name: 'id', type: Number })
  updateDraft(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(ptProgressReviewDraftEditSchema)) dto: PtProgressReviewDraftEditDto,
    @CurrentUser() actor: AuthenticatedUser,
  ) {
    return this.service.updateDraft(id, dto, actor);
  }

  @Get('reviews/:id/export-pdf')
  @RequirePermission('pt_reviews.read')
  @ApiOperation({
    operationId: 'exportPtProgressReviewPdf',
    summary: 'Export the review presentation card as PDF',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiProduces('application/pdf')
  async exportPdf(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() actor: AuthenticatedUser,
    @Res({ passthrough: true }) res: Response,
  ): Promise<StreamableFile> {
    const { filename, buffer } = await this.pdfService.exportPresentationCard(id, actor);
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
    return new StreamableFile(buffer);
  }

  @Patch('reviews/:id/trainer-sign')
  @RequirePermission('pt_reviews.write')
  @ApiOperation({ operationId: 'trainerSignPtProgressReview', summary: 'Trainer signs a draft review' })
  @ApiParam({ name: 'id', type: Number })
  trainerSign(@Param('id', ParseIntPipe) id: number, @CurrentUser() actor: AuthenticatedUser) {
    return this.service.trainerSign(id, actor);
  }

  @Patch('reviews/:id/client-sign')
  @RequirePermission('pt_reviews.client_sign')
  @ApiOperation({ operationId: 'clientSignPtProgressReview', summary: 'Client signs a review' })
  @ApiParam({ name: 'id', type: Number })
  clientSign(@Param('id', ParseIntPipe) id: number, @CurrentUser() actor: AuthenticatedUser) {
    return this.service.clientSign(id, actor);
  }

  @Patch('reviews/:id/manager-approve')
  @RequirePermission('pt_reviews.approve')
  @ApiOperation({ operationId: 'managerApprovePtProgressReview', summary: 'Manager approves a review' })
  @ApiParam({ name: 'id', type: Number })
  managerApprove(@Param('id', ParseIntPipe) id: number, @CurrentUser() actor: AuthenticatedUser) {
    return this.service.managerApprove(id, actor);
  }
}
