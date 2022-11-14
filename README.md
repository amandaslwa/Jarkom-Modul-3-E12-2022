# Jarkom-Modul-3-E12-2022

Kelas Jaringan Komputer E - Kelompok E12
### Nama Anggota
- Amanda Salwa Salsabila        (5025201172)
- Michael Ariel Manihuruk       (5025201158)
- Azzura Mahendra Putra Malinus (5025201211)

### Topologi
<img width="586" alt="image" src="https://user-images.githubusercontent.com/90702710/201578464-9fe1af61-8598-4a2c-9914-aefeac693cd9.png">

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
```
Ostania sebagai DHCP Relay (2)
```
### Penjelasan

**Menyiapkan DHCP Relay di Ostania**

Menginstall isc-dhcp-relay pada Ostania
```sh
apt-get update
apt-get install isc-dhcp-relay -y
```

Mengonfigurasi DHCP relay 
```sh
echo "
SERVERS=\"192.198.2.4\"
INTERFACES=\"eth1 eth2 eth3\"
OPTIONS=\"\"
" > /etc/default/isc-dhcp-relay
```

Memulai DHCP relay
```
service isc-dhcp-relay start
```

### Soal 3
```
Semua client yang ada HARUS menggunakan konfigurasi IP dari DHCP Server.
Client yang melalui Switch1 mendapatkan range IP dari [prefix IP].1.50 - [prefix IP].1.88 dan [prefix IP].1.120 - [prefix IP].1.155 (3)
```
### Penjelasan
**Mengonfigurasi range IP pada konfigurasi DHCP**
Pengaturan `range` terdapat pada konfigurasi DHCP di Westalis untuk client yang melewati Switch1 (subnet 192.198.1.0)
```
subnet 192.198.1.0 netmask 255.255.255.0 {
    range 192.198.1.50 192.198.1.88;
    range 192.198.1.120 192.198.1.155;
    option routers 192.198.1.1;
    option broadcast-address 192.198.1.255;
    option domain-name-servers 192.198.2.2;
    default-lease-time 300;
    max-lease-time 6900;
}
```

### Soal 4
```
Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.10 - [prefix IP].3.30 dan [prefix IP].3.60 - [prefix IP].3.85 (4)
```
### Penjelasan
**Mengonfigurasi range IP pada konfigurasi DHCP**
Pengaturan `range` terdapat pada konfigurasi DHCP di Westalis untuk client yang melewati Switch3 (subnet 192.198.3.0)
```
subnet 192.198.3.0 netmask 255.255.255.0 {
    range 192.198.3.10 192.198.3.30;
    range 192.198.3.60 192.198.3.85;
    option routers 192.198.3.1;
    option broadcast-address 192.198.3.255;
    option domain-name-servers 192.198.2.2;
    default-lease-time 600;
    max-lease-time 6900;
}
```

### Soal 5
```
Client mendapatkan DNS dari WISE dan client dapat terhubung dengan internet melalui DNS tersebut. (5)
```
### Penjelasan
Pada konfigurasi DHCP di Westalis, pada masing-masing konfigurasi subnet ditambahkan line `option domain-name-servers 192.198.2.2;`

### Soal 6
```
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch1 selama 5 menit sedangkan pada client yang melalui Switch3 selama 10 menit. Dengan waktu maksimal yang dialokasikan untuk peminjaman alamat IP selama 115 menit. (6)
```
### Penjelasan
**Mengonfigurasi lama waktu pada konfigurasi DHCP**
Pengaturan `time` terdapat pada konfigurasi DHCP di Westalis
- Untuk client yang melewati Switch1
```
    default-lease-time 300;
    max-lease-time 6900;
```
- Untuk client yang melewati Switch3
```
    default-lease-time 600;
    max-lease-time 6900;
```

### Soal 7
```
Loid dan Franky berencana menjadikan Eden sebagai server untuk pertukaran informasi dengan alamat IP yang tetap dengan IP [prefix IP].3.13 (7)
```
### Penjelasan
**Mengonfigurasi fixed address**
Pengaturan fixed address terdapat pada konfigurasi DHCP di Westalis
```
host Eden {
    hardware ethernet 16:ca:f3:e7:ea:ee;
    fixed-address 192.198.3.13;
}
```

### Soal 8
```
SSS, Garden, dan Eden digunakan sebagai client Proxy agar pertukaran informasi dapat terjamin keamanannya, juga untuk mencegah kebocoran data.
```
### Penjelasan
**Menginstall Squid dan Lynx**
Pada ketiga client, dilakukan instalasi Squid dan Lynx
```sh
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install squid -y
apt-get install lynx -y
```

**Mengonfigurasi jaringan**
- Pada SSS dan Garden
Konfigurasi jaringan diubah dari yang awalnya static menjadi DHCP
```sh
echo "
auto eth0
iface eth0 inet dhcp
" > /etc/network/interfaces
```
- Pada Eden yang memiliki fixed address
Konfigurasi jaringan menjadi DHCP serta hwaddress
```sh
echo "
auto eth0
iface eth0 inet dhcp
hwaddress ether 16:ca:f3:e7:ea:ee
" > /etc/network/interfaces
```

**Mengexport proxy**
Dilakukan export proxy pada masing-masing client, dengan menggunakan IP Berlint dan port 8080
```
export http_proxy="http://192.198.2.3:8080"
env | grep -i proxy
```

### Soal 9
### Penjelasan

### Soal 10
### Penjelasan

## Kendala
