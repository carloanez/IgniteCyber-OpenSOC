#!/bin/bash

# Configuration
SRC="/tmp/extracted"
DST="/tmp/data/stream.log"

# Wipe old data from the stream so we don't duplicate
> "$DST"

for f in "$SRC"/*.json; do
    [ -f "$f" ] || continue
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        
        # Appending JSON text into a .log file
        echo "$line" >> "$DST"
        sleep 0.01
    done < "$f"
done

echo 'done'