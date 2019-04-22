DROP TABLE IF EXISTS default.int20M;

SET max_block_size=2097152;
SET max_insert_block_size=2097152;

CREATE TABLE default.int20M  Engine=MergeTree
ORDER BY (id)
PARTITION BY tuple()
SETTINGS index_granularity = 128
AS
SELECT
   cityHash64( number ) id,
   rand(1) / ( rand(2) + 1 ) AS value
FROM numbers(20000000);

-- Looks stupid, but final is too expensive, and we can have max 10 parts
-- OPTIMIZE do nothing if everything is already merged (final remerge everything each time).
OPTIMIZE TABLE default.int20M;
OPTIMIZE TABLE default.int20M;
OPTIMIZE TABLE default.int20M;
OPTIMIZE TABLE default.int20M;
OPTIMIZE TABLE default.int20M;
OPTIMIZE TABLE default.int20M;
OPTIMIZE TABLE default.int20M;
OPTIMIZE TABLE default.int20M;
OPTIMIZE TABLE default.int20M;
OPTIMIZE TABLE default.int20M;
