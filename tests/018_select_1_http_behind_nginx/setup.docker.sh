
source ../helpers/start_clickhouse_server_docker.sh
source ../helpers/wait_for_clickhouse_server_start.sh

docker rm -f ch_sts_nginx &>/dev/null && echo 'Removed old container'
docker run -d --rm  \
   --name ch_sts_nginx \
   --network=host \
   --ulimit nofile=262144:262144 \
   --volume=$(pwd)/nginx/conf.d:/etc/nginx/conf.d \
   --volume=$(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf \
   nginx

CHSTS_CLICKHOUSE_HTTP_BASE='http://127.0.0.1:18123/'
CHSTS_CLICKHOUSE_HOST='127.0.0.1'
CHSTS_CLICKHOUSE_PORT=9000
CHSTS_CLICKHOUSE_USER='default'
