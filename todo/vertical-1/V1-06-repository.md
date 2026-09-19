# V1-06 — `ExerciseRepository`

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V1-05 |
| **Files** | 2 |

## Files

- `apps/api/src/work/exercise.repository.ts` (new)
- `apps/api/src/work/work.module.ts` (new — registers the repository as a provider)

## Work

Extend `BaseRepository<typeof exercises>` (`apps/api/src/platform/db/base.repository.ts`), same
pattern as `SettingsRepository`/`SessionRepository`. Add:

- `findManyFiltered(params: { q?: string; primaryMuscleGroup?: string; equipmentNeeded?: string;
  difficultyLevel?: string; limit: number; offset: number; activeOnly?: boolean }): Promise<{ rows:
  Exercise[]; total: number }>` — `q` matches `name` case-insensitively (collation already handles
  this, plain `LIKE` is sufficient, no need for `FULLTEXT` unless V1-05's indexing note said
  otherwise). `activeOnly` true for member/trainer reads, false for admin.
- Inherit `findById`/`insert`/`update` from `BaseRepository` unless its generic signature doesn't fit
  — check before adding duplicate methods.

`work.module.ts` exists mainly so V1-07/V1-08 have a home; keep it minimal (providers: repository,
service; controllers: exercise controller — the controller itself lands in V1-08, this ticket can
leave the `controllers` array empty or stub it).

## Done when

- Repository compiles and is injectable.
- No raw SQL outside the repository (mirrors the standards finding F-05/F-06 fixed for auth —
  don't reintroduce the same smell here).
