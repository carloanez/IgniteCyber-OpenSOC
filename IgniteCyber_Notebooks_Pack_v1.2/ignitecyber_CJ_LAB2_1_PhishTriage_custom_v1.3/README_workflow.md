# Prebuilt TheHive 5.x case import workflow (Lab 2.1 / Lab 2.2)

This workflow lets students import a **prebuilt case** (tasks + observables + notes) that matches the **CINDER JACKAL** storyline.

## Compatible versions
- TheHive **5.x** (Public API **v1**)

## Files
- `casebundle_lab2_1.json`
- `casebundle_lab2_2.json`
- `import_casebundle.py`
- `import_lab2_cases.sh`

## Prereqs
- TheHive running (offline/local is fine)
- API key for a user that can create cases / tasks / observables

## Steps
```bash
export THEHIVE_URL="http://127.0.0.1:9000"
export THEHIVE_API_KEY="YOUR_API_KEY"
```

Import Lab 2.1:
```bash
python3 import_casebundle.py casebundle_lab2_1.json
```

Import Lab 2.2:
```bash
python3 import_casebundle.py casebundle_lab2_2.json
```

Or import both in one command:
```bash
bash import_lab2_cases.sh
```

## Smoke test
The importer attempts `GET /api/v1/status` before import (if enabled in your instance).
