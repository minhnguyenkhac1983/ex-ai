import type { ReactNode } from 'react'
import { ClientOtelProvider } from './otel-client'

export const metadata = {
  title: 'BFF Web',
  description: 'Web BFF with Next.js 14 + OTel client'
}

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body>
        <ClientOtelProvider />
        {children}
      </body>
    </html>
  )
}


