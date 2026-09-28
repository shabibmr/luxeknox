import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import type { DrizzleDb } from '../client';
import { exercises, type NewExercise } from '../schema/exercises';
import { exerciseWriteSchema } from '../../../work/exercise.dto';
import { z } from 'zod';

const EXERCISES_JSON = resolve(__dirname, '../../../../seed/exercises.json');
const BATCH_SIZE = 200;

export function loadSeedExercises(path: string = EXERCISES_JSON) {
  return z.array(exerciseWriteSchema).parse(JSON.parse(readFileSync(path, 'utf8')));
}

/**
 * Idempotent: inserts only exercises whose name (case-insensitive) is not already present,
 * so re-running never duplicates rows and never overwrites admin edits.
 */
export async function seedExercises(db: DrizzleDb): Promise<{ inserted: number; skipped: number }> {
  const seedRows = loadSeedExercises();
  const existing = await db.select({ name: exercises.name }).from(exercises);
  const known = new Set(existing.map((r) => r.name.trim().toLowerCase()));

  const now = new Date();
  const toInsert: NewExercise[] = [];
  for (const row of seedRows) {
    const key = row.name.toLowerCase();
    if (known.has(key)) continue;
    known.add(key);
    toInsert.push({
      name: row.name,
      primary_muscle_group: row.primary_muscle_group ?? null,
      secondary_muscles: row.secondary_muscles ?? null,
      equipment_needed: row.equipment_needed ?? null,
      instructions: row.instructions ?? null,
      video_url: row.video_url ?? null,
      gif_url: row.gif_url ?? null,
      difficulty_level: row.difficulty_level ?? null,
      is_active: row.is_active ?? true,
      created_at: now,
    });
  }

  for (let i = 0; i < toInsert.length; i += BATCH_SIZE) {
    await db.insert(exercises).values(toInsert.slice(i, i + BATCH_SIZE));
  }

  return { inserted: toInsert.length, skipped: seedRows.length - toInsert.length };
}
