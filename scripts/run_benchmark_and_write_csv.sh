#!/usr/bin/env bash

# get the environment passed from control script running on host 
if [ -f /CHSTS.env ]; then 
    source /CHSTS.env
fi

CHSTS_CLICKHOUSE_SERVER_VERSION="$(source /scripts/run_query.sh 'SELECT version()')"

if [ -z $CHSTS_TARGET_CSV_FILENAME ] ; then
    CHSTS_TARGET_CSV_FILENAME=$(date +%Y%m%d%H%M%S)_results.csv
    echo No target file provided. Results will be written to $CHSTS_TARGET_CSV_FILENAME 
fi

TARGET_CSV_FILENAME_FULL="/results/${CHSTS_TARGET_CSV_FILENAME}"

CHSTS_CONCURRENCY_LEVELS=${CHSTS_CONCURRENCY_LEVELS:-'1 4 8 16 32 64 128 256 512 768 1024'}
CHSTS_SLEEP_AFTER_TEST=${CHSTS_SLEEP_AFTER_TEST:-0.2}
CHSTS_VERBOSE=${CHSTS_VERBOSE:-0}

CHSTS_CLICKHOUSE_CLIENT_VERSION="$(clickhouse-client --version-clean)"
CHSTS_WRK_VERSION="$(wrk --version | head -n 1 | cut -d' ' -f1,2)"

# write csv header is file not exists
if [ ! -f $TARGET_CSV_FILENAME_FULL ]; then
    echo 'server_version,client_version,test_name,test_subtype1,test_subtype2,test_subtype3,protocol,http_keepalive,concurrency,QPS,num_queries,MiBPS_result,latency_0percentile,latency_20percentile,latency_50percentile,latency_80percentile,latency_90percentile,latency_95percentile,latency_99percentile,latency_999percentile,duration,errors' > $TARGET_CSV_FILENAME_FULL
fi

for CHSTS_TEST_CONCURRENCY in $CHSTS_CONCURRENCY_LEVELS; do 
    export CHSTS_OUTPUT_JSON=$(mktemp /results/XXXXXXXXX.json)

    echo "Running $CHSTS_TEST_NAME ($CHSTS_TEST_SUBTYPE1;$CHSTS_TEST_SUBTYPE2;$CHSTS_TEST_SUBTYPE3;$CHSTS_TEST_CONCURRENCY;$CHSTS_TEST_PROTOCOL;$CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE) for $CHSTS_TEST_DURATION sec."

    if [ "$CHSTS_TEST_PROTOCOL" = "http" ]; then
        reported_client_version="$CHSTS_WRK_VERSION"
        if [ "$CHSTS_VERBOSE" -eq 1 ]; then 
            source /scripts/run_http_benchmark.sh
        else
            source /scripts/run_http_benchmark.sh &> /dev/null 
        fi
    else 
        # in my tests clickhouse-benchmark can't work with high-concurrency (probably too many threads) 
        if [ "$CHSTS_TEST_CONCURRENCY" -ge 2100 ]; then
            continue;
        fi 

        reported_client_version="$CHSTS_CLICKHOUSE_CLIENT_VERSION"
        if [ "$CHSTS_VERBOSE" -eq 1 ]; then 
            source /scripts/run_clickhouse_benchmark.sh
        else
            source /scripts/run_clickhouse_benchmark.sh &> /dev/null 
        fi
    fi

    cat $CHSTS_OUTPUT_JSON | jq \
        --arg test_name "$CHSTS_TEST_NAME" \
        --arg server_version "$CHSTS_CLICKHOUSE_SERVER_VERSION" \
        --arg client_version "$reported_client_version" \
        --arg test_subtype1 "$CHSTS_TEST_SUBTYPE1" \
        --arg test_subtype2 "$CHSTS_TEST_SUBTYPE2" \
        --arg test_subtype3 "$CHSTS_TEST_SUBTYPE3" \
        --arg protocol "$CHSTS_TEST_PROTOCOL" \
        --arg http_keepalive "$CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE" \
        --arg concurrency $CHSTS_TEST_CONCURRENCY  \
        -r '[$server_version,$client_version,$test_name,$test_subtype1,$test_subtype2,$test_subtype3,$protocol,$http_keepalive,$concurrency,.statistics.QPS,.statistics.num_queries,.statistics.MiBPS_result,.query_time_percentiles."0",.query_time_percentiles."20",.query_time_percentiles."50", .query_time_percentiles."80",.query_time_percentiles."90",.query_time_percentiles."95",.query_time_percentiles."99",.query_time_percentiles."99.9",.summary.duration,.summary.errors] | @csv' \
         >> $TARGET_CSV_FILENAME_FULL 

    rm $CHSTS_OUTPUT_JSON

    sleep $CHSTS_SLEEP_AFTER_TEST
done
