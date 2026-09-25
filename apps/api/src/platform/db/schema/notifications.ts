import {
  bigint,
  boolean,
  index,
  json,
  mysqlEnum,
  mysqlTable,
  text,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { users } from './users';

export const NOTIFICATION_TYPE_CODES = [
  'membership_expiry',
  'session_reminder',
  'payment_due',
  'announcement',
  'freeze_pending',
  'booking_confirmed',
  'booking_cancelled',
  'session_waitlist_promoted',
  'trainer_assigned',
  'broadcast',
] as const;
export type NotificationTypeCode = (typeof NOTIFICATION_TYPE_CODES)[number];

export const DEVICE_PLATFORMS = ['ios', 'android', 'web'] as const;
export type DevicePlatform = (typeof DEVICE_PLATFORMS)[number];

export const BROADCAST_AUDIENCES = ['all_members', 'assigned_clients', 'role'] as const;
export type BroadcastAudience = (typeof BROADCAST_AUDIENCES)[number];

export const DELIVERY_STATUSES = ['pending', 'sent', 'failed'] as const;
export type DeliveryStatus = (typeof DELIVERY_STATUSES)[number];

// 1. Notification Types Catalog
export const notificationTypes = mysqlTable(
  'notification_types',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    type_code: varchar('type_code', { length: 64 }).notNull(),
    template_text: text('template_text').notNull(),
    is_active: boolean('is_active').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('notification_types_type_code_unique').on(table.type_code),
  ],
);

export type NotificationType = typeof notificationTypes.$inferSelect;
export type NewNotificationType = typeof notificationTypes.$inferInsert;

// 2. Notifications Table
export const notifications = mysqlTable(
  'notifications',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    notification_type_id: bigint('notification_type_id', { mode: 'number', unsigned: true })
      .references(() => notificationTypes.id),
    title: varchar('title', { length: 255 }).notNull(),
    message: text('message').notNull(),
    data_payload: json('data_payload').$type<Record<string, unknown> | null>(),
    sender_user_id: bigint('sender_user_id', { mode: 'number', unsigned: true })
      .references(() => users.id),
    is_broadcast: boolean('is_broadcast').notNull().default(false),
    broadcast_audience: mysqlEnum('broadcast_audience', BROADCAST_AUDIENCES),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('notifications_sender_user_id_idx').on(table.sender_user_id),
    index('notifications_notification_type_id_idx').on(table.notification_type_id),
    index('notifications_is_broadcast_created_at_idx').on(table.is_broadcast, table.created_at),
  ],
);

export type Notification = typeof notifications.$inferSelect;
export type NewNotification = typeof notifications.$inferInsert;

// 3. User Devices Table
export const userDevices = mysqlTable(
  'user_devices',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    user_id: bigint('user_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => users.id),
    device_token: varchar('device_token', { length: 512 }).notNull(),
    device_platform: mysqlEnum('device_platform', DEVICE_PLATFORMS).notNull(),
    last_active_at: utcDatetime('last_active_at').notNull(),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('user_devices_token_unique').on(table.device_token),
    index('user_devices_user_id_idx').on(table.user_id),
  ],
);

export type UserDevice = typeof userDevices.$inferSelect;
export type NewUserDevice = typeof userDevices.$inferInsert;

// 4. Notification Deliveries Table
export const notificationDeliveries = mysqlTable(
  'notification_deliveries',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    notification_id: bigint('notification_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => notifications.id),
    user_id: bigint('user_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => users.id),
    status: mysqlEnum('status', DELIVERY_STATUSES).notNull().default('pending'),
    failure_reason: text('failure_reason'),
    retry_count: bigint('retry_count', { mode: 'number' }).notNull().default(0),
    is_read: boolean('is_read').notNull().default(false),
    read_at: utcDatetime('read_at'),
    delivered_at: utcDatetime('delivered_at'),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    uniqueIndex('notification_deliveries_notif_user_unique').on(
      table.notification_id,
      table.user_id,
    ),
    index('notification_deliveries_user_read_created_idx').on(
      table.user_id,
      table.is_read,
      table.created_at,
    ),
    index('notification_deliveries_status_retry_idx').on(table.status, table.retry_count),
  ],
);

export type NotificationDelivery = typeof notificationDeliveries.$inferSelect;
export type NewNotificationDelivery = typeof notificationDeliveries.$inferInsert;
