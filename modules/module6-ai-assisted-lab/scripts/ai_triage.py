#!/usr/bin/env python3
"""
AI-assisted triage helper for Module 6.
Supports either OpenAI API or local Ollama via REST.

Usage:
  python ai_triage.py --alert sample_alert.json --out artifacts/ai_triage_summary.md \
      --provider openai --model gpt-4o-mini
  python ai_triage.py --alert sample_alert.json --out artifacts/ai_triage_summary.md \
      --provider ollama --model llama3
"""

import argparse, json, os, sys, textwrap
from datetime import datetime

import requests  # only used for Ollama; OK to include even if using OpenAI

OPENAI_API_BASE = os.getenv("OPENAI_API_BASE", "https://api.openai.com/v1")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
OLLAMA_BASE = os.getenv("OLLAMA_BASE", "http://localhost:11434")

PROMPT_PATH = os.path.join(os.path.dirname(__file__), "..", "prompts", "analyst_assistant.md")

def load_prompt() -> str:
    with open(PROMPT_PATH, "r", encoding="utf-8") as f:
        return f.read()

def read_json(path: str) -> dict:
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)

def call_openai(model: str, content: str) -> str:
    if not OPENAI_API_KEY:
        raise RuntimeError("OPENAI_API_KEY not set")
    url = f"{OPENAI_API_BASE}/chat/completions"
    payload = {
        "model": model,
        "messages": [{"role": "user", "content": content}],
        "temperature": 0.2,
    }
    headers = {"Authorization": f"Bearer {OPENAI_API_KEY}"}
    r = requests.post(url, headers=headers, json=payload, timeout=120)
    r.raise_for_status()
    return r.json()["choices"][0]["message"]["content"]

def call_ollama(model: str, content: str) -> str:
    url = f"{OLLAMA_BASE}/api/chat"
    payload = {"model": model, "messages": [{"role": "user", "content": content}]}
    r = requests.post(url, json=payload, timeout=120)
    r.raise_for_status()
    data = r.json()
    # Some Ollama versions stream tokens; handle both cases
    if isinstance(data, dict) and "message" in data and "content" in data["message"]:
        return data["message"]["content"]
    return json.dumps(data, indent=2)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--alert", required=True, help="Path to alert JSON (Wazuh/Zeek)")
    ap.add_argument("--out", required=True, help="Output markdown file")
    ap.add_argument("--provider", choices=["openai", "ollama"], default="ollama")
    ap.add_argument("--model", default="llama3")
    args = ap.parse_args()

    base_prompt = load_prompt()
    alert = read_json(args.alert)
    # Keep the alert compact in prompt
    alert_snippet = json.dumps(alert, indent=2)[:6000]

    prompt = textwrap.dedent(f"""
    {base_prompt}

    === ALERT (sanitized/trimmed) ===
    {alert_snippet}
    """)

    if args.provider == "openai":
        content = call_openai(args.model, prompt)
    else:
        content = call_ollama(args.model, prompt)

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w", encoding="utf-8") as f:
        f.write(f"# AI Triage Summary\n\nGenerated: {datetime.utcnow().isoformat()}Z\n\n")
        f.write(content.strip() + "\n")

    print(f"Wrote {args.out}")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"[ERROR] {e}", file=sys.stderr)
        sys.exit(1)
