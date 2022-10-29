echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
iptables -t filter -A FORWARD -j ACCEPT
iptables -t nat -A POSTROUTING -s ${SUBNET} -j MASQUERADE

/opt/AdGuardHome/AdGuardHome -c /opt/AdGuardHome/conf/AdGuardHome.yaml -h 0.0.0.0 -w /opt/AdGuardHome/work