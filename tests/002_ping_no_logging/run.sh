CHSTS_TEST_NAME='002_ping_no_logging'

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=1

source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=0

source ../helpers/run_benchmark_in_docker.sh
