FROM balenalib/raspberrypi3-debian:latest

LABEL maintainer="chrborg"

RUN [ "cross-build-start" ]

ENV  DEBIAN_FRONTEND noninteractive

RUN mkdir templates

ADD ./templates/* templates/

# Install RPI-Monitor form Xavier Berger's repository
RUN apt-get -y update && \
    apt-get install -y --no-install-recommends dirmngr apt-transport-https ca-certificates  && \
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2C0D3C0F && \
    echo deb http://giteduberger.fr rpimonitor/ > /etc/apt/sources.list.d/rpimonitor.list && \
    apt-get -y update && \
    apt-get install -y rpimonitor && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    sed -i 's/\/sys\//\/dockerhost\/sys\//g' /etc/rpimonitor/template/* && \
    sed -i 's/\/etc\/os-release/\/dockerhost\/usr\/lib\/os-release/g' /etc/rpimonitor/template/version.conf && \
    sed -i 's/\/proc\//\/dockerhost\/proc\//g' /etc/rpimonitor/template/* && \
    echo include=/etc/rpimonitor/template/wlan.conf >> /etc/rpimonitor/data.conf && \
    sed -i '/^web.status.1.content.8.line/ d' /etc/rpimonitor/template/network.conf && \
    sed -i '/^#web.status.1.content.8.line/s/^#//g' /etc/rpimonitor/template/network.conf && \
    sed -i 's/\#dynamic/dynamic/g' /etc/rpimonitor/template/network.conf && \
    sed -i 's/\#web.statistics/web.statistics/g' /etc/rpimonitor/template/network.conf && \
    cp templates/* /etc/rpimonitor/template/ && \
    cd templates && \
    for FILE in *.conf; do sed -i '/include=\/etc\/rpimonitor\/template\/sdcard.conf$/a include=\/etc\/rpimonitor\/template\/'$FILE /etc/rpimonitor/data.conf; done


# Allow access to port 8888
EXPOSE 8888

# Start rpimonitord using run.sh wrapper script
ADD run.sh /run.sh
RUN chmod +x /run.sh
CMD bash -C '/run.sh';'bash'

RUN [ "cross-build-end" ]
