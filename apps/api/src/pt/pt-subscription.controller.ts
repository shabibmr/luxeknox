import { Body, Controller, Get, Param, ParseIntPipe, Post, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiHeader,
  ApiOperation,
  ApiParam,
  ApiProperty,
  ApiQuery,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { UseIdempotency } from '../platform/idempotency/idempotency.interceptor';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { RequirePermission } from '../rbac/require-permission.decorator';
import {
  ptChangeSlotSchema,
  ptPaymentPreviewQuerySchema,
  ptPurchaseSchema,
  ptReassignTrainerSchema,
  ptRenewSchema,
  ptScheduleGridQuerySchema,
  type PtChangeSlotDto,
  type PtPurchaseDto,
  type PtReassignTrainerDto,
  type PtRenewDto,
} from './pt.dto';
import { BadRequestError } from '../platform/errors/app-error';
import { PtScheduleService } from './pt-schedule.service';
import { PtSubscriptionService } from './pt-subscription.service';

/** CP-06 Swagger response shape for PT subscription reads. */
export class PtSubscriptionResponseDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: Number }) member_id!: number;
  @ApiProperty({ type: Number }) pt_product_id!: number;
  @ApiProperty({ type: String }) product_name!: string;
  @ApiProperty({ type: String, enum: ['single', 'couple'] }) package_type!: 'single' | 'couple';
  @ApiProperty({ type: Number }) trainer_id!: number;
  @ApiProperty({ type: String }) trainer_name!: string;
  @ApiProperty({ type: String }) start_date!: string;
  @ApiProperty({ type: String }) end_date!: string;
  @ApiProperty({ type: [Number] }) weekdays!: number[];
  @ApiProperty({ type: Number }) sessions_per_week!: number;
  @ApiProperty({ type: String }) slot_start!: string;
  @ApiProperty({ type: String }) slot_label!: string;
  @ApiProperty({ type: String }) status!: string;
  @ApiProperty({ type: Boolean }) is_primary!: boolean;
  @ApiProperty({ type: Number, nullable: true }) partner_subscription_id!: number | null;
  @ApiProperty({ type: Number, nullable: true }) partner_member_id!: number | null;
  @ApiProperty({ type: String, nullable: true }) partner_member_name!: string | null;
}

@ApiTags('PT')
@ApiBearerAuth('bearer')
@Controller()
export class PtSubscriptionController {
  constructor(
    private readonly service: PtSubscriptionService,
    private readonly scheduleService: PtScheduleService,
  ) {}

  @Get('pt/schedule-grid')
  @RequirePermission('pt_subscriptions.create')
  @ApiOperation({
    operationId: 'getPtScheduleGrid',
    summary: 'Hours × active trainers occupancy for a PT package, start date and weekdays',
  })
  @ApiQuery({ name: 'member_id', required: true, type: Number })
  @ApiQuery({ name: 'pt_product_id', required: true, type: Number })
  @ApiQuery({ name: 'start_date', required: true, type: String })
  @ApiQuery({ name: 'weekdays', required: true, type: String, description: 'CSV of 0–6' })
  @ApiQuery({ name: 'partner_member_id', required: false, type: Number })
  @ApiQuery({ name: 'exclude_subscription_id', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'OK' })
  grid(@Query() rawQuery: Record<string, unknown>) {
    const parsed = ptScheduleGridQuerySchema.safeParse(rawQuery);
    if (!parsed.success) {
      throw new BadRequestError('Validation failed', parsed.error.errors);
    }
    return this.scheduleService.buildGrid(parsed.data);
  }

  @Get('pt/payment-preview')
  @RequirePermission('pt_subscriptions.create')
  @ApiOperation({
    operationId: 'getPtPaymentPreview',
    summary: 'Subtotal, discount, tax and total a PT sale would charge',
  })
  @ApiQuery({ name: 'pt_product_id', required: true, type: Number })
  @ApiQuery({ name: 'discount_amount', required: false, type: String })
  @ApiResponse({ status: 200, description: 'OK' })
  paymentPreview(@Query() rawQuery: Record<string, unknown>) {
    const parsed = ptPaymentPreviewQuerySchema.safeParse(rawQuery);
    if (!parsed.success) {
      throw new BadRequestError('Validation failed', parsed.error.errors);
    }
    return this.service.previewPayment(parsed.data);
  }

  @Post('pt-subscriptions')
  @RequirePermission('pt_subscriptions.create')
  @UseIdempotency()
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Replays the original result if a timed-out sale is retried',
  })
  @ApiOperation({
    operationId: 'purchasePtSubscription',
    summary: 'Sell PT: assign trainer + fixed weekly slot, take payment, generate sessions',
  })
  @ApiResponse({ status: 201, description: 'Created', type: PtSubscriptionResponseDto })
  @ApiResponse({ status: 409, description: 'Slot not free for the whole period / member already has PT' })
  @ApiResponse({ status: 422, description: 'Membership expired, payment insufficient' })
  purchase(
    @Body(new ZodValidationPipe(ptPurchaseSchema)) dto: PtPurchaseDto,
    @CurrentUser() actor: AuthenticatedUser,
  ) {
    return this.service.purchase(dto, actor);
  }

  @Get('pt-subscriptions/:id')
  @RequirePermission('pt_subscriptions.read')
  @ApiOperation({ operationId: 'getPtSubscription', summary: 'PT subscription detail' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: PtSubscriptionResponseDto })
  getById(@Param('id', ParseIntPipe) id: number, @CurrentUser() actor: AuthenticatedUser) {
    return this.service.getById(id, actor);
  }

  @Post('pt-subscriptions/:id/renew')
  @RequirePermission('pt_subscriptions.create')
  @ApiOperation({ operationId: 'renewPtSubscription', summary: 'Renew PT with the same trainer and slot' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 201, description: 'Created' })
  renew(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(ptRenewSchema)) dto: PtRenewDto,
    @CurrentUser() actor: AuthenticatedUser,
  ) {
    return this.service.renew(id, dto, actor);
  }

  @Post('pt-subscriptions/:id/reassign-trainer')
  @RequirePermission('pt_subscriptions.manage')
  @ApiOperation({ operationId: 'reassignPtTrainer', summary: 'Move remaining PT sessions to another trainer' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK' })
  reassignTrainer(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(ptReassignTrainerSchema)) dto: PtReassignTrainerDto,
    @CurrentUser() actor: AuthenticatedUser,
  ) {
    return this.service.reassignTrainer(id, dto, actor);
  }

  @Post('pt-subscriptions/:id/change-slot')
  @RequirePermission('pt_subscriptions.manage')
  @ApiOperation({ operationId: 'changePtSlot', summary: 'Move remaining PT sessions to other weekdays/hour' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK' })
  changeSlot(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(ptChangeSlotSchema)) dto: PtChangeSlotDto,
    @CurrentUser() actor: AuthenticatedUser,
  ) {
    return this.service.changeSlot(id, dto, actor);
  }

  @Get('members/:id/pt-subscriptions')
  @RequirePermission('pt_subscriptions.read')
  @ApiOperation({
    operationId: 'getMemberPtSummary',
    summary: "Member's current PT, PT history, and the calling trainer's access level",
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK' })
  memberSummary(@Param('id', ParseIntPipe) id: number, @CurrentUser() actor: AuthenticatedUser) {
    return this.service.summaryForMember(id, actor);
  }
}
