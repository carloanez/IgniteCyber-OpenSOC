#!/usr/bin/env python3
"""Bulk ingest JSONL datasets (from extracted OTRF archives) into Elastic or Wazuh Indexer.

This is intentionally simple:
- Find *.json files under a directory
- For each file, read line-delimited JSON and send _bulk requests

Usage examples:
  python3 scripts/ingest_bulk.py --target elastic --index ic-lab-2-3 --path /tmp/extracted
  python3 scripts/ingest_bulk.py --target wazuh --index ic-lab-2-3 --path /tmp/extracted

Auth:
- Elastic: ELASTIC_URL, ELASTIC_APIKEY OR ELASTIC_USER/ELASTIC_PASS
- Wazuh Indexer: WAZUH_INDEXER_URL, WAZUH_INDEXER_USER, WAZUH_INDEXER_PASS
"""

from __future__ import annotations

import argparse
import base64
import json
import os
import ssl
import sys
import urllib.request
from pathlib import Path


def _env(name: str, default: str = "") -> str:
    return os.environ.get(name, default)


def _build_auth_header(user: str, pwd: str) -> str:
    token = base64.b64encode(f"{user}:{pwd}".encode()).decode()
    return f"Basic {token}"


def _http_post(url: str, data: bytes, headers: dict, insecure: bool) -> tuple[int, bytes]:
    req = urllib.request.Request(url, data=data, method="POST")
    for k, v in headers.items():
        req.add_header(k, v)

    ctx = None
    if insecure and url.startswith("https://"):
        ctx = ssl.create_default_context()
        ctx.check_hostname = False
        ctx.verify_mode = ssl.CERT_NONE

    with urllib.request.urlopen(req, context=ctx) as resp:
        return resp.status, resp.read()


def iter_json_files(root: Path):
    for p in root.rglob("*.json"):
        if p.is_file():
            yield p


def bulk_ingest(base_url: str, index: str, json_file: Path, headers: dict, insecure: bool, batch: int = 2000) -> None:
    bulk_url = f"{base_url.rstrip('/')}/{index}/_bulk"
    sent = 0
    buf = []

    def flush(buf_lines):
        nonlocal sent
        if not buf_lines:
            return
        payload = "\n".join(buf_lines) + "\n"
        status, body = _http_post(bulk_url, payload.encode(), headers, insecure)
        if status >= 300:
            raise RuntimeError(f"bulk ingest failed ({status}): {body[:200]!r}")
        sent += len(buf_lines) // 2

    with json_file.open("r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                json.loads(line)
            except Exception:
                continue
            buf.append('{"index":{}}')
            buf.append(line)
            if (len(buf) // 2) >= batch:
                flush(buf)
                buf = []
        flush(buf)

    print(f"[+] Ingested {sent} docs from {json_file.name} -> {index}")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--target", choices=["elastic", "wazuh"], required=True)
    ap.add_argument("--index", required=True)
    ap.add_argument("--path", required=True, help="Directory containing extracted JSON files")
    ap.add_argument("--insecure", action="store_true", help="Skip TLS verification for https")
    args = ap.parse_args()

    root = Path(args.path)
    if not root.exists():
        print(f"Path not found: {root}", file=sys.stderr)
        return 2

    if args.target == "elastic":
        base = _env("ELASTIC_URL", "http://localhost:9200")
        api_key = _env("ELASTIC_APIKEY", "")
        user = _env("ELASTIC_USER", "elastic")
        pwd = _env("ELASTIC_PASS", "changeme")
        headers = {"Content-Type": "application/x-ndjson"}
        if api_key:
            headers["Authorization"] = f"ApiKey {api_key}"
        else:
            headers["Authorization"] = _build_auth_header(user, pwd)
    else:
        base = _env("WAZUH_INDEXER_URL", "https://localhost:9201")
        user = _env("WAZUH_INDEXER_USER", "admin")
        pwd = _env("WAZUH_INDEXER_PASS", "admin")
        headers = {"Content-Type": "application/x-ndjson", "Authorization": _build_auth_header(user, pwd)}

    for jf in iter_json_files(root):
        bulk_ingest(base, args.index, jf, headers, args.insecure)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
