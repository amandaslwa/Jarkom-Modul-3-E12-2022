# Jarkom-Modul-3-E12-2022

Kelas Jaringan Komputer E - Kelompok E12
### Nama Anggota
- Amanda Salwa Salsabila        (5025201172)
- Michael Ariel Manihuruk       (5025201158)
- Azzura Mahendra Putra Malinus (5025201211)

### Soal 1
```
Loid bersama Franky berencana membuat peta tersebut dengan kriteria WISE sebagai DNS Server, Westalis sebagai DHCP Server, Berlint sebagai Proxy Server (1)
```
### Penjelasan

**Menyiapkan DNS Server di WISE**

Mengatur nameserver agar WISE bisa terhubung ke internet
```sh
echo nameserver 192.168.122.1 > /etc/resolv.conf
```
Menginstall bind9
```sh
apt-get update
apt-get install bind9 -y
```

Mengatur DNS Forwarder ke Ostania agar host yang memiliki DNS WISE bisa tersambung ke internet
```sh
echo "
options {
directory \"/var/cache/bind\";
forwarders {
192.168.122.1;
};
//dnssec-validation auto;
allow-query{ any; };
auth-nxdomain no;    # conform to RFC1035
listen-on-v6 { any; };
};
" > /etc/bind/named.conf.options
```
Mengulang bind9 agar perubahan tersimpan dan mengecek statusnya
```sh
service bind9 restart
service bind9 status
```
**Menyiapan DHCP Server di Westalis**

Mengatur nameserver agar Westalis bisa terhubung ke internet
```sh
echo nameserver 192.168.122.1 > /etc/resolv.conf
```
Menginstall DHCP Server
```sh
apt-get update
apt-get install isc-dhcp-server -y
dhcpd --version
```

Menentukan interface yang terhubung ke DHCP Relay
```sh
echo "
INTERFACES=\"eth0\"
" > /etc/default/isc-dhcp-server
```

Mengonfigurasi DHCP Server \
DHCP server Westalis akan terhubung ke DHCP Relay Ostania untuk mengatur alamat IP dari semua host.
Pengaturan dibuat untuk interface eth1, eth2, dan eth3.

```sh
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
```

Mengulang DHCP Server agar perubahan tersimpan
```sh
service isc-dhcp-server stop
service isc-dhcp-server start
service isc-dhcp-server restart
service isc-dhcp-server status
```
**Menyiapkan Proxy Server di Berlint**
Mengatur nameserver agar Berlint bisa terhubung ke internet
```sh
echo nameserver 192.168.122.1 > /etc/resolv.conf
```
Menginstall squid
```sh
apt-get update
apt-get install squid -y
service squid start
service squid status
```

Mengonfigurasi squid
```sh
mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
echo "
http_port 8080
visible_hostname Berlint
http_access deny AVAILABLE_WORKING
http_access allow all
" > /etc/squid/squid.conf
```

Mengulang squid agar perubahan tersimpan
```sh
service squid restart
service squid status
```
**Mengonfigurasi Semua Host sebagai Client dari DNS Server, DHCP Server, dan Proxy Server**

Mengatur host sebagai DNS Client dengan mengatur nameserver agar mengarah ke IP WISE
```sh
echo nameserver 192.198.122.2 > /etc/resolv.conf
```

Mengatur host sebagai DHCP Client
```sh
echo "
auto eth0
iface eth0 inet dhcp
" > /etc/network/interfaces
```

Mengatur host sebagai proxy client
```sh
apt-get update
apt-get install lynx -y
export http_proxy="http://192.198.2.3:8080"
env | grep -i proxy
```

### Soal 2
### Penjelasan

### Soal 3
### Penjelasan

### Soal 4
### Penjelasan

### Soal 5
### Penjelasan

### Soal 6
### Penjelasan

### Soal 7
### Penjelasan

### Soal 8
### Penjelasan

### Soal 9
### Penjelasan

### Soal 10
### Penjelasan

## Kendala
