#!/usr/bin/env python3
"""Lightweight validation for IgniteCyber MISP JSON event files."""
from __future__ import annotations
import argparse, json, sys
from pathlib import Path

REQUIRED_EVENT = {'info','date','threat_level_id','analysis','distribution','Attribute'}
REQUIRED_ATTR = {'type','category','value','to_ids','comment'}

def iter_files(path: Path):
    if path.is_dir():
        yield from sorted(path.glob('*_misp_event.json'))
    else:
        yield path

def validate_file(path: Path) -> tuple[int, int]:
    data = json.loads(path.read_text(encoding='utf-8'))
    event = data.get('Event')
    if not isinstance(event, dict):
        raise ValueError(f'{path}: missing top-level Event object')
    missing = REQUIRED_EVENT - event.keys()
    if missing:
        raise ValueError(f'{path}: Event missing required fields: {sorted(missing)}')
    attrs = event.get('Attribute', [])
    if not isinstance(attrs, list):
        raise ValueError(f'{path}: Event.Attribute must be a list')
    seen = set()
    for idx, attr in enumerate(attrs):
        missing = REQUIRED_ATTR - attr.keys()
        if missing:
            raise ValueError(f'{path}: Attribute[{idx}] missing required fields: {sorted(missing)}')
        key = (attr.get('type'), attr.get('value'))
        if key in seen:
            raise ValueError(f'{path}: duplicate attribute {key}')
        seen.add(key)
    return 1, len(attrs)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('input', help='MISP event JSON file or events directory')
    args = ap.parse_args()
    total_events = total_attrs = 0
    for p in iter_files(Path(args.input)):
        e, a = validate_file(p)
        print(f'OK {p} ({a} attributes)')
        total_events += e; total_attrs += a
    print(f'Validated {total_events} event file(s), {total_attrs} attributes.')

if __name__ == '__main__':
    try:
        main()
    except Exception as exc:
        print(f'ERROR: {exc}', file=sys.stderr)
        sys.exit(1)
