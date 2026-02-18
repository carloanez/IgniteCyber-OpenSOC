#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1:11434}"
MODEL="${MODEL:-llama3.2:3b}"

echo "[*] Checking Ollama tags..."
curl -s "${BASE_URL}/api/tags" | jq '.models[].name' | head

echo "[*] Running a quick generate test on ${MODEL}..."
curl -s "${BASE_URL}/api/generate" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "'"${MODEL}"'",
    "prompt": "You are a SOC assistant. Summarize the top 3 checks for suspicious PowerShell in 3 bullets.",
    "stream": false
  }' | jq -r '.response' | sed -e 's/\\n/\n/g'
