> 如果您从来不知道 [AdGuardHome](https://github.com/AdguardTeam/AdGuardHome/wiki) 和 [Clash-Meta](https://docs.metacubex.one/function/general), 请先自行去了解

## 开始之前

请在 `.env` 中配置好参数信息

```.env
HOST=192.168.1.3
WORK_DIR=/workstation/aghome-and-clash
SUBNET=192.168.1.0/24
GATEWAY=192.168.1.1
PARENT=enp0s1
```

- HOST 表示服务 services 的 IP, 自行设定, 确保与宿主机同网段
- WORK_DIR 填写宿主机上的路径, 用于挂载文件至 docker 服务
- SUBNET 子网, 如果您宿主机的 ip 是 192.168.1.2 则此处填写 192.168.1.0/24, 其他 IP 仿写即可
- GATEWAY 网关, 小白选手请填写与宿主机同局域网的路由器 IP 或者宿主机 IP
- PARENT 物理网卡名称, 可通过下述方式查看, 一般是 enp 或者 eth 开头, 也有例外, 请根据实际情况填写
```shell
$ip a | grep -E "enp|eth" | grep "inet"
inet 192.168.1.2/24 brd 192.168.1.255 scope global enp0s1
```

## 启动服务
```shell
docker compose up -d
docker exec -i adguardhome echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
docker exec -i adguardhome sysctl -p
docker exec -i adguardhome apk add iptables
docker exec -i adguardhome iptables -t filter -A FORWARD -j ACCEPT
# 192.168.1.0/24 改为前面的 SUBNET 内容
docker exec -i adguardhome iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -j MASQUERADE
```
启动完成后, 会自动在 WORK_DIR 将 adguardhome 和 clash 的配置文件挂载出来

### 首次需要进行如下配置
- clash/config.yaml 改为自己的配置文件, 或者从订阅源下载 clash 文件
- adguardhome/AdGuardHome.yaml 这个文件应该没有, 您有两种方式配置
    - 1) 网页 <前面配置的 HOST>:3000 从头开始配置 (如 192.168.1.3:3000)
    - 2) 使用 [我的 AdGuardHome.yaml](https://raw.githubusercontent.com/UNICKCHENG/Tools-Deployment/main/AdGuardHome/AdGuardHome.yaml), 与第一种方式相比较而言，增加了拦截列表和允许列表，以及 DNS 设置。网页访问 <前面配置的 HOST>:1999, 默认账号为 admin, 密码为 12345678 

### 开始起飞

请将局域网其他设备的 DNS 和 网关改为 <前面配置的 HOST> , 如 192.168.1.3


## 可选: 优化服务

不知道为什么使用时间久了之后，网络会变卡，有可能与我的设备有关。如果您想体验更好的服务建议定时重启

```
# ！！！注意：
# 192.168.1.0 改成您局域网的网段，与前面 SUBNET 内容一致
# iptables 详细用法可参考 https://wangchujiang.com/linux-command/c/iptables.html
route_vlan=192.168.1.0/24

cat >> restar.sh << EOF
# 重启服务, 将 /home/unickcheng 修改为自己的路径地址
docker compose -f /home/unickcheng/docker-compose.yml restart
# 开启 ipv4 转发
docker exec -i adguardhome echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
docker exec -i adguardhome sysctl -p
# 配置网关
docker exec -i adguardhome apk add iptables
docker exec -i adguardhome iptables -t filter -A FORWARD -j ACCEPT
docker exec -i adguardhome iptables -t nat -A POSTROUTING -s ${route_vlan} -j MASQUERADE
EOF

# 定时执行 restar.sh 脚本, 将 /home/unickcheng 修改为自己的路径地址
crontab -e 
0 0,12,18 * * * sh /home/unickcheng/restar.sh
```