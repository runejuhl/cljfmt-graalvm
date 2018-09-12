ARG GRAALVM_VERSION=latest
FROM runejuhl/graalvm:${GRAALVM_VERSION} as build

ENV LEIN_VERSION=2.8.1
ENV LEIN_INSTALL=/usr/local/bin/

WORKDIR /tmp

RUN apt-get update && \
    apt-get -y install \
            curl \
            build-essential \
            debhelper \
            devscripts \
            gcc \
            git \
            make \
            zlib1g-dev

RUN ( cd /usr/local/bin && \
      curl -LO https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
      chmod +x lein && \
      lein )

# Enable running lein as root
ENV LEIN_ROOT 1
