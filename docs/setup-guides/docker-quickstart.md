# Docker Quickstart

1. Install Docker Desktop and enable Compose V2.
2. Copy `.env.example` to `.env` and adjust memory (>= 6 GB recommended).
3. Start: `docker compose -f docker/docker-compose.yml up -d`
4. Verify: `docker ps` and open Kibana at http://localhost:5601
