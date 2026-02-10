#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

echo "[-] Stopping baseline containers (project: $BASELINE_PROJECT)"
docker compose -p "$BASELINE_PROJECT" -f "$BASELINE_COMPOSE" down
