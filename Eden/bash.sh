#!/bin/bash
echo "
auto eth0
iface eth0 inet static
	address 192.198.3.4
	netmask 255.255.255.0
	gateway 192.198.3.1
" > /etc/network/interfaces
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install squid -y
apt-get install lynx -y
export http_proxy="http://192.198.2.3:8080"
env | grep -i proxy
echo "
auto eth0
iface eth0 inet dhcp
hardware ethernet 16:ca:f3:e7:ea:ee
" > /etc/network/interfaces