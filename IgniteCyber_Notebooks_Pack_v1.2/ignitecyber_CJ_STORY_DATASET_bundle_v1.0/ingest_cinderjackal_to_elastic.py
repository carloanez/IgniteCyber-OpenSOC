#!/usr/bin/env python3
Ingest Cinder Jackal story NDJSON into Elastic (offline)

Creates indices matching:
- elastic-agent-* 
- zeek-* 
- wazuh-alerts-*

Usage:
  export ES_HOST="http://localhost:9200"
  export ES_USER="elastic"
  export ES_PASS="..."
  python3 ingest_cinderjackal_to_elastic.py --dataset-dir . --date-suffix 2026.02.03

Notes:
- Uses Elastic Bulk API.
- If your cluster has index templates for these patterns, mapping will apply automatically.

import os, argparse, json, requests
from datetime import datetime

ES_HOST = os.getenv("ES_HOST","http://localhost:9200").rstrip("/")
ES_USER = os.getenv("ES_USER","elastic")
ES_PASS = os.getenv("ES_PASS","changeme")
ES_VERIFY_TLS = os.getenv("ES_VERIFY_TLS","false").lower()=="true"

def bulk(index, ndjson_path, chunk=2000):
    url = f"{ES_HOST}/{index}/_bulk"
    headers = {"Content-Type":"application/x-ndjson"}
    auth=(ES_USER, ES_PASS)

    sent=0
    with open(ndjson_path,"r",encoding="utf-8") as f:
        buf=[]
        for line in f:
            line=line.strip()
            if not line:
                continue
            buf.append(json.dumps({"index":{}}))
            buf.append(line)
            if len(buf)//2 >= chunk:
                payload="\n".join(buf)+"\n"
                r=requests.post(url, data=payload, headers=headers, auth=auth, verify=ES_VERIFY_TLS, timeout=120)
                r.raise_for_status()
                sent += len(buf)//2
                buf=[]
        if buf:
            payload="\n".join(buf)+"\n"
            r=requests.post(url, data=payload, headers=headers, auth=auth, verify=ES_VERIFY_TLS, timeout=120)
            r.raise_for_status()
            sent += len(buf)//2
    return sent

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--dataset-dir", required=True, help="Directory containing *cinderjackal.ndjson files")
    ap.add_argument("--date-suffix", default=datetime.utcnow().strftime("%Y.%m.%d"))
    ap.add_argument("--prefix", default="cinderjackal")
    args=ap.parse_args()

    ds=args.dataset_dir
    suffix=args.date_suffix
    prefix=args.prefix

    files = {
        f"elastic-agent-{prefix}-{suffix}": os.path.join(ds, "elastic-agent-cinderjackal.ndjson"),
        f"zeek-{prefix}-conn-{suffix}": os.path.join(ds, "zeek-conn-cinderjackal.ndjson"),
        f"zeek-{prefix}-http-{suffix}": os.path.join(ds, "zeek-http-cinderjackal.ndjson"),
        f"zeek-{prefix}-dns-{suffix}": os.path.join(ds, "zeek-dns-cinderjackal.ndjson"),
        f"wazuh-alerts-{prefix}-{suffix}": os.path.join(ds, "wazuh-alerts-cinderjackal.ndjson"),
    }

    for idx, fp in files.items():
        if not os.path.exists(fp):
            print("Missing:", fp)
            continue
        n = bulk(idx, fp)
        print(f"Ingested {n} docs into {idx}")

if __name__=="__main__":
    main()
