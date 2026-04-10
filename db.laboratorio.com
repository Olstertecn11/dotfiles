$TTL    604800
@       IN      SOA     laboratorio.com. admin.laboratorio.com. (
                              3         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
; Servidores de nombre (NS)
@       IN      NS      ns.laboratorio.com.

; Registros A (Nombre a IP)
@       IN      A       10.10.10.1
ns      IN      A       10.10.10.1
servidor IN     A       10.10.10.1
