docker rm -f ch_sts_testserver &>/dev/null && echo 'Removed old container'
docker run --rm -d \
   --name ch_sts_testserver \
   --network=host \
   --volume=$(pwd)/conf.d:/etc/clickhouse-server/conf.d \
   --volume=$(pwd)/users.d:/etc/clickhouse-server/users.d \
   --volume=$(pwd)/ssl/server.crt:/etc/clickhouse-server/server.crt \
   --volume=$(pwd)/ssl/server.key:/etc/clickhouse-server/server.key \
   --volume=$(pwd)/ssl/dhparam.pem:/etc/clickhouse-server/dhparam.pem \
   --volume=$(pwd)/dictionaries.d:/etc/clickhouse-server/dictionaries.d \
   --volume=$(pwd)/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d \
   --ulimit nofile=262144:262144 \
   yandex/clickhouse-server

source ../helpers/wait_for_clickhouse_server_start.sh

CHSTS_CLICKHOUSE_HTTP_BASE='https://127.0.0.1:8443/'

CHSTS_CLICKHOUSE_HOST='127.0.0.1'
CHSTS_CLICKHOUSE_PORT=9440
CHSTS_CLICKHOUSE_USER='default'
CHSTS_CLICKHOUSE_SECURE=1
