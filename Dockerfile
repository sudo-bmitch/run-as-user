FROM debian:9
ARG GOSU_VERSION=1.10

# run as root, let the entrypoint drop back to myuser
USER root

# install prereq debian packages
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
     ca-certificates \
     curl \
     vim \
     wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install gosu
RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
 && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
 && chmod 755 /usr/local/bin/gosu \
 && gosu nobody true

RUN useradd -d /home/myuser -m myuser
WORKDIR /home/myuser

# entrypoint is used to update uid/gid and then run the users command
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD /bin/sh

