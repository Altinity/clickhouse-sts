CHSTS_TEST_NAME='014_fs2M_dictionary'

# that scanario is not working properly, see https://github.com/yandex/ClickHouse/issues/1148#issuecomment-485731032


CHSTS_TEST_SUBTYPE3='single hit, all props'
CHSTS_CLICKHOUSE_QUERY="select dictGetFloat32('fs2M', 'value1', tuple( unhex('7FF893AE81A7F97C2A0DAE87749F53E3') ) ) as value1, dictGetFloat32('fs2M', 'value2', tuple( unhex('7FF893AE81A7F97C2A0DAE87749F53E3') ) )  as value2,dictGetFloat32('fs2M', 'value3', tuple( unhex('7FF893AE81A7F97C2A0DAE87749F53E3') ) )  as value3,dictGetFloat32('fs2M', 'value4', tuple( unhex('7FF893AE81A7F97C2A0DAE87749F53E3') ) )  as value4,dictGetFloat32('fs2M', 'str_value', tuple( unhex('7FF893AE81A7F97C2A0DAE87749F53E3') ) ) as  str_value"
source ../helpers/run_benchmark_in_docker.sh

CHSTS_TEST_SUBTYPE3='single miss'
CHSTS_CLICKHOUSE_QUERY="select dictGetFloat32('fs2M', 'value1', tuple( unhex('7FF893AE81A7F97C2A0DAE87749F53E4') ) )"
source ../helpers/run_benchmark_in_docker.sh


CHSTS_TEST_SUBTYPE3='single hit'
CHSTS_CLICKHOUSE_QUERY="select dictGetFloat32('fs2M', 'value1', tuple( unhex('7FF893AE81A7F97C2A0DAE87749F53E3') ) ) value1 WHERE id="
source ../helpers/run_benchmark_in_docker.sh

