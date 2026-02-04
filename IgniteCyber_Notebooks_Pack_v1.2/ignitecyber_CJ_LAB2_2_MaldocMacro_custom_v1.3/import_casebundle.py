#!/usr/bin/env python3
IgniteCyber TheHive Case Importer (TheHive 5.x / API v1) — Offline-friendly

Targets TheHive API v1 routes:
- GET  /api/v1/status
- POST /api/v1/case
- POST /api/v1/case/{caseId}/task
- POST /api/v1/case/{caseId}/note
- POST /api/v1/case/{caseId}/observable

Usage:
  export THEHIVE_URL="http://127.0.0.1:9000"
  export THEHIVE_API_KEY="YOURKEY"
  python3 import_casebundle.py casebundle.json

Notes:
- Case IDs in TheHive 5 often look like "~123". This script supports that.

import os, sys, json, time, requests

THEHIVE_URL = os.getenv("THEHIVE_URL", "http://127.0.0.1:9000").rstrip("/")
THEHIVE_API_KEY = os.getenv("THEHIVE_API_KEY")
TIMEOUT = int(os.getenv("THEHIVE_TIMEOUT", "60"))
RETRY = int(os.getenv("THEHIVE_RETRY", "2"))

if not THEHIVE_API_KEY:
    print("ERROR: THEHIVE_API_KEY not set")
    sys.exit(2)

HEADERS = {
    "Authorization": f"Bearer {THEHIVE_API_KEY}",
    "Content-Type": "application/json"
}

def request(method, path, obj=None):
    url = THEHIVE_URL + path
    last_exc = None
    for attempt in range(RETRY + 1):
        try:
            if method == "GET":
                r = requests.get(url, headers=HEADERS, timeout=TIMEOUT)
            else:
                r = requests.request(method, url, headers=HEADERS, json=obj, timeout=TIMEOUT)
            if r.status_code >= 300:
                print(f"{method} failed:", url, r.status_code, r.text[:800])
                r.raise_for_status()
            return r.json() if r.text else {}
        except Exception as e:
            last_exc = e
            if attempt < RETRY:
                time.sleep(1.0 + attempt)
                continue
            raise last_exc

def get_status():
    try:
        return request("GET", "/api/v1/status")
    except Exception as e:
        print("WARNING: /api/v1/status check failed. Continuing anyway. Error:", str(e)[:200])
        return None

def extract_case_id(created_obj: dict):
    for k in ("id", "_id", "caseId", "number"):
        v = created_obj.get(k)
        if isinstance(v, str) and v:
            return v
    if isinstance(created_obj.get("case"), dict):
        for k in ("id", "_id", "caseId", "number"):
            v = created_obj["case"].get(k)
            if isinstance(v, str) and v:
                return v
    raise ValueError(f"Could not extract case id from response keys: {list(created_obj.keys())}")

def main(fp):
    with open(fp, "r", encoding="utf-8") as f:
        bundle = json.load(f)

    status = get_status()
    if status:
        print("TheHive status (truncated):", json.dumps(status)[:500])

    created = request("POST", "/api/v1/case", bundle["case"])
    case_id = extract_case_id(created)
    print("Created case:", case_id)

    for t in bundle.get("tasks", []):
        try:
            request("POST", f"/api/v1/case/{case_id}/task", t)
        except Exception as e:
            print("Task create error:", str(e)[:200])

    for n in bundle.get("notes", []):
        try:
            request("POST", f"/api/v1/case/{case_id}/note", n)
        except Exception as e:
            print("Note create error:", str(e)[:200])

    for o in bundle.get("observables", []):
        try:
            request("POST", f"/api/v1/case/{case_id}/observable", o)
        except Exception as e:
            print("Observable create error:", str(e)[:200])

    print("Import complete.")
    return 0

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 import_casebundle.py casebundle.json")
        sys.exit(1)
    sys.exit(main(sys.argv[1]))
