#!/usr/bin/env bash
set -euo pipefail

# Generate SDKs from OpenAPI/gRPC (placeholder commands)

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)

echo "Generating OpenAPI clients..."
# Example with openapi-generator (requires installation)
# openapi-generator generate -i $ROOT_DIR/contracts/api/trading-oms.openapi.yaml -g typescript-axios -o $ROOT_DIR/libs/sdk/oms-ts
# openapi-generator generate -i $ROOT_DIR/contracts/api/market-data.openapi.yaml -g typescript-axios -o $ROOT_DIR/libs/sdk/marketdata-ts

echo "Generating gRPC stubs..."
# Example with buf/protoc
# buf generate

echo "Done."


