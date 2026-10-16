import { z } from 'zod';

function queryBoolean(val: unknown): unknown {
  if (typeof val === 'string') {
    const lower = val.trim().toLowerCase();
    if (lower === 'true' || lower === '1') return true;
    if (lower === 'false' || lower === '0') return false;
  }
  return val;
}

export const catalogFilterQuerySchema = z.object({
  is_active: z.preprocess(queryBoolean, z.boolean().optional()).optional(),
});

export interface UomDto {
  id: number;
  code: string;
  name: string;
  decimal_places: number;
  is_active: boolean;
}

export interface ItemCategoryDto {
  id: number;
  name: string;
  parent_id: number | null;
  is_active: boolean;
}
