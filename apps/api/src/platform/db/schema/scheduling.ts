import {
  bigint,
  boolean,
  date,
  index,
  int,
  mysqlTable,
  text,
  tinyint,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';
import { trainers } from './trainers';
import { users } from './users';

export const scheduleTypes = mysqlTable(
  'schedule_types',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    name: varchar('name', { length: 150 }).notNull(),
    color_code: varchar('color_code', { length: 16 }),
    default_duration_minutes: int('default_duration_minutes').notNull().default(60),
    requires_trainer: boolean('requires_trainer').notNull().default(false),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [uniqueIndex('schedule_types_name_unique').on(table.name)],
);

export type ScheduleType = typeof scheduleTypes.$inferSelect;
export type NewScheduleType = typeof scheduleTypes.$inferInsert;

export const facilities = mysqlTable(
  'facilities',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    name: varchar('name', { length: 150 }).notNull(),
    capacity: int('capacity').notNull().default(1),
    location_details: text('location_details'),
    is_active: boolean('is_active').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('facilities_name_unique').on(table.name),
    index('facilities_is_active_idx').on(table.is_active),
  ],
);

export type Facility = typeof facilities.$inferSelect;
export type NewFacility = typeof facilities.$inferInsert;

export const schedules = mysqlTable(
  'schedules',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    series_id: bigint('series_id', { mode: 'number', unsigned: true }),
    schedule_type_id: bigint('schedule_type_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => scheduleTypes.id),
    facility_id: bigint('facility_id', { mode: 'number', unsigned: true }).references(
      () => facilities.id,
    ),
    trainer_id: bigint('trainer_id', { mode: 'number', unsigned: true }).references(
      () => trainers.id,
    ),
    title: varchar('title', { length: 255 }).notNull(),
    start_time: utcDatetime('start_time').notNull(),
    end_time: utcDatetime('end_time').notNull(),
    max_capacity: int('max_capacity').notNull().default(1),
    status: varchar('status', { length: 16 }).notNull().default('scheduled'),
    notes: text('notes'),
    row_version: int('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('schedules_start_time_idx').on(table.start_time),
    index('schedules_end_time_idx').on(table.end_time),
    // Covers the calendar overlap query (end_time > from AND start_time < to)
    // used by ScheduleRepository.findManyFiltered without a second table scan.
    index('schedules_calendar_range_idx').on(table.end_time, table.start_time),
    index('schedules_trainer_id_start_idx').on(table.trainer_id, table.start_time),
    index('schedules_facility_id_start_idx').on(table.facility_id, table.start_time),
    index('schedules_series_id_idx').on(table.series_id),
    index('schedules_status_idx').on(table.status),
    index('schedules_type_id_idx').on(table.schedule_type_id),
  ],
);

export type Schedule = typeof schedules.$inferSelect;
export type NewSchedule = typeof schedules.$inferInsert;

export const scheduleParticipants = mysqlTable(
  'schedule_participants',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    schedule_id: bigint('schedule_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => schedules.id),
    member_id: bigint('member_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => members.id),
    booking_status: varchar('booking_status', { length: 16 }).notNull().default('booked'),
    attended: boolean('attended'),
    booked_at: utcDatetime('booked_at').notNull(),
    marked_at: utcDatetime('marked_at'),
  },
  (table) => [
    uniqueIndex('schedule_participants_schedule_member_unique').on(
      table.schedule_id,
      table.member_id,
    ),
    index('schedule_participants_member_id_idx').on(table.member_id),
    index('schedule_participants_schedule_id_idx').on(table.schedule_id),
  ],
);

export type ScheduleParticipant = typeof scheduleParticipants.$inferSelect;
export type NewScheduleParticipant = typeof scheduleParticipants.$inferInsert;

export const trainerAvailabilities = mysqlTable(
  'trainer_availabilities',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    trainer_id: bigint('trainer_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => trainers.id),
    day_of_week: tinyint('day_of_week', { unsigned: true }),
    start_time: varchar('start_time', { length: 8 }).notNull(),
    end_time: varchar('end_time', { length: 8 }).notNull(),
    is_recurring: boolean('is_recurring').notNull().default(true),
    override_date: date('override_date', { mode: 'string' }),
    is_available: boolean('is_available').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('trainer_availabilities_trainer_id_idx').on(table.trainer_id),
    index('trainer_availabilities_trainer_day_idx').on(table.trainer_id, table.day_of_week),
    index('trainer_availabilities_trainer_override_idx').on(table.trainer_id, table.override_date),
  ],
);

export type TrainerAvailability = typeof trainerAvailabilities.$inferSelect;
export type NewTrainerAvailability = typeof trainerAvailabilities.$inferInsert;

export const scheduleHistories = mysqlTable(
  'schedule_histories',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    schedule_id: bigint('schedule_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => schedules.id),
    action: varchar('action', { length: 32 }).notNull(),
    changed_by_user_id: bigint('changed_by_user_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => users.id),
    notes: text('notes'),
    timestamp: utcDatetime('timestamp').notNull(),
  },
  (table) => [index('schedule_histories_schedule_id_idx').on(table.schedule_id)],
);

export type ScheduleHistory = typeof scheduleHistories.$inferSelect;
export type NewScheduleHistory = typeof scheduleHistories.$inferInsert;
