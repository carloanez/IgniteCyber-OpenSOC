# Module 6 – AI-Assisted Threat Detection & Lab Automation
**Goal:** Integrate AI/LLM helpers into SOC workflows to speed up triage, enrichment, detection engineering, and reporting—always with a human-in-the-loop.

## Learning Objectives
- Identify where AI fits in SOC operations (triage, summarization, correlation).
- Use LLM assistants to explain alerts, map to MITRE ATT&CK, and draft detections.
- Automate enrichment playbooks (TheHive/Cortex-friendly outputs).
- Evaluate AI outputs for accuracy, hallucinations, bias, and privacy.

## Lab Flow (90–120 min)
1. **Warm-up:** Review Wazuh/Zeek alerts for a phishing → PowerShell chain.
2. **AI Triage:** Run `ai_triage.py` on a Wazuh alert JSON; generate ATT&CK mapping and an analyst summary.
3. **Detection Assist:** Prompt the model to propose a Sigma rule skeleton; refine manually.
4. **Playbook Output:** Export a short incident note suitable for TheHive.
5. **Debrief:** Validate findings; document AI wins/pitfalls.

## Tools
- Elastic (Kibana), Wazuh, Zeek
- Python 3.10+
- Optional LLM backends: OpenAI API or local **Ollama** (e.g., `llama3`, `qwen2.5-coder`)

## MITRE ATT&CK Emphasis
- **TA0002 – Execution** → T1059 (Command/Scripting)
- **TA0007 – Discovery**, **TA0008 – Lateral Movement**
- **TA0040 – Impact** (response considerations)

## Deliverables
- `artifacts/ai_triage_summary.md`
- `sigma/T1059_candidate.yml` (human-reviewed)
- `reports/incident_note_thehive.md`

> ⚠️ **Data handling:** Never paste tenant-identifiable or regulated data into third-party APIs. Prefer local models or redaction.

