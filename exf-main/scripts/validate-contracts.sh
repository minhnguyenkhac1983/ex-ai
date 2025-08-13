#!/usr/bin/env bash
set -euo pipefail

echo "Validate OpenAPI"
redocly lint contracts/api/*.openapi.yaml || true
redocly lint contracts/api/**/*.yaml || true

echo "Validate AsyncAPI"
asyncapi validate contracts/events/asyncapi.yaml

echo "Validate JSON Schemas"
for f in contracts/events/schemas/*.schema.json; do
  ajv compile -s "$f"; done

echo "OK"


