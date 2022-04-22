FROM mono:latest

ENV S6_VERSION=v1.21.4.0
ENV LANG=en_US.UTF-8
ENV HOMESEER_VERSION=4_2_11_0


RUN apt-get update && apt-get install -y \
    chromium \
    flite \
    wget \
    nano \
    iputils-ping \
    net-tools \
    etherwake \
    ssh-client \
    mosquitto-clients \
    mono-xsp4 \
    mono-vbnc \
    avahi-discover \
    libavahi-compat-libdnssd-dev \
    libnss-mdns \
    avahi-daemon avahi-utils mdns-scan \
    ffmpeg aha flite alsa-utils alsa-utils mono-devel \
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
EXPOSE 80 8888 10200 10300 10401 11000

ENTRYPOINT [ "/init" ]
