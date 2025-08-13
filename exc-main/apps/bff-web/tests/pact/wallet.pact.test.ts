import path from 'node:path'
import { PactV3 } from '@pact-foundation/pact'
import { describe, it, beforeAll, afterAll, expect } from 'vitest'
import { deposit } from '@/src/services/wallet'

describe('Wallet consumer pact', () => {
  const provider = new PactV3({
    port: 8999,
    consumer: 'bff-web',
    provider: 'wallet-service',
    dir: path.resolve(process.cwd(), 'pacts'),
    logLevel: 'error',
  })

  it('deposit accepted', async () => {
    provider
      .given('deposit accepted')
      .uponReceiving('a valid deposit request')
      .withRequest({
        method: 'POST',
        path: '/deposit',
        headers: { 'content-type': 'application/json' },
        body: { userId: 'user_1', asset: 'USDT', amount: 10 },
      })
      .willRespondWith({
        status: 200,
        headers: { 'content-type': 'application/json; charset=utf-8' },
        body: { status: 'accepted', requestId: 'req_1' },
      })

    await provider.executeTest(async () => {
      const baseUrl = 'http://localhost:8999'
      const res = await deposit(baseUrl, { userId: 'user_1', asset: 'USDT', amount: 10 })
      expect(res.status).toBe('accepted')
    })
  })
})


