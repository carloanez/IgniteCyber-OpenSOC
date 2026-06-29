#!/usr/bin/env python3
"""Import IgniteCyber MISP event JSON files into a local MISP instance.

Uses the MISP REST API directly so the script works without PyMISP. Keep this pointed at the
local training MISP instance; do not sync training data to production communities.
"""
from __future__ import annotations
import argparse, json, sys
from pathlib import Path
from urllib.parse import urljoin
import requests


def iter_files(path: Path):
    if path.is_dir():
        yield from sorted(path.glob('*_misp_event.json'))
    else:
        yield path


def post_event(misp_url: str, api_key: str, payload: dict, verify: bool):
    endpoint = urljoin(misp_url.rstrip('/') + '/', 'events/add')
    headers = {
        'Authorization': api_key,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
    }
    return requests.post(endpoint, headers=headers, json=payload, verify=verify, timeout=60)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--misp-url', required=True, help='Base URL, e.g. https://localhost')
    ap.add_argument('--api-key', required=True, help='MISP automation/API key')
    ap.add_argument('--input', required=True, help='MISP event JSON file or events directory')
    ap.add_argument('--insecure', action='store_true', help='Disable TLS certificate validation for local lab instances')
    ap.add_argument('--dry-run', action='store_true', help='Validate and print what would be imported without posting')
    args = ap.parse_args()

    verify = not args.insecure
    for path in iter_files(Path(args.input)):
        payload = json.loads(path.read_text(encoding='utf-8'))
        info = payload.get('Event', {}).get('info', '<missing info>')
        attrs = len(payload.get('Event', {}).get('Attribute', []))
        if args.dry_run:
            print(f'DRY-RUN would import: {path.name} | {info} | {attrs} attributes')
            continue
        resp = post_event(args.misp_url, args.api_key, payload, verify)
        if resp.status_code >= 300:
            print(f'ERROR importing {path}: HTTP {resp.status_code} {resp.text[:500]}', file=sys.stderr)
            continue
        print(f'Imported: {path.name} | {info}')

if __name__ == '__main__':
    main()
