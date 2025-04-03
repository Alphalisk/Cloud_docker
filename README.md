# Cloud_docker
Repository voor opdrachten Cloud Computing - Docker.

Inventaris:
- Het verantwoordingsverslag voor de opdrachten wordt in het bestand *Verantwoordingsverslag.md* bijgehouden.
- De map screenhots bevat bewijsvoering
- De map Scripts bevat bash scripts
- De map Opdrachtbeschrijving is de daadwerkelijke opdracht

**Netwerkconfiguratie:**
|nodenaam|IP node intern |Type node    |IP Tailscale  |
|--------|---------------|-------------|--------------|
|pve00   |10.24.13.100   |control node |100.94.185.45 |
|pve01   |10.24.13.101   |managed node |100.104.126.78|
|pve02   |10.24.13.102   |managed node |100.84.145.8  |

**VM Docker adressen**
|nodenaam|bevat VM  |IP VM intern   |IP tailscale |
|--------|----------|---------------|-------------|
|pve00   |VMDocker3 |10.24.13.142   |100.100.51.67|
|pve01   |VMDocker2 |10.24.13.141   |             |
|pve02   |VMDocker  |10.24.13.140   |             |

## Werkwijze aanmaken LXM container voor wordpress, klant 1

- inloggen op container:
  `ssh Dockeradmin@10.24.13.<VM-IP>`