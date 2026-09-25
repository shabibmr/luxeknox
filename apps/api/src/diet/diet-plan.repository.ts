import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, inArray, like, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { foods, type Food } from '../platform/db/schema/foods';
import {
  dietPlans,
  dietPlanVersions,
  dietPlanMeals,
  dietPlanFoods,
  type DietPlan,
  type NewDietPlan,
  type DietPlanVersion,
  type NewDietPlanVersion,
  type DietPlanMeal,
  type NewDietPlanMeal,
  type DietPlanFood,
  type NewDietPlanFood,
} from '../platform/db/schema/diet';
import { ConflictError } from '../platform/errors/app-error';

export interface DietPlanFilterParams {
  memberId?: number;
  isTemplate?: boolean;
  trainerId?: number;
  status?: string;
  q?: string;
  limit: number;
  offset: number;
}

export type EnrichedDietPlanFood = DietPlanFood & { food?: Food };

export type EnrichedDietPlanMeal = DietPlanMeal & {
  foods: EnrichedDietPlanFood[];
  computed_calories?: number;
  computed_protein_g?: number;
  computed_carbs_g?: number;
  computed_fat_g?: number;
};

export interface EnrichedDietPlanVersion extends DietPlanVersion {
  meals: EnrichedDietPlanMeal[];
  total_computed_calories?: number;
  total_computed_protein_g?: number;
  total_computed_carbs_g?: number;
  total_computed_fat_g?: number;
}

export interface DietPlanWithDetails extends DietPlan {
  current_version?: EnrichedDietPlanVersion;
}

@Injectable()
export class DietPlanRepository extends BaseRepository<
  typeof dietPlans,
  DietPlan,
  NewDietPlan
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, dietPlans);
  }

  private buildFilterConditions(
    params: Omit<DietPlanFilterParams, 'limit' | 'offset'>,
  ): SQL | undefined {
    const conditions: SQL[] = [];

    if (params.isTemplate !== undefined) {
      conditions.push(eq(dietPlans.is_template, params.isTemplate));
    }
    if (params.memberId !== undefined) {
      conditions.push(eq(dietPlans.member_id, params.memberId));
    }
    if (params.trainerId !== undefined) {
      conditions.push(eq(dietPlans.trainer_id, params.trainerId));
    }
    if (params.status !== undefined) {
      conditions.push(eq(dietPlans.status, params.status));
    }
    if (params.q) {
      conditions.push(like(dietPlans.title, `%${params.q}%`));
    }

    if (conditions.length === 0) return undefined;
    return conditions.length === 1 ? conditions[0] : and(...conditions);
  }

  async findPlans(
    params: DietPlanFilterParams,
  ): Promise<{ rows: DietPlanWithDetails[]; total: number }> {
    const db = this.getDb() as any;
    const whereClause = this.buildFilterConditions(params);

    let plansQuery = db
      .select()
      .from(dietPlans)
      .orderBy(desc(dietPlans.created_at))
      .limit(params.limit)
      .offset(params.offset);

    let countQuery = db
      .select({ count: dietPlans.id })
      .from(dietPlans);

    if (whereClause) {
      plansQuery = plansQuery.where(whereClause);
      countQuery = countQuery.where(whereClause);
    }

    const [rows, countResult] = await Promise.all([plansQuery, countQuery]);

    const enrichedRows: DietPlanWithDetails[] = await Promise.all(
      (rows as DietPlan[]).map(async (plan) => {
        const latestVersion = await this.findLatestVersionByPlanId(plan.id);
        if (!latestVersion) return plan;
        const meals = await this.findMealsByVersionId(latestVersion.id);
        const enrichedVersion = this.enrichVersionNutrition(latestVersion, meals);
        return {
          ...plan,
          current_version: enrichedVersion,
        };
      }),
    );

    return { rows: enrichedRows, total: countResult.length };
  }

  async findPlanById(id: number): Promise<DietPlanWithDetails | null> {
    const db = this.getDb() as any;
    const [plan] = await db
      .select()
      .from(dietPlans)
      .where(eq(dietPlans.id, id))
      .limit(1);

    if (!plan) return null;

    const latestVersion = await this.findLatestVersionByPlanId(plan.id);
    if (!latestVersion) return plan;

    const meals = await this.findMealsByVersionId(latestVersion.id);
    const enrichedVersion = this.enrichVersionNutrition(latestVersion, meals);

    return {
      ...plan,
      current_version: enrichedVersion,
    };
  }

  async findActivePlanForMember(memberId: number): Promise<DietPlan | null> {
    const db = this.getDb() as any;
    const [activePlan] = await db
      .select()
      .from(dietPlans)
      .where(
        and(
          eq(dietPlans.member_id, memberId),
          eq(dietPlans.status, 'active'),
          eq(dietPlans.is_template, false),
        ),
      )
      .limit(1);

    return activePlan || null;
  }

  async insertPlan(data: NewDietPlan): Promise<DietPlan> {
    const db = this.getDb() as any;
    const [result] = await db.insert(dietPlans).values(data);
    const insertId = Number((result as any).insertId);
    const [inserted] = await db
      .select()
      .from(dietPlans)
      .where(eq(dietPlans.id, insertId))
      .limit(1);
    return inserted;
  }

  async updatePlan(
    id: number,
    changes: Partial<NewDietPlan>,
    expectedRowVersion?: number,
  ): Promise<DietPlan> {
    const db = this.getDb() as any;
    const whereConditions: SQL[] = [eq(dietPlans.id, id)];
    if (expectedRowVersion !== undefined) {
      whereConditions.push(eq(dietPlans.row_version, expectedRowVersion));
    }

    const nextRowVersion = expectedRowVersion !== undefined ? expectedRowVersion + 1 : undefined;

    const updatePayload: Record<string, any> = {
      ...changes,
      updated_at: new Date(),
    };
    if (nextRowVersion !== undefined) {
      updatePayload.row_version = nextRowVersion;
    }

    const [updateResult] = await db
      .update(dietPlans)
      .set(updatePayload)
      .where(and(...whereConditions));

    const affected = Number((updateResult as any).affectedRows ?? 0);
    if (expectedRowVersion !== undefined && affected === 0) {
      throw new ConflictError(
        'Diet plan has been modified by another process. Please refresh and try again.',
      );
    }

    const [updated] = await db
      .select()
      .from(dietPlans)
      .where(eq(dietPlans.id, id))
      .limit(1);
    return updated;
  }

  async insertVersion(data: NewDietPlanVersion): Promise<DietPlanVersion> {
    const db = this.getDb() as any;
    const [result] = await db.insert(dietPlanVersions).values(data);
    const insertId = Number((result as any).insertId);
    const [inserted] = await db
      .select()
      .from(dietPlanVersions)
      .where(eq(dietPlanVersions.id, insertId))
      .limit(1);
    return inserted;
  }

  async findLatestVersionByPlanId(planId: number): Promise<DietPlanVersion | null> {
    const db = this.getDb() as any;
    const [latest] = await db
      .select()
      .from(dietPlanVersions)
      .where(eq(dietPlanVersions.diet_plan_id, planId))
      .orderBy(desc(dietPlanVersions.version_number))
      .limit(1);
    return latest || null;
  }

  async findVersionsByPlanId(
    planId: number,
    limit = 20,
    offset = 0,
  ): Promise<{ rows: EnrichedDietPlanVersion[]; total: number }> {
    const db = this.getDb() as any;
    const where = eq(dietPlanVersions.diet_plan_id, planId);

    const [rows, countResult] = await Promise.all([
      db
        .select()
        .from(dietPlanVersions)
        .where(where)
        .orderBy(desc(dietPlanVersions.version_number))
        .limit(limit)
        .offset(offset),
      db.select({ count: dietPlanVersions.id }).from(dietPlanVersions).where(where),
    ]);

    const enriched = await Promise.all(
      (rows as DietPlanVersion[]).map(async (v) => {
        const meals = await this.findMealsByVersionId(v.id);
        return this.enrichVersionNutrition(v, meals);
      }),
    );

    return { rows: enriched, total: countResult.length };
  }

  async insertMeal(data: NewDietPlanMeal): Promise<DietPlanMeal> {
    const db = this.getDb() as any;
    const [result] = await db.insert(dietPlanMeals).values(data);
    const insertId = Number((result as any).insertId);
    const [inserted] = await db
      .select()
      .from(dietPlanMeals)
      .where(eq(dietPlanMeals.id, insertId))
      .limit(1);
    return inserted;
  }

  async insertFoods(items: NewDietPlanFood[]): Promise<void> {
    if (items.length === 0) return;
    const db = this.getDb() as any;
    await db.insert(dietPlanFoods).values(items);
  }

  async findMealsByVersionId(versionId: number): Promise<EnrichedDietPlanMeal[]> {
    const db = this.getDb() as any;
    const mealsRows = await db
      .select()
      .from(dietPlanMeals)
      .where(eq(dietPlanMeals.diet_plan_version_id, versionId))
      .orderBy(dietPlanMeals.order_index, dietPlanMeals.id);

    if (mealsRows.length === 0) {
      return [];
    }

    const mealIds = mealsRows.map((m: DietPlanMeal) => m.id);

    const foodRows = await db
      .select({
        planFood: dietPlanFoods,
        food: foods,
      })
      .from(dietPlanFoods)
      .leftJoin(foods, eq(dietPlanFoods.food_id, foods.id))
      .where(inArray(dietPlanFoods.diet_plan_meal_id, mealIds))
      .orderBy(dietPlanFoods.order_index, dietPlanFoods.id);

    const foodsByMealId = new Map<number, EnrichedDietPlanFood[]>();
    for (const r of foodRows as any[]) {
      const mealId = r.planFood.diet_plan_meal_id;
      if (!foodsByMealId.has(mealId)) {
        foodsByMealId.set(mealId, []);
      }
      foodsByMealId.get(mealId)!.push({
        ...r.planFood,
        food: r.food || undefined,
      });
    }

    return mealsRows.map((meal: DietPlanMeal) => {
      const mealFoods = foodsByMealId.get(meal.id) || [];
      let computedCalories = 0;
      let computedProtein = 0;
      let computedCarbs = 0;
      let computedFat = 0;

      for (const f of mealFoods) {
        if (f.food) {
          computedCalories += f.quantity * (f.food.calories ?? 0);
          computedProtein += f.quantity * (f.food.protein_grams ?? 0);
          computedCarbs += f.quantity * (f.food.carbs_grams ?? 0);
          computedFat += f.quantity * (f.food.fat_grams ?? 0);
        }
      }

      return {
        ...meal,
        foods: mealFoods,
        computed_calories: Math.round(computedCalories * 10) / 10,
        computed_protein_g: Math.round(computedProtein * 10) / 10,
        computed_carbs_g: Math.round(computedCarbs * 10) / 10,
        computed_fat_g: Math.round(computedFat * 10) / 10,
      };
    });
  }

  private enrichVersionNutrition(
    version: DietPlanVersion,
    meals: EnrichedDietPlanMeal[],
  ): EnrichedDietPlanVersion {
    let totalCalories = 0;
    let totalProtein = 0;
    let totalCarbs = 0;
    let totalFat = 0;

    for (const m of meals) {
      totalCalories += m.computed_calories ?? 0;
      totalProtein += m.computed_protein_g ?? 0;
      totalCarbs += m.computed_carbs_g ?? 0;
      totalFat += m.computed_fat_g ?? 0;
    }

    return {
      ...version,
      meals,
      total_computed_calories: Math.round(totalCalories * 10) / 10,
      total_computed_protein_g: Math.round(totalProtein * 10) / 10,
      total_computed_carbs_g: Math.round(totalCarbs * 10) / 10,
      total_computed_fat_g: Math.round(totalFat * 10) / 10,
    };
  }
}
