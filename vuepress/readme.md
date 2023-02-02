如果您是首次配置，请先手动生成相应的模板 [^1]

```shell
docker compose -f .\init-docker-compose.yml up -d
docker exec -it init_vuepress npm init vuepress-theme-hope@next docs
docker compose -f .\init-docker-compose.yml down
```

最终的目录结构如下

```
- docs
	- node_modules
	- src
	- package-lock.json
	- package.json
- docker-compose.yml
- Dockerfile
- init-docker-compose.yml
```

启动开发环境

```shell
# 后台启动开发环境
docker compose up -d

# 如果您想实时查看输出日志
docker logs vuepress-dev -f --tail=30
```

[^1]: https://vuepress-theme-hope.github.io/v2/zh/guide/get-started/install.html