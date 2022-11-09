#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install squid -y
service squid start
service squid status
mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
echo "
http_port 8080
visible_hostname Berlint
http_access allow all
" > /etc/squid/squid.conf
service squid restart
service squid status