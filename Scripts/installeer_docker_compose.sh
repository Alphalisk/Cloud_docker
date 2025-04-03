#!/bin/bash

IP="10.24.13.142" # Deze veranderen!
USER="Dockeradmin"

echo "🔧 Docker prerequisites installeren..."
ssh ${USER}@${IP} << 'EOF'
sudo apt-get remove -y docker docker-engine docker.io containerd runc
sudo apt update
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
EOF

# 6. DNS fix
echo "🌐 DNS instellen op 1.1.1.1"
ssh $USER@${IP%/*} "echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf"

echo "🔐 Docker GPG key toevoegen..."
ssh ${USER}@${IP} << 'EOF'
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null
EOF

echo "➕ Docker repository toevoegen..."
ssh ${USER}@${IP} << 'EOF'
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
EOF

echo "📦 Docker installeren..."
ssh ${USER}@${IP} << 'EOF'
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
EOF

# DNS fixen
ssh ${USER}@${IP%/*} "echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf > /dev/null"


echo "👤 Toevoegen aan docker groep..."
ssh ${USER}@${IP} << EOF
sudo usermod -aG docker $USER
EOF

echo "✅ Docker installatie klaar! Reboot de VM om docker zonder sudo te gebruiken."
