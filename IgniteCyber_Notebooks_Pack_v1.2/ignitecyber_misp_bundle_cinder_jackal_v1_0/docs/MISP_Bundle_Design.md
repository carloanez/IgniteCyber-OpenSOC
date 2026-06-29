# MISP Bundle Design

## Goal

Provide a MISP counterpart to the TheHive case bundle so CTI can be staged per lab/case and promoted from case investigation into structured threat intelligence.

## Two import models

### 1. Single campaign spine event

`CJ_CAMPAIGN_SPINE_misp_event.json` is the master event. It accumulates all validated campaign CTI and contains one Event Report per lab. This supports the bootcamp narrative where Cinder Jackal is a single evolving campaign.

### 2. Per-lab/case events

Each `LAB-*_misp_event.json` is a standalone MISP event aligned with a TheHive case ID. This supports students or teams working independently on a lab without seeing future-day spoilers.

## Event design

Each event contains:

- Event-level tags for course, lab, case, day, actor, TLP/PAP, and ATT&CK technique IDs.
- Context attributes for case ID, notebook, and source file references.
- CTI attributes for indicators/observables.
- Embedded EventReport content for analyst narrative and promotion guidance.

## TheHive to MISP promotion rules

- TheHive observable `ioc=true` maps to MISP `to_ids=true` only after validation.
- TheHive notes and task logs map to MISP Event Reports.
- Detection logic does not become an IOC by default; it becomes Event Report context or a text attribute unless it is directly useful for detection/correlation.
- Student AI-generated summaries are not promoted unless a human validates them against evidence.

## Training safety

This is training data. Keep it local to the lab MISP instance unless explicitly sanitized for sharing.
