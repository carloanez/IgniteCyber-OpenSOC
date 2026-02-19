# AI Profile Test Results (VM)

## VM Specs
- CPU: 6 vCPU (12th Gen Intel(R) Core(TM) i5-12600K)
- RAM: 11 GiB
- Disk: 147G total, ~110G free (22% used)

## Versions
- OS/Kernel: Ubuntu 24.04.x (kernel 6.17.0-14-generic)
- Python: 3.12.3
- Docker: 28.2.2
- Docker Compose: v5.0.2
- JupyterLab: 4.5.4
- Ollama: 0.16.1

## AI Profile Containers
Command used:
- `docker compose --env-file .env -f docker/ai/docker-compose.ai.yml --profile ai up -d --build`

Result:
- opensoc-ollama: PASS (Up)
- opensoc-jupyterlab: PASS (Up)

Notes:
- Port conflict encountered with baseline stack using 127.0.0.1:11434 (ollama already running on host).
- Fix: changed `OLLAMA_PORT` to 11435 in `.env`, then brought AI profile up again.

## Models Pulled
Pulled successfully:
- llama3.2:3b
- qwen2.5:7b-instruct
- qwen2.5-coder:7b-instruct
- phi3:mini

Issue:
- `phi3.5:mini` failed with "file does not exist"
Fix:
- used `phi3:mini` instead.

## Tests (Pass/Fail)
### Container up/down
- PASS: `up -d --build`
- PASS: `down` stops only AI profile containers

### Model pulls
- PASS: models listed in `ollama list`
- NOTE: `phi3.5:mini` tag invalid; used `phi3:mini`

### Smoke test
- PASS: `./docker/ai/scripts/smoke-test.sh` returns model tags + generates response with llama3.2:3b

### Jupyter notebook test
- PASS: Notebook request to `http://ollama:11434/api/generate` returned HTTP 200 and valid JSON response.

## Recommendation
- SOC assistant: `llama3.2:3b` (fast, good general SOC explanations)
- Sigma/KQL/coding helper: `qwen2.5-coder:7b-instruct` (best for structured queries / code)
