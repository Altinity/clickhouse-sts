CHSTS_TEST_NAME='016_join_fs12M'

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=1

source ./fs12join_lookups.sh

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=0

source ./fs12join_lookups.sh

CHSTS_TEST_PROTOCOL='tcp'
source ./fs12join_lookups.sh