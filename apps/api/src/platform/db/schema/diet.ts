import { sql } from 'drizzle-orm';
import {
  bigint,
  boolean,
  date,
  doublePrecision,
  index,
  integer,
  pgTable,
  text,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/pg-core';
import { utcDatetime } from '../utc-datetime';
import { foods } from './foods';
import { members } from './members';
import { trainers } from './trainers';

export const DIET_PLAN_STATUSES = ['draft', 'active', 'archived'] as const;
export type DietPlanStatus = (typeof DIET_PLAN_STATUSES)[number];

export const dietPlans = pgTable(
  'diet_plans',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    title: varchar('title', { length: 150 }).notNull(),
    description: text('description'),
    member_id: bigint('member_id', { mode: 'number' }).references(() => members.id),
    trainer_id: bigint('trainer_id', { mode: 'number' }).references(() => trainers.id),
    daily_calorie_target: integer('daily_calorie_target'),
    protein_target_g: doublePrecision('protein_target_g'),
    carbs_target_g: doublePrecision('carbs_target_g'),
    fat_target_g: doublePrecision('fat_target_g'),
    is_template: boolean('is_template').notNull().default(false),
    status: varchar('status', { length: 16 }).notNull().default('draft'),
    row_version: integer('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('diet_plans_member_id_idx').on(table.member_id),
    index('diet_plans_trainer_id_idx').on(table.trainer_id),
    index('diet_plans_status_idx').on(table.status),
    index('diet_plans_is_template_idx').on(table.is_template),
    // PostgreSQL partial unique index replaces MySQL's stored generated column + UNIQUE KEY (ADR-0009).
    uniqueIndex('diet_plans_active_assigned_member_id_unique')
      .on(table.member_id)
      .where(sql`status = 'active' AND is_template = false`),
  ],
);

export type DietPlan = typeof dietPlans.$inferSelect;
export type NewDietPlan = typeof dietPlans.$inferInsert;

export const dietPlanVersions = pgTable(
  'diet_plan_versions',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    diet_plan_id: bigint('diet_plan_id', { mode: 'number' })
      .notNull()
      .references(() => dietPlans.id),
    version_number: integer('version_number').notNull(),
    changelog: text('changelog'),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    uniqueIndex('diet_plan_versions_plan_id_version_unique').on(
      table.diet_plan_id,
      table.version_number,
    ),
    index('diet_plan_versions_diet_plan_id_idx').on(table.diet_plan_id),
  ],
);

export type DietPlanVersion = typeof dietPlanVersions.$inferSelect;
export type NewDietPlanVersion = typeof dietPlanVersions.$inferInsert;

export const dietPlanMeals = pgTable(
  'diet_plan_meals',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    diet_plan_version_id: bigint('diet_plan_version_id', { mode: 'number' })
      .notNull()
      .references(() => dietPlanVersions.id),
    meal_name: varchar('meal_name', { length: 100 }).notNull(),
    scheduled_time: varchar('scheduled_time', { length: 16 }),
    target_calories: integer('target_calories'),
    notes: text('notes'),
    order_index: integer('order_index').notNull().default(0),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('diet_plan_meals_version_idx').on(table.diet_plan_version_id),
    index('diet_plan_meals_version_order_idx').on(table.diet_plan_version_id, table.order_index),
  ],
);

export type DietPlanMeal = typeof dietPlanMeals.$inferSelect;
export type NewDietPlanMeal = typeof dietPlanMeals.$inferInsert;

export const dietPlanFoods = pgTable(
  'diet_plan_foods',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    diet_plan_meal_id: bigint('diet_plan_meal_id', { mode: 'number' })
      .notNull()
      .references(() => dietPlanMeals.id),
    food_id: bigint('food_id', { mode: 'number' })
      .notNull()
      .references(() => foods.id),
    quantity: doublePrecision('quantity').notNull(),
    serving_unit: varchar('serving_unit', { length: 50 }),
    order_index: integer('order_index').notNull().default(0),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('diet_plan_foods_meal_idx').on(table.diet_plan_meal_id),
    index('diet_plan_foods_food_idx').on(table.food_id),
  ],
);

export type DietPlanFood = typeof dietPlanFoods.$inferSelect;
export type NewDietPlanFood = typeof dietPlanFoods.$inferInsert;

export const dietHistories = pgTable(
  'diet_histories',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    member_id: bigint('member_id', { mode: 'number' })
      .notNull()
      .references(() => members.id),
    diet_plan_id: bigint('diet_plan_id', { mode: 'number' }).references(
      () => dietPlans.id,
    ),
    logged_date: date('logged_date', { mode: 'string' }).notNull(),
    total_calories_consumed: doublePrecision('total_calories_consumed').notNull().default(0),
    adherence_score: doublePrecision('adherence_score'),
    water_intake_ml: integer('water_intake_ml'),
    member_notes: text('member_notes'),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('diet_histories_member_id_idx').on(table.member_id),
    index('diet_histories_logged_date_idx').on(table.logged_date),
    uniqueIndex('diet_histories_member_logged_date_unique').on(
      table.member_id,
      table.logged_date,
    ),
  ],
);

export type DietHistory = typeof dietHistories.$inferSelect;
export type NewDietHistory = typeof dietHistories.$inferInsert;
