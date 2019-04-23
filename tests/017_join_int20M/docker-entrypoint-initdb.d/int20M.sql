DROP TABLE IF EXISTS default.int20M;

CREATE TABLE default.int20M
Engine=Join(ANY,LEFT,id) 
AS SELECT
   cityHash64( number ) id,
   rand(1) / ( rand(2) + 1 ) AS value
FROM numbers(20000000);
