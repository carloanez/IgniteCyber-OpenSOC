# IgniteCyber Custom Dataset — Cinder Jackal Storyline
## Lab Code: LAB2.1 — Phishing Triage (AFS Payroll Recon)

**Company:** ApexFin Solutions (AFS)  
**Threat Actor:** Cinder Jackal (financially motivated operator specializing in spearphish + LOLBins)  

### What this pack contains
- `artifacts/email/CJ-LAB2_1-phish.eml` — simulated phishing email
- `artifacts/attachments/AFS_Q4_BonusPlan.docm` — *benign* macro-enabled container (no macros)
- `artifacts/urls/extracted_urls.txt` — URLs you should extract/normalize
- `ioc/ioc.csv` — starter IOC list (you will add hashes after analysis)
- `mitre_mapping.json` — ATT&CK mapping used by the lab notebook
- `thehive/case_template.json` — optional case template to import/create manually in TheHive

### How to use (offline VM)
1. Copy this zip into `/opt/bootcamp/datasets/custom/` and unzip.
2. Create a TheHive case named **LAB2.1 — Phishing Triage** and attach the `.eml` + `.docm`.
3. Follow the LAB2.1 notebook to:
   - parse headers, identify anomalies, and baseline sender infrastructure
   - extract/normalize IOCs (hxxp -> https, [.] -> .)
   - map to ATT&CK (T1566.001, T1566.002, T1204.002, T1071.001)
   - draft Sigma rules first, then validate in Elastic via `zeek-*`, `elastic-agent-*`, and `wazuh-alerts-*`.

### Safety note
All artifacts are **training-only** and **non-malicious**.
