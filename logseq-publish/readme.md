建议的文件路径

```
- logseq-publish
    - Dockerfile            Docker 构建文件
    - docker-compose.yml    服务配置文件
    - readme.md             说明文件
    - demo                  您的笔记根目录
        - assert
        - journals
        - logseq
        - pages
        - www               需要您先创建好
```


启动命令

```shell
docker compose up -d
# 等待十几秒后，静态文件会被导出到 www 路径下

# 确定是否成功导出
docker logs logseq
```