FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;

RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y tzdata 

RUN apt-get update && \
    apt-get install -y npm && \
    apt-get install -y git && \
    apt-get install -y zip && \
    apt-get install -y maven && \
    apt-get install -y wget 

RUN mkdir -p /data/
WORKDIR /data
RUN git clone https://github.com/oskariorg/oskari-frontend.git
RUN git clone https://github.com/oskariorg/oskari-server-extension-template.git
RUN wget http://oskari.org/build/server/jetty-9.4.12-oskari.zip
RUN unzip -o jetty-9.4.12-oskari.zip

WORKDIR /data/oskari-server
RUN mkdir work
RUN mkdir temp
RUN mkdir logs

WORKDIR /

RUN apt-get update && \
         apt-get install -y postgresql && \
         apt-get install -y postgresql-contrib && \
         apt-get install -y postgresql-10-postgis-2.4 && \
         apt-get install -y postgresql-10-postgis-scripts && \
         apt-get install -y postgresql-10-pgrouting

USER postgres

ADD pg_hba.conf /etc/postgresql/10/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf

USER root

ADD initDBandStartOskari.sh /data/initDBandStartOskari.sh
RUN chmod 755 /data/initDBandStartOskari.sh

ENV REDIS_VERSION=4.0.9 \
    REDIS_USER=redis \
    REDIS_DATA_DIR=/var/lib/redis \
    REDIS_LOG_DIR=/var/log/redis

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server=5:${REDIS_VERSION}* \
 && sed 's/^bind /# bind /' -i /etc/redis/redis.conf \
 && sed 's/^logfile /# logfile /' -i /etc/redis/redis.conf \
 && sed 's/^daemonize yes/daemonize no/' -i /etc/redis/redis.conf \
 && sed 's/^protected-mode yes/protected-mode no/' -i /etc/redis/redis.conf \
 && sed 's/^# unixsocket /unixsocket /' -i /etc/redis/redis.conf \
 && sed 's/^# unixsocketperm 700/unixsocketperm 777/' -i /etc/redis/redis.conf \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
ENTRYPOINT ["/data/initDBandStartOskari.sh"]
