CHSTS_CLICKHOUSE_QUERY='SELECT 1'

CHSTS_TEST_NAME='003_select_1_no_logging'

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=1
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=0
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_PROTOCOL='tcp'
source ../helpers/run_benchmark_in_docker.sh
