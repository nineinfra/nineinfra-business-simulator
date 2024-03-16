FROM eclipse-temurin:11-jre-jammy

RUN sed -i s/deb.debian.org/mirrors.ustc.edu.cn/g /etc/apt/sources.list
RUN apt update && apt install -y netcat mysql-client vim iputils-ping net-tools telnet && apt upgrade -y

RUN mkdir -p /opt/nineinfra

ENV NINEINFRA_HOME=/opt/nineinfra

COPY ./ $NINEINFRA_HOME/

WORKDIR /opt/nineinfra

ENTRYPOINT ["/bin/bash","-l"]
