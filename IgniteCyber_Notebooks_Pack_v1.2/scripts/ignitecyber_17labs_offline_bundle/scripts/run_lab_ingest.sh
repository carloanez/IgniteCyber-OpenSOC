#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../ops/env.sh"

LAB_ID="${1:-}"
if [[ -z "$LAB_ID" ]]; then
  echo "Usage: scripts/run_lab_ingest.sh LAB-2.3" >&2
  exit 2
fi

# Create a deterministic index name (safe chars)
INDEX_BASE="ic-$(echo "$LAB_ID" | tr '[:upper:]' '[:lower:]' | tr '.' '-' | tr '_' '-')"

# Prefetch (if not already present)
python3 "$BUNDLE_ROOT/scripts/download_otrf_datasets.py" --lab "$LAB_ID" --manifest "$MANIFEST_YAML" --datasets-dir "$DATASETS_DIR" || true

# Extract archives to a temp dir
TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

LAB_DATA_DIR="$DATASETS_DIR/$LAB_ID"
if [[ ! -d "$LAB_DATA_DIR" ]]; then
  echo "[!] No datasets dir for $LAB_ID ($LAB_DATA_DIR)" >&2
  exit 0
fi

shopt -s nullglob
ARCHIVES=("$LAB_DATA_DIR"/*.zip "$LAB_DATA_DIR"/*.tar.gz "$LAB_DATA_DIR"/*.tgz)
if [[ ${#ARCHIVES[@]} -eq 0 ]]; then
  echo "[!] No archives found for $LAB_ID in $LAB_DATA_DIR" >&2
  exit 0
fi

for a in "${ARCHIVES[@]}"; do
  echo "[+] Extracting: $(basename "$a")"
  if [[ "$a" == *.zip ]]; then
    unzip -o -q "$a" -d "$TMP_DIR" || true
  else
    tar -xzf "$a" -C "$TMP_DIR" || true
  fi
  
  # Ingest to Elastic
  echo "[+] Ingesting to Elastic index: ${INDEX_BASE}-elastic"
  python3 "$BUNDLE_ROOT/scripts/ingest_bulk.py" --target elastic --index "${INDEX_BASE}-elastic" --path "$TMP_DIR" || true

  # Ingest to Wazuh Indexer
  echo "[+] Ingesting to Wazuh Indexer index: ${INDEX_BASE}-wazuh" 
  python3 "$BUNDLE_ROOT/scripts/ingest_bulk.py" --target wazuh --index "${INDEX_BASE}-wazuh" --path "$TMP_DIR" --insecure || true

done

echo "[+] Lab ingest complete for $LAB_ID"
