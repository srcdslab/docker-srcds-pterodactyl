FROM ubuntu:20.04 as production

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 \
    && apt-get update -q \
    && apt-get install -yq --no-install-recommends \
        ca-certificates \
        clang \
        curl \
        g++-multilib \
        iproute2 \
        lib32stdc++-7-dev \
        lib32z1-dev \
        libc6-dev-i386 \
        linux-libc-dev:i386 \
        libncurses5:i386 \
        tzdata \
    && update-ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/log/*

RUN useradd -m -d /home/container container

USER container

ENV HOME /home/container

WORKDIR /home/container

COPY --chown=container:container ./entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
