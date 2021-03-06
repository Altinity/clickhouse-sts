docker rm -f ch_sts_testserver &>/dev/null && echo 'Removed old container'

docker run --rm -d \
   --name ch_sts_testserver \
   --network=host \
   --volume=$(pwd)/conf.d:/etc/clickhouse-server/conf.d \
   --volume=$(pwd)/users.d:/etc/clickhouse-server/users.d \
   --volume=$(pwd)/dictionaries.d:/etc/clickhouse-server/dictionaries.d \
   --volume=$(pwd)/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d \
   --ulimit nofile=262144:262144 \
   yandex/clickhouse-server

CHSTS_CLICKHOUSE_HTTP_BASE='http://127.0.0.1:8123/'
CHSTS_CLICKHOUSE_HOST='127.0.0.1'
CHSTS_CLICKHOUSE_PORT=9000
CHSTS_CLICKHOUSE_USER='default'