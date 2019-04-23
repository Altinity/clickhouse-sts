#!/usr/bin/env bash

## simple wrapper for wrk (http benchmark utility), allows to control everything via env (nice for docker/k8)
## creates clickhouse requests & collect results in clickhouse-benchmark compatible json  

CHSTS_CLICKHOUSE_HTTP_BASE=${CHSTS_CLICKHOUSE_HTTP_BASE:-http://127.0.0.1:8123/}
# CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE
# CHSTS_CLICKHOUSE_QUERY

# CHSTS_WRK_TIMEOUT
# CHSTS_OUTPUT_JSON 
# CHSTS_WRK_THREADS

CHSTS_TEST_CONCURRENCY=${CHSTS_TEST_CONCURRENCY:-8}
CHSTS_TEST_DURATION=${CHSTS_TEST_DURATION:-5}

if [ -z $CHSTS_WRK_THREADS ]; then
  if (( $CHSTS_TEST_CONCURRENCY <= 8 )); then 
     CHSTS_WRK_THREADS=$CHSTS_TEST_CONCURRENCY
  else
     CHSTS_WRK_THREADS=8
  fi
fi

if [ -z "$CHSTS_CLICKHOUSE_QUERY" ]; then
  CHSTS_CLICKHOUSE_URL=$CHSTS_CLICKHOUSE_HTTP_BASE
else
  URL_ENCODED_QUERY=$(printf '%s' "$CHSTS_CLICKHOUSE_QUERY" | jq -sRr @uri)
  # jq leaves single quotes, which brake the bash parameters passing
  URL_ENCODED_QUERY=${URL_ENCODED_QUERY//\'/%27}
  CHSTS_CLICKHOUSE_URL=$(printf "%s?query=%s" "$CHSTS_CLICKHOUSE_HTTP_BASE" "$URL_ENCODED_QUERY")
fi

WRK_ARGUMENTS=(
  "-t $CHSTS_WRK_THREADS"
  "-c $CHSTS_TEST_CONCURRENCY"
  "-d $CHSTS_TEST_DURATION"
  "--timeout ${CHSTS_WRK_TIMEOUT:-30}"
  "--latency"
  "-s /scripts/report.lua"
  "'$CHSTS_CLICKHOUSE_URL'"
)

if [ "$CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE" -eq "0" ]; then 
  WRK_ARGUMENTS+=("-H 'Connection: Close'")
fi 

echo ${WRK_ARGUMENTS[*]}
bash -c "wrk ${WRK_ARGUMENTS[*]}"