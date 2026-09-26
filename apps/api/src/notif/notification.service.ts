import {
  Injectable,
  Logger,
} from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import { DomainEventBus } from '../platform/events/domain-events';
import {
  BadRequestError,
  ForbiddenError,
  NotFoundError,
} from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import type { UserDevice } from '../platform/db/schema/notifications';
import {
  NotificationRepository,
  type BroadcastItem,
  type InboxItem,
} from './notification.repository';
import { PushDispatcherAdapter } from './push-dispatcher.adapter';
import type {
  BroadcastListQueryDto,
  BroadcastRequestDto,
  DeviceWriteDto,
  NotificationFilterQueryDto,
} from './notification.dto';

export interface DispatchNotificationOptions {
  recipientUserIds: number[];
  title: string;
  message: string;
  typeCode?: string;
  dataPayload?: Record<string, unknown> | null;
  senderUserId?: number | null;
  isBroadcast?: boolean;
  broadcastAudience?: 'all_members' | 'assigned_clients' | 'role';
}

@Injectable()
export class NotificationService {
  private readonly logger = new Logger(NotificationService.name);

  constructor(
    private readonly repository: NotificationRepository,
    private readonly pushDispatcher: PushDispatcherAdapter,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
    private readonly eventBus: DomainEventBus,
  ) {}

  // ==================== Dispatch Pipeline ====================

  /**
   * Primary notification creation and dispatch pipeline.
   * Guarantees delivery records for recipient user IDs (deduplicated),
   * pushes to active user devices, and tracks delivery state.
   */
  async dispatch(options: DispatchNotificationOptions): Promise<number> {
    const {
      recipientUserIds,
      title,
      message,
      typeCode,
      dataPayload = null,
      senderUserId = null,
      isBroadcast = false,
      broadcastAudience,
    } = options;

    const uniqueRecipients = Array.from(new Set(recipientUserIds)).filter((id) => id > 0);
    if (uniqueRecipients.length === 0) {
      this.logger.debug(`No valid recipients to dispatch notification "${title}"`);
      return 0;
    }

    let typeId: number | null = null;
    if (typeCode) {
      const notifType = await this.repository.findTypeByCode(typeCode);
      if (notifType) {
        typeId = notifType.id;
      }
    }

    const now = new Date();

    // 1. Create central notification record
    const notificationId = await this.repository.insertNotification({
      notification_type_id: typeId,
      title,
      message,
      data_payload: dataPayload,
      sender_user_id: senderUserId,
      is_broadcast: isBroadcast,
      broadcast_audience: broadcastAudience ?? null,
      created_at: now,
    });

    // 2. Create deliveries for all recipients
    const deliveryRows = uniqueRecipients.map((userId) => ({
      notification_id: notificationId,
      user_id: userId,
      status: 'pending' as const,
      failure_reason: null,
      retry_count: 0,
      is_read: false,
      read_at: null,
      delivered_at: null,
      created_at: now,
    }));

    await this.repository.insertDeliveries(deliveryRows);

    // 3. Trigger asynchronous push delivery to registered devices
    for (const userId of uniqueRecipients) {
      this.sendPushToUser(userId, notificationId, title, message, dataPayload).catch((err) => {
        this.logger.error(`Error sending push to user ${userId}: ${err.message}`);
      });
    }

    return notificationId;
  }

  /**
   * Sends push notifications to all registered devices of a user.
   */
  async sendPushToUser(
    userId: number,
    notificationId: number,
    title: string,
    message: string,
    dataPayload?: Record<string, unknown> | null,
  ): Promise<void> {
    const devices = await this.repository.findDevicesByUserId(userId);
    const delivery = await this.repository.findDelivery(notificationId, userId);
    if (!delivery) return;

    if (devices.length === 0) {
      // No devices registered, marked as sent (inbox delivered)
      await this.repository.updateDeliveryStatus(delivery.id, 'sent', {
        deliveredAt: new Date(),
      });
      return;
    }

    let allFailed = true;
    let lastError: string | null = null;

    for (const device of devices) {
      try {
        const result = await this.pushDispatcher.send({
          deviceToken: device.device_token,
          platform: device.device_platform,
          title,
          body: message,
          data: dataPayload,
        });

        if (result.success) {
          allFailed = false;
        } else {
          lastError = result.errorMessage ?? 'Unknown push error';
        }
      } catch (err: any) {
        lastError = err?.message ?? String(err);
      }
    }

    if (allFailed) {
      await this.repository.updateDeliveryStatus(delivery.id, 'failed', {
        failureReason: lastError,
        retryCount: delivery.retry_count + 1,
      });
    } else {
      await this.repository.updateDeliveryStatus(delivery.id, 'sent', {
        deliveredAt: new Date(),
      });
    }
  }

  // ==================== User Inbox ====================

  async getInbox(
    user: AuthenticatedUser,
    query: NotificationFilterQueryDto,
  ): Promise<PaginatedResponse<InboxItem>> {
    const limit = await this.paginationHelper.resolveLimit(query.limit);
    let cursorObj: { createdAt: string; id: number } | undefined;

    if (query.cursor) {
      const decoded = this.paginationHelper.normalizeParams({ cursor: query.cursor, limit });
      const params = await decoded;
      if (params.mode === 'cursor' && params.cursor) {
        cursorObj = {
          createdAt: params.cursor.createdAt,
          id: params.cursor.id,
        };
      }
    }

    // Over-fetch by 1 to detect next page cursor
    const items = await this.repository.findUserInbox(user.id, limit + 1, cursorObj);

    return createPaginatedResponse({
      items,
      limit,
      requestCursor: query.cursor ?? null,
      cursorExtractor: (item) => ({
        createdAt: item.created_at.toISOString(),
        id: item.id,
      }),
    });
  }

  async getNotificationDetail(user: AuthenticatedUser, id: number): Promise<InboxItem> {
    const item = await this.repository.findUserInboxItem(user.id, id);
    if (!item) {
      throw new NotFoundError(`Notification with ID ${id} not found in inbox`);
    }
    return item;
  }

  async markAsRead(user: AuthenticatedUser, id: number): Promise<InboxItem> {
    const now = new Date();
    const updated = await this.repository.markDeliveryRead(user.id, id, now);
    if (!updated) {
      throw new NotFoundError(`Notification with ID ${id} not found in inbox`);
    }
    return this.getNotificationDetail(user, id);
  }

  async markAllAsRead(user: AuthenticatedUser): Promise<void> {
    const now = new Date();
    await this.repository.markAllDeliveriesRead(user.id, now);
  }

  // ==================== Devices ====================

  async listDevices(user: AuthenticatedUser): Promise<UserDevice[]> {
    return this.repository.findDevicesByUserId(user.id);
  }

  async registerDevice(user: AuthenticatedUser, dto: DeviceWriteDto): Promise<UserDevice> {
    const now = new Date();
    return this.repository.upsertDevice({
      user_id: user.id,
      device_token: dto.device_token,
      device_platform: dto.device_platform,
      last_active_at: now,
      created_at: now,
      updated_at: now,
    });
  }

  async deleteDevice(user: AuthenticatedUser, id: number): Promise<void> {
    const deleted = await this.repository.deleteDevice(id, user.id);
    if (!deleted) {
      throw new NotFoundError(`Device with ID ${id} not found for this account`);
    }
  }

  // ==================== Broadcasts ====================

  async broadcast(user: AuthenticatedUser, dto: BroadcastRequestDto): Promise<BroadcastItem> {
    let recipientUserIds: number[] = [];

    const audience = dto.audience ?? 'all_members';

    if (audience === 'assigned_clients') {
      if (user.userType !== 'trainer' && user.userType !== 'admin') {
        throw new ForbiddenError('Only trainers or administrators can broadcast to assigned clients');
      }
      if (user.userType === 'trainer') {
        if (!user.profileId) {
          throw new BadRequestError('Trainer profile not associated with this account');
        }
        recipientUserIds = await this.repository.findActiveAssignedClientUserIds(user.profileId);
      } else {
        // Admin broadcast to all assigned clients -> all members
        recipientUserIds = await this.repository.findAllActiveMemberUserIds();
      }
    } else if (audience === 'role') {
      if (user.userType !== 'admin') {
        throw new ForbiddenError('Only administrators can broadcast by role');
      }
      if (!dto.role_id) {
        throw new BadRequestError('role_id is required when audience is "role"');
      }
      recipientUserIds = await this.repository.findActiveUserIdsForRole(dto.role_id);
    } else {
      // all_members
      if (user.userType !== 'admin') {
        throw new ForbiddenError('Only administrators can broadcast to all members');
      }
      recipientUserIds = await this.repository.findAllActiveMemberUserIds();
    }

    const notifId = await this.dispatch({
      recipientUserIds,
      title: dto.title,
      message: dto.message,
      typeCode: 'broadcast',
      dataPayload: dto.data_payload,
      senderUserId: user.id,
      isBroadcast: true,
      broadcastAudience: audience,
    });

    const notif = await this.repository.findNotificationById(notifId);
    if (!notif) {
      throw new NotFoundError('Failed to retrieve created broadcast');
    }

    await this.auditService.recordAudit({
      actorUserId: user.id,
      action: 'notification.broadcast',
      entityName: 'notifications',
      entityId: notifId,
      beforeState: null,
      afterState: {
        title: dto.title,
        audience,
        recipient_count: recipientUserIds.length,
      },
    });

    return {
      id: notif.id,
      notification_type_id: notif.notification_type_id,
      title: notif.title,
      message: notif.message,
      data_payload: notif.data_payload,
      sender_user_id: notif.sender_user_id,
      created_at: notif.created_at,
    };
  }

  async listBroadcasts(
    user: AuthenticatedUser,
    query: BroadcastListQueryDto,
  ): Promise<PaginatedResponse<BroadcastItem>> {
    const limit = await this.paginationHelper.resolveLimit(query.limit);
    const offset = query.offset ?? 0;

    // Trainers see only their own broadcasts; admins see all broadcasts
    const senderUserId = user.userType === 'trainer' ? user.id : undefined;

    const { rows, total } = await this.repository.findBroadcasts(limit, offset, senderUserId);

    return createPaginatedResponse({
      items: rows,
      limit,
      offset,
      total,
    });
  }

  // ==================== Retry Worker ====================

  async retryFailedDeliveries(maxRetryCount = 3): Promise<number> {
    const failedDeliveries = await this.repository.findFailedDeliveries(maxRetryCount, 50);
    let retried = 0;

    for (const delivery of failedDeliveries) {
      const notif = await this.repository.findNotificationById(delivery.notification_id);
      if (!notif) continue;

      await this.sendPushToUser(
        delivery.user_id,
        delivery.notification_id,
        notif.title,
        notif.message,
        notif.data_payload,
      );
      retried++;
    }

    return retried;
  }
}
