# V2-06 — `FoodController` + `DietModule`

| | |
| :--- | :--- |
| **Status** | completed |
| **Depends** | V2-05, V2-02 |
| **Files** | 3 |

## Files

- `apps/api/src/diet/food.controller.ts` (new)
- `apps/api/src/diet/diet.module.ts` (finish wiring — controller, service, repository)
- `apps/api/src/app.module.ts` (import `DietModule`, same pattern as `WorkModule`)

## Work

Four routes, matching `docs/openapi/v1.yaml` operation-for-operation — same shape as
`ExerciseController` (`RequirePermission`, `ZodValidationPipe`, `@nestjs/swagger`):

| Route | `operationId` | Guard (`x-permission`) | Body |
| :--- | :--- | :--- | :--- |
| `GET /foods` | `listFoods` | `diet.read` | — (query: `limit`, `offset`, `q`, `is_verified`, `is_active`) |
| `POST /foods` | `createFood` | `diet.create` | `FoodWrite` |
| `GET /foods/{id}` | `getFood` | `diet.read` | — |
| `PATCH /foods/{id}` | `updateFood` | `diet.update` | `FoodWrite` |

- `@ApiTags('DIET')` to match YAML `tags: [DIET]`.
- Explicit `@ApiQuery` / `@ApiParam` so dump parity sees filters and `id` (V1-11 lesson).
- Response DTOs with `@ApiProperty`, snake_case fields.
- No `@Public()` — Bearer required. No `DELETE` route.

## Done when

- Happy path, 401, 403 (wrong role / missing `diet.*`), 404, 400/422 behave correctly.
- Module is imported; routes reachable under the app prefix used by exercises.
