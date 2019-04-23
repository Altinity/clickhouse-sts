source ../helpers/start_clickhouse_server_docker.sh
source ../helpers/wait_for_clickhouse_server_start.sh
CHSTS_CLICKHOUSE_HTTP_BASE='http://127.0.0.1:8123/ping'