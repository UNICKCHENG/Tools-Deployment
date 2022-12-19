# Download packages
FROM alpine:latest AS packages

WORKDIR /packages

RUN apk update &&\
    apk add ca-certificates wget --no-cache &&\
    update-ca-certificates

# download AdGuardHome
RUN set -x &&\
    wget -t1 -T8 https://raw.githubusercontent.com/UNICKCHENG/Tools-Deployment/main/Scripts/info_os_and_cpu.sh &&\
    info=`sh info_os_and_cpu.sh "AdguardTeam/AdGuardHome" | grep AdGuardHome | awk -F ":" '{print $2}'` && rm -f info_os_and_cpu.sh &&\
    VERSION=`echo $info | awk -F "-" '{print $3}'` &&\
    OS=`echo $info | awk -F "-" '{print $1 "_" $2}'` &&\
    wget -O AdGuardHome.tar.gz -t1 -T8 https://github.com/AdguardTeam/AdGuardHome/releases/download/${VERSION}/AdGuardHome_${OS}.tar.gz
# download yacd theme
RUN set -x &&\
    wget https://raw.githubusercontent.com/UNICKCHENG/Tools-Deployment/main/Scripts/info_os_and_cpu.sh &&\
    info=`sh info_os_and_cpu.sh "haishanh/yacd" | grep yacd | awk -F ":" '{print $2}'` && rm -f info_os_and_cpu.sh &&\
    VERSION=`echo $info | awk -F "-" '{print $3}'`  &&\
    wget -O yacd.tar.xz -t1 -T8 https://github.com/haishanh/yacd/releases/download/${VERSION}/yacd.tar.xz
# download clash-meta
RUN set -x &&\
    wget https://raw.githubusercontent.com/UNICKCHENG/Tools-Deployment/main/Scripts/info_os_and_cpu.sh &&\
    info=`sh info_os_and_cpu.sh "MetaCubeX/Clash.Meta" | grep Clash | awk -F ":" '{print $2}'` && rm -f info_os_and_cpu.sh &&\
    VERSION=`echo $info | awk -F "-" '{print $3}'` &&\
    OS=`echo $info | awk -F "-" '{print $1 "-" $2}'` &&\
    wget -O clash.gz -t1 -T8 https://github.com/MetaCubeX/Clash.Meta/releases/download/${VERSION}/Clash.Meta-${OS}-compatible-${VERSION}.gz || true &&\
    if [ ! -s clash.gz ]; then wget -O clash.gz -t1 -T8 https://github.com/MetaCubeX/Clash.Meta/releases/download/${VERSION}/Clash.Meta-${OS}-${VERSION}.gz; fi 

# Merge files
FROM alpine:latest AS files

WORKDIR /files
COPY --from=packages /packages/ ./
COPY ./AdGuardHome-and-Clash/config/AdGuardHome.yaml ./
COPY ./AdGuardHome-and-Clash/entrypoint.sh ./

RUN mkdir config && cd config &&\
    mv ../AdGuardHome.yaml ./ && touch Clash.yaml

RUN tar zxvf AdGuardHome.tar.gz && rm -f AdGuardHome.tar.gz &&\
    mkdir ./AdGuardHome/work

RUN mkdir clash && cd clash &&\
    mv ../yacd.tar.xz ./; mv ../clash.gz ./ &&\
    tar -xf yacd.tar.xz && rm -rf yacd.tar.xz && mv public yacd &&\
    gzip -f clash.gz -d

# Build AdGuardHome Image
FROM alpine:latest
LABEL MAINTAINER="unickcheng" GitHUb="https://github.com/UNICKCHENG"

ENV SUBNET ${SUBNET}
ENV WEB_PORT ${WEB_PORT}

WORKDIR /opt
COPY --from=files /files/ ./

RUN apk add apache2-utils iptables --no-cache &&\
    cd clash && chmod +x clash && ./clash -t -d .

ENTRYPOINT ["/bin/sh", "/opt/entrypoint.sh"]