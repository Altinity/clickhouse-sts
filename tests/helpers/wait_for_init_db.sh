echo "Waiting for init.db"

# 5 minutes
for ((retry=1; retry<=600; retry++))
do
   sleep 0.5
   if docker logs ch_sts_testserver 2>&1 | grep -A 2000 'running /docker-entrypoint-initdb.d' | grep 'Logging errors' -q
   then
      echo "ok"
      break
   fi
done

echo "Waiting for ports being opened"
docker exec -i ch_sts_testserver wget --spider --quiet --tries=120 --waitretry=1 --retry-connrefused "http://localhost:8123/ping"
