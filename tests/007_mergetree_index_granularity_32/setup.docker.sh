docker run --rm -d \
   --name ch_sts_testserver \
   --network=host \
   --volume=$(pwd)/conf.d:/etc/clickhouse-server/conf.d \
   --volume=$(pwd)/users.d:/etc/clickhouse-server/users.d \
   --volume=$(pwd)/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d \
   --ulimit nofile=262144:262144 \
   yandex/clickhouse-server


CHSTS_CLICKHOUSE_HTTP_BASE='http://127.0.0.1:8123/'
CHSTS_CLICKHOUSE_HOST='127.0.0.1'
CHSTS_CLICKHOUSE_PORT=9000
CHSTS_CLICKHOUSE_USER='default'

echo "Waiting for init.db"

# 5 minutes
for ((retry=1; retry<=1500; retry++))
do
   sleep 0.2
   if docker logs ch_sts_testserver 2>&1 | grep -A 200 'running /docker-entrypoint-initdb.d' | grep 'Logging errors' -q
   then
      echo "ok"
      break
   fi
done
