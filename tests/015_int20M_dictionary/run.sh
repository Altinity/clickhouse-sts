CHSTS_TEST_NAME='015_int20M_dictionary'

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=1

source ./int20Mdict_lookups.sh

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=0

source ./int20Mdict_lookups.sh

CHSTS_TEST_PROTOCOL='tcp'
source ./int20Mdict_lookups.sh
