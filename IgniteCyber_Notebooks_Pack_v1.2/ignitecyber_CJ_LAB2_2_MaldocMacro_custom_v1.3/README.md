# IgniteCyber Custom Dataset — Cinder Jackal Storyline
## Lab Code: LAB2.2 — Maldoc/Macro Analysis (AFS Remittance)

**Company:** ApexFin Solutions (AFS)  
**Threat Actor:** Cinder Jackal

### What this pack contains
- `artifacts/maldoc/AFS_Payment_Remittance.docm` — benign container (no macros)
- `artifacts/maldoc/vba_export_obfuscated.vba` — *training-only* exported VBA text (inert)
- `analysis/olevba_output.txt` — sample tool output to validate your own results
- `analysis/strings_output.txt` — starter strings (simulate quick triage)
- `ioc/ioc.csv` — starter IOC list
- `mitre_mapping.json` — ATT&CK mapping used by the lab notebook

### How to use (offline VM)
1. Copy zip into `/opt/bootcamp/datasets/custom/` and unzip.
2. Follow the LAB2.2 notebook to:
   - identify obfuscation patterns (Chr/Asc/Mid loops)
   - deobfuscate and extract the decoded URL
   - create Sigma-first detections for follow-on execution patterns (mshta, powershell)
   - validate hunts in Elastic indexes: `elastic-agent-*` and `wazuh-alerts-*`.

### Safety note
The VBA sample is **inert** (it only writes a document comment property). No downloads, no command execution.
