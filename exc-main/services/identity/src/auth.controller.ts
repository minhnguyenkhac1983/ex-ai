import { Controller, Get, Query } from '@nestjs/common'
import * as jwt from 'jsonwebtoken'
import { authenticator } from 'otplib'

@Controller('auth')
export class AuthController {
  @Get('token')
  issue(@Query('sub') sub = 'user-1') {
    const token = jwt.sign({ sub }, process.env.JWT_SECRET || 'dev-secret', { expiresIn: '1h' })
    return { token }
  }

  @Get('totp')
  totp(@Query('secret') secret?: string) {
    const sec = secret || authenticator.generateSecret()
    const code = authenticator.generate(sec)
    return { secret: sec, code }
  }
}


