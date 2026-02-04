# Bootcamp Lab Workbook Quick Reference (v1.1)

Offline-only. Use the aligned notebook for each lab.

## Lab 1.1 — Hosted Lab Onboarding + Health Checks
- **Day:** 1  | **Book:** 1
- **Notebook:** `notebooks/LAB-1.1_Onboarding_HealthChecks.ipynb`
- **ATT&CK:**
  - **TA0007 / T1082** — System Information Discovery
- **Datasets (offline ZIPs):**
  _(No external dataset required — use the pre-indexed lab telemetry.)_
- **Tasks:**
  - Verify Elastic cluster health and authenticate.
  - Confirm that index patterns (`zeek-*`, `wazuh-alerts-*`, `elastic-agent-*`) return data.
  - Record ingestion status (healthy/yellow/red), unassigned shards, and most recent event timestamp per index family.
- **Starter KQL pivots:**
  - `index:zeek-* and @timestamp>=now-24h`
  - `index:wazuh-alerts-* and @timestamp>=now-24h`
  - `index:elastic-agent-* and @timestamp>=now-24h`

## Lab 1.2 — Baseline Dashboards (Zeek + Endpoint Telemetry)
- **Day:** 1  | **Book:** 1
- **Notebook:** `notebooks/LAB-1.2_Baseline_Dashboards_Zeek_Endpoint.ipynb`
- **ATT&CK:**
  - **TA0007 / T1046** — Network Service Discovery
- **Datasets (offline ZIPs):**
  _(No external dataset required — use the pre-indexed lab telemetry.)_
- **Tasks:**
  - Build a baseline view of top talkers (src/dst), top ports, and top domains in `zeek-*`.
  - Build an endpoint baseline: top processes, top parent processes, and top command-line tokens in `elastic-agent-*`.
  - Document what 'normal' looks like for later anomaly hunting.
- **Starter KQL pivots:**
  - `event.dataset:zeek.conn and @timestamp>=now-24h`
  - `process.name:* and @timestamp>=now-24h`

## Lab 1.3 — First Detection: Suspicious PowerShell (Sigma)
- **Day:** 1  | **Book:** 1
- **Notebook:** `notebooks/LAB-1.3_First_Detection_Suspicious_PowerShell_Sigma.ipynb`
- **ATT&CK:**
  - **TA0002 / T1059.001** — PowerShell
- **Datasets (offline ZIPs):**
  _(No external dataset required — use the pre-indexed lab telemetry.)_
- **Tasks:**
  - Hunt for encoded PowerShell (`-enc`, `FromBase64String`, `IEX`).
  - Identify parent process and user context for suspicious executions.
  - Create a Sigma rule and validate it against collected events.
  - Propose a tuning plan (reduce false positives).
- **Starter KQL pivots:**
  - `process.name:powershell.exe and process.command_line:(* -enc * or *FromBase64String* or *IEX* or *Invoke-Expression*)`

## Lab 2.1 — Phishing Case Triage (Elastic Casebook-style)
- **Day:** 2  | **Book:** 2
- **Notebook:** `notebooks/LAB-2.1_Phishing_Triage_Elastic_Casebook.ipynb`
- **ATT&CK:**
  - **TA0001 / T1566.001** — Spearphishing Attachment
- **Datasets (offline ZIPs):**
  _(No external dataset required — use the pre-indexed lab telemetry.)_
- **Tasks:**
  - Pivot from a suspicious email/URL to Zeek HTTP/DNS evidence.
  - Identify affected user/host and first time seen.
  - Build a case timeline of initial access.
  - Draft containment: block domain/IP, isolate host, reset creds.
- **Starter KQL pivots:**
  - `event.dataset:zeek.http and (url.full:*login* or url.full:*oauth* or url.full:*microsoftonline*)`
  - `event.dataset:zeek.dns and (dns.question.name:*login* or dns.question.name:*microsoftonline*)`

## Lab 2.2 — Maldoc/Macro Analysis + Deobfuscation (Offline) + IOC Extraction
- **Day:** 2  | **Book:** 2
- **Notebook:** `notebooks/LAB-2.2_Maldoc_Macro_Deobfuscation_IOC_Extraction.ipynb`
- **ATT&CK:**
  - **TA0002 / T1204.002** — Malicious File
- **Datasets (offline ZIPs):**
  _(No external dataset required — use the pre-indexed lab telemetry.)_
- **Tasks:**
  - Parse a provided macro/script snippet and deobfuscate key strings.
  - Extract IOCs (URLs, domains, IPs, file names, registry paths).
  - Create 2 KQL pivots and 1 Sigma rule proposal based on extracted artifacts.

## Lab 2.3 — LOLBAS Proxy Execution: mshta.exe (T1218.005)
- **Day:** 2  | **Book:** 2
- **Notebook:** `notebooks/LAB-2.3_LOLBAS_mshta_ProxyExecution_T1218_005.ipynb`
- **ATT&CK:**
  - **TA0005 / T1218.005** — Mshta
- **Datasets (offline ZIPs):**
  - Mshta VBScript Execute PowerShell *(hint: `mshta_vbscript_execute_psh`)* — mapped to **T1218.005**
  - Mshta Javascript GetObject Sct *(hint: `mshta_javascript_getobject_sct`)* — mapped to **T1218.005**
  - Mshta HTML Application (HTA) Execution *(hint: `mshta_html_application_execution`)* — mapped to **T1218.005**
- **Tasks:**
  - Find mshta execution events and identify their parent processes.
  - Determine the payload source (local .hta vs remote scriptlet / URL).
  - Correlate endpoint execution with Zeek DNS/HTTP around the same time window.
  - Write a Sigma rule and validate it against your evidence.
- **Starter KQL pivots:**
  - `process.name:mshta.exe`
  - `process.command_line:(*vbscript:Execute(* or *javascript:* or *.hta* or *GetObject(* )`

## Lab 2.4 — Stage 2 Download: bitsadmin.exe (T1197)
- **Day:** 2  | **Book:** 2
- **Notebook:** `notebooks/LAB-2.4_BITSADMIN_Download_T1197.ipynb`
- **ATT&CK:**
  - **TA0005 / T1197** — BITS Jobs
- **Datasets (offline ZIPs):**
  - Bitsadmin Download Malicious File *(hint: `bitsadmin_download`)* — mapped to **T1197**
- **Tasks:**
  - Identify bitsadmin executions that include URL download behavior.
  - Extract downloaded URL + destination path if available.
  - Correlate with network evidence (Zeek) and subsequent process execution.
  - Draft a Sigma rule and propose allowlist/tuning controls.
- **Starter KQL pivots:**
  - `process.name:bitsadmin.exe`
  - `process.command_line:(* /transfer * and (*http* or *https*))`

## Lab 3.1 — C2 Beacon Investigation (Cobalt Strike patterns)
- **Day:** 3  | **Book:** 3
- **Notebook:** `notebooks/LAB-3.1_C2_Beacon_Investigation_CobaltStrike.ipynb`
- **ATT&CK:**
  - **TA0011 / T1071.001** — Web Protocols
  - **TA0011 / T1573.002** — Asymmetric Cryptography
- **Datasets (offline ZIPs):**
  - APT Simulator Cobalt Strike *(hint: `aptsimulator_cobaltstrike`)* — mapped to **APTSimulator module**
- **Tasks:**
  - Use Zeek to identify periodic beaconing (consistent intervals, repeated destinations).
  - Extract potential C2 indicators: dest IP, SNI, URI path, user-agent anomalies.
  - Validate with endpoint telemetry: process responsible for connections, parent chain.
  - Write a hunt summary and suggested blocking/containment plan.
- **Starter KQL pivots:**
  - `event.dataset:zeek.conn and @timestamp>=now-7d`
  - `event.dataset:zeek.http and (url.path:*update* or user_agent:*Windows*)`

## Lab 3.2 — Lateral Movement: WinRM + Remote Scheduled Tasks
- **Day:** 3  | **Book:** 3
- **Notebook:** `notebooks/LAB-3.2_Lateral_Movement_WinRM_Schtasks.ipynb`
- **ATT&CK:**
  - **TA0008 / T1021.006** — PowerShell Remoting
  - **TA0008 / T1053.005** — Scheduled Task
- **Datasets (offline ZIPs):**
  - Covenant PowerShell Remoting Command *(hint: `psremoting`)* — mapped to **T1021.006**
  - Remote Scheduled Task Creation *(hint: `schtask_create`)* — mapped to **T1053.005**
  - Remote Scheduled Task Modification *(hint: `schtask_modification`)* — mapped to **T1053.005**
- **Tasks:**
  - Detect remote `schtasks` usage (`/S`, `/U`, `/P`) and identify target hosts.
  - Look for WinRM/PowerShell remoting signals (host logs + network).
  - Build a lateral movement map: source host → target host → executed payload.
  - Document containment: disable scheduled task, isolate hosts, reset creds.
- **Starter KQL pivots:**
  - `process.command_line:*schtasks* AND process.command_line:* /S *`
  - `process.command_line:(*Enter-PSSession* or *Invoke-Command* or *New-PSSession*)`

## Lab 3.3 — Timeline Reconstruction (Elastic-based, Timesketch optional)
- **Day:** 3  | **Book:** 3
- **Notebook:** `notebooks/LAB-3.3_Timeline_Reconstruction_Elastic.ipynb`
- **ATT&CK:**
  - **TA0009 / T1074.001** — Local Data Staging
- **Datasets (offline ZIPs):**
  _(No external dataset required — use the pre-indexed lab telemetry.)_
- **Tasks:**
  - Create a time-ordered sequence of key events across endpoint + network data.
  - Mark phase boundaries: initial access → execution → persistence → C2 → actions on objectives.
  - Export a timeline evidence CSV and write a 1-paragraph narrative.

## Lab 4.1 — Persistence Hunt: Run Keys + Scheduled Tasks
- **Day:** 4  | **Book:** 4
- **Notebook:** `notebooks/LAB-4.1_Persistence_Hunt_RunKeys_Schtasks.ipynb`
- **ATT&CK:**
  - **TA0003 / T1547.001** — Registry Run Keys/Startup Folder
  - **TA0003 / T1053.005** — Scheduled Task
- **Datasets (offline ZIPs):**
  - Empire Elevated Registry Run Keys *(hint: `registry_modification_run_keys`)* — mapped to **T1547.001**
  - Empire Userland Scheduled Tasks *(hint: `schtasks_creation_standard_user`)* — mapped to **T1053.005**
  - Empire Elevated Scheduled Tasks *(hint: `schtasks_creation_execution_elevated_user`)* — mapped to **T1053.005**
- **Tasks:**
  - Search for Run key modifications linked to suspicious binaries/scripts.
  - Search for scheduled task creation/modification events and identify creators.
  - Validate persistence by locating subsequent execution events.
  - Build an eradication plan and verify removal steps.
- **Starter KQL pivots:**
  - `registry.path:*\\Software\\Microsoft\\Windows\\CurrentVersion\\Run*`
  - `process.command_line:*schtasks* and (process.command_line:* /create * or process.command_line:* /change *)`

## Lab 4.2 — Credential Access Signal: Rubeus ASKTGT CreateNetOnly (T1003.003)
- **Day:** 4  | **Book:** 4
- **Notebook:** `notebooks/LAB-4.2_Credential_Access_Rubeus_T1003_003.ipynb`
- **ATT&CK:**
  - **TA0006 / T1003.003** — OS Credential Dumping (Rubeus patterns)
- **Datasets (offline ZIPs):**
  - Rubeus Elevated ASKTGT CreateNetOnly *(hint: `rubeus_asktgt_createnetonly`)* — mapped to **T1003.003**
- **Tasks:**
  - Hunt for Rubeus execution artifacts in process creation telemetry.
  - Identify associated Kerberos-related signals (where available).
  - Assess privilege/risk impact and propose response: isolate host, reset tickets, rotate creds.
- **Starter KQL pivots:**
  - `process.command_line:(*Rubeus* and *asktgt*) or process.command_line:(*/createnetonly:*)`

## Lab 4.3 — Threat Hunting Workflow (ELK): Hypothesis → Query → Validate → Report
- **Day:** 4  | **Book:** 4
- **Notebook:** `notebooks/LAB-4.3_Threat_Hunting_Workflow_ELK.ipynb`
- **ATT&CK:**
  - **TA0007 / T1087** — Account Discovery
- **Datasets (offline ZIPs):**
  _(No external dataset required — use the pre-indexed lab telemetry.)_
- **Tasks:**
  - Write a hunt hypothesis (what you expect to see and where).
  - Run 3 iterative queries, each time refining based on results.
  - Document decisions: why you kept/changed each query.
  - Produce a 1-page hunt report.

## Lab 5.1 — AI Triage Assistant (Validated Summaries)
- **Day:** 5  | **Book:** 5
- **Notebook:** `notebooks/LAB-5.1_AI_Triage_Assistant_Validated_Summaries.ipynb`
- **ATT&CK:**
  - **TA0009 / T1119** — Automated Collection
- **Datasets (offline ZIPs):**
  _(No external dataset required — use the pre-indexed lab telemetry.)_
- **Tasks:**
  - Create a prompt that summarizes alerts only using provided evidence rows.
  - Force the model to output: summary, ATT&CK, validation queries, containment.
  - Add an 'uncertainty' section and require analyst validation.

## Lab 5.2 — AI-Assisted Sigma Authoring + Unit Tests
- **Day:** 5  | **Book:** 5
- **Notebook:** `notebooks/LAB-5.2_AI_Assisted_Sigma_Authoring_Unit_Tests.ipynb`
- **ATT&CK:**
  - **TA0005 / T1027** — Obfuscated/Compressed Files and Information
- **Datasets (offline ZIPs):**
  _(No external dataset required — use the pre-indexed lab telemetry.)_
- **Tasks:**
  - Provide the model with example events (positive) and benign events (negative).
  - Generate Sigma rule variants and evaluate precision vs recall tradeoffs.
  - Write a short unit-test plan: required fields, expected matches, known false positives.

## Lab 5.3 — AI-Assisted ATT&CK Mapping + Reporting (Human-in-the-loop)
- **Day:** 5  | **Book:** 5
- **Notebook:** `notebooks/LAB-5.3_AI_Assisted_ATTACK_Mapping_Report.ipynb`
- **ATT&CK:**
  - **TA0009 / T1074** — Data Staged
- **Datasets (offline ZIPs):**
  _(No external dataset required — use the pre-indexed lab telemetry.)_
- **Tasks:**
  - Given an evidence CSV, have the model propose an ATT&CK timeline.
  - Manually verify each technique mapping and correct it if needed.
  - Produce a final incident report section with verified mappings.

## Lab 5.4 — Capstone: Full Intrusion Investigation (CINDER JACKAL @ FinanceFront)
- **Day:** 5  | **Book:** 5
- **Notebook:** `notebooks/LAB-5.4_Capstone_CINDER_JACKAL_Investigation.ipynb`
- **ATT&CK:**
  - **TA0001 / T1566** — Phishing
  - **TA0010 / T1041** — Exfiltration Over C2 Channel
- **Datasets (offline ZIPs):**
  _(No external dataset required — use the pre-indexed lab telemetry.)_
- **Tasks:**
  - Conduct end-to-end investigation using all prior techniques.
  - Produce: timeline, IOCs, ATT&CK mapping, detection improvements, lessons learned.
  - Deliver a 2-page final report and a 5-minute executive briefing.
