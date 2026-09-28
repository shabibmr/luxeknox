import { z } from 'zod';
import {
  BROADCAST_AUDIENCES,
  DEVICE_PLATFORMS,
  type BroadcastAudience,
  type DevicePlatform,
} from '../platform/db/schema/notifications';

// ==================== Notification / Inbox DTOs ====================

export const notificationFilterQuerySchema = z.object({
  limit: z.coerce.number().int().positive().max(100).optional().default(20),
  cursor: z.string().optional(),
});

export type NotificationFilterQueryDto = z.output<typeof notificationFilterQuerySchema>;

export const broadcastRequestSchema = z.object({
  title: z.string().trim().min(1).max(255),
  message: z.string().trim().min(1),
  notification_type_id: z.coerce.number().int().positive().optional(),
  data_payload: z.record(z.unknown()).optional().nullable(),
  audience: z.enum(BROADCAST_AUDIENCES).optional().default('all_members'),
  role_id: z.coerce.number().int().positive().optional(),
});

export type BroadcastRequestDto = z.input<typeof broadcastRequestSchema>;

export const broadcastListQuerySchema = z.object({
  limit: z.coerce.number().int().positive().max(100).optional().default(20),
  offset: z.coerce.number().int().min(0).optional().default(0),
});

export type BroadcastListQueryDto = z.output<typeof broadcastListQuerySchema>;

// ==================== Device DTOs ====================

export const deviceWriteSchema = z.object({
  device_token: z.string().trim().min(1).max(512),
  device_platform: z.enum(DEVICE_PLATFORMS),
});

export type DeviceWriteDto = z.input<typeof deviceWriteSchema>;
