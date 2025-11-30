#!/usr/bin/env bash

cd "$(dirname "$0")/../stacks/stack-network-soc"

docker compose down
docker compose up -d
docker ps
