## 🤔注意事项

本项目绝大多数方案提供 docker-compose.yml 和 Dockerfile，以及相关服务的配置文件，以确保您可以在绝大多数场景下快速配置和启动。不过在开始之前请先了解以下注意事项。

1. 🐋参考 [Docker 官网文档](https://docs.docker.com/engine/install/) 确保正确地安装 Docker。您可以执行 `docker info` 查看。
2. 🐳确保 `docker compose` 支持。您可通过 `docker compose version` 或者 `docker-compose version` 查看。
3. 🤔受限于本人的能力，一些配置方案可能在某些场景下存在问题，因此，在食用相关方案时，请保持您的思考。


## 🙋问题集

### Q docker compose 不支持

先验证下是否支持 `docker-compose`，注意存在 `-` 连接符。这种写法属于较老的 v1 版本，而新版本 Compose V2 采用了 `docker compose` 方式来运行[^1] [^2]。

如果您不关心这个话题，只想知道如何安装 docker compose 可参考如下方案。

- 方案1：从官方 GitHub 仓库下载最新版本[^3]
```shell
# 获取最新发布版本号
VERSION=`wget -qO- -t1 -T2 "https://api.github.com/repos/docker/compose/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'`
# 下载
curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
if [ ! -d ~/.docker/cli-plugins ] ; then mkdir -p ~/.docker/cli-plugins; fi
cp /usr/local/bin/docker-compose ~/.docker/cli-plugins/
# 查看是否成功支持
docker compose version
```

- 方案2：国内用户快速下载[^4]，注意替换你所需的版本号，此处使用的是 `v2.12.2` 为例
```shell
# 参考 https://get.daocloud.io/#install-compose
VERSION=v2.12.2
curl -L https://get.daocloud.io/docker/compose/releases/download/${VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
if [ ! -d ~/.docker/cli-plugins ] ; then mkdir -p ~/.docker/cli-plugins; fi
cp /usr/local/bin/docker-compose ~/.docker/cli-plugins/
# 查看是否成功支持
docker compose version
```


### Q 如何开启远程模式（请知悉相关风险）

如果您希望通过本地 Docker CLI 来管理多个平台上的 Docker 节点，您可以采取 SSH 或者 TLS 方式。注意不建议在 docker.service 配置 tcp 端口来使用，安全等级太低[^5]。 下面以 SSH 配置为例。

- 请先配置 SSH，如果不清楚如何配置，请自行搜索。
- 本地设备管理远程 Docker 节点 [^6]
```shell
docker context create docker-server \
	--description "docker server" \
	--docker "host=ssh://docker-server"

# 查看是否加入
docker context ls 

# 切换 docker server
docker context use docker-server
```

## 引用

[^1]: https://github.com/docker/compose#about-update-and-backward-compatibility
[^2]: https://docs.docker.com/compose/reference/
[^3]: https://github.com/docker/compose/releases
[^4]: https://get.daocloud.io/#install-compose
[^5]: https://docs.docker.com/engine/security/#docker-daemon-attack-surface
[^6]: https://docs.docker.com/engine/security/protect-access/