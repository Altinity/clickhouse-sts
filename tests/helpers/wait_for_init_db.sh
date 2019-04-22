echo "Waiting for init.db"

# 5 minutes
for ((retry=1; retry<=150; retry++))
do
   sleep 0.5
   if docker logs ch_sts_testserver 2>&1 | grep -A 200 'running /docker-entrypoint-initdb.d' | grep 'Logging errors' -q
   then
      echo "ok"
      break
   fi
done
