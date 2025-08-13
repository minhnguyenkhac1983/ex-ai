"use client"
import { useEffect } from 'react'

export function ClientOtelProvider() {
  useEffect(() => {
    import('../src/otel/client').catch(() => {})
  }, [])
  return null
}


