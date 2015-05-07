#!/bin/bash

IP=`/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`

if hash docker-compose 2>/dev/null; then
  echo "Docker Compose found!"
else
  curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
fi

docker-compose up -d web

echo "Grafana: http://$IP:3000 - admin/admin"
echo "InfluxDB: http://$IP:8083 - root/root"
echo "Apache: http://$IP"

