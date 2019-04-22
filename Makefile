image:
	docker build --network=host -t clickhouse_sts .

test:: image
	tests/run.sh --all
