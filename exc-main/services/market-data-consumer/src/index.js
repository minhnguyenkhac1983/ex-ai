import { Kafka } from 'kafkajs'
import { createClient } from '@clickhouse/client'
import http from 'http'
import client from 'prom-client'

const brokers = (process.env.MD_KAFKA_BROKERS || 'redpanda:9092').split(',').map(s => s.trim()).filter(Boolean)
const topic = process.env.MD_KAFKA_TOPIC || 'md.ticks'

const ch = createClient({
  host: process.env.CH_HOST || 'http://clickhouse:8123',
  username: process.env.CH_USER || 'default',
  password: process.env.CH_PASSWORD || ''
})

async function ensureTable() {
  await ch.query({
    query: `CREATE TABLE IF NOT EXISTS md_ticks (
      ts DateTime64(3) CODEC(Delta, ZSTD),
      price Float64 CODEC(ZSTD),
      qty Float64 CODEC(ZSTD),
      src LowCardinality(String) CODEC(ZSTD)
    ) ENGINE = MergeTree ORDER BY ts`,
    format: 'JSONEachRow'
  })
}

async function run() {
  // Metrics
  const registry = new client.Registry()
  const rowsTotal = new client.Counter({ name: 'md_consumer_rows_total', help: 'rows inserted into ClickHouse' })
  const errorsTotal = new client.Counter({ name: 'md_consumer_errors_total', help: 'errors during consume/insert' })
  registry.registerMetric(rowsTotal)
  registry.registerMetric(errorsTotal)
  client.collectDefaultMetrics({ register: registry })

  // Expose /metrics
  const metricsServer = http.createServer(async (req, res) => {
    if (req.url === '/metrics') {
      res.writeHead(200, { 'content-type': registry.contentType })
      res.end(await registry.metrics())
    } else if (req.url === '/health') {
      res.writeHead(200, { 'content-type': 'application/json' })
      res.end(JSON.stringify({ status: 'ok' }))
    } else {
      res.writeHead(404); res.end()
    }
  })
  metricsServer.listen(9100, '0.0.0.0')
  console.log(`[md-consumer] metrics listening on 0.0.0.0:9100`)
  console.log(`[md-consumer] brokers: ${brokers.join(', ')}, topic: ${topic}`)

  await ensureTable()
  const kafka = new Kafka({ clientId: 'md-consumer', brokers })
  const consumer = kafka.consumer({ groupId: 'md-consumer-g1' })
  await consumer.connect()
  await consumer.subscribe({ topic, fromBeginning: false })
  await consumer.run({
    eachMessage: async ({ message }) => {
      try {
        const obj = JSON.parse(message.value.toString())
        if (!obj || typeof obj.price !== 'number') return
        await ch.insert({
          table: 'md_ticks',
          values: [{ ts: new Date(obj.ts || Date.now()).toISOString(), price: obj.price, qty: obj.qty || 0, src: obj.src || 'unknown' }],
          format: 'JSONEachRow'
        })
        rowsTotal.inc()
      } catch (e) { errorsTotal.inc() }
    }
  })
}

run().catch((e) => { console.error('[md-consumer] fatal', e) })


