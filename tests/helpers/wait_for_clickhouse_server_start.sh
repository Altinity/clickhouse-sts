# TODO: more intelligent way to check.
echo "Waiting for clickhouse-server start"

# 5 minutes
for ((retry=1; retry<=600; retry++))
do
   sleep 0.5
   if docker logs ch_sts_testserver 2>&1 | grep 'Logging errors' -q
   then
      echo "ok"
      break
   fi
done

sleep 1