# Docker Stack

# IgniteCyber OpenSOC — Docker AI Profile 

This guide helps interns **spin up and validate** the optional **AI profile** components for IgniteCyber OpenSOC:

- **Ollama** (local LLM runtime)
- **JupyterLab** (notebooks for AI-assisted SOC workflows)

The AI profile is designed to run **independently** from the baseline SOC stack so you can start/stop it as needed.

---

## Folder Layout (Expected)

Create/confirm these files exist:

```text
docker/
  ai/
    docker-compose.ai.yml
    scripts/
      pull-models.sh
      smoke-test.sh
  jupyterlab/
    Dockerfile
    requirements.txt

Prerequisites
1) VM Requirements

Docker Engine installed

Docker Compose v2 available

Enough disk space for models (recommend 30–60GB free minimum)

Check:

docker --version
docker compose version
df -h

2) Repo + Environment File

From repo root:

cp .env.example .env

Recommended .env defaults:

OPENSOC_NETWORK=ignitecyber

OLLAMA_BIND=127.0.0.1
OLLAMA_PORT=11434

JUPYTER_BIND=127.0.0.1
JUPYTER_PORT=8888
JUPYTER_TOKEN=ignitecyber

Network Setup (One-Time)

The AI compose expects an external Docker network (default: ignitecyber).

Check/create:

docker network ls | grep ignitecyber || docker network create ignitecyber

If your baseline stack uses a different network name, set it in .env:

OPENSOC_NETWORK=<your_network_name>

Start the AI Profile

From repo root:

docker compose -f docker/ai/docker-compose.ai.yml --profile ai up -d --build


Verify containers are running:

docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

✅ Pass criteria

opensoc-ollama is Up

opensoc-jupyterlab is Up

Ports are bound to localhost:

127.0.0.1:11434 (Ollama)

127.0.0.1:8888 (JupyterLab)

Pull Standard Models

Make scripts executable (first time only):

chmod +x docker/ai/scripts/*.sh

Pull the standard model set:

./docker/ai/scripts/pull-models.sh

✅ Pass criteria

ollama list shows the pulled models

No errors during pulls

If disk is limited, pull fewer models first (start with llama3.2:3b).

Run a Smoke Test (Ollama API)
./docker/ai/scripts/smoke-test.sh


✅ Pass criteria

/api/tags returns a model list

A non-empty response is returned for the prompt

Validate JupyterLab
1) Open JupyterLab

From the VM browser (or port-forwarded on your host):

http://127.0.0.1:8888

Token (default):

ignitecyber (or whatever you set in .env)

2) Notebook Test (Copy/Paste)

Create a new notebook and run:

import os, requests

base = os.environ.get("OLLAMA_BASE_URL", "http://127.0.0.1:11434")

r = requests.post(f"{base}/api/generate", json={
  "model": "llama3.2:3b",
  "prompt": "Return a JSON object with keys: risk, summary. Scenario: suspicious PowerShell encoded command.",
  "stream": False
})

print(r.status_code)
print(r.json()["response"])

✅ Pass criteria

Status code is 200

Response prints successfully

Stability & Performance Checks
1) Basic Resource Snapshot
docker stats --no-stream

2) Repeat Prompt Test (10 Runs)
for i in {1..10}; do ./docker/ai/scripts/smoke-test.sh >/tmp/ai_test_$i.txt; done


✅ Pass criteria

No container restarts

No timeouts/errors across 10 runs

Stop the AI Profile
docker compose -f docker/ai/docker-compose.ai.yml --profile ai down


This stops only the AI profile containers defined in the AI compose file.

Troubleshooting
View Logs

Ollama:

docker logs opensoc-ollama --tail 200


JupyterLab:

docker logs opensoc-jupyterlab --tail 200

Common Issues

1) Port already in use

Change OLLAMA_PORT or JUPYTER_PORT in .env

Re-run up -d

2) “No space left on device” during model pulls

Remove unused Docker artifacts:

docker system prune -af


Pull fewer models (start with llama3.2:3b)

3) Jupyter doesn’t start

Check logs and confirm Dockerfile/requirements build successfully:

docker compose -f docker/ai/docker-compose.ai.yml --profile ai up -d --build
docker logs opensoc-jupyterlab --tail 200

Recommended Standard Models (Baseline)

Suggested starter pack:

llama3.2:3b (fast + general)

qwen2.5:7b-instruct (quality + multilingual)

qwen2.5-coder:7b-instruct (coding + detections)

phi3.5:mini (lightweight backup)

Notes

Do not commit .env (it should be gitignored).

Do not commit Ollama model blobs (stored in Docker volume ollama_models).

If you hit blockers, capture:

docker ps

docker logs opensoc-ollama --tail 200

docker logs opensoc-jupyterlab --tail 200

