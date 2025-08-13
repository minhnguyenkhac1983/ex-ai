import ws from 'k6/ws'
import { check, sleep } from 'k6'

export default function () {
  const url = __ENV.WS_URL || 'ws://localhost:8080/ws'
  const res = ws.connect(url, {}, function (socket) {
    socket.on('message', function (msg) { /* no-op */ })
    socket.setTimeout(function () { socket.close() }, 5000)
  })
  check(res, { 'status is 101': (r) => r && r.status === 101 })
  sleep(1)
}


