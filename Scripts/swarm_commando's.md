
```bash
sudo docker swarm init --advertise-addr <MANAGER_NODE_IP>

docker swarm join --token SWMTKN-1-4cpg4wbyjr1jrh0s04p08j81h2oxsl8ukjq4onphdn6s44opp0-cz27d8itoxag43izgqxrcdwcd 10.24.13.140:2377

# firewall voor swarm
sudo ufw allow 2377/tcp
sudo ufw allow 7946/tcp
sudo ufw allow 7946/udp
sudo ufw allow 4789/udp

```

