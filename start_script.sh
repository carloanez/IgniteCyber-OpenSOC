#!/usr/bin/env bash
# start-stacks.sh — Start all OpenSOC stacks
set -euo pipefail

REPO_ROOT="/home/ic-soc/IgniteCyber-OpenSOC/ignitecyber-opensoc-labs"

echo "Starting AI Stack (Ollama + JupyterLab)..."
docker compose -f "/home/ic-soc/IgniteCyber-OpenSOC/docker/ai/docker-compose.yml" --profile ai up -d

echo "Starting TheHive + Cortex..."
docker compose -f "${REPO_ROOT}/stacks/stack-case-intel/hive-cortex/docker-compose.yml" up -d

echo "Starting MISP..."
docker compose -f "${REPO_ROOT}/stacks/stack-case-intel/misp-docker/docker-compose.yml" up -d

echo "Starting Wazuh..."
docker compose -f "${REPO_ROOT}/stacks/stack-wazuh-endpoint/docker-compose.yml" up -d

echo "Starting DFIR-Hunt (Timesketch)..."
docker compose -f "${REPO_ROOT}/stacks/stack-dfir-hunt/docker-compose.yml" up -d

echo ""
echo "All stacks started."
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"