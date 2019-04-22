CHSTS_TEST_NAME='007_merge_tree_index_granularity_32'
CHSTS_CONCURRENCY_LEVELS='64'
CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=1


CHSTS_TEST_SUBTYPE1='fs12M'



CHSTS_TEST_SUBTYPE2='where'

CHSTS_TEST_SUBTYPE3='single hit'
CHSTS_CLICKHOUSE_QUERY="select * from fs12M WHERE id=unhex('80057A5416B5BE94E840E379077DC2D2')"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='single miss'
CHSTS_CLICKHOUSE_QUERY="select * from fs12M WHERE id=unhex('80057A5416B5BE94E840E379077DC2D3')"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='check 100 ids at once, 1/3 hits'
CHSTS_CLICKHOUSE_QUERY="select * from fs12M where id in (select murmurHash3_128(reinterpretAsString( rand64() % 36000000 )) from numbers(100))"
source ../helpers/run_benchmark_in_docker.sh




CHSTS_TEST_SUBTYPE2='prewhere'

CHSTS_TEST_SUBTYPE3='single hit'
CHSTS_CLICKHOUSE_QUERY="select * from fs12M PREWHERE id=unhex('80057A5416B5BE94E840E379077DC2D2')"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='single miss'
CHSTS_CLICKHOUSE_QUERY="select * from fs12M PREWHERE id=unhex('80057A5416B5BE94E840E379077DC2D3')"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='check 100 ids at once, 1/3 hits'
CHSTS_CLICKHOUSE_QUERY="select * from fs12M prewhere id in (select murmurHash3_128(reinterpretAsString( rand64() % 36000000 )) from numbers(100))"
source ../helpers/run_benchmark_in_docker.sh






CHSTS_TEST_SUBTYPE1='int20M'



CHSTS_TEST_SUBTYPE2='where'

CHSTS_TEST_SUBTYPE3='single hit'
CHSTS_CLICKHOUSE_QUERY="select * from int20M WHERE id=9221669071414979782"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='single miss'
CHSTS_CLICKHOUSE_QUERY="select * from int20M WHERE id=9221669071414979783"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='check 100 ids at once, 1/3 hits'
CHSTS_CLICKHOUSE_QUERY="select * from int20M where id in (select cityHash64( rand64() % 60000000 ) from numbers(100))"
source ../helpers/run_benchmark_in_docker.sh



CHSTS_TEST_SUBTYPE2='prewhere'

CHSTS_TEST_SUBTYPE3='single hit'
CHSTS_CLICKHOUSE_QUERY="select * from int20M PREWHERE id=9221669071414979782"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='single miss'
CHSTS_CLICKHOUSE_QUERY="select * from int20M PREWHERE id=9221669071414979783"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='check 100 ids at once, 1/3 hits'
CHSTS_CLICKHOUSE_QUERY="select * from int20M prewhere id in (select cityHash64( rand64() % 60000000 ) from numbers(100))"
source ../helpers/run_benchmark_in_docker.sh

