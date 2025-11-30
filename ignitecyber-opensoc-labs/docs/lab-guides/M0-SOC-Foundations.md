# Module 0 – SOC Foundations

## Goals
- Deploy network SOC stack
- Replay PCAPs in Zeek
- View logs in Kibana
- Map findings to MITRE ATT&CK

---

## 1. Start the SOC Stack

cd stacks/stack-network-soc
docker compose -f docker-compose.yml -f docker-compose.module0.yml up -d

---

## 2. Load PCAPs

../../scripts/load-pcaps-network-soc.sh ../../datasets/module0/pcaps

---

## 3. Open Kibana

http://<IC-SOC-LAB-IP>:5601

---

## 4. Run KQL Queries

Example:

url.path : "*.ps1"
