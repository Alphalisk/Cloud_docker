# Begeleidende Verantwoording – Cloud Computing - Docker

## Inleiding

In dit verslag verantwoord ik mijn werkzaamheden binnen het vak **Cloud Computing**, onderdeel van de **HBO-ICT** module **Operations Engineering**. De nadruk ligt op het inrichten, beheren en monitoren van een Proxmox-cluster inclusief geautomatiseerde uitrol van webapplicaties. In deze opdracht: Docker.

## Opdrachten van het project

![alt text](OpdrachtBeschrijving\Opdracht.png)

Te doen:

Opdracht 1
- Installeer op een Proxmox node een Ubunbtu host (bijvoorkeur VM)  met daarop Docker.Registreer van alle lessons de uitkomsten met een 
screen recording/screenshots en leg het vast in je repository
- Build Image with DockerFile and create new Container op elk docker instantie op het Proxmox cluster.
- Docker Compose install op alle 3 Docker installaties op het Proxmox cluster
- Voer, vanaf stap 6,  geautomatiseerd de stappen uit op alle Docker omgevingen op het Proxmox cluster. Met als resultaat 3 swarms met 3 
manager(op elke procmode node 1) 
- Extra  - alle swarms via een centrale manager
- "Basic Docker Neworking Command" Zet de commando's in een script en laat het script de commando's een voor een uitvoeren.

Opdracht 2:
- Bekijk de volgende YouTube video : Docker networking is crazy (https://www.youtube.com/watch?v=bKFMS5C4CG0). Zet twee MySQL ( 
lesson8 van opdracht 1) Zet elke server in een apart subnet. Controleer of je vanuit jouw eigen subnet (waar ook de Proxmox nodes opstaan), 
je de MySQL containers kunt benaderen en of de servers elkaar kunnen benaderen. Mocht dat niet lukken pas dan de setting aan zodat wel 
kan,  script deze. Maak een korte beschrijving hoe je meerdere subnetten kunt creëren met Docker en waarom dit nuttig kan zijn.  Plaats 
deze ook op je repository.

Opdracht 3:
- Opdrachten:  Load Balancing en Reverse Proxy:
1) (2pt) Maak kennis met een product dat bovenstaande verzorgt:
https://doc.traefik.io/traefik/getting-started/quick-start/
Maak screenshots van de uitkomsten van bovenstaande en leg uit wat een Reverse proxy doet
1) (4pt) Kies een tutorial waarin men in Docker een load balancer/proxy toepast. Met behulp van Nginx. Volg de tutorial en leg per stap je 
handeling vast in je eigen repository. Voeg een Markdown file toe waarin je een verwijzing maakt naar de gevolgde tutorial. Maak een korte 
screen recording van de uitkomsten (werking van reverse proxy en scaling/load balancing).

### Voorbereiding

ik heb een script gemaakt voor het maken van een VM bedoeld voor docker.

```bash
#!/bin/bash

# === Instellingen ===
VMID=140 # Deze veranderen!
VMNAME="VMDocker"
CEPHPOOL="vm-storage"
DISK="vm-${VMID}-disk-0"
CLOUDIMG_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
CLOUDIMG="jammy-server-cloudimg-amd64.img"
IMG_RAW="ubuntu.raw"
IMG_RESIZED="ubuntu-20G.raw"
MEM=2048
CORES=2
IP="10.24.13.140/24"
GW="10.24.13.1"
USER="Dockeradmin"
SSH_PUBKEY_PATH="$HOME/.ssh/id_rsa.pub"

echo "📥 Download Ubuntu Cloud Image"
sudo wget -O $CLOUDIMG $CLOUDIMG_URL

echo "🔄 Converteer naar RAW"
sudo qemu-img convert -f qcow2 -O raw $CLOUDIMG $IMG_RAW

echo "📏 Vergroot RAW image naar 20G"
sudo qemu-img resize $IMG_RAW 20G

echo "📤 Upload RAW disk naar Ceph"
sudo rbd rm ${CEPHPOOL}/$DISK 2>/dev/null
sudo rbd import $IMG_RAW $DISK --dest-pool $CEPHPOOL

echo "🖥️ Maak VM aan"
sudo qm create $VMID \
  --name $VMNAME \
  --memory $MEM \
  --cores $CORES \
  --net0 virtio,bridge=vmbr0 \
  --scsihw virtio-scsi-pci \
  --ide2 ${CEPHPOOL}:cloudinit \
  --ostype l26 \
  --agent enabled=1

echo "💾 Koppel disk en stel boot in"
sudo qm set $VMID --scsi0 ${CEPHPOOL}:$DISK
sudo qm set $VMID --boot c --bootdisk scsi0

echo "⚙️ Configureer cloud-init"
sudo qm set $VMID \
  --ciuser $USER \
  --ipconfig0 ip=$IP,gw=$GW \
  --sshkey $SSH_PUBKEY_PATH

# 4. Start de VM
echo "🟢 Start VM $VMID..."
qm start $VMID

# 5. Wacht tot SSH beschikbaar is
echo "⏳ Wachten tot SSH werkt op $IP..."
until ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o BatchMode=yes $USER@${IP%/*} 'echo SSH OK' 2>/dev/null; do
  sleep 3
done

# 6. DNS fix
echo "🌐 DNS instellen op 1.1.1.1"
ssh $USER@${IP%/*} "echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf"

# 7. UFW firewall configureren
echo "🛡️ Firewall instellen"
ssh $USER@${IP%/*} << 'EOF'
sudo apt update
sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw allow 22 comment 'Allow SSH'
sudo ufw allow 80 comment 'Allow HTTP'
sudo ufw allow 443 comment 'Allow HTTPS'
sudo ufw --force enable
sudo ufw status verbose
EOF



# 8. Update & upgrade uitvoeren
# Hij gaat de eerste keer mis door een blokkade
ssh $USER@${IP%/*} "sudo kill -9 \$(pgrep apt-get)"
ssh $USER@${IP%/*} "sudo dpkg --configure -a"

echo "🔄 System update uitvoeren"
ssh $USER@${IP%/*} << 'EOF'
sudo apt update && sudo apt upgrade -y
EOF

# herstarten
sudo qm reboot 140

echo "✅ VM $VMID is volledig klaar en geconfigureerd op $IP"

```

### Opdracht 1

#### Lesson 4 - Installeren van docker met Ubuntu

screenshot van acties:

![alt text](Screenshots\Opdracht1\Repositoryinstellen.png)

alle acties in script:

```bash
#!/bin/bash

IP="10.24.13.140"
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
```

Hier toon ik commando docker ps en docker images.

![alt text](Screenshots\Opdracht1\docker_ps_images.png)


Docker staat op de VM!
Ik heb hello world aangevraagd, en die krijg ik terug!

![alt text](Screenshots\Opdracht1\DockerWerkt.png)


#### Lesson 7 - Build Image with DockerFile and create new Container op elk docker instantie op het Proxmox cluster.

Dockerfile maken:
![alt text](Screenshots\Opdracht1\Dockerfilemaken.sh.png)

Builden van Dockerfile:
![alt text](Screenshots\Opdracht1\buildDockerfile.png)

Runnen van de build.
![alt text](Screenshots\Opdracht1\Dockerrunnen.png)

Les 7 afgerond!

#### Lesson 8 - Docker Compose install op alle 3 Docker installaties op het Proxmox cluster. 

Opdracht:
elke node van het cluster moet een VM + docker + docker compose.
Momenteel is er alleen een docker op de VM in node1.

Voorbereidende stappen:
- script gebruiken om docker te installeren op de andere 2 nodes.

![alt text](Screenshots\Opdracht1\3dockerservers.png)

- Docker composer installeren

Blijkt al geinstalleerd te zijn!

![alt text](Screenshots\Opdracht1\docker_composer.png)

stappen om een docker_compose.yml te maken:

![alt text](Screenshots\Opdracht1\composeyml.png)

docker compose up werkt:

![alt text](Screenshots\Opdracht1\compose_up.png)

- Tailgate erop zetten zodat server bereikbaar is

![alt text](Screenshots\Opdracht1\tailscalewerkend.png)

#### Lesson 9 - Voer, vanaf stap 6, geautomatiseerd de stappen uit op alle Docker omgevingen op het Proxmox cluster. Met als resultaat 3 swarms met 3 manager(op elke procmode node 1) 

- Manager gemaakt op pve02
- firewall geopend voor swarm op alle nodes en docker VM's:
```bash
sudo ufw allow 2377/tcp
sudo ufw allow 7946/tcp
sudo ufw allow 7946/udp
sudo ufw allow 4789/udp
```
- Worker gemaakt met gekregen code:

![alt text](Screenshots\Opdracht1\Worker node.png)

- Lijst met centrale manager en worker nodes:

![alt text](Screenshots\Opdracht1\swarmlijst.png)

Hierbij de automaat die meteen op alle swarms uitgevoerd wordt met een service.
- service gemaakt over de swarm

![alt text](Screenshots\Opdracht1\swarmservice.png)

#### Lesson 10 - "Basic Docker Neworking Command" Zet de commando's in een script en laat het script de commando's een voor een uitvoeren.



### Opdracht 2


### Opdracht 3