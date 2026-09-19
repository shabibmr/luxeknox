#!/usr/bin/env bash
# Enforces the Clean Architecture layer boundaries from ADR-0006:
#   - presentation/ must not reference data/
#   - domain/ must not import package:flutter
#   - presentation/ and domain/ must not import package:api_client
#
# Exits 0 when clean, 1 when any violation is found.

set -uo pipefail

APP_LIB="app/lib"
violations=0

if [ ! -d "$APP_LIB" ]; then
  echo "check_layers: $APP_LIB not found" >&2
  exit 1
fi

grep_in_dirs() {
  # $1 = pattern, remaining args = path predicates for find (already built)
  local pattern="$1"
  shift
  local files
  files=$(find "$APP_LIB" -type f -name "*.dart" "$@" 2>/dev/null)
  if [ -z "$files" ]; then
    return 1
  fi
  echo "$files" | xargs grep -nE "$pattern" -- 2>/dev/null
}

echo "Checking: presentation/ must not reference data/ ..."
presentation_to_data=$(grep_in_dirs "import[[:space:]]+'[^']*/data/[^']*\.dart'" -path "*/presentation/*")
if [ -n "$presentation_to_data" ]; then
  echo "VIOLATION: presentation/ referencing data/:"
  echo "$presentation_to_data"
  violations=1
fi

echo "Checking: domain/ must not import package:flutter ..."
domain_flutter=$(grep_in_dirs "import[[:space:]]+'package:flutter" -path "*/domain/*")
if [ -n "$domain_flutter" ]; then
  echo "VIOLATION: domain/ importing package:flutter:"
  echo "$domain_flutter"
  violations=1
fi

echo "Checking: presentation/ and domain/ must not import package:api_client ..."
layer_api_client=$(grep_in_dirs "import[[:space:]]+'package:api_client" \( -path "*/presentation/*" -o -path "*/domain/*" \))
if [ -n "$layer_api_client" ]; then
  echo "VIOLATION: presentation/ or domain/ importing package:api_client:"
  echo "$layer_api_client"
  violations=1
fi

if [ "$violations" -ne 0 ]; then
  echo "check_layers: FAILED"
  exit 1
fi

echo "check_layers: OK"
exit 0
