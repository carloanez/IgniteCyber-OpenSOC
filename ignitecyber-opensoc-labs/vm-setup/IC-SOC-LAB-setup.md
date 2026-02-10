IC-SOC-LAB Setup (Linux VM)

Specs:

Ubuntu 22.04

4 vCPU - 6 VCPU

8–12 GB RAM

120GB disk

Install Docker:

sudo apt update && sudo apt install -y git curl ca-certificates gnupg

curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

sudo usermod -aG docker $USER

Clone repo:

git clone https://github.com/carloanez/IgniteCyber-OpenSOC.git

Test stack:
cd ignitecyber-opensoc-labs/stacks/stack-wazuh-endpoint

sudo docker compose up -d

sudo docker ps
