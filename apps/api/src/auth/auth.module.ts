import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { AuthController } from './auth.controller';
import { MeController } from './me.controller';
import { AuthService } from './auth.service';
import { SessionRepository } from './session.repository';
import { UserRepository } from './user.repository';
import { SessionCache } from './session.cache';
import { LoginThrottle } from './login-throttle';
import { AuthGuard } from './auth.guard';
import { RbacModule } from '../rbac/rbac.module';

@Module({
  imports: [RbacModule],
  controllers: [AuthController, MeController],
  providers: [
    AuthService,
    SessionRepository,
    UserRepository,
    SessionCache,
    LoginThrottle,
    AuthGuard,
    {
      provide: APP_GUARD,
      useClass: AuthGuard,
    },
  ],
  exports: [
    AuthService,
    SessionRepository,
    UserRepository,
    SessionCache,
    LoginThrottle,
    AuthGuard,
  ],
})
export class AuthModule {}
