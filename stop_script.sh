#!/usr/bin/env bash
# stop-stacks.sh — Stop all OpenSOC stacks
set -euo pipefail

REPO_ROOT="/home/ic-soc/IgniteCyber-OpenSOC/ignitecyber-opensoc-labs"

echo "Stopping DFIR-Hunt (Timesketch)..."
docker compose -f "${REPO_ROOT}/stacks/stack-dfir-hunt/docker-compose.yml" down

echo "Stopping Wazuh..."
docker compose -f "${REPO_ROOT}/stacks/stack-wazuh-endpoint/docker-compose.yml" down

echo "Stopping MISP..."
docker compose -f "${REPO_ROOT}/stacks/stack-case-intel/misp-docker/docker-compose.yml" down

echo "Stopping TheHive + Cortex..."
docker compose -f "${REPO_ROOT}/stacks/stack-case-intel/hive-cortex/docker-compose.yml" down

echo "Stopping AI Stack (Ollama + JupyterLab)..."
docker compose -f "/home/ic-soc/IgniteCyber-OpenSOC/docker/ai/docker-compose.yml" --profile ai down

echo ""
echo "All stacks stopped."