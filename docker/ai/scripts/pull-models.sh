#!/usr/bin/env bash
set -euo pipefail

OLLAMA_CONTAINER="${OLLAMA_CONTAINER:-opensoc-ollama}"

MODELS=(
  "llama3.2:3b"
  "qwen2.5:7b-instruct"
  "qwen2.5-coder:7b-instruct"
  "phi3.5:mini"
)

echo "[*] Pulling models into ${OLLAMA_CONTAINER}..."
for m in "${MODELS[@]}"; do
  echo "  - ollama pull ${m}"
  docker exec -it "${OLLAMA_CONTAINER}" ollama pull "${m}"
done

echo "[*] Done. Installed models:"
docker exec -it "${OLLAMA_CONTAINER}" ollama list
