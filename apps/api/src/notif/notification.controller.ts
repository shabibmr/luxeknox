import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseIntPipe,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthGuard, type AuthenticatedUser } from '../auth/auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { PermissionGuard } from '../rbac/permission.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { NotificationService } from './notification.service';
import {
  broadcastListQuerySchema,
  broadcastRequestSchema,
  deviceWriteSchema,
  notificationFilterQuerySchema,
  type BroadcastListQueryDto,
  type BroadcastRequestDto,
  type DeviceWriteDto,
  type NotificationFilterQueryDto,
} from './notification.dto';

@ApiTags('NOTIF')
@ApiBearerAuth('bearer')
@Controller('notifications')
@UseGuards(AuthGuard, PermissionGuard)
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  @Get()
  @ApiOperation({ operationId: 'listNotifications', summary: 'Inbox' })
  @ApiResponse({ status: 200, description: 'OK' })
  @RequirePermission('notifications.read')
  async listNotifications(
    @CurrentUser() user: AuthenticatedUser,
    @Query(new ZodValidationPipe(notificationFilterQuerySchema)) query: NotificationFilterQueryDto,
  ) {
    return this.notificationService.getInbox(user, query);
  }

  @Get('broadcasts')
  @ApiOperation({ operationId: 'listBroadcasts', summary: 'Sent broadcasts' })
  @ApiResponse({ status: 200, description: 'OK' })
  @RequirePermission('notifications.broadcast')
  async listBroadcasts(
    @CurrentUser() user: AuthenticatedUser,
    @Query(new ZodValidationPipe(broadcastListQuerySchema)) query: BroadcastListQueryDto,
  ) {
    return this.notificationService.listBroadcasts(user, query);
  }

  @Get(':id')
  @ApiOperation({ operationId: 'getNotification', summary: 'Notification detail' })
  @ApiResponse({ status: 200, description: 'OK' })
  @RequirePermission('notifications.read')
  async getNotification(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.notificationService.getNotificationDetail(user, id);
  }

  @Post(':id/read')
  @ApiOperation({ operationId: 'markNotificationRead', summary: 'Mark one notification read' })
  @ApiResponse({ status: 200, description: 'OK' })
  @RequirePermission('notifications.update')
  async markNotificationRead(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.notificationService.markAsRead(user, id);
  }

  @Post('read-all')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ operationId: 'markAllNotificationsRead', summary: 'Mark all read' })
  @ApiResponse({ status: 204, description: 'No content' })
  @RequirePermission('notifications.update')
  async markAllNotificationsRead(@CurrentUser() user: AuthenticatedUser) {
    await this.notificationService.markAllAsRead(user);
  }

  @Post('broadcast')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    operationId: 'broadcastNotification',
    summary: 'Broadcast to a role-scoped audience',
  })
  @ApiResponse({ status: 201, description: 'OK' })
  @RequirePermission('notifications.broadcast')
  async broadcast(
    @CurrentUser() user: AuthenticatedUser,
    @Body(new ZodValidationPipe(broadcastRequestSchema)) dto: BroadcastRequestDto,
  ) {
    return this.notificationService.broadcast(user, dto);
  }
}

@ApiTags('NOTIF')
@ApiBearerAuth('bearer')
@Controller('devices')
@UseGuards(AuthGuard, PermissionGuard)
export class DeviceController {
  constructor(private readonly notificationService: NotificationService) {}

  @Get()
  @ApiOperation({
    operationId: 'listDevices',
    summary: 'Registered push devices for the current user',
  })
  @ApiResponse({ status: 200, description: 'OK' })
  @RequirePermission('notifications.read')
  async listDevices(@CurrentUser() user: AuthenticatedUser) {
    const devices = await this.notificationService.listDevices(user);
    return {
      data: devices,
      meta: {
        limit: devices.length,
        has_more: false,
      },
    };
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ operationId: 'registerDevice', summary: 'Register a push token' })
  @ApiResponse({ status: 201, description: 'OK' })
  @RequirePermission('notifications.update')
  async registerDevice(
    @CurrentUser() user: AuthenticatedUser,
    @Body(new ZodValidationPipe(deviceWriteSchema)) dto: DeviceWriteDto,
  ) {
    return this.notificationService.registerDevice(user, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ operationId: 'deleteDevice', summary: 'Unregister a device' })
  @ApiResponse({ status: 204, description: 'No content' })
  @RequirePermission('notifications.update')
  async deleteDevice(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', ParseIntPipe) id: number,
  ) {
    await this.notificationService.deleteDevice(user, id);
  }
}
