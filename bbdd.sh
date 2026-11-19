#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y mariadb-server ufw

# MariaDB escucha solo en su IP de la red privada
sed -i 's/^bind-address.*/bind-address = 192.168.30.10/' /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb
mysql -e "CREATE DATABASE IF NOT EXISTS tarea;"
mysql -e "CREATE USER IF NOT EXISTS 'app'@'192.168.30.%' IDENTIFIED BY '1234';"
mysql -e "GRANT ALL PRIVILEGES ON tarea.* TO 'app'@'192.168.30.%'; FLUSH PRIVILEGES;"

# Cortafuegos: solo los servidores web acceden a MariaDB
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow from 10.0.2.0/24 to any port 22 proto tcp     # acceso de Vagrant
ufw allow from 192.168.30.11 to any port 3306 proto tcp # Web1
ufw allow from 192.168.30.12 to any port 3306 proto tcp # Web2
ufw --force enable
