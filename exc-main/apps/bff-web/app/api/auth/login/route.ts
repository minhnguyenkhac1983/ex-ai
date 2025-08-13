import { NextResponse } from 'next/server'
import { oidcConfig } from '@/src/auth/oidc'
import { generateCodeVerifierAndChallenge } from '@/src/auth/pkce'

export async function GET() {
  const { verifier, challenge } = await generateCodeVerifierAndChallenge()
  const authUrl = `${oidcConfig.issuer}/protocol/openid-connect/auth?` +
    new URLSearchParams({
      response_type: 'code',
      client_id: oidcConfig.clientId,
      redirect_uri: oidcConfig.redirectUri,
      scope: 'openid profile email',
      code_challenge_method: 'S256',
      code_challenge: challenge,
    }).toString()
  const res = NextResponse.redirect(authUrl)
  res.cookies.set('pkce_verifier', verifier, { httpOnly: true, sameSite: 'lax', secure: false, maxAge: 300, path: '/' })
  return res
}


