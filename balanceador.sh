#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y apache2 certbot python3-certbot-apache ufw

a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests

cat > /etc/apache2/sites-available/balanceador.conf <<'APACHE'
<VirtualHost *:80>
    ServerName balanceador

    <Proxy "balancer://servidores_web">
        BalancerMember http://192.168.20.11
        BalancerMember http://192.168.20.12
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPreserveHost On
    ProxyPass "/" "balancer://servidores_web/"
    ProxyPassReverse "/" "balancer://servidores_web/"
</VirtualHost>
APACHE

a2dissite 000-default
a2ensite balanceador
systemctl enable apache2
systemctl restart apache2

ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow from 10.0.2.0/24 to any port 22 proto tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable
