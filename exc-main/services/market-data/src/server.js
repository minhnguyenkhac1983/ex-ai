const http = require('http')
const WebSocket = require('ws')
const { startBinanceTradeStream } = require('./connectors/binance')
const { createKafkaProducer } = require('./connectors/redpanda')

const client = require('prom-client')
const registry = new client.Registry()
const tickCounter = new client.Counter({ name: 'md_ticks_total', help: 'Total ticks broadcasted' })
registry.registerMetric(tickCounter)

const server = http.createServer(async (req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, { 'content-type': 'application/json' })
    return res.end(JSON.stringify({ status: 'ok' }))
  }
  if (req.url === '/metrics') {
    res.setHeader('Content-Type', registry.contentType)
    return res.end(await registry.metrics())
  }
  res.writeHead(404); res.end()
})

const wss = new WebSocket.Server({ server, path: '/ws' })
let kafka
wss.on('connection', (ws) => {
  ws.send(JSON.stringify({ type: 'welcome' }))
})

setInterval(() => {
  const msg = JSON.stringify({ type: 'tick', ts: Date.now(), price: 10000 + Math.random() * 100 })
  wss.clients.forEach((c) => c.readyState === WebSocket.OPEN && c.send(msg))
  tickCounter.inc()
}, 1000)

server.listen(8080, '0.0.0.0', () => console.log('market-data listening on :8080'))

// Optional: stream real trades from Binance and re-broadcast as ticks
if (process.env.MD_BINANCE_ENABLE === '1') {
  startBinanceTradeStream({
    symbol: process.env.MD_BINANCE_SYMBOL || 'btcusdt',
    onTrade: ({ price, qty, ts }) => {
      const msgObj = { type: 'tick', ts, price, qty, src: 'binance' }
      const msg = JSON.stringify(msgObj)
      wss.clients.forEach((c) => c.readyState === WebSocket.OPEN && c.send(msg))
      if (kafka) { kafka.publish(process.env.MD_KAFKA_TOPIC || 'md.ticks', msgObj).catch(() => {}) }
      tickCounter.inc()
    }
  })
}

// Optional: publish to Redpanda/Kafka if brokers are set
(async () => {
  const brokers = (process.env.MD_KAFKA_BROKERS || '').split(',').map(s => s.trim()).filter(Boolean)
  if (brokers.length > 0) {
    kafka = createKafkaProducer({ brokers })
    try { await kafka.start() } catch { kafka = null }
  }
})()


