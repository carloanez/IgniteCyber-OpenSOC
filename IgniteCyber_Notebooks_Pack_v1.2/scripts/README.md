# Wazuh Dataset Ingestion


---

#### 1. Verify `wazuh_manager.conf`

In `stacks/stack-wazuh-endpoint/config/wazuh_cluster/wazuh_manager.conf`, ensure the following are set:

```xml
<global>
  <jsonout_output>yes</jsonout_output>
  <logall_json>yes</logall_json>
</global>

<localfile>
  <location>/var/ossec/logs/custom_json_logs/*.log</location>
  <log_format>json</log_format>
  <only-future-events>no</only-future-events>
</localfile>
```

---

#### 2. Verify `filebeat.yml`

In `stacks/stack-wazuh-endpoint/config/wazuh_cluster/filebeat.yml`, ensure archives are enabled and SSL credentials are uncommented:

```yaml
filebeat.modules:
  - module: wazuh
    alerts:
      enabled: true
    archives:
      enabled: true

output.elasticsearch:
  hosts: ['https://wazuh.indexer:9200']
  username: admin
  password: SecretPassword
  ssl.verification_mode: full
  ssl.certificate_authorities: ['/etc/ssl/root-ca.pem']
  ssl.certificate: '/etc/ssl/filebeat.pem'
  ssl.key: '/etc/ssl/filebeat.key'
```

---

#### 3. Start the stack

In the `stack-wazuh-endpoint` directory, start the containers:

```bash
docker compose up -d
```

---

#### 4. Extract datasets

```bash
bash extract.sh
```

---

#### 5. Run ECS setup

In the scripts folder, go to setup_ecs.sh and add the path to /IgniteCyber-OpenSOC for CERT_DIR.
Run the script to set up the normalization pipeline and index mapping:

```bash
bash setup_ecs.sh ./ecs_pipeline.json
```

---

#### 6. Run ingest

```bash
bash log_ingest.sh
```

---

#### 7. Monitor progress

```bash
watch -n 5 'echo "=== Doc count ===" && \
curl -sk -u admin:SecretPassword "https://localhost:9200/_cat/indices/wazuh-archives-4.x-*?v" && \
echo "=== Stream vs archive ===" && \
wc -l /tmp/data/stream.log && \
docker exec stack-wazuh-endpoint-wazuh.manager-1 wc -l /var/ossec/logs/archives/archives.json'
```

```bash
watch -n 5 'echo "=== Doc count ===" && \
curl -sk -u admin:SecretPassword "https://localhost:9200/_cat/indices/wazuh-archives-4.x-*?v" && \
echo "=== Stream vs archive ===" && \
wc -l /tmp/data/stream.log && \
docker exec stack-wazuh-endpoint-wazuh.manager-1 wc -l /var/ossec/logs/archives/archives.json'
```

---

#### Troubleshooting — start fresh

```bash
CERT_DIR="[path_to_dir]/IgniteCyber-OpenSOC/ignitecyber-opensoc-labs/stacks/stack-wazuh-endpoint/config/wazuh_indexer_ssl_certs"

curl -sk --cacert "$CERT_DIR/root-ca.pem" --cert "$CERT_DIR/admin.pem" --key "$CERT_DIR/admin-key.pem" \
  -u admin:SecretPassword -X DELETE "https://localhost:9200/wazuh-archives-4.x-*"

docker exec stack-wazuh-endpoint-wazuh.manager-1 bash -c "rm -rf /var/lib/filebeat/registry"
docker exec stack-wazuh-endpoint-wazuh.manager-1 bash -c "> /var/ossec/logs/archives/archives.json"
> /tmp/data/stream.log
docker restart stack-wazuh-endpoint-wazuh.manager-1
```

Then repeat steps 5 and 6.


---

#### Before starting the lab:

export ES_USER=admin
export ES_PASS=SecretPassword
export ES_VERIFY_TLS=[path_to_dir]/IgniteCyber-OpenSOC/ignitecyber-opensoc-labs/stacks/stack-wazuh-endpoint/config/wazuh_indexer_ssl_certs/root-ca.pem

---


# Zeek PCAP Ingestion


---

#### 1. Generate Zeek logs from PCAP

Follow the instructions in `stacks/stack-network-soc/README.md` to generate the Zeek logs from the PCAP file.

Logs will be written to `stacks/stack-network-soc/logs/zeek-logs/`.

---

#### 2. Update the cert path in `docker-compose.yml`

In `stacks/stack-network-soc/docker-compose.yml`, update the cert volume mount in the logstash service to match your local path:

```yaml
logstash:
  volumes:
    - ./logs/zeek-logs:/var/log/zeek:ro
    - ./logstash-zeek.conf:/usr/share/logstash/pipeline/logstash.conf:ro
    - [path_to_dir]/IgniteCyber-OpenSOC/ignitecyber-opensoc-labs/stacks/stack-wazuh-endpoint/config/wazuh_indexer_ssl_certs/root-ca.pem:/etc/ssl/root-ca.pem:ro
```

---

#### 3. Start Logstash

In the `stack-network-soc` directory:

```bash
docker compose up -d logstash
```

---

#### 4. Verify ingestion

```bash
curl -sk -u admin:SecretPassword \
  curl -sk -u admin:SecretPassword "https://localhost:9200/_cat/indices/zeek-*?v&s=index"
```

---

#### 5. Create index pattern in dashboard

In the Wazuh dashboard go to **Management → Dashboards Management → Index Patterns** and create:

- Pattern: `zeek-*`
- Time field: `@timestamp`

> **Note:** Zeek log timestamps reflect the original PCAP capture time. Set the dashboard time picker to cover the PCAP capture date when querying.

---

#### 6. Stop the logstash container

In the `stack-network-soc` directory:

```bash
docker compose stop logstash
```