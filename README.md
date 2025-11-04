# IgniteCyber OpenSOC Initiative

An open education and research lab for cybersecurity analysts.  
**Version 1.0 – November 2025**

## Vision
Train, empower, and connect analysts through **hands‑on, open‑source SOC labs**, mapped to **MITRE ATT&CK**.

## Partners & Community
- **IgniteCyber Academy** (Samkana & Cause‑Finder LLC)
- **SANS Community Chapters** (collaboration on community nights, mentorship, and co‑hosted hacklabs)
- **Blue Team Village** / DEF CON (community engagement)
- Universities, nonprofits, and local cyber meetups

## Repository Structure
```plaintext
IgniteCyber-OpenSOC/
├── docker/
├── modules/
├── datasets/
├── docs/
└── community/
```

## Quickstart
```bash
# 1) Clone
git clone https://github.com/YOUR_ORG/IgniteCyber-OpenSOC.git
cd IgniteCyber-OpenSOC

# 2) Bring up core services (edit .env first)
docker compose -f docker/docker-compose.yml up -d

# 3) Open Kibana (see docs/setup-guides/kibana.md) and import sample dashboards
```

> **Note**: Default configs are **safe, demo‑grade** and intended for **local training only**.

## Compliance & Ethics
- Open‑source only (no proprietary/export‑controlled materials)
- Synthetic/anonymized datasets only
- Follows the **Code of Conduct** and **Contributor Agreement**

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md). Join the discussion on Discord/Slack (invite in `community/README.md`).

## License
Apache 2.0 — see [LICENSE](LICENSE).
