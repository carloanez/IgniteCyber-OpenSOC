IC-SOC-LAB Setup (Linux VM)

Specs:

Ubuntu 22.04

4 vCPU

8–12 GB RAM

120GB disk

Install Docker:
sudo apt update && sudo apt install -y git curl ca-certificates gnupg
curl -fsSL https://get.docker.com
 | sudo sh
sudo usermod -aG docker $USER

Clone repo:
git clone https://github.com/carloanez/IgniteCyber-OpenSOC.git

Test stack:
cd stacks/stack-network-soc
docker compose up -d
docker ps
