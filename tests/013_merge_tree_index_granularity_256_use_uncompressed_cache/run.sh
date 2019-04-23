CHSTS_TEST_NAME='013_merge_tree_index_granularity_256_use_uncompressed_cache'

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=1

source ../helpers/fs12M_int20M_lookups.sh

CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=0

source ../helpers/fs12M_int20M_lookups.sh

CHSTS_TEST_PROTOCOL='tcp'
source ../helpers/fs12M_int20M_lookups.sh