#!/bin/bash
SUBNET1="10.10.8.0/24"
SUBNET2="10.10.9.0/24"
NET1="mysql_net_1"
NET2="mysql_net_2"
CONTAINER1="mysql1"
CONTAINER2="mysql2"
CONTAINER1_IP="10.10.8.10"
CONTAINER2_IP="10.10.9.10"

# aanmaken subnet 1
docker network create \
  --driver bridge \
  --subnet $SUBNET1 \
  $NET1

# aanmaken subnet 2
docker network create \
  --driver bridge \
  --subnet $SUBNET2 \
  $NET2

# aanmaken container1 met SQL in subnet 1
docker run -d \
  --name $CONTAINER1 \
  --network $NET1 \
  --ip $CONTAINER1_IP \
  -p 3307:3306 \
  -e MYSQL_ROOT_PASSWORD=secret \
  mysql:5.7

# aanmaken container2 met SQL in subnet 2
docker run -d \
  --name $CONTAINER2 \
  --network $NET2 \
  --ip $CONTAINER2_IP \
  -p 3308:3306 \
  -e MYSQL_ROOT_PASSWORD=secret \
  mysql:5.7