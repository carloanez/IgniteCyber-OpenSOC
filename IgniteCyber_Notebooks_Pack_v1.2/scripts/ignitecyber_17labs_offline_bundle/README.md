# IgniteCyber Academy - 17 Labs Bundle

This bundle contains SANS-style start/stop wrappers, ingest helpers, and a per-lab dataset manifest.

## Contents
- notebooks/ : 17 lab notebooks
- manifest/otrf_labs_manifest.yaml : external dataset archives by lab (primarily OTRF/Security-Datasets)
- ops/ : baseline start/stop wrappers
- scripts/ : dataset prefetch + Elastic/Wazuh ingest helpers
- labs/ : per-lab READMEs

## Quick start
1) Configure endpoints and compose file in ops/env.sh
2) Start baseline containers:
   ./ops/start-baseline.sh
3) Prefetch all external datasets (requires internet):
   ./scripts/prefetch_all.sh
4) Run a lab ingest (example):
   ./scripts/run_lab_ingest.sh LAB-3.1
5) Stop baseline containers:
   ./ops/stop-baseline.sh


## Build a fully-offline ZIP (recommended)
On a machine with internet access:
  ./scripts/build_offline_bundle.sh
This will download the external dataset archives into `datasets/` and create `ignitecyber_17labs_offline_full.zip`.
