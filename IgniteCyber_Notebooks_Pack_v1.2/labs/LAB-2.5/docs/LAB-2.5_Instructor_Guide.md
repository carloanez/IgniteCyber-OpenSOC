# LAB-2.5 Instructor Guide - Voice Fraud & Voice Security Triage

## Purpose

This lab adds defensive voice fraud and voice security coverage to Day 2. It answers partner and IAUG interest by showing how a SOC can investigate vishing, caller impersonation, help desk process abuse, and MFA reset fraud using the current bootcamp stack.

## Instructor Emphasis

- This is a defensive SOC triage and incident response lab.
- Caller ID and urgency are not identity proof.
- Help desk process controls are part of the security control plane.
- AI can summarize transcripts and draft reports, but it is not evidence.
- Students should prove claims through call records, transcripts, help desk events, identity events, endpoint telemetry, Zeek HTTP, MISP, and TheHive artifacts.

## Avaya / Enterprise Voice Positioning

This is not an Avaya CM administration lab. It is relevant to Avaya and enterprise voice environments because it teaches defensive monitoring, call-record correlation, help desk process security, and SOC response to voice-enabled fraud.

## Safe-Training Note

Do not introduce voice cloning, deepfake generation, real voice samples, real phone numbers, real customer data, authentication bypass methods, or offensive impersonation workflows. Keep discussion focused on detection, verification, escalation, containment, and reporting.

## Suggested Timing

- 10 min: Scenario and safety scope
- 10 min: CDR and transcript review
- 15 min: Help desk and identity correlation
- 15 min: Endpoint and Zeek correlation
- 10 min: MISP and TheHive artifacts
- 10 min: Detection logic
- 5 min: AI-assisted summary and validation warning

## Expected Findings

- `CJ-VOICE-001` is the malicious case.
- Suspicious caller ID: `+1-202-555-0148`
- Callback mismatch: `+1-202-555-0199`
- Target user: `mrivera@apexfin.example`
- Ticket: `HD-2025-0619-4451`
- Suspicious domain: `apexfin-helpdesk-login.example`
- Suspicious URL: `https://apexfin-helpdesk-login.example/verify`
- Source IP: `203.0.113.45`
- Social engineering markers: urgency, executive authority pressure, refusal of standard verification, alternate callback number, MFA reset pressure, and request to use an external verification URL.
- ATT&CK: T1566.004, T1598.004, T1656, T1078.

## Answer Key

Students should conclude that Cinder Jackal used executive impersonation over voice to pressure help desk staff into an MFA rebind. The MFA change was followed by a new device login, conditional access challenge satisfaction using the new MFA device, increased identity risk, suspicious domain access, and PowerShell execution from the browser context.

Recommended mitigations:

- Strong help desk identity verification
- Callback only to known corporate directory numbers
- MFA reset approval workflow
- Phishing-resistant MFA where available
- Training for executive impersonation and voice fraud
- Monitoring for suspicious MFA reset patterns
- Treat caller ID as untrusted metadata

## Troubleshooting

- If the notebook cannot find data, confirm it is running from `IgniteCyber_Notebooks_Pack_v1.2/notebooks` or update `DATASET_DIR`.
- If Ollama is unavailable, students can still complete the AI section manually by reading the provided prompt.
- If TheHive or MISP are not running, inspect the JSON bundles offline and discuss what would be imported.
