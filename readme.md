## ð¤æ³¨æäºé¡¹

æ¬é¡¹ç®ç»å¤§å¤æ°æ¹æ¡æä¾ docker-compose.yml å Dockerfileï¼ä»¥åç¸å³æå¡çéç½®æä»¶ï¼ä»¥ç¡®ä¿æ¨å¯ä»¥å¨ç»å¤§å¤æ°åºæ¯ä¸å¿«ééç½®åå¯å¨ãä¸è¿å¨å¼å§ä¹åè¯·åäºè§£ä»¥ä¸æ³¨æäºé¡¹ã

1. ðåè [Docker å®ç½ææ¡£](https://docs.docker.com/engine/install/) ç¡®ä¿æ­£ç¡®å°å®è£ Dockerãæ¨å¯ä»¥æ§è¡ `docker info` æ¥çã
2. ð³ç¡®ä¿ `docker compose` æ¯æãæ¨å¯éè¿ `docker compose version` æè `docker-compose version` æ¥çã
3. ð¤åéäºæ¬äººçè½åï¼ä¸äºéç½®æ¹æ¡å¯è½å¨æäºåºæ¯ä¸å­å¨é®é¢ï¼å æ­¤ï¼å¨é£ç¨ç¸å³æ¹æ¡æ¶ï¼è¯·ä¿ææ¨çæèã


## ðé®é¢é

### Q docker compose ä¸æ¯æ

åéªè¯ä¸æ¯å¦æ¯æ `docker-compose`ï¼æ³¨æå­å¨ `-` è¿æ¥ç¬¦ãè¿ç§åæ³å±äºè¾èç v1 çæ¬ï¼èæ°çæ¬ Compose V2 éç¨äº `docker compose` æ¹å¼æ¥è¿è¡[^1] [^2]ã

å¦ææ¨ä¸å³å¿è¿ä¸ªè¯é¢ï¼åªæ³ç¥éå¦ä½å®è£ docker compose å¯åèå¦ä¸æ¹æ¡ã

- æ¹æ¡1ï¼ä»å®æ¹ GitHub ä»åºä¸è½½ææ°çæ¬[^3]
```shell
# è·åææ°åå¸çæ¬å·
VERSION=`wget -qO- -t1 -T2 "https://api.github.com/repos/docker/compose/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'`
# ä¸è½½
curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
if [ ! -d ~/.docker/cli-plugins ] ; then mkdir -p ~/.docker/cli-plugins; fi
cp /usr/local/bin/docker-compose ~/.docker/cli-plugins/
# æ¥çæ¯å¦æåæ¯æ
docker compose version
```

- æ¹æ¡2ï¼å½åç¨æ·å¿«éä¸è½½[^4]ï¼æ³¨ææ¿æ¢ä½ æéççæ¬å·ï¼æ­¤å¤ä½¿ç¨çæ¯ `v2.12.2` ä¸ºä¾
```shell
# åè https://get.daocloud.io/#install-compose
VERSION=v2.12.2
curl -L https://get.daocloud.io/docker/compose/releases/download/${VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
if [ ! -d ~/.docker/cli-plugins ] ; then mkdir -p ~/.docker/cli-plugins; fi
cp /usr/local/bin/docker-compose ~/.docker/cli-plugins/
# æ¥çæ¯å¦æåæ¯æ
docker compose version
```


### Q å¦ä½å¼å¯è¿ç¨æ¨¡å¼ï¼è¯·ç¥æç¸å³é£é©ï¼

å¦ææ¨å¸æéè¿æ¬å° Docker CLI æ¥ç®¡çå¤ä¸ªå¹³å°ä¸ç Docker èç¹ï¼æ¨å¯ä»¥éå SSH æè TLS æ¹å¼ãæ³¨æä¸å»ºè®®å¨ docker.service éç½® tcp ç«¯å£æ¥ä½¿ç¨ï¼å®å¨ç­çº§å¤ªä½[^5]ã ä¸é¢ä»¥ SSH éç½®ä¸ºä¾ã

- è¯·åéç½® SSHï¼å¦æä¸æ¸æ¥å¦ä½éç½®ï¼è¯·èªè¡æç´¢ã
- æ¬å°è®¾å¤ç®¡çè¿ç¨ Docker èç¹ [^6]
```shell
docker context create docker-server \
	--description "docker server" \
	--docker "host=ssh://docker-server"

# æ¥çæ¯å¦å å¥
docker context ls 

# åæ¢ docker server
docker context use docker-server
```

## å¼ç¨

[^1]: https://github.com/docker/compose#about-update-and-backward-compatibility
[^2]: https://docs.docker.com/compose/reference/
[^3]: https://github.com/docker/compose/releases
[^4]: https://get.daocloud.io/#install-compose
[^5]: https://docs.docker.com/engine/security/#docker-daemon-attack-surface
[^6]: https://docs.docker.com/engine/security/protect-access/