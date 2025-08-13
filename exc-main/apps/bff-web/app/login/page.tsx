import { oidcConfig } from '@/src/auth/oidc'
import { generateCodeVerifierAndChallenge } from '@/src/auth/pkce'
import { cookies } from 'next/headers'

export default async function Login() {
  const { verifier, challenge } = await generateCodeVerifierAndChallenge()
  // Persist code_verifier in a short-lived httpOnly cookie
  cookies().set('pkce_verifier', verifier, { httpOnly: true, sameSite: 'lax', secure: false, maxAge: 300, path: '/' })
  const authUrl = `${oidcConfig.issuer}/protocol/openid-connect/auth?` +
    new URLSearchParams({
      response_type: 'code',
      client_id: oidcConfig.clientId,
      redirect_uri: oidcConfig.redirectUri,
      scope: 'openid profile email',
      code_challenge_method: 'S256',
      code_challenge: challenge,
    }).toString()
  return (
    <div style={{ padding: 24 }}>
      <h1>Login</h1>
      <a href={authUrl}>Login with Keycloak</a>
    </div>
  )
}


