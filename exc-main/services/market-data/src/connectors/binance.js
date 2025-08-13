const WebSocket = require('ws')

function startBinanceTradeStream({ symbol = 'btcusdt', onTrade }) {
  const streamUrl = `wss://stream.binance.com:9443/ws/${symbol}@trade`
  const ws = new WebSocket(streamUrl)

  ws.on('open', () => {
    // connected
  })
  ws.on('message', (data) => {
    try {
      const msg = JSON.parse(data.toString())
      // Binance trade message has fields p (price), q (qty), T (trade time)
      const price = parseFloat(msg.p)
      const qty = parseFloat(msg.q)
      const ts = msg.T || Date.now()
      if (onTrade && Number.isFinite(price) && Number.isFinite(qty)) {
        onTrade({ price, qty, ts })
      }
    } catch {}
  })
  ws.on('close', () => {
    // Reconnect after short delay
    setTimeout(() => startBinanceTradeStream({ symbol, onTrade }), 2000)
  })
  ws.on('error', () => ws.close())
}

module.exports = { startBinanceTradeStream }


