# Bootcamp shared imports & helpers (offline-only)
import os, re, json, glob, zipfile
from io import BytesIO
from datetime import datetime
import pandas as pd
import requests

# ---------------------------
# Elastic connection helpers
# ---------------------------
ES_HOST = os.getenv("ES_HOST", "http://localhost:9200")
ES_USER = os.getenv("ES_USER", "elastic")
ES_PASS = os.getenv("ES_PASS", "changeme")  # baked in VM; override via env if needed
ES_VERIFY_TLS = os.getenv("ES_VERIFY_TLS", "false").lower() == "true"

def es_get(path: str):
    url = ES_HOST.rstrip("/") + "/" + path.lstrip("/")
    r = requests.get(url, auth=(ES_USER, ES_PASS), verify=ES_VERIFY_TLS, timeout=60)
    r.raise_for_status()
    return r.json()

def es_post(path: str, body: dict):
    url = ES_HOST.rstrip("/") + "/" + path.lstrip("/")
    r = requests.post(url, auth=(ES_USER, ES_PASS), json=body, verify=ES_VERIFY_TLS, timeout=90)
    r.raise_for_status()
    return r.json()

def es_search(index: str, query: dict, size: int = 200, sort_field: str = "@timestamp", sort_order: str = "asc"):
    body = {"size": size, "sort": [{sort_field: {"order": sort_order}}], "query": query}
    return es_post(f"{index}/_search", body)

def es_qs(index: str, query_string: str, size: int = 200):
    q = {"query_string": {"query": query_string, "default_operator": "AND"}}
    return es_search(index=index, query=q, size=size)

def hits_to_df(res: dict):
    hits = res.get("hits", {}).get("hits", [])
    rows = [h.get("_source", {}) for h in hits]
    return pd.json_normalize(rows) if rows else pd.DataFrame()

# ---------------------------
# Dataset helpers (ZIP -> DataFrame)
# ---------------------------
DATASET_DIR = "/opt/bootcamp/datasets"

def list_dataset_zips(pattern: str = "*.zip"):
    return sorted(glob.glob(os.path.join(DATASET_DIR, pattern)))

def find_dataset_zip(contains: str):
    for z in list_dataset_zips("*.zip"):
        if contains.lower() in os.path.basename(z).lower():
            return z
    return None

def read_first_jsonl_from_zip(zip_path: str, max_lines: int = 20000):
    with zipfile.ZipFile(zip_path, "r") as zf:
        members = [m for m in zf.namelist() if m.lower().endswith((".json", ".jsonl", ".ndjson"))]
        if not members:
            raise ValueError(f"No JSON/JSONL/NDJSON files found in {zip_path}")
        target = members[0]
        with zf.open(target) as f:
            lines = []
            for i, line in enumerate(f):
                if i >= max_lines:
                    break
                lines.append(line)
            bio = BytesIO(b"".join(lines))
            df = pd.read_json(bio, lines=True)
    return target, df

# ---------------------------
# Evidence helpers
# ---------------------------
def save_evidence_csv(df: pd.DataFrame, lab_slug: str):
    out_path = f"/tmp/{datetime.utcnow().strftime('%Y%m%d_%H%M%S')}_evidence_{lab_slug}.csv"
    df.to_csv(out_path, index=False)
    return out_path

# ---------------------------
# Ollama helpers (local LLM)
# ---------------------------
OLLAMA_HOST = os.getenv("OLLAMA_HOST", "http://localhost:11434")

def ollama_models():
    try:
        r = requests.get(f"{OLLAMA_HOST}/api/tags", timeout=15)
        r.raise_for_status()
        data = r.json()
        return [m.get("name") for m in data.get("models", [])]
    except Exception:
        return []

def ollama_generate(prompt: str, model: str = None, temperature: float = 0.2):
    models = ollama_models()
    if model is None:
        model = models[0] if models else "llama3"
    payload = {"model": model, "prompt": prompt, "stream": False, "options": {"temperature": temperature}}
    r = requests.post(f"{OLLAMA_HOST}/api/generate", json=payload, timeout=180)
    r.raise_for_status()
    return r.json().get("response", "")
