# Cinder Jackal MISP Event Report Bundle

This file mirrors the event reports embedded in the JSON bundle.

## LAB-1.1 — Hosted Lab Onboarding + Health Checks

- Case: CJ-001
- Date: 2025-06-16
- ATT&CK: T1082

Students verify the local SOC stack, confirm telemetry readiness, and establish the Cinder Jackal campaign context before promoting any intel into MISP.

## LAB-1.2 — Baseline Dashboards (Zeek + Endpoint Telemetry)

- Case: CJ-002
- Date: 2025-06-18
- ATT&CK: T1046

Students establish baseline network and endpoint behavior so later Cinder Jackal activity can be compared against normal traffic.

## LAB-1.3 — First Detection: Suspicious PowerShell (Sigma)

- Case: CJ-003
- Date: 2025-06-20
- ATT&CK: T1059.001

Students triage suspicious PowerShell behavior and create the first Sigma-driven detection artifact for the campaign.

## LAB-2.1 — Phishing Case Triage (Elastic Casebook-style)

- Case: CJ-004
- Date: 2025-07-08
- ATT&CK: T1566.001

Students triage a reported phishing lead, capture observables, and prepare a casebook entry before expanding into malware/macro analysis.

## LAB-2.2 — Maldoc/Macro Analysis + Deobfuscation + IOC Extraction

- Case: CJ-005
- Date: 2025-07-10
- ATT&CK: T1204.002, T1059.001, T1027

Students deobfuscate a suspicious document macro and promote extracted indicators into MISP with confidence and validation notes.

## LAB-2.3 — LOLBAS Proxy Execution: mshta.exe

- Case: CJ-006
- Date: 2025-07-15
- ATT&CK: T1218.005

Students investigate mshta proxy execution that launches a scriptlet over HTTPS and pivots into spawned child process behavior.

## LAB-2.4 — Stage 2 Download: bitsadmin.exe

- Case: CJ-007
- Date: 2025-07-17
- ATT&CK: T1197, T1105

Students investigate BITSAdmin used as a living-off-the-land downloader and record the download URL, target path, and process evidence.

## LAB-3.1 — C2 Beacon Investigation (Cobalt Strike patterns)

- Case: CJ-008
- Date: 2025-08-05
- ATT&CK: T1071.001, T1573.002

Students pivot from suspicious process behavior to C2-like web beaconing and named-pipe behavior, then promote confirmed CTI into MISP.

## LAB-3.2 — Lateral Movement: WinRM + Remote Scheduled Tasks

- Case: CJ-009
- Date: 2025-08-07
- ATT&CK: T1021.006, T1053.005

Students correlate PowerShell remoting/WinRM-style activity with scheduled task creation or modification across Windows hosts.

## LAB-3.3 — Timeline Reconstruction (Elastic-based, Timesketch optional)

- Case: CJ-010
- Date: 2025-08-12
- ATT&CK: T1074.001

Students reconstruct the campaign chain from execution to transfer and C2-like behavior using evidence already promoted into TheHive and MISP.

## LAB-4.1 — Persistence Hunt: Run Keys + Scheduled Tasks

- Case: CJ-011
- Date: 2025-08-26
- ATT&CK: T1547.001, T1053.005

Students hunt persistence signals in registry and scheduled task telemetry and distinguish benign administrative actions from suspicious CJ tradecraft.

## LAB-4.2 — Credential Access Signal: Rubeus ASKTGT CreateNetOnly

- Case: CJ-012
- Date: 2025-08-28
- ATT&CK: T1003.003, T1555

Students review credential access signals, including credential prompt behavior and credential-manager access, then document confidence and limitations.

## LAB-4.3 — Threat Hunting Workflow (ELK): Hypothesis → Query → Validate → Report

- Case: CJ-013
- Date: 2025-09-02
- ATT&CK: T1087

Students convert hypotheses into Elastic queries, validate results against case evidence, and decide what should be promoted into MISP as actionable CTI.

## LAB-5.1 — AI Triage Assistant (Validated Summaries)

- Case: CJ-014
- Date: 2025-09-09
- ATT&CK: T1119

Students use AI to draft triage summaries, then validate every claim against evidence before promoting final CTI or case notes.

## LAB-5.2 — AI-Assisted Sigma Authoring + Unit Tests

- Case: CJ-015
- Date: 2025-09-10
- ATT&CK: T1027

Students use AI to accelerate Sigma authoring but validate detections with unit tests and known-good/known-bad examples.

## LAB-5.3 — AI-Assisted ATT&CK Mapping + Reporting

- Case: CJ-016
- Date: 2025-09-11
- ATT&CK: T1074

Students complete final ATT&CK mapping and reporting, linking MISP event context back to TheHive case evidence and final incident report.

## CAPSTONE — Project Obsidian Mini-CTF / Full Campaign

- Case: CJ-017
- Date: 2025-09-12
- ATT&CK: T1566.001, T1204.002, T1059.001, T1218.005, T1197, T1071.001, T1053.005, T1547.001, T1003.003, T1119

Capstone event aggregates validated observables across the full Cinder Jackal campaign for final reporting and scoring.

## LAB-3.4 — Log4Shell JNDI Reference Traffic

- Case: CJ-010B
- Date: 2025-08-14
- ATT&CK: T1190, T1059.004, T1105

Optional network exploit evidence demonstrates a Log4Shell/JNDI request, LDAP reference, HTTP class retrieval, and reverse-shell style payload in a safe lab.