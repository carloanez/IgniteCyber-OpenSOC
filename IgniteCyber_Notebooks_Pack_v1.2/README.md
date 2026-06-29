# IgniteCyber Bootcamp Notebooks Pack (v1.1)

Offline-only Jupyter notebooks aligned to the IgniteCyber Academy **5-Day Cyber AI Analyst Bootcamp** labs.

## Key paths
- Notebooks: `notebooks/`
- Datasets (ZIP): `/opt/bootcamp/datasets`
- Index patterns: `zeek-*`, `wazuh-alerts-*`, `elastic-agent-*`
- Ollama: `http://localhost:11434`

## What’s included
- One notebook per lab (aligned to lab codes).
- Shared helper: `notebooks/bootcamp_lib.py`
- Lab workbook quick reference: `docs/lab_workbook_quickref.md`
- Attribution & reference links: `docs/references.md`
- Manifest: `manifest/notebook_manifest.json`

## Daily Executive Summary Checkpoint

Each lab notebook includes a **Daily Executive Summary Checkpoint**. Students use the checkpoint to convert validated evidence into a short executive-ready update with help from the local AI assistant when Ollama is available. The checkpoint saves a draft template under `/opt/bootcamp/reports/cj/` and requires analyst validation before anything is shared or appended to the weekly Cinder Jackal report.

## Day 2: Phishing, Voice Fraud, and Social Engineering Triage

Day 2 now includes a voice fraud and voice security lab focused on vishing, caller impersonation, help desk social engineering, MFA reset abuse, and AI-assisted SOC triage. This lab is defensive and uses synthetic call records, transcripts, help desk events, identity events, endpoint logs, network telemetry, MISP CTI, and TheHive case management.

- LAB-2.1 — Phishing Triage
- LAB-2.2 — Maldoc Macro Deobfuscation
- LAB-2.3 — LOLBAS mshta Proxy Execution
- LAB-2.4 — BITSAdmin Download
- LAB-2.5 — Voice Fraud & Voice Security Triage

Generated: 2026-02-02T21:38:28.991261Z
