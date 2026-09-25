import { Body, Controller, HttpCode, Param, ParseIntPipe, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  bookRequestSchema,
  cancelBookingRequestSchema,
  type BookRequestDto,
  type CancelBookingRequestDto,
} from './booking.dto';
import { BookingService } from './booking.service';

@ApiTags('SCHED')
@ApiBearerAuth('bearer')
@Controller('schedules')
export class BookingController {
  constructor(private readonly service: BookingService) {}

  @Post(':id/book')
  @RequirePermission('schedules.book')
  @HttpCode(201)
  @ApiOperation({ operationId: 'bookSchedule', summary: 'Book or waitlist a member for a schedule' })
  @ApiParam({ name: 'id', type: Number })
  async book(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(bookRequestSchema)) dto: BookRequestDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.book(id, dto, currentUser);
  }

  @Post(':id/bookings/:memberId/cancel')
  @RequirePermission('schedules.cancel')
  @ApiOperation({ operationId: 'cancelBooking', summary: 'Cancel a member booking' })
  @ApiParam({ name: 'id', type: Number })
  @ApiParam({ name: 'memberId', type: Number })
  async cancelBooking(
    @Param('id', ParseIntPipe) id: number,
    @Param('memberId', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(cancelBookingRequestSchema)) dto: CancelBookingRequestDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.service.cancelBooking(id, memberId, dto, currentUser);
  }
}
