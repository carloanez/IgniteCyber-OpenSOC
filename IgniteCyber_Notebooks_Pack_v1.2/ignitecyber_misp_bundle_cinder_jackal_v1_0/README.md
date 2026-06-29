# IgniteCyber Academy — Cinder Jackal MISP Bundle v1.0

This package is the MISP equivalent of the TheHive lab/case bundle. It gives the CTI team a ready-to-import structure for the Cinder Jackal campaign and for each lab/case in the 5-day bootcamp.

## What is included

- `events/CJ_CAMPAIGN_SPINE_misp_event.json` — one evolving campaign event for Cinder Jackal.
- `events/LAB-*_misp_event.json` — one MISP event per lab/case.
- `ignitecyber_cj_misp_event_collection.json` — wrapper containing all per-lab events.
- `ignitecyber_cj_misp_campaign_spine.json` — copy of the single campaign spine event.
- `observables/cj_all_observables.csv` — flat observable list for review, QA, or manual import.
- `lab_case_catalog.csv` — per-lab case catalog.
- `mappings/thehive_to_misp_field_map.csv` — field mapping from TheHive cases/observables to MISP events/attributes.
- `scripts/import_misp_bundle.py` — REST importer for a local MISP instance.
- `scripts/validate_misp_bundle.py` — lightweight local validation.

## Recommended operating model

Use the campaign spine event as the master CTI object and the per-lab events as student-facing or instructor-controlled case events.

1. Import `events/CJ_CAMPAIGN_SPINE_misp_event.json` before Day 1 or during instructor prep.
2. Import the matching `events/LAB-*_misp_event.json` at the start of each lab.
3. During the lab, students validate evidence in Elastic/Wazuh/Zeek and TheHive.
4. Analysts promote only validated indicators into MISP.
5. Add sightings/correlations for repeated observables across labs.

## Offline/local lab paths

Suggested VM paths:

```text
/opt/bootcamp/datasets/misp/ignitecyber_misp_bundle_cinder_jackal_v1_0/
/opt/bootcamp/scripts/import-misp-bundle.sh
```

## Import with the script

```bash
python3 scripts/validate_misp_bundle.py events/CJ_CAMPAIGN_SPINE_misp_event.json
python3 scripts/import_misp_bundle.py   --misp-url https://localhost   --api-key "$MISP_API_KEY"   --input events/CJ_CAMPAIGN_SPINE_misp_event.json   --insecure   --dry-run
```

Remove `--dry-run` after validation.

For all per-lab events:

```bash
python3 scripts/import_misp_bundle.py --misp-url https://localhost --api-key "$MISP_API_KEY" --input events --insecure
```

## Notes for CTI curation

- `to_ids=true` is reserved for behaviorally useful detection indicators.
- Internal IPs, documentation/test ranges, lab hostnames, workflow metadata, and baseline cloud service indicators are set to `to_ids=false`.
- Some indicators intentionally point to training sources such as Atomic Red Team or reserved/private ranges. Do not sync this training data to production communities.
- This bundle is designed for local-first IgniteCyber lab use and API-based integration between TheHive/Cortex/MISP.
