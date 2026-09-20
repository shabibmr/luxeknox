# V2-04 — `FoodRepository`

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V2-03 |
| **Files** | 2 |

## Files

- `apps/api/src/diet/food.repository.ts` (new)
- `apps/api/src/diet/diet.module.ts` (new — registers the repository as a provider)

## Work

Mirror `ExerciseRepository` (`apps/api/src/work/exercise.repository.ts`): extend
`BaseRepository<typeof foods>`. Add:

- `findManyFiltered(params: { q?: string; isActive?: boolean; isVerified?: boolean; limit: number;
  offset: number }): Promise<{ rows: Food[]; total: number }>` — `q` matches `name`
  case-insensitively (`LIKE`; collation handles case). Repo **accepts** `isActive` / `isVerified`
  filter flags when provided; does not invent caller policy.
- Default “active + verified for non-updaters” is enforced later in the service (V2-05), not hard-coded
  inside the repository beyond applying the flags it receives.
- Inherit `findById` / `insert` / `update` from `BaseRepository` unless the generic signature does
  not fit — check before duplicating methods.

Keep `diet.module.ts` minimal (providers: repository; controller/service land in later tickets).

## Done when

- Repository compiles and is injectable.
- No raw SQL outside the repository.
