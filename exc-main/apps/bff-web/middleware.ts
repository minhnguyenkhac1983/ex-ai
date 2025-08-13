import { NextRequest, NextResponse } from 'next/server'
import { verifySession, session } from '@/src/auth/session'

const PUBLIC_PATHS = [
  '/', '/login', '/api/health', '/api/auth/login', '/api/auth/callback'
]

export function middleware(req: NextRequest) {
  const { pathname } = new URL(req.url)
  if (PUBLIC_PATHS.some(p => pathname.startsWith(p))) {
    return NextResponse.next()
  }
  const cookie = req.cookies.get(session.name)?.value
  const { valid } = verifySession(cookie)
  if (!valid) {
    const loginUrl = new URL('/api/auth/login', req.url)
    return NextResponse.redirect(loginUrl)
  }
  return NextResponse.next()
}

export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico).*)'],
}


