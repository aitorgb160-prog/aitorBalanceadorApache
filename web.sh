#!/bin/bash
NUM=$1
NOMBRE=$2
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y apache2 mariadb-client ufw

echo "<h1>Servidor Web ${NUM} - ${NOMBRE}</h1>" > /var/www/html/index.html
systemctl enable --now apache2

ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow from 10.0.2.0/24 to any port 22 proto tcp
ufw allow from 192.168.20.10 to any port 80 proto tcp
ufw --force enable
