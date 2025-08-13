import http from 'k6/http'
import { check, sleep } from 'k6'

export const options = {
  vus: 10,
  duration: '30s',
}

export default function () {
  const base = __ENV.GW_BASE || 'http://localhost:8088'
  const res = http.get(`${base}/api/wallet/health`)
  check(res, { 'status is 200': (r) => r.status === 200 })
  sleep(0.5)
  const d = http.post(`${base}/api/wallet/deposit`, null, { headers: { 'Content-Type': 'application/json' } })
  check(d, { 'deposit 200': (r) => r.status === 200 })
}


