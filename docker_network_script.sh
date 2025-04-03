#!/bin/bash

# === Configuratie ===
NETWORK_NAME="multi-host-network"
CONTAINER_NAME="container" # Pas de naam van de container aan indien nodig
IP_ADDRESS="10.10.36.122"  # Pas het IP-adres aan indien nodig

# 1. Lijst alle netwerken in Docker
echo "📋 Lijst van alle Docker netwerken:"
docker network ls

# 2. Verbind een container met een netwerk
echo "🔗 Verbind de container met het netwerk $NETWORK_NAME"
docker network connect $NETWORK_NAME $CONTAINER_NAME

# 3. Verbind een container met een netwerk en specificeer een IP-adres
echo "🔗 Verbind de container met het netwerk $NETWORK_NAME en wijs IP $IP_ADDRESS toe"
docker network connect --ip $IP_ADDRESS $NETWORK_NAME $CONTAINER_NAME

# 4. Maak een netwerk alias voor een container
echo "🔗 Maak een netwerk alias voor de container $CONTAINER_NAME"
docker network connect --alias db --alias mysql $NETWORK_NAME $CONTAINER_NAME

# 5. Verbreek de verbinding van de container met het netwerk
echo "❌ Verbreek de verbinding van de container $CONTAINER_NAME met het netwerk $NETWORK_NAME"
docker network disconnect $NETWORK_NAME $CONTAINER_NAME

# 6. Verwijder een netwerk
echo "🗑️ Verwijder het netwerk $NETWORK_NAME"
docker network rm $NETWORK_NAME

# 7. Verwijder meerdere netwerken (gebruik de ID van het netwerk)
echo "🗑️ Verwijder meerdere netwerken"
docker network rm 3695c422697f $NETWORK_NAME

# 8. Verwijder alle ongebruikte netwerken
echo "🧹 Verwijder alle ongebruikte netwerken"
docker network prune -f

echo "✅ Alle Docker netwerkcommando's zijn uitgevoerd!"
