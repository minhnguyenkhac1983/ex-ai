-- Materialize example: create Kafka source and 1m candles view
CREATE CONNECTION IF NOT EXISTS redpanda_conn TO KAFKA (
  BROKER 'redpanda:9092',
  SECURITY PROTOCOL 'PLAINTEXT'
);

DROP MATERIALIZED VIEW IF EXISTS candles_1m;
DROP VIEW IF EXISTS md_ticks;
DROP SOURCE IF EXISTS md_ticks_raw;

CREATE SOURCE IF NOT EXISTS md_ticks_json
  FROM KAFKA CONNECTION redpanda_conn (TOPIC 'md.ticks.clean')
  FORMAT JSON
  ENVELOPE NONE;

CREATE VIEW md_ticks AS
  SELECT 
    (data->>'ts')::timestamp AS ts,
    (data->>'price')::double precision AS price,
    (data->>'qty')::double precision AS qty,
    (data->>'src')::text AS src
  FROM md_ticks_json
  WHERE data IS NOT NULL;

CREATE MATERIALIZED VIEW candles_1m AS
SELECT
  date_trunc('minute', ts) AS window_start,
  min(price) AS low,
  max(price) AS high,
  sum(coalesce(qty,0)) AS volume
FROM md_ticks
GROUP BY 1;


