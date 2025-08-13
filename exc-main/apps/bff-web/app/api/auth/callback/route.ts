import { NextRequest, NextResponse } from 'next/server'
import { oidcConfig } from '@/src/auth/oidc'
import { cookies } from 'next/headers'
import { createSessionCookie } from '@/src/auth/session'

export async function GET(req: NextRequest) {
  const url = new URL(req.url)
  const code = url.searchParams.get('code')
  // const state = url.searchParams.get('state')
  if (!code) return NextResponse.json({ error: 'missing code' }, { status: 400 })
  try {
    const cv = cookies().get('pkce_verifier')?.value
    const tokenRes = await fetch(`${oidcConfig.issuer}/protocol/openid-connect/token`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        grant_type: 'authorization_code',
        code,
        redirect_uri: oidcConfig.redirectUri,
        client_id: oidcConfig.clientId,
        code_verifier: cv || '',
      }),
    })
    const tokens = await tokenRes.json()
    if (!tokenRes.ok) {
      return NextResponse.json({ error: 'oidc token exchange failed', details: tokens }, { status: 500 })
    }
    const sess = createSessionCookie(tokens)
    const res = NextResponse.redirect(new URL('/', req.url))
    res.cookies.set(sess.name, sess.value, { httpOnly: true, secure: false, sameSite: 'lax', maxAge: sess.maxAge, path: '/' })
    return res
  } catch (e) {
    return NextResponse.json({ error: 'oidc exchange failed' }, { status: 500 })
  }
}


