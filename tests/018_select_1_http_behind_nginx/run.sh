CHSTS_CLICKHOUSE_QUERY='SELECT 1'

CHSTS_TEST_NAME='018_select_1_http_behind_nginx'

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=1
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=0
source ../helpers/run_benchmark_in_docker.sh
