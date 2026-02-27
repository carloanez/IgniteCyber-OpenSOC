#!/bin/bash

# Wrapper script to run Zeek and Suricata containers with custom pcap and rules file
# Usage: ./start-lab.sh [options] [pcap_file] [rule_file]
# Options:
#   -c, --clean    Clean up logs before running (default: always clean)
#   -k, --keep     Keep existing logs (don't clean)
#   -h, --help     Show this help message
#
# Examples:
#   ./start-lab.sh                           # Use defaults, clean logs first
#   ./start-lab.sh capture.pcap             # Custom pcap, default rules
#   ./start-lab.sh capture.pcap myrules.rules
#   ./start-lab.sh -k capture.pcap          # Keep existing logs

CLEAN=true
PCAP_FILE=""
RULES_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--clean)
            CLEAN=true
            shift
            ;;
        -k|--keep)
            CLEAN=false
            shift
            ;;
        -h|--help)
            echo "Usage: ./start-lab.sh [options] [pcap_file] [rule_file]"
            echo ""
            echo "Options:"
            echo "  -c, --clean    Clean up logs before running (default)"
            echo "  -k, --keep     Keep existing logs"
            echo "  -h, --help     Show this help message"
            echo ""
            echo "Arguments:"
            echo "  pcap_file      PCAP file to analyze (default: pcap_log4shell_cve2021_44228_jndi_reference_2022-05-11181020.pcap)"
            echo "  rule_file      Suricata rules file (default: local.rules)"
            exit 0
            ;;
        *)
            if [ -z "$PCAP_FILE" ]; then
                PCAP_FILE="$1"
            elif [ -z "$RULES_FILE" ]; then
                RULES_FILE="$1"
            else
                echo "Error: Unknown argument '$1'"
                exit 1
            fi
            shift
            ;;
    esac
done

# Set defaults if not provided
PCAP_FILE="${PCAP_FILE:-pcap_log4shell_cve2021_44228_jndi_reference_2022-05-11181020.pcap}"
RULES_FILE="${RULES_FILE:-local.rules}"

if [ "$CLEAN" = true ]; then
    echo "Cleaning up log files..."
    rm -f logs/suricata-logs/*
    rm -f logs/zeek-logs/*
    echo "Logs cleaned."
    echo ""
fi

if [ ! -f "$PCAP_FILE" ]; then
    echo "Error: PCAP file '$PCAP_FILE' not found"
    exit 1
fi

if [ ! -f "rules/$RULES_FILE" ]; then
    echo "Error: Rules file 'rules/$RULES_FILE' not found"
    exit 1
fi

echo "========================================="
echo "  Network SOC Lab - PCAP Analysis"
echo "========================================="
echo "PCAP File: $PCAP_FILE"
echo "Rules File: $RULES_FILE"
echo "========================================="
echo ""

echo "Running Suricata..."
echo "-----------------------------------------"
PCAP_FILE="$PCAP_FILE" RULES_FILE="$RULES_FILE" docker compose --profile suricata up

echo ""
echo "Suricata complete. Check logs in: logs/suricata-logs/"
echo ""

echo "Running Zeek..."
echo "-----------------------------------------"
PCAP_FILE="$PCAP_FILE" docker compose --profile zeek up

echo ""
echo "Zeek complete. Check logs in: logs/zeek-logs/"
echo ""
echo "========================================="
echo "  Analysis Complete"
echo "========================================="
