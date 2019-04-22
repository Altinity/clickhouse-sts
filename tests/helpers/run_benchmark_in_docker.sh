results_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../results" >/dev/null 2>&1 && pwd )"

## we will just pass all CHSTS_ prefixed vars inside docker
env_file=$(mktemp /tmp/XXXXXXXXX.env)

set | grep -E '^CHSTS_' > $env_file
# that will write values in a quoted way like FOO='BAR' (shell-comaptible) 
# while docker's env-file parameter expects to have it w/o any quotes
# so we'll just mount the env file inside docker image as bash environment
# and source it when needed

docker run -it --rm \
    --network=host \
    --ulimit nofile=262144:262144 \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    -v$env_file:/CHSTS.env \
    -v$results_dir:/results \
    clickhouse_sts \
    /scripts/run_benchmark_and_write_csv.sh

rm $env_file