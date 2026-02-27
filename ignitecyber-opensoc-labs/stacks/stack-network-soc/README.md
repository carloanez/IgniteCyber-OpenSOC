# Network SOC Lab - Zeek & Suricata PCAP Analysis

Docker Compose setup for analyzing PCAP files using Zeek and Suricata to generate network logs and detection alerts.

## Overview

This lab environment provides:

- **Suricata**: Intrusion detection system that analyzes PCAP files against custom rules and generates alerts
- **Zeek**: Network security monitor that generates detailed logs from PCAP analysis
- **socnet**: Bridge network for container communication

## Directory Structure

```
.
├── docker-compose.yml          # Docker Compose configuration
├── start-lab.sh               # Wrapper script to run the lab
├── pcap_log4shell_cve2021_44228_jndi_reference_2022-05-11181020.pcap  # Sample PCAP
├── rules/
│   └── local.rules           # Suricata detection rules
└── logs/
    ├── suricata-logs/        # Suricata output logs
    └── zeek-logs/            # Zeek output logs
```

## Quick Start

```bash
# Run with default PCAP and rules
./start-lab.sh

# Run with custom PCAP and rules
./start-lab.sh capture.pcap myrules.rules

# Keep existing logs (don't clean)
./start-lab.sh -k capture.pcap rules.rules
```

## Usage

### Wrapper Script Options

| Option        | Description                         |
| ------------- | ----------------------------------- |
| `-c, --clean` | Clean logs before running (default) |
| `-k, --keep`  | Keep existing logs                  |
| `-h, --help`  | Show help message                   |

### Arguments

| Argument    | Description          | Default                                                             |
| ----------- | -------------------- | ------------------------------------------------------------------- |
| `pcap_file` | PCAP file to analyze | `pcap_log4shell_cve2021_44228_jndi_reference_2022-05-11181020.pcap` |
| `rule_file` | Suricata rules file  | `local.rules`                                                       |

### Direct Docker Compose Usage

```bash
# Run Suricata only
docker compose --profile suricata up

# Run Zeek only
docker compose --profile zeek up

# With custom environment variables
PCAP_FILE=capture.pcap RULES_FILE=rules.rules docker compose --profile suricata up
```

## Testing with Log4Shell PCAP

This repository includes a sample PCAP file (`pcap_log4shell_cve2021_44228_jndi_reference_2022-05-11181020.pcap`) containing Log4Shell (CVE-2021-44228) exploit traffic.

### Suricata Rules

The `rules/local.rules` file contains detection rules for Log4Shell:

```bash
# Run the lab
./start-lab.sh
```

### Expected Results

**Suricata Alerts** (`logs/suricata-logs/fast.log`):

```
05/11/2022-18:10:22.056303  [**] [1:1000001:1] LOG4J JNDI LDAP Reference Detected [**] [Classification: Web Application Attack] [Priority: 1] {TCP} 192.168.2.6:38782 -> 192.168.2.5:8080
05/11/2022-18:10:22.056303  [**] [1:1000002:1] LOG4J JNDI Reference Detected [**] [Classification: Web Application Attack] [Priority: 1] {TCP} 192.168.2.6:38782 -> 192.168.2.5:8080
05/11/2022-18:10:22.056303  [**] [1:1000003:1] LOG4J User-Agent Exploitation Attempt [**] [Classification: Web Application Attack] [Priority: 1] {TCP} 192.168.2.6:38782 -> 192.168.2.5:8080
```

**Zeek Logs** (`logs/zeek-logs/`):

- `conn.log` - Connection logs
- `http.log` - HTTP traffic
- `ldap.log` - LDAP traffic
- `ldap_search.log` - LDAP search operations
- `files.log` - File transfer logs
- `processed.pcap` - Processed PCAP output

### Suricata JSON Alerts

View detailed alerts in JSON format:

```bash
cat logs/suricata-logs/eve.json | jq -r 'select(.event_type=="alert") | .alert.signature'
```

## Output Locations

| Tool     | Log Directory         | Key Files                                       |
| -------- | --------------------- | ----------------------------------------------- |
| Suricata | `logs/suricata-logs/` | `fast.log`, `eve.json`, `stats.log`             |
| Zeek     | `logs/zeek-logs/`     | `conn.log`, `http.log`, `ldap.log`, `files.log` |

## Docker Images

- **Suricata**: `jasonish/suricata:latest`
- **Zeek**: `zeek/zeek:latest`
