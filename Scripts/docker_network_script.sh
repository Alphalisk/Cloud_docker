#!/bin/bash

# Configuratie
NETWORK_NAME="multi-host-network"
SUBNET="10.10.36.0/24"
GATEWAY="10.10.36.1"
CONTAINER1="test-container-1"
CONTAINER2="test-container-2"
IP1="10.10.36.101"
IP2="10.10.36.102"

# 1. Maak een custom bridge netwerk aan
echo "🌐 Netwerk 'multi-host-netwerk' aanmaken..."
docker network create \
  --driver bridge \
  --subnet=$SUBNET \
  --gateway=$GATEWAY \
  $NETWORK_NAME

# 2. Start eerste container met statisch IP-adres
echo "🚀 Start $CONTAINER1 met IP $IP1"
docker run -dit --name $CONTAINER1 --network $NETWORK_NAME --ip $IP1 alpine:latest sh

# 3. Start tweede container met statisch IP-adres
echo "🚀 Start $CONTAINER2 met IP $IP2"
docker run -dit --name $CONTAINER2 --network $NETWORK_NAME --ip $IP2 alpine:latest sh

# 4. Test netwerkconnectie (vanuit container 1 naar container 2)
echo "📡 Test netwerkverbinding van $CONTAINER1 naar $CONTAINER2 ($IP2)"
docker exec $CONTAINER1 ping -c 4 $IP2

# 5. Laat netwerkinfo zien
echo "📋 Docker netwerken laten zien, hierin zit een mukti-host-netwerk!"
docker network ls
docker network inspect $NETWORK_NAME

# 6 verbind container1 opnieuw en voeg aliassen toe
echo "🔗 Voeg aliassen toe aan $CONTAINER1"
docker network disconnect $NETWORK_NAME $CONTAINER1
docker network connect --alias db --alias mysql $NETWORK_NAME $CONTAINER1

# 6 disconnect de containers, verwijder containers en verwijder netwerk
echo "Disconnect en verwijder netwerk 'multi-host-netwerk'"
docker network disconnect multi-host-network test-container-2
docker rm -f $CONTAINER1 $CONTAINER2
docker network rm $NETWORK_NAME
docker network prune -f

# 7 controle dat alles verwijdert is.
echo "Laat zien dat het multi-host-netwerk niet meer zichtbaar is: (er is geen multi-host-netwerk meer)"
docker network ls
docker network inspect $NETWORK_NAME

echo "✅ Setup voltooid!"

