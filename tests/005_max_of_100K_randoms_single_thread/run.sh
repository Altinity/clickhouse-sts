CHSTS_CLICKHOUSE_QUERY='SELECT max(x) FROM (SELECT rand() x FROM system.numbers_mt WHERE number<100000 LIMIT 100000)'
CHSTS_TEST_NAME='005_max_of_100K_randoms_singlethread'

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=1
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=0
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_PROTOCOL='tcp'
source ../helpers/run_benchmark_in_docker.sh
