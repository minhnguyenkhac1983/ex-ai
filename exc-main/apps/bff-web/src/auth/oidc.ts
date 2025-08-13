export const oidcConfig = {
  issuer: process.env.OIDC_ISSUER || 'http://localhost:18084/realms/exc',
  clientId: process.env.OIDC_CLIENT_ID || 'bff-web',
  redirectUri: process.env.OIDC_REDIRECT_URI || 'http://localhost:3000/api/auth/callback',
}


