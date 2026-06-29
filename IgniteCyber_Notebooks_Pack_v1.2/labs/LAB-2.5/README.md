# LAB-2.5 - Voice Fraud & Voice Security Triage

Day 2 now includes a voice fraud and voice security lab focused on vishing, caller impersonation, help desk social engineering, MFA reset abuse, and AI-assisted SOC triage. This lab is defensive and uses synthetic call records, transcripts, help desk events, identity events, endpoint logs, network telemetry, MISP CTI, and TheHive case management.

## Scenario

ApexFin Solutions receives a suspicious call to the help desk. The caller claims to be a senior executive traveling for a board meeting and urgently requests an MFA reset. The caller provides partial employee information and pressures the help desk technician to bypass normal verification. Shortly after the call, identity logs show a successful MFA device rebind attempt, followed by a suspicious login from a new device and browsing activity to a suspicious domain.

## Files

- Notebook: `../../notebooks/LAB-2.5_Voice_Fraud_Voice_Security_Triage.ipynb`
- Datasets: `../../datasets/LAB-2.5/`
- TheHive case bundle: `thehive/casebundle_lab2_5_voice_fraud.json`
- MISP event: `misp/LAB-2_5_voice_fraud_misp_event.json`
- Detections: `detections/`
- Guides: `docs/`

## Safety

This is a defensive SOC and incident response lab. It contains no voice cloning instructions, deepfake generation code, real voice samples, real customer phone numbers, Avaya CM exploitation steps, or instructions for bypassing voice authentication.
