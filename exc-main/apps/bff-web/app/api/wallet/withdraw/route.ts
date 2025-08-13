import { NextRequest, NextResponse } from 'next/server'
import { withdraw as walletWithdraw, type WithdrawRequest, type WithdrawResponse } from '@/src/services/wallet'

export async function POST(req: NextRequest) {
  const payload = (await req.json()) as WithdrawRequest
  const baseUrl = process.env.WALLET_BASE_URL || 'http://localhost:8088/api/wallet'
  const data = (await walletWithdraw(baseUrl, payload)) as WithdrawResponse
  return NextResponse.json(data, { status: 200 })
}


