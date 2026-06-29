# LAB-2.5 Documentation Creation Summary

Use this summary as source context for creating or updating the book, workbook, instructor materials, student materials, and notebook narrative for LAB-2.5.

## Lab Identity

- **Lab ID:** LAB-2.5
- **Title:** Voice Fraud & Voice Security Triage
- **Day:** 2
- **Day theme:** Phishing, Voice Fraud, and Social Engineering Triage
- **Duration:** 75 minutes
- **Scenario:** Executive impersonation voice fraud leading to help desk MFA reset abuse
- **Primary organization:** ApexFin Solutions
- **Threat actor:** Cinder Jackal
- **Case ID:** CJ-VOICE-001
- **Target user:** `mrivera@apexfin.example`
- **Suspicious caller ID:** `+1-202-555-0148`
- **Callback number:** `+1-202-555-0199`
- **Suspicious domain:** `apexfin-helpdesk-login.example`
- **Suspicious URL:** `https://apexfin-helpdesk-login.example/verify`

## Purpose

LAB-2.5 was added so the 5-Day Cyber AI Analyst Bootcamp explicitly covers voice fraud and voice security from a defensive SOC, incident response, CTI, and AI-assisted investigation perspective.

The lab answers partner and IAUG-style questions about whether the course covers vishing, caller impersonation, enterprise voice fraud, help desk social engineering, MFA reset abuse, and voice-enabled identity attacks.

## Safety Scope

This lab is defensive only.

It uses synthetic call records, synthetic transcripts, simulated help desk events, simulated identity events, endpoint telemetry, Zeek-style HTTP events, MISP CTI, TheHive case artifacts, and local AI-assisted triage.

The lab does not include:

- Voice cloning instructions
- Deepfake generation code
- Real person voice samples
- Real customer phone numbers
- Real Avaya CM configuration or exploitation steps
- Instructions for bypassing voice authentication
- Instructions for committing fraud

## Storyline

ApexFin Solutions receives a suspicious call to the help desk. The caller claims to be the ApexFin CFO, says they are traveling for a board meeting, and urgently requests an MFA reset. The caller provides partial employee information and pressures the help desk technician to bypass normal verification.

The caller requests use of a callback number that does not match the corporate directory. Shortly after the help desk workflow submits the reset, identity logs show a successful MFA device rebind, a new device login, conditional access satisfaction using the new MFA device, and an identity risk increase. Endpoint and Zeek-style HTTP telemetry show browsing to a suspicious look-alike help desk domain and follow-on script activity.

Students must determine whether the incident is malicious, identify the supporting evidence, enrich observables, update the case workflow, draft detection logic, and produce a final analyst report.

## Learning Objectives

Students should be able to:

- Identify social engineering indicators in call metadata and transcripts.
- Distinguish suspicious voice fraud signals from benign help desk calls.
- Correlate call records, help desk tickets, MFA identity events, endpoint events, and Zeek-style network telemetry.
- Use `case_id`, `ticket_id`, `user`, `caller_id`, `source_ip`, and `device_id` as correlation keys.
- Review MISP and TheHive artifacts for voice fraud response.
- Draft detection logic for suspicious help desk MFA reset abuse.
- Use local AI assistance to summarize transcripts while validating every claim against source evidence.
- Recommend process and technical mitigations for voice-enabled identity fraud.

## ATT&CK Mapping

- **T1566.004** - Phishing: Spearphishing Voice
- **T1598.004** - Phishing for Information: Spearphishing Voice
- **T1656** - Impersonation
- **T1078** - Valid Accounts

## Current Stack Used

LAB-2.5 uses the existing bootcamp stack and introduces no major new platform dependency:

- Jupyter notebooks
- OpenSearch / Elastic-style investigation
- Wazuh / Windows / Sysmon-style endpoint events
- Zeek-style HTTP telemetry
- TheHive case bundle
- MISP event bundle
- Ollama / local LLM workflow through the existing notebook helper style
- Markdown, JSON, NDJSON, and YAML artifacts

## Main Files Created

### Notebook

- `IgniteCyber_Notebooks_Pack_v1.2/notebooks/LAB-2.5_Voice_Fraud_Voice_Security_Triage.ipynb`

The notebook includes:

1. Lab overview
2. Scenario brief
3. Learning objectives
4. Dataset loading
5. Call-detail record review
6. Transcript review
7. Help desk ticket analysis
8. MFA / identity event correlation
9. Endpoint and network activity correlation
10. MISP enrichment
11. TheHive case update
12. Detection logic
13. AI-assisted triage with Ollama/SecAssist-style workflow
14. Human validation checklist
15. Final analyst report
16. Reflection questions

### Synthetic Datasets

- `IgniteCyber_Notebooks_Pack_v1.2/datasets/LAB-2.5/voice_call_records.json`
- `IgniteCyber_Notebooks_Pack_v1.2/datasets/LAB-2.5/helpdesk_ticket_events.json`
- `IgniteCyber_Notebooks_Pack_v1.2/datasets/LAB-2.5/mfa_identity_events.json`
- `IgniteCyber_Notebooks_Pack_v1.2/datasets/LAB-2.5/voice_fraud_endpoint_events.json`
- `IgniteCyber_Notebooks_Pack_v1.2/datasets/LAB-2.5/voice_fraud_zeek_http.json`
- `IgniteCyber_Notebooks_Pack_v1.2/datasets/LAB-2.5/voice_fraud_transcripts/call_001_transcript.txt`
- `IgniteCyber_Notebooks_Pack_v1.2/datasets/LAB-2.5/voice_fraud_transcripts/call_002_transcript.txt`

Dataset design:

- 10 synthetic voice call records
- 1 clearly malicious voice fraud event
- 2 suspicious but inconclusive events
- Several benign baseline calls
- Help desk ticket timeline with verification failure, callback mismatch, MFA reset request, and escalation
- MFA identity event timeline with reset request, device rebind, new device login, conditional access challenge, and risk increase
- Endpoint and Zeek-style HTTP events showing follow-on suspicious URL access and script activity

### Lab Wrapper and Documentation

- `IgniteCyber_Notebooks_Pack_v1.2/labs/LAB-2.5/README.md`
- `IgniteCyber_Notebooks_Pack_v1.2/labs/LAB-2.5/start.sh`
- `IgniteCyber_Notebooks_Pack_v1.2/labs/LAB-2.5/stop.sh`
- `IgniteCyber_Notebooks_Pack_v1.2/labs/LAB-2.5/docs/LAB-2.5_Instructor_Guide.md`
- `IgniteCyber_Notebooks_Pack_v1.2/labs/LAB-2.5/docs/LAB-2.5_Student_Guide.md`

Instructor guide emphasis:

- Why voice fraud was added
- Partner / IAUG relevance
- Defensive-only scope
- Expected findings
- Discussion prompts
- Avaya / enterprise voice positioning
- Answer key
- Troubleshooting notes

Student guide includes:

- Scenario
- Learning objectives
- Step-by-step tasks
- Questions to answer
- Evidence collection table
- Final report template

### TheHive, MISP, Dashboard, and Detections

- `IgniteCyber_Notebooks_Pack_v1.2/labs/LAB-2.5/thehive/casebundle_lab2_5_voice_fraud.json`
- `IgniteCyber_Notebooks_Pack_v1.2/labs/LAB-2.5/misp/LAB-2_5_voice_fraud_misp_event.json`
- `IgniteCyber_Notebooks_Pack_v1.2/labs/LAB-2.5/dashboards/opensearch_voice_fraud_dashboard.ndjson`
- `IgniteCyber_Notebooks_Pack_v1.2/labs/LAB-2.5/detections/sigma_voice_fraud_helpdesk_mfa_reset.yml`
- `IgniteCyber_Notebooks_Pack_v1.2/labs/LAB-2.5/detections/opensearch_voice_fraud_queries.md`

TheHive case includes:

- Title: `LAB-2.5 Voice Fraud and Help Desk MFA Reset Abuse`
- Severity: High
- TLP: Amber
- PAP: Amber
- Tags for `voice-fraud`, `vishing`, `helpdesk-social-engineering`, `mfa-reset-abuse`, `cinder-jackal`, and `LAB-2.5`
- Observables for caller ID, callback number, suspicious domain, suspicious URL, source IP, target user, and ticket ID
- Tasks for call review, transcript review, help desk/MFA correlation, endpoint/network review, MISP enrichment, detection drafting, and final reporting

MISP event includes:

- Suspicious caller ID
- Callback number
- Suspicious domain
- Suspicious URL
- Synthetic source IP
- Threat actor context
- Tags for voice fraud, vishing, help desk abuse, MFA reset abuse, Cinder Jackal, and ATT&CK mappings

Detection content includes:

- Sigma-style rule for suspicious voice-driven help desk MFA reset abuse
- OpenSearch query starters for caller ID, callback mismatch, MFA reset, new device login, suspicious domain access, and case timeline review

## Existing Files Updated

- `IgniteCyber_Notebooks_Pack_v1.2/README.md`
- `IgniteCyber_Notebooks_Pack_v1.2/docs/lab_workbook_quickref.md`
- `IgniteCyber_Notebooks_Pack_v1.2/manifest/notebook_manifest.json`
- `.codex/history`

README update added the new Day 2 positioning:

```text
Day 2: Phishing, Voice Fraud, and Social Engineering Triage
```

Day 2 schedule now includes:

```text
LAB-2.1 - Phishing Triage
LAB-2.2 - Maldoc Macro Deobfuscation
LAB-2.3 - LOLBAS mshta Proxy Execution
LAB-2.4 - BITSAdmin Download
LAB-2.5 - Voice Fraud & Voice Security Triage
```

Manifest update added LAB-2.5 after LAB-2.4 and before LAB-3.1.

## Student Deliverables

Students should produce:

- A short incident timeline
- A list of suspicious indicators
- A MISP enrichment summary
- A TheHive case summary
- One detection idea
- A final incident report
- Recommended mitigations

Recommended mitigations:

- Strong help desk identity verification
- Callback to known corporate directory number
- MFA reset approval workflow
- Phishing-resistant MFA where available
- Training for executive impersonation and voice fraud
- Monitoring for suspicious MFA reset patterns
- Caller ID should not be trusted as identity proof

## AI-Assisted Workflow

The notebook includes an AI-assisted triage section using the existing local Ollama helper pattern.

The AI workflow asks students to:

1. Summarize the call transcript
2. Extract social engineering indicators
3. Identify suspicious entities
4. Suggest MITRE ATT&CK mappings
5. Draft a TheHive case summary
6. Draft an executive-ready incident summary
7. Validate AI output against source evidence

Required warning included in the notebook:

```text
AI output must be treated as an analyst assistant, not as evidence. Students must validate all findings against the source logs, transcript, case artifacts, and CTI.
```

## Daily Executive Summary Checkpoint

All bootcamp lab notebooks now include a shared **Daily Executive Summary Checkpoint** section. This makes executive reporting explicit and repeatable across Days 1-5.

The checkpoint:

- Builds from the lab's validated evidence packet, CJ Event Report block, `findings` object, or LAB-2.5 report object.
- Prepares an AI prompt for a local Ollama workflow.
- Requires the model to use only validated evidence.
- Produces a leadership-facing structure with executive summary, what changed today, current risk, validated evidence, decisions/actions needed, open questions, and analyst validation checklist.
- Falls back to a manual template if Ollama is unavailable.
- Saves a draft checkpoint file under `/opt/bootcamp/reports/cj/`.

This checkpoint does not replace analyst judgment. Students must validate every AI-assisted claim against source evidence before sharing or appending the content to the weekly Cinder Jackal report.

## Validation Added

Created:

- `IgniteCyber_Notebooks_Pack_v1.2/scripts/validate_lab_2_5.py`

The validation script checks:

- Required LAB-2.5 files exist
- JSON files are valid
- Notebook JSON is valid
- Manifest includes LAB-2.5
- Manifest notebook path exists
- Phone numbers use reserved `+1-202-555-01xx` format
- Domains use reserved `.example`, `.test`, `.invalid`, or `.localhost` domains, with documented exception for MITRE ATT&CK reference URLs
- Offensive voice/deepfake construction phrases are not present

Validation command:

```bash
python3 IgniteCyber_Notebooks_Pack_v1.2/scripts/validate_lab_2_5.py
```

Last result:

```text
LAB-2.5 validation passed.
```

Additional checks completed:

- Manifest JSON parsed successfully.
- Notebook JSON parsed successfully.
- Dataset JSON loaded successfully.
- Notebook uses existing `ollama_stream` helper style from `bootcamp_lib.py`.

Full notebook execution was not completed locally because `jupyter` was not installed in the environment used for implementation.

## Documentation Guidance

### For the Book

Position LAB-2.5 as the bridge between phishing triage and identity-focused incident response. The book narrative should explain that voice fraud is part of modern social engineering and identity attack chains, especially where help desk workflows can change MFA state.

The book should emphasize:

- Voice is an initial access and information-gathering channel.
- Caller ID is metadata, not proof of identity.
- Help desk verification is a security control.
- MFA reset and rebind workflows require monitoring and approval.
- SOC teams should correlate voice records, tickets, identity events, endpoint logs, and network telemetry.
- AI can help summarize transcript evidence but cannot replace analyst validation.

### For the Workbook

The workbook should guide students through evidence capture:

- Identify suspicious call record.
- Mark social engineering indicators in transcript.
- Correlate `HD-2025-0619-4451` with `CJ-VOICE-001`.
- Prove that the MFA reset was followed by new device login and risky activity.
- Identify suspicious URL and domain access.
- Fill out the evidence collection table.
- Draft detection logic.
- Write mitigations.

The workbook should include short-answer questions and an evidence table rather than long prose.

### For the Notebook

The notebook should remain hands-on:

- Load JSON and transcript files locally.
- Print call records and risk flags.
- Build a sorted case timeline.
- Review MISP and TheHive JSON artifacts.
- Run simple detection logic against the local synthetic events.
- Use Ollama only as an optional assistant.
- Require a human validation checklist before final reporting.

## Partner-Facing Summary

The 5-Day Cyber AI Analyst Bootcamp now includes LAB-2.5, Voice Fraud & Voice Security Triage. The lab covers vishing, caller impersonation, help desk social engineering, MFA reset abuse, MISP enrichment, TheHive case workflow, and AI-assisted transcript triage from a strictly defensive SOC and incident response perspective. It uses synthetic enterprise call records, transcripts, help desk events, identity events, endpoint telemetry, and Zeek-style network data. No offensive voice cloning, deepfake generation, or impersonation tooling is included.
