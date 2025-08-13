import path from 'node:path'
import { PactV3 } from '@pact-foundation/pact'
import { describe, it, beforeAll, afterAll, expect } from 'vitest'
import { withdraw } from '@/src/services/wallet'

describe('Wallet consumer pact - withdraw', () => {
  const provider = new PactV3({
    port: 8998,
    consumer: 'bff-web',
    provider: 'wallet-service',
    dir: path.resolve(process.cwd(), 'pacts'),
    logLevel: 'error',
  })

  it('withdraw accepted', async () => {
    provider
      .given('withdraw accepted')
      .uponReceiving('a valid withdraw request')
      .withRequest({
        method: 'POST',
        path: '/withdraw',
        headers: { 'content-type': 'application/json' },
        body: { userId: 'user_1', asset: 'BTC', amount: 0.01, address: 'bc1qabc' },
      })
      .willRespondWith({
        status: 200,
        headers: { 'content-type': 'application/json; charset=utf-8' },
        body: { status: 'accepted', requestId: 'req_w1' },
      })

    await provider.executeTest(async () => {
      const baseUrl = 'http://localhost:8998'
      const res = await withdraw(baseUrl, { userId: 'user_1', asset: 'BTC', amount: 0.01, address: 'bc1qabc' })
      expect(res.status).toBe('accepted')
    })
  })
})


