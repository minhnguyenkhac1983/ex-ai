import jwt from 'jsonwebtoken'

type Tokens = {
  access_token: string
  id_token?: string
  refresh_token?: string
  expires_in?: number
  token_type?: string
}

const SESSION_COOKIE_NAME = 'bff_session'
const DEFAULT_TTL_SEC = 15 * 60

function getSecret(): string {
  const secret = process.env.BFF_SESSION_SECRET || 'dev-secret-change-me'
  return secret
}

export function createSessionCookie(tokens: Tokens): { name: string; value: string; maxAge: number } {
  const ttl = Math.max(60, Math.min(tokens.expires_in || DEFAULT_TTL_SEC, 24 * 3600))
  const payload = {
    at: tokens.access_token,
    rt: tokens.refresh_token,
  }
  const token = jwt.sign(payload, getSecret(), { algorithm: 'HS256', expiresIn: ttl })
  return { name: SESSION_COOKIE_NAME, value: token, maxAge: ttl }
}

type SessionPayload = { at?: string; rt?: string; [key: string]: unknown }

export function verifySession(cookieValue: string | undefined): { valid: boolean; payload?: SessionPayload } {
  if (!cookieValue) return { valid: false }
  try {
    const payload = jwt.verify(cookieValue, getSecret()) as SessionPayload
    return { valid: true, payload }
  } catch {
    return { valid: false }
  }
}

export const session = {
  name: SESSION_COOKIE_NAME,
}


