FROM alpine:latest
LABEL MAINTAINER="unickcheng" GitHUb="https://github.com/UNICKCHENG"

WORKDIR /root/.config/clash

# yacd theme
RUN set -x \
    && wget -t1 -T8 https://raw.githubusercontent.com/UNICKCHENG/Tools-Deployment/main/Scripts/info_os_and_cpu.sh \
    && info=`sh info_os_and_cpu.sh "haishanh/yacd" | grep yacd | awk -F ":" '{print $2}'` && rm -f info_os_and_cpu.sh \
    && VERSION=`echo $info | awk -F "-" '{print $3}'`  \
    && wget -O yacd.tar.xz -t1 -T8 https://github.com/haishanh/yacd/releases/download/${VERSION}/yacd.tar.xz \
    && tar -xf yacd.tar.xz && rm -rf yacd.tar.xz \
    && mv public yacd

# install clash-meta
RUN set -x \
    && wget -t1 -T8 https://raw.githubusercontent.com/UNICKCHENG/Tools-Deployment/main/Scripts/info_os_and_cpu.sh \
    && info=`sh info_os_and_cpu.sh "MetaCubeX/Clash.Meta" | grep Clash | awk -F ":" '{print $2}'` && rm -f info_os_and_cpu.sh \
    && VERSION=`echo $info | awk -F "-" '{print $3}'` \
    && OS=`echo $info | awk -F "-" '{print $1 "-" $2}'` \
    && wget -O clash.gz -t1 -T8 https://github.com/MetaCubeX/Clash.Meta/releases/download/${VERSION}/Clash.Meta-${OS}-compatible-${VERSION}.gz || true\
    && if [ ! -s clash.gz ]; then wget -O clash.gz -t1 -T8 https://github.com/MetaCubeX/Clash.Meta/releases/download/${VERSION}/Clash.Meta-${OS}-${VERSION}.gz; fi \
    && gzip -f clash.gz  -d && chmod +x clash \
    && mv clash /usr/sbin/clash && clash -t 

CMD ["/usr/sbin/clash"]