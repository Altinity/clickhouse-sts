#!/usr/bin/env bash

if [ -z $CHSTS_TARGET_CSV_FILENAME ] ; then
    export CHSTS_TARGET_CSV_FILENAME=$(date +%Y%m%d%H%M%S)_results.csv
    echo Results will be written to $CHSTS_TARGET_CSV_FILENAME 
fi

CHSTS_CONCURRENCY_LEVELS=${CHSTS_CONCURRENCY_LEVELS:-'1 4 8 16 32 64 128 256 512 768 1024 1536 2048 3072 4096'}
#CHSTS_CONCURRENCY_LEVELS=${CHSTS_CONCURRENCY_LEVELS:-'16'}

CHSTS_VERBOSE=${CHSTS_VERBOSE:-0}
CHSTS_TEST_DURATION=${CHSTS_TEST_DURATION:-10}

CHSTS_TEST_ENVIRONMENT=${CHSTS_TEST_ENVIRONMENT:-docker} # as some tests need to setup environment,
                          # environment setup/teardown in each test case. 
                          # so you can just create another ways to set it up

if [ "$1" = "--all" ]; then
    tests_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    for dir in ${tests_dir}/*/; do
        dir=${dir%*/} 
        dirname=${dir##*/} # basename 
        if [ "$dirname" = "helpers" ]; then
            continue
        fi  
        bash -c "${tests_dir}/run.sh '$dir'" 
    done
elif [ -n "$1" ] && [ -d "$1" ]; then 
    CHSTS_TEST_PATH=$1
    cd $CHSTS_TEST_PATH
    CHSTS_TEST_NAME=$(basename $CHSTS_TEST_PATH)

    if [ ! -f run.sh ]; then
        echo "run.sh is absent in $CHSTS_TEST_PATH test directory!"
        exit 1
    fi 

    if [ -z $CHSTS_TEST_ENVIRONMENT ]; then 
        echo "Test environment is not defined. Please ensure that you setup environment for $CHSTS_TEST_PATH test!"
        read -p "Press enter to continue, or Ctrl+C to break"
    elif [ ! -f setup.${CHSTS_TEST_ENVIRONMENT}.sh ]; then
        echo "Setup file is absent for test environment ${CHSTS_TEST_ENVIRONMENT}. Please ensure that you setup environment for $CHSTS_TEST_PATH test and ${CHSTS_TEST_ENVIRONMENT}!"
        read -p "Press enter to continue, or Ctrl+C to break"
    else
        source setup.${CHSTS_TEST_ENVIRONMENT}.sh
    fi

    source run.sh

    if [ -z $CHSTS_TEST_ENVIRONMENT ]; then 
        echo "Test environment is not defined. Please ensure that you teardown environment for $CHSTS_TEST_PATH test!"
        read -p "Press enter to continue, or Ctrl+C to break"
    elif [ ! -f teardown.${CHSTS_TEST_ENVIRONMENT}.sh ]; then
        echo "Setup file is absent for test environment ${CHSTS_TEST_ENVIRONMENT}. Please ensure that you setup environment for $CHSTS_TEST_PATH test and ${CHSTS_TEST_ENVIRONMENT}!"
        read -p "Press enter to continue, or Ctrl+C to break"
    else
        source teardown.${CHSTS_TEST_ENVIRONMENT}.sh
    fi

else 
    echo 'Usage: ./run.sh --all   # to run all tests'
    echo '       ./run.sh folder  # to run single test'
    echo 'By default results will be written to ../results/YYYYMMDDHHMMSS_results.csv.'
    exit 1
fi
