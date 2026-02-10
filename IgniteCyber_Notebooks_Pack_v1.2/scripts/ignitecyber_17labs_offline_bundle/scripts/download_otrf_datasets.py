#!/usr/bin/env python3
"""Prefetch external dataset archives for offline use.

Downloads each archive URL listed in manifest/otrf_labs_manifest.yaml into:
  datasets/<LAB-ID>/<filename>

Usage:
  python3 scripts/download_otrf_datasets.py --all
  python3 scripts/download_otrf_datasets.py --lab LAB-4.1

Notes:
- Requires internet connectivity on the machine where you run this.
- Uses only standard library modules.
"""

from __future__ import annotations

import argparse
import os
import sys
import urllib.request
from urllib.parse import urlparse
import yaml


def load_manifest(path: str) -> dict:
    with open(path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def filename_from_url(url: str) -> str:
    return os.path.basename(urlparse(url).path)


def download(url: str, out_path: str) -> None:
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    if os.path.exists(out_path) and os.path.getsize(out_path) > 0:
        print(f"[=] Exists: {out_path}")
        return
    print(f"[+] Downloading: {url}\n    -> {out_path}")
    req = urllib.request.Request(url, headers={"User-Agent": "ignitecyber-offline-bundle/1.0"})
    with urllib.request.urlopen(req) as resp, open(out_path, "wb") as wf:
        wf.write(resp.read())


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--manifest", default="manifest/otrf_labs_manifest.yaml")
    ap.add_argument("--datasets-dir", default="datasets")
    g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument("--all", action="store_true")
    g.add_argument("--lab", help="LAB-ID, e.g., LAB-2.3")
    args = ap.parse_args()

    manifest = load_manifest(args.manifest)
    labs = manifest.get("labs", {})

    targets = [args.lab] if args.lab else list(labs.keys())

    for lab_id in targets:
        lab = labs.get(lab_id)
        if not lab:
            print(f"[!] Unknown lab: {lab_id}")
            continue
        for d in lab.get("datasets", []) or []:
            url = d.get("url")
            if not url:
                continue
            fname = filename_from_url(url)
            out_path = os.path.join(args.datasets_dir, lab_id, fname)
            try:
                download(url, out_path)
            except Exception as e:
                print(f"[!] Failed: {url} ({e})")

    print("[+] Done")
    return 0


if __name__ == "__main__":
    try:
        import yaml  # type: ignore
    except Exception:
        print("Missing dependency: pyyaml. Install with: pip install pyyaml", file=sys.stderr)
        sys.exit(2)
    raise SystemExit(main())
