#!/usr/bin/env bash
set -euo pipefail
: "${MISP_URL:=https://localhost}"
: "${MISP_API_KEY:?Set MISP_API_KEY first}"
INPUT="${1:-events/CJ_CAMPAIGN_SPINE_misp_event.json}"
python3 scripts/import_misp_bundle.py --misp-url "$MISP_URL" --api-key "$MISP_API_KEY" --input "$INPUT" --insecure
