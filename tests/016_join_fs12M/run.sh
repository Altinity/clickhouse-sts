CHSTS_TEST_NAME='016_join_fs12M'

CHSTS_CONCURRENCY_LEVELS='64 64'
CHSTS_TEST_PROTOCOL='http'
CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE=1


CHSTS_TEST_SUBTYPE1='fs12M'

CHSTS_TEST_SUBTYPE2='joinGet'

CHSTS_TEST_SUBTYPE3='single hit'
CHSTS_CLICKHOUSE_QUERY="WITH toFixedString( unhex('80057A5416B5BE94E840E379077DC2D2'), 16) as id select joinGet('fs12M', 'value1', id) as value1, joinGet('fs12M', 'value2', id ) as value2, joinGet('fs12M', 'value3', id ) as value3, joinGet('fs12M', 'value4', id ) as value4, joinGet('fs12M', 'str_value', id ) as str_value"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='single miss'
CHSTS_CLICKHOUSE_QUERY="WITH toFixedString( unhex('80057A5416B5BE94E840E379077DC2D3'), 16) as id select joinGet('fs12M', 'value1', id ) as value1, joinGet('fs12M', 'value2', id ) as value2, joinGet('fs12M', 'value3', id ) as value3, joinGet('fs12M', 'value4', id ) as value4, joinGet('fs12M', 'str_value', id ) as str_value"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='check 100 ids at once, 1/3 hits'
CHSTS_CLICKHOUSE_QUERY="WITH murmurHash3_128( reinterpretAsString( rand64() % 36000000 ) ) as id select joinGet('fs12M', 'value1', id ) as value1, joinGet('fs12M', 'value2', id ) as value2, joinGet('fs12M', 'value3', id ) as value3, joinGet('fs12M', 'value4', id ) as value4, joinGet('fs12M', 'str_value', id ) as str_value from numbers(100)"
source ../helpers/run_benchmark_in_docker.sh


CHSTS_TEST_SUBTYPE2='system.one left join'

CHSTS_TEST_SUBTYPE3='single hit'
CHSTS_CLICKHOUSE_QUERY="SELECT toFixedString( unhex('80057A5416B5BE94E840E379077DC2D2'), 16 ) as id, * FROM system.one ANY LEFT JOIN fs12M USING (id);"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='single miss'
CHSTS_CLICKHOUSE_QUERY="SELECT toFixedString( unhex('80057A5416B5BE94E840E379077DC2D3'), 16 ) as id, * FROM system.one ANY LEFT JOIN fs12M USING (id);"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='check 100 ids at once, 1/3 hits'
CHSTS_CLICKHOUSE_QUERY="SELECT murmurHash3_128(reinterpretAsString( rand64() % 36000000 )) as id, * FROM numbers(100) ANY LEFT JOIN fs12M USING (id);"
source ../helpers/run_benchmark_in_docker.sh
