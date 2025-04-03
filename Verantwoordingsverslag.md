# Begeleidende Verantwoording – Cloud Computing - Docker

## Inleiding

In dit verslag verantwoord ik mijn werkzaamheden binnen het vak **Cloud Computing**, onderdeel van de **HBO-ICT** module **Operations Engineering**. De nadruk ligt op het inrichten, beheren en monitoren van een Proxmox-cluster inclusief geautomatiseerde uitrol van webapplicaties. In deze opdracht: Docker.

## Opdrachten van het project

![alt text](OpdrachtBeschrijving\Opdracht.png)

In plaats van lesson 4,7 en 8 volg ik de officiele training. 
https://docs.docker.com/get-started/

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
2) (4pt) Kies een tutorial waarin men in Docker een load balancer/proxy toepast. Met behulp van Nginx. Volg de tutorial en leg per stap je 
handeling vast in je eigen repository. Voeg een Markdown file toe waarin je een verwijzing maakt naar de gevolgde tutorial. Maak een korte 
screen recording van de uitkomsten (werking van reverse proxy en scaling/load balancing).

### Opdracht 1
