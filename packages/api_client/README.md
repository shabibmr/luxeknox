# api_client

Generated Dart HTTP client for the LuxeKnox gym API.

## Source document

`docs/openapi/v1.yaml` — this is the only source of truth. Do not hand-write or hand-edit
anything under `lib/`.

## Regenerating

```bash
bash tool/gen_api.sh
```

This wraps:

```bash
npx @openapitools/openapi-generator-cli generate \
  -i docs/openapi/v1.yaml \
  -g dart-dio \
  -o packages/api_client \
  --additional-properties=pubName=api_client,nullableFields=true
```

After regenerating, from `packages/api_client/`:

```bash
dart pub get
dart run build_runner build --delete-conflicting-outputs
dart analyze
```

`build_runner` is required because the `dart-dio` generator emits `built_value` model classes
whose `.g.dart` serializer files are generated code, not checked in as generator output.

## Commit policy

Generated files under `lib/`, `doc/`, and `test/` **are committed to git** and must **never be
hand-edited**. If the OpenAPI spec changes, regenerate with the command above and commit the
diff. Any manual edit to a generated file will be silently discarded (and diverge from the spec)
the next time someone regenerates.

If generated code needs different behaviour, change `docs/openapi/v1.yaml` (or, if the generator
itself is the problem, the generation command/config in `tool/gen_api.sh`) — never the output.
