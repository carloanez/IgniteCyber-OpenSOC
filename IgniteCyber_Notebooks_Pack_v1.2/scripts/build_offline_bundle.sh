#!/usr/bin/env bash
# Build a fully-offline distributable ZIP by prefetching all datasets, then zipping the bundle directory.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

"$SCRIPT_DIR/prefetch_all.sh"

OUT_ZIP="${1:-$PWD/ignitecyber_17labs_offline_full.zip}"
(
  cd "$(dirname "$ROOT_DIR")"
  ZIP_ROOT="$(basename "$ROOT_DIR")"
  zip -r "$OUT_ZIP" "$ZIP_ROOT" >/dev/null
)

echo "[+] Built offline bundle: $OUT_ZIP"
