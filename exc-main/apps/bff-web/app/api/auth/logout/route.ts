import { NextResponse } from 'next/server'
import { session } from '@/src/auth/session'

export async function POST() {
  const res = NextResponse.redirect(new URL('/', process.env.APP_BASE_URL || 'http://localhost:3000'))
  res.cookies.set(session.name, '', { httpOnly: true, maxAge: 0, path: '/' })
  res.cookies.set('pkce_verifier', '', { httpOnly: true, maxAge: 0, path: '/' })
  return res
}


