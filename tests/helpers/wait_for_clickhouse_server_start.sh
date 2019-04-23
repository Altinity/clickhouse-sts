echo "Waiting for clickhouse-server start"

docker exec -i ch_sts_testserver wget --spider --quiet --tries=120 --waitretry=1 --retry-connrefused "http://localhost:8123/ping"
