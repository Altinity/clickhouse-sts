
CHSTS_TEST_SUBTYPE1='int20M'
CHSTS_TEST_SUBTYPE2='joinGet'

CHSTS_TEST_SUBTYPE3='single hit'
CHSTS_CLICKHOUSE_QUERY="WITH 9221669071414979782 as id select joinGet('int20M', 'value', id) as value"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='single miss'
CHSTS_CLICKHOUSE_QUERY="WITH 9221669071414979783 as id select joinGet('int20M', 'value', id) as value"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='check 100 ids at once, 1/3 hits'
CHSTS_CLICKHOUSE_QUERY="WITH cityHash64( rand64() % 60000000 ) as id select joinGet('int20M', 'value', id ) as value from numbers(100)" 
source ../helpers/run_benchmark_in_docker.sh


CHSTS_TEST_SUBTYPE2='system.one left join'

CHSTS_TEST_SUBTYPE3='single hit'
CHSTS_CLICKHOUSE_QUERY="SELECT 9221669071414979782 as id, * FROM system.one ANY LEFT JOIN int20M USING (id);"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='single miss'
CHSTS_CLICKHOUSE_QUERY="SELECT 9221669071414979783 as id, * FROM system.one ANY LEFT JOIN int20M USING (id);"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='check 100 ids at once, 1/3 hits'
CHSTS_CLICKHOUSE_QUERY="SELECT cityHash64( rand64() % 60000000 ) as id, * FROM numbers(100) ANY LEFT JOIN int20M USING (id);"
source ../helpers/run_benchmark_in_docker.sh
