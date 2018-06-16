FROM mono:5

ENV S6_VERSION=v1.21.4.0 \
    HOMESEER_VERSION=3_0_0_435 \
    LANG=en_US.UTF-8

RUN apt-get update && apt-get install -y \
    avahi-discover \
    chromium \
    flite \
    libavahi-compat-libdnssd-dev \
    libnss-mdns \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && touch /DO_INSTALL

ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
    && tar -xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin \
    && rm -rf /tmp/* /var/tmp/*

COPY rootfs /

ARG AVAHI
RUN [ "${AVAHI:-1}" = "1" ] || (echo "Removing Avahi" && rm -rf /etc/services.d/avahi /etc/services.d/dbus)

VOLUME [ "/HomeSeer" ] 
EXPOSE 80 10200 10300 10401

ENTRYPOINT [ "/init" ]
