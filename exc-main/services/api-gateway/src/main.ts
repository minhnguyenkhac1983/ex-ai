import 'reflect-metadata'
import { NestFactory } from '@nestjs/core'
import { FastifyAdapter, NestFastifyApplication } from '@nestjs/platform-fastify'
import { Module, Controller, Get } from '@nestjs/common'

@Controller('health')
class HealthController {
  @Get()
  get() {
    return { status: 'ok' }
  }
}

@Module({ controllers: [HealthController] })
class AppModule {}

async function bootstrap() {
  const app = await NestFactory.create<NestFastifyApplication>(
    AppModule,
    new FastifyAdapter({ logger: true })
  )
  await app.listen({ port: Number(process.env.PORT) || 3000, host: '0.0.0.0' })
}

bootstrap()


