# clickhouse-sts

ClickHouse stress tests suite.

Use that benchmark to estimate maximum QPS & latencies of ClickHouse in high-concurrency scanarios - both via HTTP & native protocols.

# How to use that?

You will need:
* docker
* make
* bash

After that just run:

```bash
make test
```

it will create a docker image containing needed tools (wrk, jq, clickhouse-benchmark and control scripts),
and after that run test suite.
