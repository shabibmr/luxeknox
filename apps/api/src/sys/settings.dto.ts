import { z } from 'zod';

export const settingCategorySchema = z.enum([
  'GENERAL',
  'BILLING',
  'SCHEDULE',
  'ATTENDANCE',
  'WORKOUT',
  'DIET',
  'NOTIFICATION',
  'SECURITY',
]);

export type SettingCategory = z.infer<typeof settingCategorySchema>;

export const settingItemWriteSchema = z.object({
  setting_key: z.string().min(1),
  setting_value: z.string(),
});

export const settingsWriteSchema = z.object({
  items: z.array(settingItemWriteSchema).min(1),
});

export type SettingsWriteDto = z.infer<typeof settingsWriteSchema>;

export interface SettingDto {
  id?: number;
  setting_key: string;
  setting_value: string;
  category: SettingCategory;
}

export interface SettingsListDto {
  data: SettingDto[];
}

export function resolveSettingCategory(key: string): SettingCategory {
  if (key.startsWith('schedule_')) return 'SCHEDULE';
  if (key.startsWith('attendance_')) return 'ATTENDANCE';
  if (key.startsWith('payments_') || key.startsWith('tax_') || key === 'currency') return 'BILLING';
  if (key.startsWith('workout_')) return 'WORKOUT';
  if (key.startsWith('diet_')) return 'DIET';
  if (key.startsWith('notification_')) return 'NOTIFICATION';
  if (key.startsWith('security_') || key.startsWith('auth_') || key.startsWith('session_')) return 'SECURITY';
  return 'GENERAL';
}
