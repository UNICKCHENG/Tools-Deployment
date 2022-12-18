echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

if [ ! ${SUBNET} ]; then
    iptables -t filter -A FORWARD -j ACCEPT
    iptables -t nat -A POSTROUTING -s ${SUBNET} -j MASQUERADE
fi

if [ ! ${WEB_PORT} ]; then
    sed -i "s/bind_port:.*/bind_port: ${WEB_PORT}" /AdGuardHome/conf/AdGuardHome.yaml
fi

/AdGuardHome/AdGuardHome -c /AdGuardHome/conf/AdGuardHome.yaml -h 0.0.0.0 -w /AdGuardHome/work