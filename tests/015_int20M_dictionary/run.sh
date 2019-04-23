CHSTS_TEST_NAME='015_int20M_dictionary'

CHSTS_TEST_SUBTYPE1='int20M'

CHSTS_TEST_SUBTYPE2='dict'

CHSTS_TEST_SUBTYPE3='single hit'
CHSTS_CLICKHOUSE_QUERY="SELECT dictGetFloat32('int20M', 'value', toUInt64( 9221669071414979782 ) )"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='single miss'
CHSTS_CLICKHOUSE_QUERY="SELECT dictGetFloat32('int20M', 'value', toUInt64( 9221669071414979783 ) )"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='check 100 ids at once, 1/3 hits'
CHSTS_CLICKHOUSE_QUERY="SELECT dictGetFloat32('int20M', 'value', cityHash64( rand64() % 60000000 )) from numbers(100)"
source ../helpers/run_benchmark_in_docker.sh

