
source ../helpers/start_clickhouse_server_docker.sh
source ../helpers/wait_for_init_db.sh

echo 'Caches warm up'
CHSTS_CLICKHOUSE_QUERY="select max(tuple(*)) from fs12M format Null; select max(tuple(*)) from int20M format Null;"
source ../helpers/run_query_in_docker.sh