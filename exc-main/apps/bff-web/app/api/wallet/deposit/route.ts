import { NextRequest, NextResponse } from 'next/server'
import { deposit as walletDeposit, type DepositRequest, type DepositResponse } from '@/src/services/wallet'

export async function POST(req: NextRequest) {
  const payload = (await req.json()) as DepositRequest
  const baseUrl = process.env.WALLET_BASE_URL || 'http://localhost:8088/api/wallet'
  const data = (await walletDeposit(baseUrl, payload)) as DepositResponse
  return NextResponse.json(data, { status: 200 })
}


