
source ../helpers/start_clickhouse_server_docker.sh
source ../helpers/wait_for_init_db.sh

echo 'Dictionary warm up'
CHSTS_CLICKHOUSE_QUERY="SYSTEM RELOAD DICTIONARIES;"
source ../helpers/run_query_in_docker.sh