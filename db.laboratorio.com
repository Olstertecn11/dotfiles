echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf


# Limpia reglas previas (opcional)
sudo iptables -F
sudo iptables -t nat -F

# Crea la regla de NAT
sudo iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE

# Permite el paso de paquetes
sudo iptables -A FORWARD -i enp0s9 -o enp0s8 -j ACCEPT
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
