#!/bin/bash

# === Config ===
VM_IP="10.24.13.142" # Dit aanpassen
SSH_USER="Dockeradmin" # Dit aanpassen
TAILSCALE_ENV="/tmp/tailscale.env"
VM_HOSTNAME="VMDocker3" # Dit aanpassen

# 🔑 SSH toegang check
echo "📤 Kopieer Tailscale config naar VM..."
scp $TAILSCALE_ENV ${SSH_USER}@${VM_IP}:/tmp/tailscale.env

# 🚀 Installatie + setup in de VM
ssh ${SSH_USER}@${VM_IP} << 'EOF'
set -e

# 🧪 DNS fix
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf

# 📦 Installatie Tailscale
source /tmp/tailscale.env
sudo apt update
sudo apt install -y curl jq
curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl enable --now tailscaled

# ⏳ Wachten op backend
for i in {1..10}; do
  if tailscale status &>/dev/null; then break; fi
  echo "⏳ Wachten op tailscaled backend..."; sleep 2
done

# 🔐 Verbinden
sudo tailscale up --authkey "$TAILSCALE_AUTH_KEY" --hostname VMDocker --ssh

# ✅ Status tonen
echo "🌐 Tailscale IP:"; tailscale ip -4 | head -n 1
echo "🔗 DNS naam:"; tailscale status --json | jq -r ".Self.DNSName"
EOF
