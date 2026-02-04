# Verify the Cinder Jackal dataset in Kibana

After ingest, confirm with these KQL queries:

## Endpoint / Elastic Agent indices
- `index: elastic-agent-* and labels.ignitecyber.scenario:"cinder-jackal"`
- `process.name: mshta.exe`
- `process.name: powershell.exe and process.command_line:* -enc *`
- `process.name: bitsadmin.exe`
- `process.name: schtasks.exe`

## Zeek indices
- `index: zeek-* and url.domain: cdn-ffsync.com`
- `index: zeek-* and dns.question.name: financefront-payroll-secure.com`
- `index: zeek-* and destination.ip: (185.199.110.153 or 104.21.32.11 or 172.67.155.12)`

## Wazuh alerts
- `index: wazuh-alerts-* and labels.ignitecyber.scenario:"cinder-jackal"`
