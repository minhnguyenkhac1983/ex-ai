// Provider verification for Wallet against generated consumer pacts
/* eslint-disable @typescript-eslint/no-var-requires */
const path = require('node:path')
const fs = require('node:fs')
const { Verifier } = require('@pact-foundation/pact')

async function main() {
  const providerBaseUrl = process.env.WALLET_BASE_URL || 'http://localhost:8088/api/wallet'
  const pactsDir = path.resolve(__dirname, '..', 'pacts')
  if (!fs.existsSync(pactsDir)) {
    console.error('No pacts directory found at', pactsDir)
    process.exit(1)
  }
  const pactUrls = fs
    .readdirSync(pactsDir)
    .filter((f) => f.endsWith('.json'))
    .map((f) => path.join(pactsDir, f))

  if (pactUrls.length === 0) {
    console.error('No pact files found. Run consumer tests first to generate pacts.')
    process.exit(1)
  }

  const verifier = new Verifier({
    providerBaseUrl,
    pactUrls,
    publishVerificationResult: false,
    providerVersion: 'local-dev',
    stateHandlers: {
      'deposit accepted': async () => {},
      'withdraw accepted': async () => {},
    },
  })

  try {
    const output = await verifier.verifyProvider()
    console.log(output)
  } catch (err) {
    console.error(err)
    process.exit(1)
  }
}

main()


