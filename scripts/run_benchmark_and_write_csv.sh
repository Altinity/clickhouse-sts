#!/usr/bin/env bash

# get the environment passed from control script running on host 
if [ -f /CHSTS.env ]; then 
    source /CHSTS.env
fi

if [ -z $CHSTS_TARGET_CSV_FILENAME ] ; then
    CHSTS_TARGET_CSV_FILENAME=$(date +%Y%m%d%H%M%S)_results.csv
    echo No target file provided. Results will be written to $CHSTS_TARGET_CSV_FILENAME 
fi

CHSTS_CONCURRENCY_LEVELS=${CHSTS_CONCURRENCY_LEVELS:='1 4 8 16 32 64 128 256 512 768 1024'}
CHSTS_SLEEP_AFTER_TEST=${CHSTS_SLEEP_AFTER_TEST:=0.2}
CHSTS_VERBOSE=${CHSTS_VERBOSE:=0}

TARGET_CSV_FILENAME_FULL="/results/${CHSTS_TARGET_CSV_FILENAME}"

# write csv header is file not exists
if [ ! -f $TARGET_CSV_FILENAME_FULL ]; then
    echo 'test_name,test_subtype1,test_subtype2,test_subtype3,protocol,http_keepalive,concurrency,QPS,num_queries,MiBPS_result,latency_0percentile,latency_20percentile,latency_50percentile,latency_80percentile,latency_90percentile,latency_95percentile,latency_99percentile,latency_999percentile' > $TARGET_CSV_FILENAME_FULL
fi

for CHSTS_TEST_CONCURRENCY in $CHSTS_CONCURRENCY_LEVELS; do 
    export CHSTS_OUTPUT_JSON=$(mktemp /results/XXXXXXXXX.json)

    echo "Running $CHSTS_TEST_NAME ($CHSTS_TEST_SUBTYPE1;$CHSTS_TEST_SUBTYPE2;$CHSTS_TEST_SUBTYPE3;$CHSTS_TEST_CONCURRENCY;$CHSTS_TEST_PROTOCOL;$CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE) for $CHSTS_TEST_DURATION sec."

    if [ "$CHSTS_TEST_PROTOCOL" = "http" ]; then
        if [ "$CHSTS_VERBOSE" -eq 1 ]; then 
            source /scripts/run_http_benchmark.sh
        else
            source /scripts/run_http_benchmark.sh &> /dev/null 
        fi
    else 
        if [ "$CHSTS_VERBOSE" -eq 1 ]; then 
            source /scripts/run_clickhouse_benchmark.sh
        else
            source /scripts/run_clickhouse_benchmark.sh &> /dev/null 
        fi
    fi

    cat $CHSTS_OUTPUT_JSON | jq --arg test_name "$CHSTS_TEST_NAME" --arg test_subtype1 "$CHSTS_TEST_SUBTYPE1" --arg test_subtype2 "$CHSTS_TEST_SUBTYPE2" --arg test_subtype3 "$CHSTS_TEST_SUBTYPE3"  --arg protocol "$CHSTS_TEST_PROTOCOL"  --arg http_keepalive "$CHSTS_CLICKHOUSE_HTTP_USE_KEEPALIVE" --arg concurrency $CHSTS_TEST_CONCURRENCY  -r '[$test_name,$test_subtype1,$test_subtype2,$test_subtype3,$protocol,$http_keepalive,$concurrency,.statistics.QPS,.statistics.num_queries,.statistics.MiBPS_result,.query_time_percentiles."0",.query_time_percentiles."20",.query_time_percentiles."50", .query_time_percentiles."80",.query_time_percentiles."90",.query_time_percentiles."95",.query_time_percentiles."99",.query_time_percentiles."99.9"] | @csv' >> $TARGET_CSV_FILENAME_FULL 

    rm $CHSTS_OUTPUT_JSON

    sleep $CHSTS_SLEEP_AFTER_TEST
done
