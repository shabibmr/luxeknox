// Builds seed JSON from yuhonas/free-exercise-db (Unlicense / public domain) + curated extras.
// Usage: node apps/api/seed/build-exercises.mjs
import { writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { extras } from './exercises-extras.mjs';

const here = dirname(fileURLToPath(import.meta.url));
const SRC =
  'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json';
const IMG = 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/';

const title = (s) => s.replace(/\b\w/g, (c) => c.toUpperCase());
const MUSCLE = { 'middle back': 'Middle Back', 'lower back': 'Lower Back' };
const muscle = (m) => MUSCLE[m] ?? title(m);
const EQUIP = { 'body only': 'Bodyweight', 'e-z curl bar': 'EZ Curl Bar', other: 'Other' };
const equip = (e) => (e == null ? 'None' : (EQUIP[e] ?? title(e)));
const LEVEL = { beginner: 'Beginner', intermediate: 'Intermediate', expert: 'Advanced' };

const res = await fetch(SRC);
if (!res.ok) throw new Error(`fetch failed ${res.status}`);
const raw = await res.json();

const full = raw.map((e) => ({
  name: e.name.trim(),
  primary_muscle_group: muscle(e.primaryMuscles[0] ?? 'full body'),
  secondary_muscles: [...e.primaryMuscles.slice(1), ...e.secondaryMuscles].map(muscle),
  equipment_needed: equip(e.equipment),
  instructions: e.instructions.map((s, i) => `${i + 1}. ${s.trim()}`).join('\n'),
  difficulty_level: LEVEL[e.level] ?? 'Beginner',
  category: title(e.category),
  mechanic: e.mechanic ? title(e.mechanic) : null,
  force: e.force ? title(e.force) : null,
  image_urls: e.images.map((p) => IMG + p),
  source: 'free-exercise-db',
  is_active: true,
}));

const seen = new Set(full.map((e) => e.name.toLowerCase()));
for (const x of extras) {
  if (seen.has(x.name.toLowerCase())) continue;
  full.push({ ...x, image_urls: [], source: 'curated', is_active: true });
}

full.sort((a, b) => a.name.localeCompare(b.name));

// Wire format: matches ExerciseWrite (apps/api/src/work/exercise.dto.ts).
const wire = full.map(
  ({ name, primary_muscle_group, secondary_muscles, equipment_needed, instructions, difficulty_level, is_active }) => ({
    name, primary_muscle_group, secondary_muscles, equipment_needed, instructions, difficulty_level, is_active,
  }),
);

writeFileSync(join(here, 'exercises.json'), JSON.stringify(wire, null, 2) + '\n');
writeFileSync(join(here, 'exercises.enriched.json'), JSON.stringify(full, null, 2) + '\n');
console.log(`exercises: ${full.length} (free-exercise-db ${raw.length}, curated added ${full.length - raw.length})`);
const count = (k) => full.reduce((m, e) => ((m[e[k]] = (m[e[k]] ?? 0) + 1), m), {});
console.log('muscles', count('primary_muscle_group'));
console.log('equipment', count('equipment_needed'));
