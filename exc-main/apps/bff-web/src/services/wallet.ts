import type { paths } from '@/src/contracts/wallet'

export type DepositRequest = paths['/deposit']['post']['requestBody']['content']['application/json']
export type DepositResponse = paths['/deposit']['post']['responses']['200']['content']['application/json']
export type WithdrawRequest = paths['/withdraw']['post']['requestBody']['content']['application/json']
export type WithdrawResponse = paths['/withdraw']['post']['responses']['200']['content']['application/json']

export async function deposit(baseUrl: string, payload: DepositRequest): Promise<DepositResponse> {
  const res = await fetch(`${baseUrl}/deposit`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify(payload),
  })
  if (!res.ok) throw new Error(`deposit failed: ${res.status}`)
  return (await res.json()) as DepositResponse
}

export async function withdraw(baseUrl: string, payload: WithdrawRequest): Promise<WithdrawResponse> {
  const res = await fetch(`${baseUrl}/withdraw`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify(payload),
  })
  if (!res.ok) throw new Error(`withdraw failed: ${res.status}`)
  return (await res.json()) as WithdrawResponse
}


