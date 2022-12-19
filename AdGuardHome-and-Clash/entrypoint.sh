#!/bin/sh

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

if [ ! ${SUBNET} ]; then
    iptables-nft -t filter -A FORWARD -j ACCEPT
    iptables-nft -t nat -A POSTROUTING -s ${SUBNET} -j MASQUERADE
fi

if [ ! ${WEB_PORT} ]; then
    sed -i "s/bind_port:.*/bind_port: ${WEB_PORT}" /opt/AdGuardHome/conf/AdGuardHome.yaml
fi

nohup /opt/clash/clash -d /opt/clash &
/opt/AdGuardHome/AdGuardHome -c /opt/AdGuardHome/conf/AdGuardHome.yaml -h 0.0.0.0 -w /opt/AdGuardHome/work