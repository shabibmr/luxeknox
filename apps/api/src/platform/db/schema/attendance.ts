import {
  bigint,
  boolean,
  date,
  index,
  int,
  mysqlTable,
  text,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { users } from './users';

/**
 * `AttendanceMethod` per OpenAPI: how a check-in/check-out event was captured.
 */
export const ATTENDANCE_METHODS = ['qr_code', 'rfid', 'biometric', 'manual_override'] as const;
export type AttendanceMethod = (typeof ATTENDANCE_METHODS)[number];

/**
 * Gate/turnstile attendance events. Separate from schedule-participant attendance
 * (`schedule_participants.attended`) — this table models physical facility access,
 * not class/PT session attendance (ADR: V08 Attendance / Hardware Boundary).
 */
export const attendances = mysqlTable(
  'attendances',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    user_id: bigint('user_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => users.id),
    check_in_time: utcDatetime('check_in_time').notNull(),
    check_out_time: utcDatetime('check_out_time'),
    method: varchar('method', { length: 32 }).notNull(),
    gate_identifier: varchar('gate_identifier', { length: 100 }),
    verified_by_user_id: bigint('verified_by_user_id', { mode: 'number', unsigned: true }).references(
      () => users.id,
    ),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('attendances_user_id_check_in_idx').on(table.user_id, table.check_in_time),
    index('attendances_check_in_time_idx').on(table.check_in_time),
    index('attendances_gate_identifier_idx').on(table.gate_identifier),
  ],
);

export type Attendance = typeof attendances.$inferSelect;
export type NewAttendance = typeof attendances.$inferInsert;

/**
 * Daily rollup of attendance activity, populated by the (future) daily-history job (ATT-013).
 */
export const attendanceHistories = mysqlTable(
  'attendance_histories',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    date: date('date', { mode: 'string' }).notNull(),
    total_member_checkins: int('total_member_checkins').notNull().default(0),
    total_trainer_checkins: int('total_trainer_checkins').notNull().default(0),
    peak_hour: int('peak_hour'),
    peak_count: int('peak_count'),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [uniqueIndex('attendance_histories_date_unique').on(table.date)],
);

export type AttendanceHistory = typeof attendanceHistories.$inferSelect;
export type NewAttendanceHistory = typeof attendanceHistories.$inferInsert;

/**
 * Hardware turnstile/reader credentials (ATT-004). Devices authenticate via the
 * `X-Device-Key` header (OpenAPI `deviceKey` securityScheme), scoped to attendance
 * ingest only. Raw keys are never stored — only an Argon2id hash (`key_hash`),
 * mirroring the password-hashing convention in `src/auth/password.ts`.
 */
export const deviceCredentials = mysqlTable(
  'device_credentials',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    device_name: varchar('device_name', { length: 150 }).notNull(),
    key_hash: varchar('key_hash', { length: 255 }).notNull(),
    is_active: boolean('is_active').notNull().default(true),
    location_details: text('location_details'),
    last_used_at: utcDatetime('last_used_at'),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('device_credentials_is_active_idx').on(table.is_active),
  ],
);

export type DeviceCredential = typeof deviceCredentials.$inferSelect;
export type NewDeviceCredential = typeof deviceCredentials.$inferInsert;
