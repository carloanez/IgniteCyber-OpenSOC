#!/usr/bin/env bash
set -euo pipefail
LAB_ID="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/ops/start-baseline.sh"

if [[ -n "${LAB_ID}" ]]; then
  "$SCRIPT_DIR/scripts/run_lab_ingest.sh" "$LAB_ID"
else
  echo "Baseline started. To ingest a lab dataset, run: ./scripts/run_lab_ingest.sh LAB-2.1"
fi
