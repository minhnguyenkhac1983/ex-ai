function base64url(input: ArrayBuffer): string {
  const bytes = Buffer.from(new Uint8Array(input))
  return bytes.toString('base64').replace(/=/g, '').replace(/\+/g, '-').replace(/\//g, '_')
}

export async function generateCodeVerifierAndChallenge(): Promise<{ verifier: string; challenge: string }> {
  const random = crypto.getRandomValues(new Uint8Array(32))
  const verifier = base64url(random.buffer)
  const encoder = new TextEncoder()
  const data = encoder.encode(verifier)
  const digest = await crypto.subtle.digest('SHA-256', data)
  const challenge = base64url(digest)
  return { verifier, challenge }
}


