FROM ubuntu:16.04

# Parts copied from the original repo below
#LABEL repo="github.com/jasimpson/Dockerfiles"
#LABEL authors="@jasimpson,@lapolonio"

ENV LIBFIXBUF_VERSION=1.7.1
ENV YAF_VERSION=2.8.4
ENV SM_VERSION=1.5.0
ENV SILK_VERSION=3.14.0

# Install Dependencies
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        gcc \
        libglib2.0-dev \
        libpcap-dev \
        python-dev \
        iputils-ping \
        && \
    apt-get clean && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/*

# Build libfixbuf
ADD http://tools.netsa.cert.org/releases/libfixbuf-$LIBFIXBUF_VERSION.tar.gz /tmp/libfixbuf-$LIBFIXBUF_VERSION.tar.gz
WORKDIR "/tmp"
RUN tar -zxvf libfixbuf-$LIBFIXBUF_VERSION.tar.gz
WORKDIR "/tmp/libfixbuf-$LIBFIXBUF_VERSION"
RUN ./configure && make && make install

# Build yaf
ADD http://tools.netsa.cert.org/releases/yaf-$YAF_VERSION.tar.gz /tmp/yaf-$YAF_VERSION.tar.gz
WORKDIR "/tmp"
RUN tar -zxvf yaf-$YAF_VERSION.tar.gz
WORKDIR "/tmp/yaf-$YAF_VERSION"
RUN ./configure --enable-applabel --enable-plugins --enable-entropy && make && make install

# Build super_mediator
ADD http://tools.netsa.cert.org/releases/super_mediator-$SM_VERSION.tar.gz /tmp/super_mediator-$SM_VERSION.tar.gz
WORKDIR "/tmp"
RUN tar -zxvf super_mediator-$SM_VERSION.tar.gz
WORKDIR "/tmp/super_mediator-$SM_VERSION"
RUN ./configure --with-mysql=no && make && make install

# Build silk
ADD https://tools.netsa.cert.org/releases/silk-$SILK_VERSION.tar.gz /tmp/silk-$SILK_VERSION.tar.gz
WORKDIR "/tmp"
RUN tar -zxvf silk-$SILK_VERSION.tar.gz
WORKDIR "/tmp/silk-$SILK_VERSION"
RUN ./configure \
    --with-libfixbuf=/usr/local/lib/pkgconfig/ \
    --with-python \
    --enable-ipv6 && \
    make && make install

RUN ldconfig

RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates dirmngr
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E0C56BD4

RUN echo "deb https://repo.clickhouse.tech/deb/stable/ main/" | tee /etc/apt/sources.list.d/clickhouse.list
RUN apt-get update

RUN apt-get install -y clickhouse-client

VOLUME ["/files"]
RUN mkdir -p /data/incremental
RUN mkdir -p /data/smflows
COPY silk.conf /data/silk.conf
COPY sensors.conf /data/sensors.conf
COPY super_mediator.conf /data/super_mediator.conf
COPY run.sh /run.sh
RUN chmod 0755 /run.sh
EXPOSE 18003/udp
EXPOSE 18004/tcp
EXPOSE 18005/udp
EXPOSE 18006/tcp
ENTRYPOINT ["/run.sh"]
