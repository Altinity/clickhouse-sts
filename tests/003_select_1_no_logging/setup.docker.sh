docker run -d --rm \
   --name ch_sts_testserver \
   --network=host \
   --volume=$(pwd)/conf.d:/etc/clickhouse-server/conf.d \
   --ulimit nofile=262144:262144 \
   yandex/clickhouse-server

CHSTS_CLICKHOUSE_HTTP_BASE='http://127.0.0.1:8123/'
CHSTS_CLICKHOUSE_HOST='127.0.0.1'
CHSTS_CLICKHOUSE_PORT=9000
CHSTS_CLICKHOUSE_USER='default'
