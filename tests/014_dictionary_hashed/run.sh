CHSTS_TEST_NAME='014_dictionary_hashed'


CHSTS_TEST_SUBTYPE1='int20M'


CHSTS_TEST_SUBTYPE2='where'

CHSTS_TEST_SUBTYPE3='single hit'
CHSTS_CLICKHOUSE_QUERY="SELECT dictGetFloat32('int20M', 'value', toUInt64( 9221669071414979782 ) );"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='single miss'
CHSTS_CLICKHOUSE_QUERY="SELECT dictGetFloat32('int20M', 'value', toUInt64( 9221669071414979783 ) );"
source ../helpers/run_benchmark_in_docker.sh
