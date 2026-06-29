#!/usr/bin/env python3
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REQUIRED = [
    "notebooks/LAB-2.5_Voice_Fraud_Voice_Security_Triage.ipynb",
    "datasets/LAB-2.5/voice_call_records.json",
    "datasets/LAB-2.5/helpdesk_ticket_events.json",
    "datasets/LAB-2.5/mfa_identity_events.json",
    "datasets/LAB-2.5/voice_fraud_endpoint_events.json",
    "datasets/LAB-2.5/voice_fraud_zeek_http.json",
    "datasets/LAB-2.5/voice_fraud_transcripts/call_001_transcript.txt",
    "datasets/LAB-2.5/voice_fraud_transcripts/call_002_transcript.txt",
    "labs/LAB-2.5/thehive/casebundle_lab2_5_voice_fraud.json",
    "labs/LAB-2.5/misp/LAB-2_5_voice_fraud_misp_event.json",
    "labs/LAB-2.5/dashboards/opensearch_voice_fraud_dashboard.ndjson",
    "labs/LAB-2.5/detections/sigma_voice_fraud_helpdesk_mfa_reset.yml",
    "labs/LAB-2.5/detections/opensearch_voice_fraud_queries.md",
    "labs/LAB-2.5/docs/LAB-2.5_Instructor_Guide.md",
    "labs/LAB-2.5/docs/LAB-2.5_Student_Guide.md",
]

JSON_FILES = [
    "datasets/LAB-2.5/voice_call_records.json",
    "datasets/LAB-2.5/helpdesk_ticket_events.json",
    "datasets/LAB-2.5/mfa_identity_events.json",
    "datasets/LAB-2.5/voice_fraud_endpoint_events.json",
    "datasets/LAB-2.5/voice_fraud_zeek_http.json",
    "labs/LAB-2.5/thehive/casebundle_lab2_5_voice_fraud.json",
    "labs/LAB-2.5/misp/LAB-2_5_voice_fraud_misp_event.json",
    "notebooks/LAB-2.5_Voice_Fraud_Voice_Security_Triage.ipynb",
    "manifest/notebook_manifest.json",
]

BANNED = [
    "bypass voice authentication",
    "clone a voice",
    "generate a deepfake",
    "voice cloning tutorial",
    "deepfake generation tutorial",
    "voice cloning code",
    "deepfake generation code:",
]

ALLOWED_PHONE_RE = re.compile(r"\+1-202-555-01\d{2}")
PHONE_RE = re.compile(r"\+1-\d{3}-\d{3}-\d{4}")
DOMAIN_RE = re.compile(r"\b(?:[a-z0-9-]+\.)+[a-z]{2,}\b", re.I)
ALLOWED_DOMAIN_SUFFIXES = (".example", ".test", ".invalid", ".localhost")
DOC_REAL_DOMAINS = {
    "attack.mitre.org",
}
ROUTABLE_TLDS = {
    "com",
    "net",
    "org",
    "edu",
    "gov",
    "mil",
    "io",
    "co",
    "us",
    "uk",
}


def fail(msg):
    print(f"[FAIL] {msg}")
    return 1


def main():
    errors = 0

    for rel in REQUIRED:
        if not (ROOT / rel).exists():
            errors += fail(f"Missing required file: {rel}")

    for rel in JSON_FILES:
        try:
            json.loads((ROOT / rel).read_text(encoding="utf-8"))
        except Exception as exc:
            errors += fail(f"Invalid JSON in {rel}: {exc}")

    manifest = json.loads((ROOT / "manifest/notebook_manifest.json").read_text(encoding="utf-8"))
    labs = manifest.get("labs", [])
    lab25 = [lab for lab in labs if lab.get("lab_code") == "Lab 2.5"]
    if not lab25:
        errors += fail("Manifest missing Lab 2.5")
    elif not (ROOT / lab25[0].get("notebook", "")).exists():
        errors += fail("Manifest Lab 2.5 notebook path does not exist")

    text = "\n".join(
        p.read_text(encoding="utf-8", errors="ignore")
        for p in [ROOT / rel for rel in REQUIRED if (ROOT / rel).exists()]
    )
    lower = text.lower()
    for phrase in BANNED:
        if phrase in lower:
            errors += fail(f"Banned offensive phrase found: {phrase}")

    for phone in PHONE_RE.findall(text):
        if not ALLOWED_PHONE_RE.fullmatch(phone):
            errors += fail(f"Non-reserved phone number found: {phone}")

    for domain in DOMAIN_RE.findall(text):
        d = domain.lower()
        if d in DOC_REAL_DOMAINS:
            continue
        if d.rsplit(".", 1)[-1] not in ROUTABLE_TLDS and not d.endswith(ALLOWED_DOMAIN_SUFFIXES):
            continue
        if not d.endswith(ALLOWED_DOMAIN_SUFFIXES):
            errors += fail(f"Non-reserved domain found: {domain}")

    if errors:
        print(f"LAB-2.5 validation failed with {errors} error(s).")
        return 1
    print("LAB-2.5 validation passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
