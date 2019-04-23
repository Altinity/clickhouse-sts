DROP TABLE IF EXISTS default.fs2M;

SET max_block_size=1048576;
SET max_insert_block_size=1048576;

-- fs12M is too big 

CREATE TABLE default.fs2M
ENGINE = MergeTree
PARTITION BY tuple()
ORDER BY id
SETTINGS index_granularity = 256 AS
SELECT
    murmurHash3_128(reinterpretAsString(number)) AS id,
    rand(1) / (rand(2) + 1) AS value1,
    toFloat64(rand(3) / (rand(4) + 1)) AS value2,
    rand(5) AS value3,
    rand64(6) AS value4,
    base64Encode(concat(reinterpretAsString(rand64(7)), reinterpretAsString(rand64(8)), toString(generateUUIDv4()))) AS str_value
FROM numbers(2000000);
