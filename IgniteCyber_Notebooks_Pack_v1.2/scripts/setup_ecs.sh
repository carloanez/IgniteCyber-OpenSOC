#!/bin/bash
# ECS normalization setup for Wazuh archives
# Injects ECS processor into Filebeat's existing pipeline
# Usage: bash setup_ecs.sh /path/to/ecs_pipeline.json

set -e

CERT_DIR="/home/malulu/IgniteCyber-OpenSOC/ignitecyber-opensoc-labs/stacks/stack-wazuh-endpoint/config/wazuh_indexer_ssl_certs"
OPENSEARCH="https://localhost:9200"
CREDS="admin:SecretPassword"
PIPELINE_JSON="${1:-./ecs_pipeline.json}"
FILEBEAT_PIPELINE="filebeat-7.10.2-wazuh-archives-pipeline"

if [ ! -f "$PIPELINE_JSON" ]; then
  echo "ERROR: Pipeline JSON not found at $PIPELINE_JSON"
  exit 1
fi

os_curl() {
  curl -sk \
    --cacert "${CERT_DIR}/root-ca.pem" \
    --cert "${CERT_DIR}/admin.pem" \
    --key "${CERT_DIR}/admin-key.pem" \
    -u "${CREDS}" \
    "$@"
}

check() {
  local label="$1"
  local result="$2"
  if echo "$result" | grep -q '"acknowledged":true'; then
    echo ">>> $label OK"
  else
    echo ">>> $label FAILED: $result"
    exit 1
  fi
}

# ── Step 1: Clean up old templates and indices ────────────────────────────────
echo ""
echo "Step 1: Cleaning up old templates and indices..."
os_curl -X DELETE "$OPENSEARCH/_index_template/wazuh-archives-template" || true
os_curl -X DELETE "$OPENSEARCH/_index_template/wazuh-archives-port-fix" || true
os_curl -X DELETE "$OPENSEARCH/_index_template/wazuh-archives-ecs" || true
os_curl -X DELETE "$OPENSEARCH/wazuh-archives-4.x-*" || true
os_curl -X DELETE "$OPENSEARCH/wazuh-archives-ecs" || true
os_curl -X DELETE "$OPENSEARCH/wazuh-archives-4.x-ecs" || true
echo ">>> Step 1 OK"

# ── Step 4: Append ECS processor to Filebeat pipeline ────────────────────────
echo ""
echo "Step 4: Injecting ECS processor into Filebeat pipeline..."
os_curl "$OPENSEARCH/_ingest/pipeline/$FILEBEAT_PIPELINE" > /tmp/existing_pipeline.json

RESULT=$(python3 << PYEOF
import json, subprocess, os

cert_dir = "$CERT_DIR"
opensearch = "$OPENSEARCH"
pipeline_name = "$FILEBEAT_PIPELINE"
pipeline_json = "$PIPELINE_JSON"

# Load ECS source directly from file - no shell variable
ecs = json.load(open(pipeline_json))
ecs_source = ecs['processors'][0]['script']['source']

# Load existing pipeline from temp file - no shell variable
existing = json.load(open('/tmp/existing_pipeline.json'))
pipeline = existing[pipeline_name]

# Remove any previously injected ECS processor
pipeline['processors'] = [
    p for p in pipeline['processors']
    if not p.get('script', {}).get('source', '').startswith('String basename')
]

# Append ECS processor
pipeline['processors'].append({
    'script': {
        'lang': 'painless',
        'source': ecs_source,
        'ignore_failure': True
    }
})

# Write to temp file and push with curl
open('/tmp/updated_pipeline.json', 'w').write(json.dumps(pipeline))
print('{"acknowledged":true}')
PYEOF
)

RESULT=$(os_curl \
  -X PUT "$OPENSEARCH/_ingest/pipeline/$FILEBEAT_PIPELINE" \
  -H 'Content-Type: application/json' \
  -d "@/tmp/updated_pipeline.json")
check "Filebeat pipeline update" "$RESULT"

# ── Step 5: Verify ECS processor was added ────────────────────────────────────
echo ""
echo "Step 5: Verifying pipeline update..."
VERIFY=$(os_curl "$OPENSEARCH/_ingest/pipeline/$FILEBEAT_PIPELINE")
if echo "$VERIFY" | grep -q "basename"; then
  echo ">>> ECS processor present in Filebeat pipeline OK"
else
  echo ">>> Verification FAILED - ECS processor not found in pipeline"
  exit 1
fi

# ── Step 6: Create index template with data.* mapping ────────────────────────
# ── Step 6: Create index template with data.* mapping ────────────────────────
echo ""
echo "Step 6: Creating index template..."
RESULT=$(os_curl \
  -X PUT "$OPENSEARCH/_index_template/wazuh-archives-template" \
  -H 'Content-Type: application/json' -d @- << 'EOF'
{
  "index_patterns": ["wazuh-archives-4.x-*"],
  "priority": 500,
  "template": {
    "mappings": {
      "properties": {
        "data": {
          "properties": {
            "port": { "type": "keyword" }
          }
        }
      },
      "dynamic_templates": [
        {
          "data_strings": {
            "path_match": "data.*",
            "match_mapping_type": "string",
            "mapping": { "type": "keyword" }
          }
        }
      ]
    }
  }
}
EOF
)


check "Template creation" "$RESULT"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "================================================================"
echo "Setup complete."
echo ""
echo "Now run your ingest script:"
echo "  bash log_ingest.sh"
echo ""
echo "Every document will have ECS fields automatically."
echo "Query using: wazuh-archives-4.x-*"
echo "================================================================"
