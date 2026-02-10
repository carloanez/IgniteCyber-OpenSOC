#!/usr/bin/env bash
# Environment defaults (override by exporting vars before running scripts)

# Docker Compose
export BASELINE_COMPOSE="${BASELINE_COMPOSE:-/opt/bootcamp/docker-compose.yml}"
export BASELINE_PROJECT="${BASELINE_PROJECT:-ignitecyber}"

# Elastic
export ELASTIC_URL="${ELASTIC_URL:-http://localhost:9200}"
# Either set ELASTIC_APIKEY, or ELASTIC_USER/ELASTIC_PASS
export ELASTIC_USER="${ELASTIC_USER:-elastic}"
export ELASTIC_PASS="${ELASTIC_PASS:-changeme}"

# Wazuh Indexer (OpenSearch)
export WAZUH_INDEXER_URL="${WAZUH_INDEXER_URL:-https://localhost:9201}"
export WAZUH_INDEXER_USER="${WAZUH_INDEXER_USER:-admin}"
export WAZUH_INDEXER_PASS="${WAZUH_INDEXER_PASS:-admin}"

# Local paths
export BUNDLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export MANIFEST_YAML="$BUNDLE_ROOT/manifest/otrf_labs_manifest.yaml"
export DATASETS_DIR="$BUNDLE_ROOT/datasets"
