FROM alpine:latest

ENV ZMQ_VERSION 3.2.5
ENV CZMQ_VERSION 3.0.2
ENV MB_VERSION 3.1.4

COPY . /tmp/

RUN apk update \
    && apk add \
           autoconf cmake build-base tar libtool zlib musl-dev openssl-dev zlib-dev curl \
    && echo " ... adding libmodbus" \

         && curl -L http://libmodbus.org/releases/libmodbus-${MB_VERSION}.tar.gz -o /tmp/libmodbus.tar.gz \
         && cd /tmp/ \
         && tar -xf /tmp/libmodbus.tar.gz \
         && cd /tmp/libmodbus*/ \
         && ./configure --prefix=/usr \
                        --sysconfdir=/etc \
                        --mandir=/usr/share/man \
                        --infodir=/usr/share/info \
         && make && make install \

    && echo " ... adding ZMQ and CZMQ" \
         && curl -L http://download.zeromq.org/zeromq-${ZMQ_VERSION}.tar.gz -o /tmp/zeromq.tar.gz \
         && cd /tmp/ \
         && tar -xf /tmp/zeromq.tar.gz \
         && cd /tmp/zeromq*/ \
         && ./configure --prefix=/usr \
                        --sysconfdir=/etc \
                        --mandir=/usr/share/man \
                        --infodir=/usr/share/info \
         && make && make install \
         
         && curl -L http://download.zeromq.org/czmq-${CZMQ_VERSION}.tar.gz -o /tmp/czmq.tar.gz \
         && cd /tmp/ \
         && tar -xf /tmp/czmq.tar.gz \
         && cd /tmp/czmq*/ \
         && ./configure --prefix=/usr \
                        --sysconfdir=/etc \
                        --mandir=/usr/share/man \
                        --infodir=/usr/share/info \
         && make && make install \

         && rm -rf /tmp/zeromq* && rm -rf /tmp/czmq* && rm -rf /tmp/modbus* \
         && rm -rf /var/cache/apk/* \
    && mkdir -p /tmp/build && cd /tmp/build && cmake .. && make && make install \
    && rm -rf /tmp/* \
    && apk del \
            autoconf cmake build-base tar libtool zlib musl-dev openssl-dev zlib-dev curl \
    && rm -rf /var/cache/apk/* \
    && rm /usr/lib/*.a && rm /usr/lib/*.la

RUN apk update \
    && apk add libgcc libstdc++

EXPOSE 502

## Default command
CMD /usr/bin/modbusd /etc/modbusd/modbusd.json