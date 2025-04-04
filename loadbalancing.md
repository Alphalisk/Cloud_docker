Stappenplan

```bash
# Stap 1: Start een Ubuntu container met poortkoppeling
docker run -it -p 8080:80 ubuntu

# Stap 2: Update de container
apt-get update

# Stap 3: Installeer NGINX
apt-get install nginx -y

# Stap 4: Installeer vim
apt-get install vim -y

# Stap 5: Installeer Node.js + pm2
apt-get install -y curl
curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get install -y nodejs
npm install -g pm2

# Stap 6: Maak mappen en bestanden aan
cd /
mkdir servers
cd servers
mkdir server1 server2 server3

# Stap 7: Schrijf de servers
cd /servers/server1
npm init -y
npm i express
vim app1.js

# # dit moet in de app1.js
# const express = require("express");
# const app = express();
# app.get("/", (req, res)=>{ res.send("response from server 1"); });
# app.listen(3001, ()=>{ console.log("App running on port 3001"); });

cd /servers/server2
npm init -y
npm i express
vim app2.js

# const express = require("express");
# const app = express();
# app.get("/", (req, res)=>{ res.send("response from server 2"); });
# app.listen(3002, ()=>{ console.log("App running on port 3002"); });

cd /servers/server3
npm init -y
npm i express
vim app3.js

# const express = require("express");
# const app = express();
# app.get("/", (req, res)=>{ res.send("response from server 3"); });
# app.listen(3003, ()=>{ console.log("App running on port 3003"); });

# Stap 8: Start de servers met pm2
pm2 start /servers/server1/app1.js
pm2 start /servers/server2/app2.js
pm2 start /servers/server3/app3.js
pm2 list

# Stap 9: Configureer NGINX als load balancer
rm /etc/nginx/nginx.conf
touch /etc/nginx/nginx.conf
vim /etc/nginx/nginx.conf

# # in config
# events{}

# http {
#     upstream servers {
#         server localhost:3001;
#         server localhost:3002;
#         server localhost:3003;
#     }

#     server {
#         listen 80;

#         location / {
#             proxy_pass http://servers;
#         }
#     }
# }

nginx -t
nginx -s reload

# Stap 10: Test de Load Balancer

# browse:
# http://localhost:8080/

# result:
# response from server 1
# response from server 2
# response from server 3

```
