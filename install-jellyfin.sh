#!/bin/bash


wget -O- https://repo.jellyfin.org/install-debuntu.sh | sudo bash

sudo apt install curl gnupg
sudo mkdir /etc/apt/keyrings
DISTRO="$( awk -F'=' '/^ID=/{ print $NF }' /etc/os-release )"
CODENAME="$( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release )"
curl -fsSL https://repo.jellyfin.org/${DISTRO}/jellyfin_team.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/jellyfin.gpg
cat <<EOF | sudo tee /etc/apt/sources.list.d/jellyfin.sources
Types: deb
URIs: https://repo.jellyfin.org/${DISTRO}
Suites: ${CODENAME}
Components: main
Architectures: $( dpkg --print-architecture )
Signed-By: /etc/apt/keyrings/jellyfin.gpg
EOF
sudo apt update
sudo apt install jellyfin
sudo systemctl start jellyfin.service
