### Free VPN BGP PEER FULL PREFIX

### IP DIAL : 114.141.51.161
### USER : free-vpn
### PASS : dementor
### SCRIPT L2TP
/interface l2tp-client add connect-to=114.141.51.161 disabled=no name=l2tp-Dementor password=dementor user=free-vpn

### BGP PEER 
### LOCAL AS : 65432
### REMOTE AS : 64899
### REMOTE IP : 172.16.254.254
### ROLE : eBGP
### SCRIPT BGP PEER 
/routing bgp template set default as=65432 disabled=no
/routing bgp instance add as=65432 disabled=no name=dementor
/routing bgp connection add as=65432 connect=yes disabled=no input.filter=from-bgp-feed instance=dementor listen=yes local.role=ebgp name=bgp-dementor output.filter-chain=deny-all .network=bgp-networks .redistribute=connected remote.address=172.16.254.254/32 .as=64899 routing-table=main templates=default

### FILTER BGP v7
/routing filter rule add chain=from-bgp-feed disabled=no rule="if (bgp-input-remote-addr==172.16.254.254) {jump bgp-route}"

### SESUAIKAN IP GATEWAY ANDA
### CONTOH JIKA MENGGUNAKAN 3 WAN
/routing filter rule add chain=wan1 rule="if (dst in 0.0.0.0/0) { set gw 192.168.18.1; accept;}"
/routing filter rule add chain=wan2 disabled=no rule="if (dst in 0.0.0.0/0) { set gw 172.16.108.1; accept;}"
/routing filter rule add chain=wan3 disabled=no rule="if (dst in 0.0.0.0/0) { set gw 172.29.29.1; accept;}"

### CONTOH FILTER AS MYREP ROUTE TO WAN1
/routing filter rule add chain=bgp-route comment="AS MYREP" disabled=no rule="if ( bgp-as-path 56300 ) { jump wan1; }"
/routing filter rule add chain=bgp-route comment="AS MYREP" disabled=no rule="if ( bgp-as-path 63859 ) { jump wan1; }"

### CONTOH FILTER PREFIX ROUTE TO WAN2
/routing filter rule add chain=bgp-route comment="PREFIX 202.154.0.0/16" disabled=no rule="if ( dst in 202.154.0.0/16 ) { jump wan2; }"
