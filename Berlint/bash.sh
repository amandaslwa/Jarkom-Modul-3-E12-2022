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
http_access deny AVAILABLE_WORKING
http_access allow all
" > /etc/squid/squid.conf
service squid restart
service squid status
apt-get install apache2-utils -y
echo "
acl AVAILABLE_WORKING time MTWHF 08:00-17:00
" > /etc/squid/acl.conf
echo "
include /etc/squid/acl.conf

http_port 8080
http_access deny AVAILABLE_WORKING
http_access allow all
visible_hostname Berlint
" > /etc/squid/squid.conf
service squid restart
service squid status