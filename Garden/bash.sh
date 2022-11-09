#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install squid -y
apt-get install lynx -y
echo "
auto eth0
iface eth0 inet dhcp
" > /etc/network/interfaces
export http_proxy="http://192.198.2.3:8080"
env | grep -i proxy