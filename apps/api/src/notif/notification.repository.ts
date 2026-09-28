import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, inArray, lt, sql, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import {
  notifications,
  notificationDeliveries,
  userDevices,
  notificationTypes,
  type Notification,
  type NewNotification,
  type NotificationDelivery,
  type NewNotificationDelivery,
  type UserDevice,
  type NewUserDevice,
  type NotificationType,
  type DeliveryStatus,
} from '../platform/db/schema/notifications';
import { users } from '../platform/db/schema/users';
import { members } from '../platform/db/schema/members';

export interface InboxItem {
  id: number;
  notification_type_id: number | null;
  title: string;
  message: string;
  data_payload: Record<string, unknown> | null;
  sender_user_id: number | null;
  created_at: Date;
  is_read: boolean;
  read_at: Date | null;
}

export interface BroadcastItem {
  id: number;
  notification_type_id: number | null;
  title: string;
  message: string;
  data_payload: Record<string, unknown> | null;
  sender_user_id: number | null;
  created_at: Date;
}

@Injectable()
export class NotificationRepository extends BaseRepository<
  typeof notifications,
  Notification,
  NewNotification
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, notifications);
  }

  // ==================== Notification Queries ====================

  async findNotificationById(id: number): Promise<Notification | null> {
    return this.findById(id);
  }

  async insertNotification(data: NewNotification): Promise<number> {
    const result = await this.create(data);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async findUserInbox(
    userId: number,
    limit: number,
    cursor?: { createdAt: string; id: number },
  ): Promise<InboxItem[]> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [eq(notificationDeliveries.user_id, userId)];

    if (cursor) {
      const cursorDate = new Date(cursor.createdAt);
      conditions.push(
        sql`(${notifications.created_at} < ${cursorDate} OR (${notifications.created_at} = ${cursorDate} AND ${notifications.id} < ${cursor.id}))`,
      );
    }

    const rows = await db
      .select({
        id: notifications.id,
        notification_type_id: notifications.notification_type_id,
        title: notifications.title,
        message: notifications.message,
        data_payload: notifications.data_payload,
        sender_user_id: notifications.sender_user_id,
        created_at: notifications.created_at,
        is_read: notificationDeliveries.is_read,
        read_at: notificationDeliveries.read_at,
      })
      .from(notificationDeliveries)
      .innerJoin(notifications, eq(notificationDeliveries.notification_id, notifications.id))
      .where(and(...conditions))
      .orderBy(desc(notifications.created_at), desc(notifications.id))
      .limit(limit);

    return rows as InboxItem[];
  }

  async findUserInboxItem(userId: number, notificationId: number): Promise<InboxItem | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select({
        id: notifications.id,
        notification_type_id: notifications.notification_type_id,
        title: notifications.title,
        message: notifications.message,
        data_payload: notifications.data_payload,
        sender_user_id: notifications.sender_user_id,
        created_at: notifications.created_at,
        is_read: notificationDeliveries.is_read,
        read_at: notificationDeliveries.read_at,
      })
      .from(notificationDeliveries)
      .innerJoin(notifications, eq(notificationDeliveries.notification_id, notifications.id))
      .where(
        and(
          eq(notificationDeliveries.user_id, userId),
          eq(notificationDeliveries.notification_id, notificationId),
        ),
      )
      .limit(1);

    return (rows[0] as InboxItem) ?? null;
  }

  async markDeliveryRead(userId: number, notificationId: number, readAt: Date): Promise<boolean> {
    const db = this.getDb() as any;
    const result = await db
      .update(notificationDeliveries)
      .set({
        is_read: true,
        read_at: readAt,
      })
      .where(
        and(
          eq(notificationDeliveries.user_id, userId),
          eq(notificationDeliveries.notification_id, notificationId),
        ),
      );
    return Number(result[0]?.affectedRows ?? 0) > 0;
  }

  async markAllDeliveriesRead(userId: number, readAt: Date): Promise<number> {
    const db = this.getDb() as any;
    const result = await db
      .update(notificationDeliveries)
      .set({
        is_read: true,
        read_at: readAt,
      })
      .where(
        and(
          eq(notificationDeliveries.user_id, userId),
          eq(notificationDeliveries.is_read, false),
        ),
      );
    return Number(result[0]?.affectedRows ?? 0);
  }

  // ==================== Deliveries ====================

  async insertDeliveries(items: NewNotificationDelivery[]): Promise<void> {
    if (items.length === 0) return;
    const db = this.getDb() as any;
    await db.insert(notificationDeliveries).values(items);
  }

  async findDelivery(notificationId: number, userId: number): Promise<NotificationDelivery | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(notificationDeliveries)
      .where(
        and(
          eq(notificationDeliveries.notification_id, notificationId),
          eq(notificationDeliveries.user_id, userId),
        ),
      )
      .limit(1);
    return (rows[0] as NotificationDelivery) ?? null;
  }

  async updateDeliveryStatus(
    id: number,
    status: DeliveryStatus,
    options?: { failureReason?: string | null; deliveredAt?: Date | null; retryCount?: number },
  ): Promise<void> {
    const db = this.getDb() as any;
    const patch: Record<string, unknown> = { status };
    if (options?.failureReason !== undefined) patch.failure_reason = options.failureReason;
    if (options?.deliveredAt !== undefined) patch.delivered_at = options.deliveredAt;
    if (options?.retryCount !== undefined) patch.retry_count = options.retryCount;

    await db.update(notificationDeliveries).set(patch).where(eq(notificationDeliveries.id, id));
  }

  async findFailedDeliveries(maxRetryCount: number, limit = 100): Promise<NotificationDelivery[]> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(notificationDeliveries)
      .where(
        and(
          eq(notificationDeliveries.status, 'failed'),
          lt(notificationDeliveries.retry_count, maxRetryCount),
        ),
      )
      .limit(limit);
    return rows as NotificationDelivery[];
  }

  // ==================== User Devices ====================

  async findDevicesByUserId(userId: number): Promise<UserDevice[]> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(userDevices)
      .where(eq(userDevices.user_id, userId))
      .orderBy(desc(userDevices.last_active_at));
    return rows as UserDevice[];
  }

  async findDeviceById(id: number): Promise<UserDevice | null> {
    const db = this.getDb() as any;
    const rows = await db.select().from(userDevices).where(eq(userDevices.id, id)).limit(1);
    return (rows[0] as UserDevice) ?? null;
  }

  async upsertDevice(data: NewUserDevice): Promise<UserDevice> {
    const db = this.getDb() as any;
    await db
      .insert(userDevices)
      .values(data)
      .onDuplicateKeyUpdate({
        set: {
          user_id: sql`VALUES(\`user_id\`)`,
          device_platform: sql`VALUES(\`device_platform\`)`,
          last_active_at: sql`VALUES(\`last_active_at\`)`,
          updated_at: new Date(),
        },
      });

    const rows = await db
      .select()
      .from(userDevices)
      .where(eq(userDevices.device_token, data.device_token))
      .limit(1);
    return rows[0] as UserDevice;
  }

  async deleteDevice(id: number, userId: number): Promise<boolean> {
    const db = this.getDb() as any;
    const result = await db
      .delete(userDevices)
      .where(and(eq(userDevices.id, id), eq(userDevices.user_id, userId)));
    return Number(result[0]?.affectedRows ?? 0) > 0;
  }

  // ==================== Broadcasts ====================

  async findBroadcasts(limit: number, offset: number, senderUserId?: number): Promise<{ rows: BroadcastItem[]; total: number }> {
    const db = this.getDb() as any;
    const conditions: SQL[] = [eq(notifications.is_broadcast, true)];
    if (senderUserId !== undefined) {
      conditions.push(eq(notifications.sender_user_id, senderUserId));
    }

    const where = and(...conditions);

    const [rows, countRows] = await Promise.all([
      db
        .select({
          id: notifications.id,
          notification_type_id: notifications.notification_type_id,
          title: notifications.title,
          message: notifications.message,
          data_payload: notifications.data_payload,
          sender_user_id: notifications.sender_user_id,
          created_at: notifications.created_at,
        })
        .from(notifications)
        .where(where)
        .orderBy(desc(notifications.created_at))
        .limit(limit)
        .offset(offset),
      db
        .select({ count: sql<number>`count(*)` })
        .from(notifications)
        .where(where),
    ]);

    return {
      rows: rows as BroadcastItem[],
      total: Number(countRows[0]?.count ?? 0),
    };
  }

  // ==================== Audience Resolution (Active Users Only) ====================

  async findActiveUserIdsForRole(roleId: number): Promise<number[]> {
    const db = this.getDb() as any;
    const rows = await db
      .select({ id: users.id })
      .from(users)
      .where(and(eq(users.role_id, roleId), eq(users.status, 'active')));
    return rows.map((r: { id: number }) => r.id);
  }

  async findAllActiveMemberUserIds(): Promise<number[]> {
    const db = this.getDb() as any;
    const rows = await db
      .select({ userId: users.id })
      .from(users)
      .innerJoin(members, eq(members.user_id, users.id))
      .where(eq(users.status, 'active'));
    return rows.map((r: { userId: number }) => r.userId);
  }

  async findActiveAssignedClientUserIds(trainerProfileId: number): Promise<number[]> {
    const db = this.getDb() as any;
    const rows = await db
      .select({ userId: users.id })
      .from(users)
      .innerJoin(members, eq(members.user_id, users.id))
      .where(
        and(
          eq(members.assigned_trainer_id, trainerProfileId),
          eq(users.status, 'active'),
        ),
      );
    return rows.map((r: { userId: number }) => r.userId);
  }

  // ==================== Notification Type Lookup ====================

  async findTypeByCode(typeCode: string): Promise<NotificationType | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select()
      .from(notificationTypes)
      .where(eq(notificationTypes.type_code, typeCode))
      .limit(1);
    return (rows[0] as NotificationType) ?? null;
  }
}
