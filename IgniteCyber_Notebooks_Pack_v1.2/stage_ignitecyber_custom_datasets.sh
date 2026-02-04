#!/usr/bin/env bash
set -euo pipefail

DEST="${1:-/opt/bootcamp/datasets/custom}"
sudo mkdir -p "$DEST"

echo "[*] Staging IgniteCyber custom datasets and TheHive case workflows to: $DEST"

sudo cp -v /mnt/data/ignitecyber_CJ_LAB2_1_PhishTriage_custom_v1.2.zip "$DEST"/
sudo cp -v /mnt/data/ignitecyber_CJ_LAB2_2_MaldocMacro_custom_v1.2.zip "$DEST"/
sudo cp -v /mnt/data/ignitecyber_CJ_STORY_DATASET_bundle_v1.0.zip "$DEST"/

echo "[*] Done. Next:"
echo "  - unzip LAB2 zips for TheHive import and artifacts"
echo "  - unzip story dataset and run ingest_cinderjackal_to_elastic.py"
