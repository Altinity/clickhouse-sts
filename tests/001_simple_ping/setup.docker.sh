docker run \
     -d --rm \
     --name ch_sts_testserver \
     --network=host \
     --ulimit nofile=262144:262144 \
     yandex/clickhouse-server

CHSTS_CLICKHOUSE_HTTP_BASE='http://127.0.0.1:8123/ping'