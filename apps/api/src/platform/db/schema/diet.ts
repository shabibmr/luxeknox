import {
  bigint,
  boolean,
  date,
  double,
  index,
  int,
  mysqlTable,
  text,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { foods } from './foods';
import { members } from './members';
import { trainers } from './trainers';

export const DIET_PLAN_STATUSES = ['draft', 'active', 'archived'] as const;
export type DietPlanStatus = (typeof DIET_PLAN_STATUSES)[number];

export const dietPlans = mysqlTable(
  'diet_plans',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    title: varchar('title', { length: 150 }).notNull(),
    description: text('description'),
    member_id: bigint('member_id', { mode: 'number', unsigned: true }).references(() => members.id),
    trainer_id: bigint('trainer_id', { mode: 'number', unsigned: true }).references(() => trainers.id),
    daily_calorie_target: int('daily_calorie_target'),
    protein_target_g: double('protein_target_g'),
    carbs_target_g: double('carbs_target_g'),
    fat_target_g: double('fat_target_g'),
    is_template: boolean('is_template').notNull().default(false),
    status: varchar('status', { length: 16 }).notNull().default('draft'),
    row_version: int('row_version').notNull().default(1),
    active_assigned_member_id: bigint('active_assigned_member_id', { mode: 'number', unsigned: true }),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('diet_plans_member_id_idx').on(table.member_id),
    index('diet_plans_trainer_id_idx').on(table.trainer_id),
    index('diet_plans_status_idx').on(table.status),
    index('diet_plans_is_template_idx').on(table.is_template),
    uniqueIndex('diet_plans_active_assigned_member_id_unique').on(table.active_assigned_member_id),
  ],
);

export type DietPlan = typeof dietPlans.$inferSelect;
export type NewDietPlan = typeof dietPlans.$inferInsert;

export const dietPlanVersions = mysqlTable(
  'diet_plan_versions',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    diet_plan_id: bigint('diet_plan_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => dietPlans.id),
    version_number: int('version_number').notNull(),
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

export const dietPlanMeals = mysqlTable(
  'diet_plan_meals',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    diet_plan_version_id: bigint('diet_plan_version_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => dietPlanVersions.id),
    meal_name: varchar('meal_name', { length: 100 }).notNull(),
    scheduled_time: varchar('scheduled_time', { length: 16 }),
    target_calories: int('target_calories'),
    notes: text('notes'),
    order_index: int('order_index').notNull().default(0),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('diet_plan_meals_version_idx').on(table.diet_plan_version_id),
    index('diet_plan_meals_version_order_idx').on(table.diet_plan_version_id, table.order_index),
  ],
);

export type DietPlanMeal = typeof dietPlanMeals.$inferSelect;
export type NewDietPlanMeal = typeof dietPlanMeals.$inferInsert;

export const dietPlanFoods = mysqlTable(
  'diet_plan_foods',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    diet_plan_meal_id: bigint('diet_plan_meal_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => dietPlanMeals.id),
    food_id: bigint('food_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => foods.id),
    quantity: double('quantity').notNull(),
    serving_unit: varchar('serving_unit', { length: 50 }),
    order_index: int('order_index').notNull().default(0),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('diet_plan_foods_meal_idx').on(table.diet_plan_meal_id),
    index('diet_plan_foods_food_idx').on(table.food_id),
  ],
);

export type DietPlanFood = typeof dietPlanFoods.$inferSelect;
export type NewDietPlanFood = typeof dietPlanFoods.$inferInsert;

export const dietHistories = mysqlTable(
  'diet_histories',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    member_id: bigint('member_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => members.id),
    diet_plan_id: bigint('diet_plan_id', { mode: 'number', unsigned: true }).references(
      () => dietPlans.id,
    ),
    logged_date: date('logged_date', { mode: 'string' }).notNull(),
    total_calories_consumed: double('total_calories_consumed').notNull().default(0),
    adherence_score: double('adherence_score'),
    water_intake_ml: int('water_intake_ml'),
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
