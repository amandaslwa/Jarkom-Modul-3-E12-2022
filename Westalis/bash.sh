#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install isc-dhcp-server -y
dhcpd --version
echo "
INTERFACES=\"eth0\"
" > /etc/default/isc-dhcp-servery
echo "
subnet 192.198.1.0 netmask 255.255.255.0 {
    range 192.198.1.50 192.198.1.88;
    range 192.198.1.120 192.198.1.155;
    option routers 192.198.1.1;
    option broadcast-address 192.198.1.255;
    option domain-name-servers 192.198.2.2;
    default-lease-time 300;
    max-lease-time 6900;
}
subnet 192.198.2.0 netmask 255.255.255.0 {    
    option routers 192.198.2.1;
}
subnet 192.198.3.0 netmask 255.255.255.0 {
    range 192.198.3.10 192.198.3.30;
    range 192.198.3.60 192.198.3.85;
    option routers 192.198.3.1;
    option broadcast-address 192.198.3.255;
    option domain-name-servers 192.198.2.2;
    default-lease-time 600;
    max-lease-time 6900;
}
host Eden {
    hardware ethernet 16:ca:f3:e7:ea:ee;
    fixed-address 192.198.3.13;
}
" > /etc/dhcp/dhcpd.conf
service isc-dhcp-server stop
service isc-dhcp-server start
service isc-dhcp-server restart
service isc-dhcp-server status