FROM runejuhl/graalvm:1.0.0-rc6 as build

ENV LEIN_VERSION=2.8.1
ENV LEIN_INSTALL=/usr/local/bin/

WORKDIR /tmp

RUN apt-get update && \
    apt-get -y install \
            curl \
            gcc \
            zlib1g-dev

RUN ( cd /usr/local/bin && \
      curl -LO https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
      chmod +x lein && \
      lein )

# Enable running lein as root
ENV LEIN_ROOT 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app

RUN lein uberjar
RUN native-image -jar target/cljfmt-graalvm-0.1.0-SNAPSHOT-standalone.jar -H:Name="cljfmt"

# NOTE: If you run jlink on ubuntu, you can't use the same jre on alpine, they
# have incompatible libc libraries!

FROM ubuntu:18.04

COPY --from=build /usr/src/app/cljfmt /usr/local/bin/

ENTRYPOINT /usr/local/bin/cljfmt
