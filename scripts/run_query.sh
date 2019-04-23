#!/usr/bin/env bash

# get the environment passed from control script running on host 
if [ -f /CHSTS.env ]; then 
    source /CHSTS.env
fi

CLICKHOUSE_CLIENT_ARGUMENTS=(
  "--host=${CHSTS_CLICKHOUSE_HOST:-localhost}"
  "--port=${CHSTS_CLICKHOUSE_PORT:-9000}"
  "--user=${CHSTS_CLICKHOUSE_USER:-default}"
  "-m"
  "-n"
)

if [ ! -z $CHSTS_CLICKHOUSE_PASSWORD ]; then 
  CLICKHOUSE_CLIENT_ARGUMENTS+=("--password=${CHSTS_CLICKHOUSE_PASSWORD}")
fi 

if [ ! -z $CHSTS_CLICKHOUSE_DATABASE ]; then 
  CLICKHOUSE_CLIENT_ARGUMENTS+=("--database=${CHSTS_CLICKHOUSE_DATABASE}")
fi 

if [ ! -z $CHSTS_CLICKHOUSE_SECURE ]; then 
  CLICKHOUSE_CLIENT_ARGUMENTS+=("--secure")
fi 

# echo ${CLICKHOUSE_CLIENT_ARGUMENTS[*]}

temp_out_file=$(mktemp /results/XXXXXXXXX.out)

echo "${1:-${CHSTS_CLICKHOUSE_QUERY:-'SELECT 0'}}" | clickhouse-client ${CLICKHOUSE_CLIENT_ARGUMENTS[*]} > $temp_out_file

if [ -z $CHSTS_TARGET_FILENAME ] ; then
    cat $temp_out_file
    rm $temp_out_file
else
    mv $temp_out_file /results/$CHSTS_TARGET_FILENAME
fi

