import { z } from 'zod';

export const dietPlanFoodItemSchema = z.object({
  food_id: z.number().int().positive('food_id is required'),
  quantity: z.number().positive('quantity must be positive'),
  serving_unit: z.string().trim().optional(),
});

export type DietPlanFoodItemDto = z.infer<typeof dietPlanFoodItemSchema>;

export const dietPlanMealItemSchema = z.object({
  meal_name: z.string().trim().min(1, 'meal_name is required'),
  scheduled_time: z.string().trim().optional(),
  target_calories: z.number().int().positive().optional(),
  notes: z.string().optional(),
  foods: z.array(dietPlanFoodItemSchema).optional().default([]),
});

export type DietPlanMealItemDto = z.infer<typeof dietPlanMealItemSchema>;

export const dietPlanCreateSchema = z.object({
  title: z.string().trim().min(1, 'title is required'),
  description: z.string().optional(),
  member_id: z.number().int().positive().optional(),
  trainer_id: z.number().int().positive().optional(),
  daily_calorie_target: z.number().int().positive().optional(),
  protein_target_g: z.number().nonnegative().optional(),
  carbs_target_g: z.number().nonnegative().optional(),
  fat_target_g: z.number().nonnegative().optional(),
  is_template: z.boolean().optional(),
});

export type DietPlanCreateDto = z.infer<typeof dietPlanCreateSchema>;

export const dietPlanUpdateSchema = z.object({
  title: z.string().trim().min(1).optional(),
  description: z.string().optional(),
  member_id: z.number().int().positive().optional(),
  trainer_id: z.number().int().positive().optional(),
  daily_calorie_target: z.number().int().positive().optional(),
  protein_target_g: z.number().nonnegative().optional(),
  carbs_target_g: z.number().nonnegative().optional(),
  fat_target_g: z.number().nonnegative().optional(),
  is_template: z.boolean().optional(),
  row_version: z.number().int().positive().optional(),
});

export type DietPlanUpdateDto = z.infer<typeof dietPlanUpdateSchema>;

export const dietPlanMealsWriteSchema = z.object({
  changelog: z.string().optional(),
  row_version: z.number().int().positive().optional(),
  meals: z.array(dietPlanMealItemSchema),
});

export type DietPlanMealsWriteDto = z.infer<typeof dietPlanMealsWriteSchema>;

export const assignDietPlanSchema = z.object({
  member_id: z.number().int().positive('member_id is required'),
});

export type AssignDietPlanDto = z.infer<typeof assignDietPlanSchema>;

export const dietPlanFilterQuerySchema = z.object({
  member_id: z.coerce.number().int().positive().optional(),
  is_template: z
    .union([z.boolean(), z.string()])
    .optional()
    .transform((val) => {
      if (val === undefined) return undefined;
      if (typeof val === 'boolean') return val;
      return val === 'true' || val === '1';
    }),
  trainer_id: z.coerce.number().int().positive().optional(),
  status: z.enum(['draft', 'active', 'archived']).optional(),
  q: z.string().trim().optional(),
});

export type DietPlanFilterQueryDto = z.infer<typeof dietPlanFilterQuerySchema>;
