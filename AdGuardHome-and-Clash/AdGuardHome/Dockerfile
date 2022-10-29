FROM alpine:latest
LABEL MAINTAINER="unickcheng" GitHUb="https://github.com/UNICKCHENG"

WORKDIR /opt
COPY AdGuardHome.yaml AdGuardHome.sh ./

ENV SUBNET ${SUBNET}

RUN set -x; DEV_TOOLS="apache2-utils iptables" \
    && wget -t1 -T8 https://raw.githubusercontent.com/UNICKCHENG/Tools-Deployment/main/Scripts/info_os_and_cpu.sh \
    && info=`sh info_os_and_cpu.sh "AdguardTeam/AdGuardHome" | grep AdGuardHome | awk -F ":" '{print $2}'` && rm -f info_os_and_cpu.sh \
    && VERSION=`echo $info | awk -F "-" '{print $3}'` \
    && OS=`echo $info | awk -F "-" '{print $1 "_" $2}'` \
    && wget -O AdGuardHome.tar.gz -t1 -T8 https://github.com/AdguardTeam/AdGuardHome/releases/download/${VERSION}/AdGuardHome_${OS}.tar.gz \
    && tar zxvf AdGuardHome.tar.gz && rm -f AdGuardHome.tar.gz \
    && mkdir ./AdGuardHome/conf && mv AdGuardHome.yaml ./AdGuardHome/conf \
    && apk add ${DEV_TOOLS} --no-cache 

ENTRYPOINT ["/bin/sh", "/opt/AdGuardHome.sh"]