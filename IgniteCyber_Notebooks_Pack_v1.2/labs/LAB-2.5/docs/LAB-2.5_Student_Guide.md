# LAB-2.5 Student Guide - Voice Fraud & Voice Security Triage

## Scenario

ApexFin Solutions receives a suspicious call to the help desk. The caller claims to be the CFO, says they are traveling for a board meeting, and urgently requests an MFA reset. The caller provides partial employee information and pressures the help desk technician to bypass normal verification. Shortly after the call, identity logs show a successful MFA device rebind, a suspicious new device login, and browsing to a suspicious domain.

## Learning Objectives

- Identify voice fraud and vishing indicators.
- Correlate call records, transcripts, help desk tickets, identity logs, endpoint events, and Zeek HTTP events.
- Build a defensible incident timeline.
- Enrich observables using MISP and manage tasks in TheHive.
- Draft detection logic and mitigations for help desk MFA reset abuse.
- Use AI assistance with human validation.

## Tasks

1. Load the LAB-2.5 datasets in the notebook.
2. Identify the suspicious call record and explain why it is suspicious.
3. Review transcripts and list social engineering markers.
4. Correlate help desk ticket events with MFA identity events.
5. Correlate endpoint and Zeek HTTP activity after the MFA rebind.
6. Review the MISP event and TheHive case bundle.
7. Draft one detection idea.
8. Write a final analyst report.

## Evidence Collection Table

| Evidence | Field/value | Why it matters |
| --- | --- | --- |
| Case ID |  |  |
| Caller ID |  |  |
| Callback number |  |  |
| Ticket ID |  |  |
| Target user |  |  |
| MFA event |  |  |
| New device login |  |  |
| Suspicious domain or URL |  |  |
| Endpoint event |  |  |
| Zeek HTTP event |  |  |

## Questions to Answer

- Which evidence proves this is more than a normal MFA support call?
- Which help desk control failed or was pressured?
- What happened after the MFA device was rebound?
- What observables should be promoted to MISP?
- What tasks should be tracked in TheHive?
- What should be monitored to detect similar abuse earlier?

## Final Report Template

```text
Title:
Case ID:
Analyst:
Date:

Executive summary:

Timeline:

Validated indicators:

Impacted user/account:

ATT&CK mapping:

TheHive case summary:

MISP enrichment summary:

Detection recommendation:

Containment and mitigation recommendations:

Open questions:
```
