#!/usr/bin/env bash
set -euo pipefail
npx @openapitools/openapi-generator-cli generate -i docs/openapi/v1.yaml -g dart-dio -o packages/api_client --additional-properties=pubName=api_client,nullableFields=true
