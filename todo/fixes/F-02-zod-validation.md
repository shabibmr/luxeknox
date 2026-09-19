# F-02 — Enforce Zod validation on auth request bodies

| | |
| :--- | :--- |
| **Status** | todo |
| **Severity** | blocker |
| **Depends** | — |
| **Blocks** | F-10 |
| **Files** | 6 |

## Why

ADR-0001: "zod schemas at the edge, inferred types inward." Today nothing validates.

`main.ts:57` registers `new ZodValidationPipe()` with **no schema**. `ZodValidationPipe.transform` (`main.ts:13-16`) returns the value untouched whenever `this.schema` is undefined — which it always is. `loginSchema` and `refreshTokenSchema` exist in `auth.dto.ts` but `rg "loginSchema|refreshTokenSchema" apps/api/src` shows they are never passed to a pipe or parsed anywhere. `POST /v1/auth/login` and `POST /v1/auth/refresh` accept any JSON body, including `{}`, and hand `undefined` to `AuthService`.

The optional-schema constructor is what allowed this to look wired while doing nothing. Making the schema required means a pipe with no schema cannot compile.

## Files

- `apps/api/src/platform/http/zod-validation.pipe.ts` (new)
- `apps/api/src/platform/http/zod-validation.pipe.spec.ts` (new)
- `apps/api/src/main.ts`
- `apps/api/src/auth/auth.controller.ts`
- `apps/api/test/helpers/mysql.ts`
- `apps/api/test/auth.e2e.spec.ts`

## Steps

1. Create `apps/api/src/platform/http/zod-validation.pipe.ts`. The schema is a **required** constructor argument, and failures throw the platform error so `GlobalExceptionFilter` renders the uniform envelope:
   ```ts
   import { ArgumentMetadata, Injectable, PipeTransform } from '@nestjs/common';
   import type { ZodSchema } from 'zod';
   import { BadRequestError } from '../errors/app-error';

   @Injectable()
   export class ZodValidationPipe<T> implements PipeTransform<unknown, T> {
     constructor(private readonly schema: ZodSchema<T>) {}

     transform(value: unknown, _metadata: ArgumentMetadata): T {
       const result = this.schema.safeParse(value);
       if (!result.success) {
         throw new BadRequestError('Validation failed', result.error.errors);
       }
       return result.data;
     }
   }
   ```
   `BadRequestError` already defaults to `ErrorCode.VALIDATION_ERROR` (`app-error.ts:32-33`), so do not pass a code. Note this replaces the old raw `BadRequestException({ code: 'VALIDATION_FAILED' })`, which emitted a code that is not in `codes.ts`.
2. In `main.ts`: delete the `ZodValidationPipe` class (lines 9-30), delete `app.useGlobalPipes(new ZodValidationPipe());` (line 57), and drop the now-unused imports `ArgumentMetadata, BadRequestException, Injectable, PipeTransform` and `ZodSchema, ZodError`. Do **not** register a global pipe — validation is now per-route, because each route has a different schema.
3. In `auth.controller.ts`, import the pipe and the schemas, then bind them at the parameter:
   ```ts
   import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
   import { AuthResponseDto, LoginDto, RefreshTokenDto, loginSchema, refreshTokenSchema } from './auth.dto';
   ```
   - line 41: `async login(@Body(new ZodValidationPipe(loginSchema)) dto: LoginDto, @Req() req: Request)`
   - line 67: `async refresh(@Body(new ZodValidationPipe(refreshTokenSchema)) dto: RefreshTokenDto)`
4. In `test/helpers/mysql.ts`: delete `import { ZodValidationPipe } from '../../src/main';` (line 5) and `app.useGlobalPipes(new ZodValidationPipe());` (line 40). Importing from `main.ts` pulled the whole bootstrap module into the test process for no reason.
5. Write `zod-validation.pipe.spec.ts` covering: valid body passes through and is returned parsed; missing required field throws `BadRequestError`; the thrown error's response carries `code: 'validation_error'` and a non-empty `details` array.
6. Add two e2e cases to `test/auth.e2e.spec.ts`:
   - `POST /v1/auth/login` with `{}` returns **400**, body `code` is `validation_error`, and `details` is non-empty.
   - `POST /v1/auth/refresh` with `{ refreshToken: 'nope' }` returns **400** (the schema requires the `gk_rt_` prefix), *not* 401.

## Done when

- `rg "new ZodValidationPipe\(\)" apps/api` returns nothing — a bare pipe no longer type-checks.
- `POST /v1/auth/login` with `{}` returns 400 with `code: "validation_error"`, not a 500 or a 401.
- The happy-path login e2e still returns 200.
- `pnpm --filter api test` and `test:e2e` pass.
