-- RisingWave example: create source from Kafka/Redpanda and aggregate 1m candles
CREATE SOURCE IF NOT EXISTS md_ticks (
  ts TIMESTAMP,
  price DOUBLE PRECISION,
  qty DOUBLE PRECISION,
  src TEXT
)
WITH (
  connector = 'kafka',
  topic = 'md.ticks',
  properties.bootstrap.server = 'redpanda:9092',
  scan.startup.mode = 'latest'
) FORMAT PLAIN ENCODE JSON;

-- Simpler minute bucketing compatible with broader RW versions
CREATE MATERIALIZED VIEW IF NOT EXISTS candles_1m AS
SELECT
  date_trunc('minute', ts) AS window_start,
  MIN(price) AS low,
  MAX(price) AS high,
  AVG(price) AS close,
  SUM(COALESCE(qty, 0)) AS volume
FROM md_ticks
GROUP BY 1;


