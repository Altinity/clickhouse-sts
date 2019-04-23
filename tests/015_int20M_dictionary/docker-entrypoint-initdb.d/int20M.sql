DROP TABLE IF EXISTS default.int20M;

SET max_block_size=2097152;
SET max_insert_block_size=2097152;

CREATE TABLE default.int20M  Engine=MergeTree
ORDER BY (id)
PARTITION BY tuple()
SETTINGS index_granularity = 256
AS
SELECT
   cityHash64( number ) id,
   rand(1) / ( rand(2) + 1 ) AS value
FROM numbers(20000000);
