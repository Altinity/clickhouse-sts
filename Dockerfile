FROM yandex/clickhouse-client

RUN apt-get update -y \
    && env DEBIAN_FRONTEND=noninteractive \
        apt-get install --yes --no-install-recommends \
            bash \
            curl \
            git \
            build-essential \
            libssl-dev \
            jq \
            ca-certificates \
    && cd /tmp \ 
    && git clone https://github.com/wg/wrk \
    && cd wrk/ \
    && make \
    && cp  ./wrk /usr/local/bin  \
    && cd / \
    && rm -rf /tmp/wrk /var/lib/apt/lists/* /var/cache/debconf \
    && apt-get clean

COPY [ "scripts/" , "/scripts" ]

# reset enrtypoint defined in clickhouse-client
ENTRYPOINT []

CMD ["/bin/bash"]