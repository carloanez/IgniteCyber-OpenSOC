#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker not found" >&2
  exit 1
fi

echo "[+] Starting baseline containers (compose: $BASELINE_COMPOSE, project: $BASELINE_PROJECT)"
docker compose -p "$BASELINE_PROJECT" -f "$BASELINE_COMPOSE" up -d 

echo "[+] Baseline status"
docker compose -p "$BASELINE_PROJECT" -f "$BASELINE_COMPOSE" ps
