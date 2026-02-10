#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../ops/env.sh"

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 required" >&2
  exit 1
fi

echo "[+] Prefetching ALL external datasets into: $DATASETS_DIR"
python3 "$BUNDLE_ROOT/scripts/download_otrf_datasets.py" --all --manifest "$MANIFEST_YAML" --datasets-dir "$DATASETS_DIR"
echo "[+] Done"
