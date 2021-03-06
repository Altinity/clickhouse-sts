#!/usr/bin/env bash

## simple clickhouse-benchmark wrapper (translate env vars to command line arguments)  
## allows to control everything via env (nice for docker/k8)

CHSTS_CLICKHOUSE_HOST=${CHSTS_CLICKHOUSE_HOST:-localhost}
CHSTS_CLICKHOUSE_PORT=${CHSTS_CLICKHOUSE_PORT:-9000}
CHSTS_CLICKHOUSE_USER=${CHSTS_CLICKHOUSE_USER:-default}

#CHSTS_CLICKHOUSE_PASSWORD
#CHSTS_CLICKHOUSE_DATABASE
#CHSTS_CLICKHOUSE_SECURE

CHSTS_CLICKHOUSE_QUERY=${CHSTS_CLICKHOUSE_QUERY:-'SELECT 1'}

#CHSTS_OUTPUT_JSON
CHSTS_TEST_CONCURRENCY=${CHSTS_TEST_CONCURRENCY:-8}
CHSTS_TEST_DURATION=${CHSTS_TEST_DURATION:-5}

CLICKHOUSE_BENCHMARK_ARGUMENTS=(
  "--host=$CHSTS_CLICKHOUSE_HOST"
  "--delay=0"
  "--port=$CHSTS_CLICKHOUSE_PORT"
  "--user=$CHSTS_CLICKHOUSE_USER"
  "--concurrency=$CHSTS_TEST_CONCURRENCY"
  "--timelimit=$CHSTS_TEST_DURATION"
)

if [ ! -z $CHSTS_CLICKHOUSE_PASSWORD ]; then 
  CLICKHOUSE_BENCHMARK_ARGUMENTS+=("--password=${CHSTS_CLICKHOUSE_PASSWORD}")
fi 

if [ ! -z $CHSTS_CLICKHOUSE_DATABASE ]; then 
  CLICKHOUSE_BENCHMARK_ARGUMENTS+=("--database=${CHSTS_CLICKHOUSE_DATABASE}")
fi 

if [ ! -z $CHSTS_CLICKHOUSE_SECURE ]; then 
  CLICKHOUSE_BENCHMARK_ARGUMENTS+=("--secure")
fi 

if [ ! -z $CHSTS_OUTPUT_JSON ]; then
  CLICKHOUSE_BENCHMARK_ARGUMENTS+=("--json=${CHSTS_OUTPUT_JSON}")
fi

echo ${CLICKHOUSE_BENCHMARK_ARGUMENTS[*]}

echo "$CHSTS_CLICKHOUSE_QUERY" | clickhouse-benchmark ${CLICKHOUSE_BENCHMARK_ARGUMENTS[*]} 
