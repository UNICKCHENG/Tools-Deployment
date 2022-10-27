运行 docker

```shell
# 开启
docker compose -f ./docker-compose.yml --env-file ./.env up -d

# 关闭
docker compose -f ./docker-compose.yml --env-file ./.env down
```


参考链接如下

- https://github.com/deviantony/docker-elk
- [Install Elasticsearch with Docker](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)
- [阮一鸣-极客时间课程课件](https://github.com/geektime-geekbang/geektime-ELK/blob/master/part-1/2.3-%E5%9C%A8Docker%E5%AE%B9%E5%99%A8%E4%B8%AD%E8%BF%90%E8%A1%8CElasticsearch%2CKibana%E5%92%8CCerebro/7.x-docker-2-es-instances/docker-compose.yaml)
- https://www.docker.elastic.co