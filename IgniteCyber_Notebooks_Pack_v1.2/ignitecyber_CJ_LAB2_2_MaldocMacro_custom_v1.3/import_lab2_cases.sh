#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

: "${THEHIVE_URL:=http://127.0.0.1:9000}"
: "${THEHIVE_API_KEY:?Set THEHIVE_API_KEY}"

echo "[*] TheHive URL: $THEHIVE_URL"
echo "[*] Importing Lab 2.1 casebundle..."
python3 "$HERE/import_casebundle.py" "$HERE/casebundle_lab2_1.json"

echo "[*] Importing Lab 2.2 casebundle..."
python3 "$HERE/import_casebundle.py" "$HERE/casebundle_lab2_2.json"

echo "[*] Done."
