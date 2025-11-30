# IgniteCyber OpenSOC Labs

This directory contains the Docker-based lab environment for the IgniteCyber Academy SOC Analyst curriculum.

Each student runs a full SOC locally using:
- One Linux VM (IC-SOC-LAB) with Docker
- One Windows VM (IC-WIN-WS) as the endpoint / analyst workstation

## Layout

- vm-setup/ — Host + VM setup instructions
- stacks/ — Docker stacks (network SOC, Wazuh, case intel, DFIR)
- datasets/ — Synthetic pcaps, logs, and email samples
- docs/ — Lab guides & MITRE ATT&CK mappings
- scripts/ — Helper scripts

## Quickstart (Module 0)

On IC-SOC-LAB:

cd ~/IgniteCyber-OpenSOC/ignitecyber-opensoc-labs/stacks/stack-network-soc
docker compose -f docker-compose.yml -f docker-compose.module0.yml up -d
../../scripts/load-pcaps-network-soc.sh ../../datasets/module0/pcaps

Then from IC-WIN-WS open:

http://<IC-SOC-LAB-IP>:5601

and explore Zeek logs in Kibana.
