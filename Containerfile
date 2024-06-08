FROM ubuntu:20.04 as production

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Paris

RUN dpkg --add-architecture i386 \
    && apt-get update -q \
    && apt-get upgrade -yq \
    && apt-get install -y \
        clang \
        g++-multilib \
        lib32stdc++-7-dev \
        lib32z1-dev \
        libc6-dev-i386 \
        linux-libc-dev:i386 \
        libncurses5:i386 \
        curl \
        ca-certificates

RUN useradd -m -d /home/container container

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

USER container

ENV HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
