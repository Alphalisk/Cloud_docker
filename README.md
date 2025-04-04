# Cloud_docker
Repository voor opdrachten Cloud Computing - Docker.

Inventaris:
- Het verantwoordingsverslag voor de opdrachten wordt in het bestand *Verantwoordingsverslag.md* bijgehouden.
- De map Screenhots bevat bewijsvoering
- De map Scripts bevat bash scripts
- De map Opdrachtbeschrijving is de daadwerkelijke opdracht
- De map `CLI commado's` bevat files met CLI commando's die gebruikt zijn, maar niet een script zijn om te runnen.
- De yml files zijn gebruikt voor de docker lessons.
- Opgenomen video's staan niet op Github vanwege de grootte. Deze worden apart geleverd.

**Netwerkconfiguratie:**
|nodenaam|IP node intern |Type node    |IP Tailscale  |
|--------|---------------|-------------|--------------|
|pve00   |10.24.13.100   |control node |100.94.185.45 |
|pve01   |10.24.13.101   |managed node |100.104.126.78|
|pve02   |10.24.13.102   |managed node |100.84.145.8  |

**VM Docker adressen**
|nodenaam|bevat VM  |IP VM intern   |IP tailscale |
|--------|----------|---------------|-------------|
|pve00   |VMDocker3 |10.24.13.142   |100.71.128.34|
|pve01   |VMDocker2 |10.24.13.141   ||
|pve02   |VMDocker  |10.24.13.140   |100.100.51.67|

## inloginstructies

- inloggen op control node (moet private key certificaat op computer hebben):
  `ssh root@100.94.185.45`
- inloggen op managed node:
  `ssh beheerder@pve01` of `ssh beheerder@pve02`
- inloggen op VMDocker:
  `ssh Dockeradmin@<VMDocker-IP>`