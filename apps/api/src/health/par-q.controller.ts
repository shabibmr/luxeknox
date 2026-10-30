import { Body, Controller, Get, HttpCode, Param, ParseIntPipe, Patch, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  ParQScreeningDto,
  parQClearanceSchema,
  parQSubmitSchema,
  parQTrainerReviewSchema,
  type ParQClearanceDto,
  type ParQSubmitDto,
  type ParQTrainerReviewDto,
} from './dto/par-q.dto';
import { ParQService } from './par-q.service';

@ApiTags('HEALTH')
@ApiBearerAuth('bearer')
@Controller('members/:id/par-q')
export class ParQController {
  constructor(private readonly service: ParQService) {}

  @Get()
  @RequirePermission('health.read')
  @ApiOperation({ operationId: 'getParQ', summary: 'Get the latest PAR-Q+ screening' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: ParQScreeningDto })
  async getLatest(
    @Param('id', ParseIntPipe) memberId: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ParQScreeningDto> {
    return this.service.getLatest(memberId, currentUser);
  }

  @Post()
  @RequirePermission('health.lifestyle')
  @ApiOperation({ operationId: 'submitParQ', summary: 'Submit a PAR-Q+ questionnaire' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 201, type: ParQScreeningDto })
  async submit(
    @Param('id', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(parQSubmitSchema)) dto: ParQSubmitDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ParQScreeningDto> {
    return this.service.submit(memberId, dto, currentUser);
  }

  @Patch('trainer-review')
  @RequirePermission('health.lifestyle')
  @ApiOperation({
    operationId: 'reviewParQ',
    summary: 'Record trainer screening notes and referral decision',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: ParQScreeningDto })
  async trainerReview(
    @Param('id', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(parQTrainerReviewSchema)) dto: ParQTrainerReviewDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ParQScreeningDto> {
    return this.service.trainerReview(memberId, dto, currentUser);
  }

  @Post('clearance')
  @HttpCode(200)
  @RequirePermission('health.approve')
  @ApiOperation({
    operationId: 'clearParQ',
    summary: 'Clear or reject a PAR-Q+ screening pending medical clearance',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, type: ParQScreeningDto })
  async clear(
    @Param('id', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(parQClearanceSchema)) dto: ParQClearanceDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<ParQScreeningDto> {
    return this.service.clear(memberId, dto, currentUser);
  }
}
