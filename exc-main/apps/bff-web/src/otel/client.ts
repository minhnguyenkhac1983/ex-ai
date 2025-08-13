// Lightweight OTel web setup; safe no-op if exporter not reachable
import { WebTracerProvider } from '@opentelemetry/sdk-trace-web'
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-http'
import { SimpleSpanProcessor } from '@opentelemetry/sdk-trace-web'
import { trace } from '@opentelemetry/api'

const provider = new WebTracerProvider()

const endpoint = process.env.NEXT_PUBLIC_OTEL_EXPORTER_OTLP_ENDPOINT || '/v1/traces'
try {
  const exporter = new OTLPTraceExporter({ url: endpoint })
  provider.addSpanProcessor(new SimpleSpanProcessor(exporter))
} catch {
  // ignore
}

provider.register()

// create a tiny startup span to verify wiring
const tracer = trace.getTracer('bff-web')
const span = tracer.startSpan('bff-web:init')
span.end()
