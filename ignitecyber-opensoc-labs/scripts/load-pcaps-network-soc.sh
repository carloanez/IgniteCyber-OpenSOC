#!/usr/bin/env bash

PCAP_DIR=${1:-./pcaps}

if [ ! -d "$PCAP_DIR" ]; then
  echo "PCAP directory $PCAP_DIR not found"
  exit 1
fi

echo "[*] Running Zeek over pcaps in $PCAP_DIR ..."
docker exec -it ic_zeek bash -c "
  rm -rf /usr/local/zeek/logs/*
  cd /pcaps && \
  for f in *.pcap *.pcapng 2>/dev/null; do
    echo \"Processing \$f\"; \
    zeek -r \"\$f\" local
  done
"

echo "[*] Done. Logs written to zeeklogs volume."
